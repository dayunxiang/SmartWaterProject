package com.smart_leak_detection.model.sensormanagement;

import com.smart_leak_detection.model.sensormanagement.dto.SensorDTO;
import java.io.Serializable;
import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
    
@Entity
@Table(name="SENSOR")
@Cacheable(false)
public class Sensor implements Serializable {
          
    @Id
    @Column(unique=true, nullable=false, length=128)
    private String noiselogger;
  
    @Column(nullable=false, length=128)
    private String company;
    
    public Sensor(){
         
    }
     
    public Sensor(SensorDTO sensor){
          this.company = sensor.getCompany();
          this.noiselogger = sensor.getNoiselogger();
    }
    
    public String getCompany() {
        return company;
    }
 
    public void setCompany(String company) {
        this.company = company;
    }    
    
    public String getNoiselogger() {
        return noiselogger;
    }
 
    public void setNoiselogger(String noiselogger) {
        this.noiselogger = noiselogger;
    }
 
    @Override
    public String toString() {
        return "Ticket [company=" + company + "noise logger=" + noiselogger +  "]";
    }

}
