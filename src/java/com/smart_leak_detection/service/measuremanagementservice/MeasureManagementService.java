package com.smart_leak_detection.service.measuremanagementservice;

import com.smart_leak_detection.json.JsonResponse;
import com.smart_leak_detection.model.mapsmanagement.MapsData;
import com.smart_leak_detection.model.mapsmanagement.MapsDataBean;
import com.smart_leak_detection.model.mapsmanagement.dto.MapsDataDTO;
import com.smart_leak_detection.model.measuremanagement.Measure;
import com.smart_leak_detection.model.measuremanagement.MeasureBean;
import com.smart_leak_detection.model.measuremanagement.dto.MeasureDTO;
import com.smart_leak_detection.model.usermanagement.User;
import com.smart_leak_detection.model.usermanagement.UserBean;
import java.io.IOException;
import java.security.Principal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("/measure")
@Produces(MediaType.TEXT_PLAIN)
@Stateless
public class MeasureManagementService {

    @EJB
    private MeasureBean measureBean;
    @EJB
    private UserBean userBean;
    @EJB
    private MapsDataBean mapsDataBean;

    @GET
    @Path("ping")
    public String ping() {
        return "alive";
    }

    //Only for test --- new measure is added by other thread
    @POST
    @Path("newmeasure")
    @Produces(MediaType.APPLICATION_JSON)
    @TransactionAttribute(TransactionAttributeType.NEVER)
    public Response newticket(@FormParam("noiselogger") String noiselogger,
            @FormParam("value") String value,
            @Context HttpServletRequest req) throws MessagingException {

        JsonResponse json = new JsonResponse();
        Principal principal = req.getUserPrincipal();
        //only login if not already logged in...
        if (principal == null) {
            json.setStatus("FAILED");
            json.setErrorMsg("Authentication failed");
            return Response.ok().entity(json).build();
        }
        Measure measure = new Measure();
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm");
        Date date = new Date();
        String timestamp = dateFormat.format(date);
        measure = this.measureBean.find(noiselogger); //Retrive company for the noiselogger
        String company = measure.getCompany();
//        FIX-ME correggere il servizio perchè adesso oltre a salvare in measure deve salvare in mapsdata

        MeasureDTO measureDto = new MeasureDTO();
        measureDto.setId("" + date.getTime());
        measureDto.setNoiselogger(noiselogger);
        measureDto.setTimestamp(timestamp);
        measureDto.setBattery("80");
        measureDto.setValue(value);
        measureDto.setCompany(company);

        measure = new Measure(measureDto);
        MapsData mapsData = new MapsData();
        mapsData = this.mapsDataBean.find(noiselogger);
        //update value
        mapsData.setBattery(80);
        mapsData.setTimestamp(timestamp);
        mapsData.setValue(Integer.valueOf(value));

        if (Integer.valueOf(value) > 600) { //Leak detected, save first value

            //modify style kml to display leak                        
            mapsData.setStyle("#alarmStyle");
            this.mapsDataBean.update(mapsData); //update last measure for the noiselogger
            System.out.println("MapsData UPDATE");
            //send email to all company users
//            String host = "smtp.gmail.com";
//            String from = "servizio.tiled@gmail.com";
//            String pass = "smartleakdetection";
//            Properties props = System.getProperties();
//            props.put("mail.smtp.starttls.enable", "true");
//            props.put("mail.smtp.host", host);
//            props.put("mail.smtp.user", from);
//            props.put("mail.smtp.password", pass);
//            props.put("mail.smtp.port", "587");
//            props.put("mail.smtp.auth", "true");
//
//            List<User> list = userBean.findAll(company);
//            String[] to = new String[list.size()];
//            for (int i = 0; i < list.size(); i++) {
//                to[i] = list.get(i).getEmail();
//            }
//
//            Session session = Session.getDefaultInstance(props, null);
//            MimeMessage message = new MimeMessage(session);
//            message.setFrom(new InternetAddress(from));
//
//            InternetAddress[] toAddress = new InternetAddress[to.length];
//
//            for (int i = 0; i < to.length; i++) {        // To get the array of addresses
//                toAddress[i] = new InternetAddress(to[i]);
//            }
//            System.out.println(Message.RecipientType.TO);
//
//            for (int i = 0; i < toAddress.length; i++) {
//                message.addRecipient(Message.RecipientType.TO, toAddress[i]);
//            }
//            message.setSubject("TI-LeD - Notifica rilevazione area di perdita");
//            message.setContent("<h1>TI-LeD</h1> <br> <div> Gentile utente,<br><br>"
//                    + "Il sistema TI-LeD ha appena rilevato una area di perdita nella zone del noise logger #" + noiselogger
//                    + ".<br>Le ricordiamo di attivare quanto prima la maglia stretta per individuare il punto esatto della perdita."
//                    + "<br><br>Cordiali saluti,<br>TI-LeD Team</div>", "text/html");
//            Transport transport = session.getTransport("smtp");
//            transport.connect(host, from, pass);
//            transport.sendMessage(message, message.getAllRecipients());
//            System.out.println("EMAIL INVIATA");
//            transport.close();
        } else {
            this.mapsDataBean.update(mapsData); //update last measure for the noiselogger
        }
        json.setData(measureDto); //just return the date we received



        //set the Company name

        req.getServletContext().log("rilevazione creata" + measure);

        json.setData(measureDto); //just return the date we received


        //this could cause a runtime exception, i.e. in case the user already exists
        //such exceptions will be caught by our ExceptionMapper, i.e. javax.transaction.RollbackException
        json.setStatus("SUCCESS");

        req.getServletContext().log("successfully added new measure: '" + measure.getCompany() + "':'" + measure.getId() + "'");

        return Response.ok().entity(json).build();
    }

    @POST
    @Path("list")
    @Produces(MediaType.APPLICATION_JSON)
    public Response list(@FormParam("noiselogger") String noiselogger,
            @Context HttpServletRequest req) {

        JsonResponse json = new JsonResponse();

        Principal principal = req.getUserPrincipal();
        if (principal == null) {
            json.setStatus("FAILED");
            json.setErrorMsg("User not logged");
            return Response.ok().entity(json).build();
        }

        User user = userBean.find(principal.getName());

        List<Measure> list = measureBean.findAll(user.getCompany(), noiselogger);
        req.getServletContext().log("list: " + list);

        json.setData(list);

        json.setStatus("SUCCESS");

        return Response.ok().entity(json).build();
    }

    //Activate for simulation
    @POST
    @Path("activate")
    @Produces(MediaType.APPLICATION_JSON)
    @TransactionAttribute(TransactionAttributeType.NEVER)
    public Response activate(@FormParam("noiselogger") String noiselogger,
            @Context HttpServletRequest req) throws IOException, MessagingException {

        JsonResponse json = new JsonResponse();

        Principal principal = req.getUserPrincipal();
        //only login if not already logged in...
        if (principal == null) {
            json.setStatus("FAILED");
            json.setErrorMsg("Authentication failed");
            return Response.ok().entity(json).build();
        }
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm");
        Date date = new Date();
        String timestamp = dateFormat.format(date);
        MapsData mapsData = new MapsData();

        //Save leak value of first noise logger
        mapsData = this.mapsDataBean.find("24");
        //update value to display in maps for #strictStyle also battery and status
        mapsData.setBattery(80);
        mapsData.setTimestamp(timestamp);
        mapsData.setValue(600);
        this.mapsDataBean.update(mapsData); //update last measure for the noiselogger


        //Save leak value of second noise logger
        mapsData = this.mapsDataBean.find("41");
        //update value to display in maps for #strictStyle also battery and status
        mapsData.setBattery(80);
        mapsData.setTimestamp(timestamp);
        mapsData.setValue(800);
        this.mapsDataBean.update(mapsData);

        //Control to prevent user error
        mapsData = this.mapsDataBean.find("leak");
        if (mapsData == null) {
            //Alert user of leak
            MapsDataDTO leak = new MapsDataDTO();
            leak.setBattery(0);
            leak.setNoiselogger("leak");
            leak.setStatus("leak");
            leak.setStyle("leak");
            leak.setTimestamp("leak");
            leak.setValue(0);
            //send email to all company users
//            String host = "smtp.gmail.com";
//            String from = "servizio.tiled@gmail.com";
//            String pass = "smartleakdetection";
//            Properties props = System.getProperties();
//            props.put("mail.smtp.starttls.enable", "true");
//            props.put("mail.smtp.host", host);
//            props.put("mail.smtp.user", from);
//            props.put("mail.smtp.password", pass);
//            props.put("mail.smtp.port", "587");
//            props.put("mail.smtp.auth", "true");
//
//            User user = userBean.find(principal.getName());
//            List<User> list = userBean.findAll(user.getCompany());
//            String[] to = new String[list.size()];
//            for (int i = 0; i < list.size(); i++) {
//                to[i] = list.get(i).getEmail();
//            }
//
//            Session session = Session.getDefaultInstance(props, null);
//            MimeMessage message = new MimeMessage(session);
//            message.setFrom(new InternetAddress(from));
//
//            InternetAddress[] toAddress = new InternetAddress[to.length];
//
//            for (int i = 0; i < to.length; i++) {        // To get the array of addresses
//                toAddress[i] = new InternetAddress(to[i]);
//            }
//            System.out.println(Message.RecipientType.TO);
//
//            for (int i = 0; i < toAddress.length; i++) {
//                message.addRecipient(Message.RecipientType.TO, toAddress[i]);
//            }
//            message.setSubject("TI-LeD - Individuato punto di perdita");
//            message.setContent("<h1>TI-LeD</h1> <br> <div>Gentile utente,<br><br>"
//                    + "in seguito alla attivazione della maglia stretta, il sistema TI-LeD ha localizzato una perdita sulla Sua rete.<br>"
//                    + "Può consultare la mappa tramite il nostro portale per visualizzare la posizione precisa.<br><br>"
//                    + "Cordiali saluti,<br>TI-LeD Team</div>", "text/html");
//            Transport transport = session.getTransport("smtp");
//            transport.connect(host, from, pass);
//            transport.sendMessage(message, message.getAllRecipients());
//            System.out.println("EMAIL INVIATA");
//            transport.close();

            //Elaborate data

            leak.setLatitude(45.10998333);
            leak.setLongitude(7.6661);
            MapsData mapsLeak = new MapsData(leak);
            this.mapsDataBean.save(mapsLeak);
            //Send email
        }

        json.setStatus("SUCCESS");

        return Response.ok().entity(json).build();
    }
}
