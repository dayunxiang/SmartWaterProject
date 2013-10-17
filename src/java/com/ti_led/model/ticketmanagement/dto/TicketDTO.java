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
package com.ti_led.model.ticketmanagement.dto;

public class TicketDTO {
    private String id;
    private String company;
    private String noiselogger;
    private String stato;
    private String info;
    
    public String getCompany() {
        return company;
    }
 
    public void setCompany(String company) {
        this.company = company;
    }
    
    public String getId() {
        return id;
    }
 
    public void setId(String id) {
        this.id = id;
    }
    
    public String getNoiselogger() {
        return noiselogger;
    }
 
    public void setNoiselogger(String noiselogger) {
        this.noiselogger = noiselogger;
    }
 
    public String getStato() {
        return stato;
    }
 
    public void setStato(String stato) {
        this.stato = stato;
    }
 
    public String getInfo() {
        return info;
    }
  
    public void setInfo(String info) {
        this.info = info;
    }
    
    @Override
    public String toString() {
        return "Ticket [company=" + company + ", id=" + id + "noise logger=" + noiselogger
                + ", stato=" + stato + ", info=" + info + "]";
    }
    
}
