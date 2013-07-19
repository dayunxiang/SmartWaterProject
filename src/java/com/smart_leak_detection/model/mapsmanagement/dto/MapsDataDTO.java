package com.smart_leak_detection.model.mapsmanagement.dto;

public class MapsDataDTO {
    private String noiselogger;
    private String description;
    private String style;
    private double latitude;
    private double longitude;
    
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
