package com.smart_leak_detection.model.mapsmanagement;

import com.smart_leak_detection.model.mapsmanagement.dto.MapsDataDTO;
import com.smart_leak_detection.model.ticketmanagement.dto.TicketDTO;
import java.io.Serializable;
import java.util.Date;
import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;

    
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
    
    @Column(nullable=false)
    private String timestamp;
    
    @Column(nullable=false)
    private int value;
    
    @Column(nullable=false)
    private int battery;
    
    @Column(nullable=false, length=1024)
    private String status;
    
     
    public MapsData(){
         
    }
     
    public MapsData(MapsDataDTO mapsData){
          this.noiselogger = mapsData.getNoiselogger();
          this.status = mapsData.getStatus();
          this.latitude = mapsData.getLatitude();
          this.longitude = mapsData.getLongitude();
          this.style = mapsData.getStyle();
          this.battery = mapsData.getBattery();
          this.timestamp = mapsData.getTimestamp();
          this.value = mapsData.getValue();
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
 
    public String getStatus() {
        return this.status;
    }
  
    public void setStatus(String status) {
        this.status = status;
    }
    
    public int getValue() {
        return this.value;
    }
  
    public void setValue(int value) {
        this.value = value;
    }
    
    public int getBattery() {
        return this.battery;
    }
  
    public void setBattery(int battery) {
        this.battery = battery;
    }
    
    public String getTimestamp() {
        return this.timestamp;
    }
  
    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }
  
    
    @Override
    public String toString() {
        return "MapsData [noise logger=" + noiselogger
                + ", lat=" + latitude + ", long=" + longitude
                + ", style=" + style + ", status= " + status
                + ", date=" + timestamp + ", value= " + value
                + ", battery=" + battery + "]";
    }
}