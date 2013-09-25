package com.smart_leak_detection.service.mapsdatamanagementservice;

import com.smart_leak_detection.json.JsonResponse;
import com.smart_leak_detection.model.mapsmanagement.MapsData;
import com.smart_leak_detection.model.mapsmanagement.MapsDataBean;
import java.security.Principal;
import java.util.List;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("/mapsdata")
@Produces(MediaType.TEXT_PLAIN)
@Stateless
public class MapsDataManagementService {

    @EJB
    private MapsDataBean mapsDataBean;

    @GET
    @Path("ping")
    public String ping() {
        return "alive";
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


        List<MapsData> list = this.mapsDataBean.findAll();

        req.getServletContext().log("INVIO LISTA");

        json.setData(list);

        json.setStatus("SUCCESS");

        return Response.ok().entity(json).build();
    }

    @GET
    @Path("reset")
    @Produces(MediaType.APPLICATION_JSON)
    public Response reset(@Context HttpServletRequest req) {
        JsonResponse json = new JsonResponse();

        List<MapsData> list = this.mapsDataBean.findAll();
        MapsData mapsData;
        req.getServletContext().log("INIZIO RESET");

        for (int i = 0; i < list.size(); i++) {
            mapsData = list.get(i);
            if (mapsData.getStyle().compareTo("#alarmStyle") == 0) {
                mapsData.setValue(0);
                mapsData.setStyle("#largeStyle");
                this.mapsDataBean.update(mapsData);
                req.getServletContext().log("AGGIORNO VALORE");
            } else if (mapsData.getStyle().compareTo("#strictStyle") == 0) {
                if (mapsData.getValue() != 0) {
                    mapsData.setValue(0);
                    this.mapsDataBean.update(mapsData);
                    req.getServletContext().log("AGGIORNO VALORE");
                }
            } else if (mapsData.getStyle().compareTo("#measureStyle") == 0) {
                    mapsData.setValue(0);
                    mapsData.setStyle("#strictStyle");
                    this.mapsDataBean.update(mapsData);
                    req.getServletContext().log("AGGIORNO VALORE");
            } else if (mapsData.getStyle().compareTo("leak") == 0) {
                this.mapsDataBean.remove(mapsData);
                req.getServletContext().log("AGGIORNO VALORE");
            }
        }
        req.getServletContext().log("TABELLA RESETTATA");

        json.setStatus("SUCCESS");

        return Response.ok().entity(json).build();
    }
}
