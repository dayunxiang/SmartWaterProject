package com.smart_leak_detection.service.usermanagement;

import java.util.ArrayList;
import java.util.List;

import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.smart_leak_detection.json.JsonResponse;
import com.smart_leak_detection.model.usermanagement.Group;
import com.smart_leak_detection.model.usermanagement.User;
import com.smart_leak_detection.model.usermanagement.UserBean;
import com.smart_leak_detection.model.usermanagement.dto.UserDTO;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

@Path("/auth")
@Produces(MediaType.TEXT_PLAIN)
@Stateless
public class UserManagementService {

    @EJB
    private UserBean userBean;

    @GET
    @Path("ping")
    public String ping() {
        return "alive";
    }

    @POST
    @Path("login")
    @Produces(MediaType.APPLICATION_JSON)
    public Response login(@FormParam("email") String email, @FormParam("password") String password,
            @Context HttpServletRequest req) {

        JsonResponse json = new JsonResponse();

        //only login if not already logged in...
        if (req.getUserPrincipal() == null) {
            try {
                req.login(email, password);
                req.getServletContext().log("Authentication Demo: successfully logged in " + email);
            } catch (ServletException e) {
                e.printStackTrace();
                json.setStatus("FAILED");
                json.setErrorMsg("Authentication failed");
                return Response.ok().entity(json).build();
            }
        } else {
            req.getServletContext().log("Skip logged because already logged in: " + email);
        }

        //read the user data from db and return to caller
        json.setStatus("SUCCESS");

        User user = userBean.find(email);
        req.getServletContext().log("Authentication Demo: successfully retrieved User Profile from DB for " + email);
        json.setData(user);

        //we don't want to send the hashed password out in the json response
        userBean.detach(user);
        user.setPassword(null);
        user.setGroups(null);
        return Response.ok().entity(json).build();
    }

    @GET
    @Path("logout")
    @Produces(MediaType.APPLICATION_JSON)
    public Response logout(@Context HttpServletRequest req) {

        JsonResponse json = new JsonResponse();

        try {
            req.getServletContext().log("Effettuo il logout");
            req.logout();
            json.setStatus("SUCCESS");
            req.getSession().invalidate();
        } catch (ServletException e) {
            e.printStackTrace();
            json.setStatus("FAILED");
            json.setErrorMsg("Logout failed on backend");
        }
        return Response.ok().entity(json).build();
    }

    @POST
    @Path("register")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    @TransactionAttribute(TransactionAttributeType.NEVER)
    public Response register(UserDTO newUser, @Context HttpServletRequest req) throws MessagingException {

        JsonResponse json = new JsonResponse();
        json.setData(newUser); //just return the date we received

        //do some validation (in reality you would do some more validation...)
        //by the way: i did not choose to use bean validation (JSR 303)
        if (newUser.getPassword1().length() == 0 || !newUser.getPassword1().equals(newUser.getPassword2())) {
            json.setErrorMsg("Both passwords have to be the same - typo?");
            json.setStatus("FAILED");
            return Response.ok().entity(json).build();
        }

        User user = new User(newUser);

        List<Group> groups = new ArrayList<Group>();
        groups.add(Group.ADMINISTRATOR);
        groups.add(Group.USER);
        groups.add(Group.DEFAULT);
        user.setGroups(groups);

        //this could cause a runtime exception, i.e. in case the user already exists
        //such exceptions will be caught by our ExceptionMapper, i.e. javax.transaction.RollbackException
        userBean.save(user); // this would use the clients transaction which is committed after save() has finished
        req.getServletContext().log("successfully registered new user: '" + newUser.getEmail() + "':'" + newUser.getPassword1() + "'");

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

        String[] to = {newUser.getEmail()};

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
        message.setSubject("Smart Leak Detection - Registrazione effettuata");
        message.setContent("<h1>Smart Leak Detection</h1> <br> <div> Registrazione Effettuata </div>", "text/html");
        Transport transport = session.getTransport("smtp");
        transport.connect(host, from, pass);
        transport.sendMessage(message, message.getAllRecipients());
        transport.close();
        req.getServletContext().log("Email sent to: '" + newUser.getEmail());

        
        req.getServletContext().log("execute login now: '" + newUser.getEmail() + "':'" + newUser.getPassword1() + "'");
        try {
            req.login(newUser.getEmail(), newUser.getPassword1());
            json.setStatus("SUCCESS");
        } catch (ServletException e) {
            e.printStackTrace();
            json.setErrorMsg("User Account created, but login failed. Please try again later.");
            json.setStatus("FAILED"); //maybe some other status? you can choose...
        }

        return Response.ok().entity(json).build();
    }
}