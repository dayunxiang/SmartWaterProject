package com.smart_leak_detection.service.me;
 
import java.util.Date;
 
import javax.ejb.Stateless;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
 
import com.smart_leak_detection.json.JsonResponse;
 
@Path("/secure/timestamp")
@Produces(MediaType.APPLICATION_JSON)
@Stateless
public class TimeService {
 
    @GET
    @Path("now")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getCurrentDate(@Context HttpServletRequest req) {
 
        JsonResponse json = new JsonResponse("SUCCESS");
        json.setData(new Date());
        return Response.ok().entity(json).build();
    }
     
}