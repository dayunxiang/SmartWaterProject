/**
 * Mon Jun 22 16:17:45 2013
 *
 * @author Simone Amoroso
 * @author Davide Pellegrino
 * @author Pierluigi Scarpetta
 * @author Mauro Vuolo
 *
 * Released under the Apache License, Version 2.0
 */
package com.ti_led.jaxrs.provider;
 
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;
 
import com.ti_led.json.JsonResponse;
 
@Provider
public class ThrowableExceptionMapper implements ExceptionMapper<Throwable>{
 
    private static final Response RESPONSE;
    private static final JsonResponse JSON = new JsonResponse("ERROR");
     
    static {
        RESPONSE = Response.status(500).entity(JSON).build();
    }
     
    @Override
    @Produces(MediaType.APPLICATION_JSON)
    public Response toResponse(Throwable ex) {
        System.out.println("ThrowableExceptionMapper: "+ex.getClass());
        ex.printStackTrace();
        //usually you don't pass detailed info out (don't do this here in production environments)
        JSON.setErrorMsg(ex.getMessage());
         
        return RESPONSE;
    }
 
}