
package com.ti_led.model.ticketmanagement;

import com.ti_led.model.ticketmanagement.dto.TicketDTO;
import java.io.Serializable;
import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

    
@Entity
@Table(name="TICKET")
@Cacheable(false)
public class Ticket implements Serializable {
          
    @Id
    @Column(unique=true, nullable=false, length=128)
    private String id;
  
    @Column(nullable=false, length=128)
    private String company;
    
    @Column(nullable=false, length=128)
    private String noiselogger;
    
    @Column(nullable=false, length=128)
    private String stato;
    
    @Column(nullable=false, length=1024)
    private String info;
    
     
    public Ticket(){
         
    }
     
    public Ticket(TicketDTO ticket){
          this.id = ticket.getId();
          this.company = ticket.getCompany();
          this.noiselogger = ticket.getNoiselogger();
          this.info = ticket.getInfo();
          this.stato = ticket.getStato();
    }
 
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