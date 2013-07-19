package com.smart_leak_detection.model.mapsmanagement;

import com.smart_leak_detection.model.mapsmanagement.dto.MapsDataDTO;
import com.smart_leak_detection.model.ticketmanagement.dto.TicketDTO;
import java.io.Serializable;
import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

    
@Entity
@Table(name="Mapsdata")
@Cacheable(false)
public class MapsData implements Serializable {
          
    @Id
    @Column(unique=true, nullable=false, length=128)
    private String noiselogger;
  
    @Column(nullable=false, length=128)
    private String style;
    
    @Column(nullable=false)
    private double latitude;
    
    @Column(nullable=false)
    private double longitude;
    
    @Column(nullable=false, length=1024)
    private String description;
    
     
    public MapsData(){
         
    }
     
    public MapsData(MapsDataDTO mapsData){
          this.noiselogger = mapsData.getNoiselogger();
          this.description = mapsData.getDescription();
          this.latitude = mapsData.getLatitude();
          this.longitude = mapsData.getLongitude();
          this.style = mapsData.getStyle();
    }
 
    public String getNoiselogger() {
        return this.noiselogger;
    }
 
    public void setNoiselogger(String noiselogger) {
        this.noiselogger = noiselogger;
    }
    
    public double getLatitude() {
        return this.latitude;
    }
 
    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }
    
    public double getLongitude() {
        return this.longitude;
    }
 
    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }
 
    public String getStyle() {
        return this.style;
    }
 
    public void setStyle(String style) {
        this.style = style;
    }
 
    public String getDescription() {
        return this.description;
    }
  
    public void setDescription(String description) {
        this.description = description;
    }
  
    
    @Override
    public String toString() {
        return "MapsData [noise logger=" + noiselogger
                + ", lat=" + latitude + ", long=" + longitude
                + ", style=" + style + ", description= " + description + "]";
    }
}