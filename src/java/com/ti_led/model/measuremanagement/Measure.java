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
package com.ti_led.model.measuremanagement;

import com.ti_led.model.measuremanagement.dto.MeasureDTO;
import java.io.Serializable;
import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="MEASURE")
@Cacheable(false)
public class Measure implements Serializable {
          
    @Id
    @Column(unique=true, nullable=false, length=128)
    private String id;
  
    @Column(nullable=false, length=128)
    private String company;
    
    @Column(nullable=false, length=128)
    private String noiselogger;
    
    @Column(nullable=false, length=128)
    private String timestamp;
    
    @Column(nullable=false, length=128)
    private String value;
    
    @Column(nullable=false, length=128)
    private String battery;
    
    public Measure(){
         
    }
     
    public Measure(MeasureDTO measure){
          this.id = measure.getId();
          this.company = measure.getCompany();
          this.noiselogger = measure.getNoiselogger();
          this.timestamp = measure.getTimestamp();
          this.value = measure.getValue();
          this.battery = measure.getBattery();
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
 
    public String getTimestamp() {
        return timestamp;
    }
 
    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }
 
    public String getValue() {
        return value;
    }
  
    public void setValue(String value) {
        this.value = value;
    }
    
    public String getBattery() {
        return battery;
    }
  
    public void setBattery(String battery) {
        this.battery = battery;
    }
    
    @Override
    public String toString() {
        return "Ticket [company=" + company + ", id=" + id + "noise logger=" + noiselogger
                + ", timestamp=" + timestamp + ", value=" + value + ", battery" + battery + "]";
    }    
}
