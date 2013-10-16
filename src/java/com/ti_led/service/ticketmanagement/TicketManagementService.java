package com.ti_led.service.ticketmanagement;

import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.ti_led.json.JsonResponse;
import com.ti_led.model.mapsmanagement.MapsData;
import com.ti_led.model.mapsmanagement.MapsDataBean;
import com.ti_led.model.ticketmanagement.Ticket;
import com.ti_led.model.ticketmanagement.TicketBean;
import com.ti_led.model.ticketmanagement.dto.TicketDTO;
import com.ti_led.model.usermanagement.User;
import com.ti_led.model.usermanagement.UserBean;
import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.security.Principal;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.ws.rs.FormParam;

@Path("/ticket")
@Produces(MediaType.TEXT_PLAIN)
@Stateless
public class TicketManagementService {

    @EJB
    private TicketBean ticketBean;
    @EJB
    private UserBean userBean;
    @EJB
    private MapsDataBean mapsDataBean;

    @GET
    @Path("ping")
    public String ping() {
        return "alive";
    }

    @POST
    @Path("newticket")
    @Produces(MediaType.APPLICATION_JSON)
    @TransactionAttribute(TransactionAttributeType.NEVER)
    public Response newticket(@FormParam("noiselogger") String noiselogger,
            @Context HttpServletRequest req) throws AddressException, MessagingException, MalformedURLException, URISyntaxException {
        Date date = new Date();

        TicketDTO newTicket = new TicketDTO();
        

        JsonResponse json = new JsonResponse();
        json.setData(newTicket); //just return the date we received

        Principal principal = req.getUserPrincipal();
        //only login if not already logged in...
        if (principal == null) {
            json.setStatus("FAILED");
            json.setErrorMsg("Authentication failed");
            return Response.ok().entity(json).build();
        }

        MapsData mapsData = this.mapsDataBean.find(noiselogger);
        
        int battery = mapsData.getBattery();
        String status = mapsData.getStatus();

        //set the Company name
        User user = userBean.find(principal.getName());
        newTicket.setCompany(user.getCompany());

        //set the id
        newTicket.setId("" + date.getTime());

        //set the noise logger id
        newTicket.setNoiselogger(noiselogger);

        //retrive state and info from kml
        if (status.compareTo("OK") != 0) { // Error on network sensor
            newTicket.setInfo("Richiesta verifica rete noise loggers");
        } else { // Low battery
            newTicket.setInfo("Richiesta sostituzione batteria - Livello: " + battery + "%");
        }

        //set stato - initial state is always "attivo"
        newTicket.setStato("attivo");

        req.getServletContext().log("ticket creato" + newTicket);

        json.setData(newTicket); //just return the date we received

        Ticket ticket = new Ticket(newTicket);


        //this could cause a runtime exception, i.e. in case the user already exists
        //such exceptions will be caught by our ExceptionMapper, i.e. javax.transaction.RollbackException
        ticketBean.save(ticket);
        //Send email to user
        String host = "smtp.gmail.com";
        String from = "servizio.tiled@gmail.com";
        String pass = "smartleakdetection";
        Properties props = System.getProperties();
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.user", from);
        props.put("mail.smtp.password", pass);
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");

        String[] to = {user.getEmail()};

        Session session = Session.getDefaultInstance(props, null);
        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(from));

        InternetAddress[] toAddress = new InternetAddress[to.length];

        for (int i = 0; i < to.length; i++) {        // To get the array of addresses
            toAddress[i] = new InternetAddress(to[i]);
        }
        req.getServletContext().log(Message.RecipientType.TO.toString());

        for (int i = 0; i < toAddress.length; i++) {
            message.addRecipient(Message.RecipientType.TO, toAddress[i]);
        }
        message.setSubject("TI-LeD - Ticket aperto #" + newTicket.getId());
        message.setContent("<h1>TI-LeD</h1> <br> <div> Gentile utente,<br><br>" +
                "la richiesta di supporto è stata creata ed assegnata con il numero #" + newTicket.getId() +
                "Potrà seguire l&lsquoavanzamento della richiesta sul nostro portale." +
                "<br>Cordiali saluti,<br>TI-LeD Team</div>", "text/html");
        Transport transport = session.getTransport("smtp");
        transport.connect(host, from, pass);
        transport.sendMessage(message, message.getAllRecipients());
        transport.close();
        req.getServletContext().log("Email sent to: '" + user.getEmail());

        json.setStatus("SUCCESS");

        req.getServletContext().log("successfully added new ticket: '" + newTicket.getCompany() + "':'" + newTicket.getId() + "'");

        return Response.ok().entity(json).build();
    }

    @GET
    @Path("list")
    @Produces(MediaType.APPLICATION_JSON)
    public Response list(@Context HttpServletRequest req) {

        JsonResponse json = new JsonResponse();

        Principal principal = req.getUserPrincipal();
        if (principal == null) {
            json.setStatus("FAILED");
            json.setErrorMsg("User not logged");
            return Response.ok().entity(json).build();
        }

        User user = userBean.find(principal.getName());

        List<Ticket> list = ticketBean.findAll(user.getCompany());

        
        json.setData(list);

        json.setStatus("SUCCESS");

        return Response.ok().entity(json).build();
    }
}
