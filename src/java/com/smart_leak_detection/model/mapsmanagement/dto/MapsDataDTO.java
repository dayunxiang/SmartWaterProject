package com.smart_leak_detection.model.mapsmanagement.dto;

import java.util.Date;

public class MapsDataDTO {

    private String noiselogger;
    private String status;
    private String style;
    private double latitude;
    private double longitude;
    private int value;
    private int battery;
    private String timestamp;

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
