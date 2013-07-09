package com.smart_leak_detection.service.sensormanagementservice;

import com.smart_leak_detection.json.JsonResponse;
import com.smart_leak_detection.model.measuremanagement.MeasureBean;
import com.smart_leak_detection.model.usermanagement.UserBean;
import java.io.IOException;
import java.security.Principal;
import java.util.Date;
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

@Path("/sensor")
@Produces(MediaType.TEXT_PLAIN)
@Stateless
public class SensorManagementService {

    @EJB
    private MeasureBean measureBean;
    @EJB
    private UserBean userBean;
    
    
    @GET
    @Path("ping")
    public String ping() {
        return "alive";
    }

    @POST
    @Path("activate")
    @Produces(MediaType.APPLICATION_JSON)
    @TransactionAttribute(TransactionAttributeType.NEVER)
    public Response newticket(@FormParam("noiselogger") String noiselogger,
            @Context HttpServletRequest req) throws IOException {

        JsonResponse json = new JsonResponse();

        Principal principal = req.getUserPrincipal();
        //only login if not already logged in...
        if (principal == null) {
            json.setStatus("FAILED");
            json.setErrorMsg("Authentication failed");
            return Response.ok().entity(json).build();
        }

        //In realtà andranno calcolati i noise loggers interni all'area circoscritta
        //per essere attivati, noi manderemo solo un intero per attivare la lettura dagli altri sensori

        //Coding message
        int message = 0;

        req.getServletContext().log("Invio il messaggio");
//        channels.sendData(message);
        req.getServletContext().log("Noise Loggers Attivati");

        json.setStatus("SUCCESS");

        return Response.ok().entity(json).build();
    }
}
