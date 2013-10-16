package com.ti_led.model.measuremanagement.dto;

public class MeasureDTO {
    private String id;
    private String company;
    private String noiselogger;
    private String timestamp;
    private String value;
    private String battery;
    
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
