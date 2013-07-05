package com.nabisoft.service.ticketmanagement;

import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.nabisoft.json.JsonResponse;
import com.nabisoft.model.ticketmanagement.Ticket;
import com.nabisoft.model.ticketmanagement.TicketBean;
import com.nabisoft.model.ticketmanagement.dto.TicketDTO;
import com.nabisoft.model.usermanagement.User;
import com.nabisoft.model.usermanagement.UserBean;
import java.security.Principal;
import java.util.Date;
import java.util.List;

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

    @GET
    @Path("newticket")
    @Produces(MediaType.APPLICATION_JSON)
    @TransactionAttribute(TransactionAttributeType.NEVER)
    public Response newticket(@Context HttpServletRequest req) {
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

        //set the Company name
        User user = userBean.find(principal.getName());
        newTicket.setCompany(user.getCompany());

        //set the id
        newTicket.setId("" + date.getTime());
        //increment the id for the next ticket
        
        newTicket.setInfo("attivo");
        newTicket.setStato("attivo");

        req.getServletContext().log("ticket creato" + newTicket);

        json.setData(newTicket); //just return the date we received

        Ticket ticket = new Ticket(newTicket);


        //this could cause a runtime exception, i.e. in case the user already exists
        //such exceptions will be caught by our ExceptionMapper, i.e. javax.transaction.RollbackException
        ticketBean.save(ticket); // this would use the clients transaction which is committed after save() has finished
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
