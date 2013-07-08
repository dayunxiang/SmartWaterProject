package com.smart_leak_detection.service.ticketmanagement;

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

import com.smart_leak_detection.json.JsonResponse;
import com.smart_leak_detection.model.ticketmanagement.Ticket;
import com.smart_leak_detection.model.ticketmanagement.TicketBean;
import com.smart_leak_detection.model.ticketmanagement.dto.TicketDTO;
import com.smart_leak_detection.model.usermanagement.User;
import com.smart_leak_detection.model.usermanagement.UserBean;
import de.micromata.opengis.kml.v_2_2_0.Coordinate;
import de.micromata.opengis.kml.v_2_2_0.Document;
import de.micromata.opengis.kml.v_2_2_0.Feature;
import de.micromata.opengis.kml.v_2_2_0.Kml;
import de.micromata.opengis.kml.v_2_2_0.Placemark;
import de.micromata.opengis.kml.v_2_2_0.Point;
import java.io.File;
import java.security.Principal;
import java.util.Date;
import java.util.Iterator;
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
            @Context HttpServletRequest req) throws AddressException, MessagingException {
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

        //Retrive info for the noise logger selected
        String path = "/Users/pelldav/University/Tesi/SmartWaterProject/web/file/Noise_loggers.kml";
        Kml kml = Kml.unmarshal(new File(path));
        Document document = (Document) kml.getFeature(); //Get the document features
        Iterator<Feature> iterator = document.getFeature().iterator(); //Create an iterator for the placemark
        Feature feature = null;
        while (iterator.hasNext()) {
            feature = iterator.next();
            if (feature.getName().compareTo(noiselogger) == 0) {
                break;
            }
        }
        req.getServletContext().log("ECCOLOOOOOO: " + feature.getDescription());
        String[] description = feature.getDescription().split("<br>");
        String battery = description[1].split("<b>")[1].split("%")[0];
        String status = description[2].split("<b>")[1].split("</b>")[0];
        
        //set the Company name
        User user = userBean.find(principal.getName());
        newTicket.setCompany(user.getCompany());

        //set the id
        newTicket.setId("" + date.getTime());

        //set the noise logger id
        newTicket.setNoiselogger(noiselogger);

        //retrive state and info from kml
        if(status.compareTo("OK") != 0 ){ // Error on network sensor
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
        ticketBean.save(ticket); // this would use the clients transaction which is committed after save() has finished

        //Send email to user
        String host = "smtp.gmail.com";
        String from = "smart.leak.detection@gmail.com";
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
        System.out.println(Message.RecipientType.TO);

        for (int i = 0; i < toAddress.length; i++) {
            message.addRecipient(Message.RecipientType.TO, toAddress[i]);
        }
        message.setSubject("Smart Leak Detection - Richiesta Manutenzione");
        message.setContent("<h1>Smart Leak Detection</h1> <br> <div> Registrazione di manutenzione inviata <br>" + newTicket.toString() + "</div>", "text/html");
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
