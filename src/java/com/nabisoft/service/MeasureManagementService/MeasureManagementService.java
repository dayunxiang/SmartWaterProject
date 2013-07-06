package com.nabisoft.service.MeasureManagementService;

import com.nabisoft.json.JsonResponse;
import com.nabisoft.model.measuremanagement.Measure;
import com.nabisoft.model.measuremanagement.MeasureBean;
import com.nabisoft.model.measuremanagement.dto.MeasureDTO;
import com.nabisoft.model.usermanagement.User;
import com.nabisoft.model.usermanagement.UserBean;
import java.security.Principal;
import java.util.Date;
import java.util.List;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
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
                              @Context HttpServletRequest req) {
        Date date = new Date();
        
        MeasureDTO newMeasure = new MeasureDTO();

        JsonResponse json = new JsonResponse();
        json.setData(newMeasure); //just return the date we received

        Principal principal = req.getUserPrincipal();
        //only login if not already logged in...
        if (principal == null) {
            json.setStatus("FAILED");
            json.setErrorMsg("Authentication failed");
            return Response.ok().entity(json).build();
        }

        //set the Company name
        User user = userBean.find(principal.getName());
        newMeasure.setCompany(user.getCompany());

        //set the id
        newMeasure.setId("" + date.getTime());
        
        //set the noise logger id
        newMeasure.setNoiselogger(noiselogger);
        
        newMeasure.setTimestamp("2013-07-10");
        newMeasure.setValue("20%");
        newMeasure.setBattery("80%");

        req.getServletContext().log("rilevazione creata" + newMeasure);

        json.setData(newMeasure); //just return the date we received

        Measure measure = new Measure(newMeasure);


        //this could cause a runtime exception, i.e. in case the user already exists
        //such exceptions will be caught by our ExceptionMapper, i.e. javax.transaction.RollbackException
        measureBean.save(measure); // this would use the clients transaction which is committed after save() has finished
        json.setStatus("SUCCESS");

        req.getServletContext().log("successfully added new measure: '" + newMeasure.getCompany() + "':'" + newMeasure.getId() + "'");

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

        json.setData(list);

        json.setStatus("SUCCESS");

        return Response.ok().entity(json).build();
    }
}
