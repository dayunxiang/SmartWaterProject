package com.nabisoft.model.ticketmanagement.dto;

public class TicketDTO {
    private String company;
    private String id;
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
        return "Ticket [company=" + company + ", id=" + id
                + ", stato=" + stato + ", info=" + info + "]";
    }
    
}
