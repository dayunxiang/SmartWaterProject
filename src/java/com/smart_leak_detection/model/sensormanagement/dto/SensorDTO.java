package com.smart_leak_detection.model.sensormanagement.dto;

public class SensorDTO {

    private String company;
    private String noiselogger;
       
    public String getCompany() {
        return this.company;
    }
 
    public void setCompany(String company) {
        this.company = company;
    }    
    
    public String getNoiselogger() {
        return this.noiselogger;
    }
 
    public void setNoiselogger(String noiselogger) {
        this.noiselogger = noiselogger;
    }
 
    @Override
    public String toString() {
        return "Ticket [company=" + this.company + "noise logger=" + this.noiselogger +  "]";
    }
}
