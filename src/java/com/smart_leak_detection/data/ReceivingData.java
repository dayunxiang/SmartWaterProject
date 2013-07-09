package com.smart_leak_detection.data;

import com.smart_leak_detection.data.protocol.Channel;
import com.smart_leak_detection.data.protocol.Config;
import java.lang.Thread;
import com.smart_leak_detection.model.measuremanagement.Measure;
import com.smart_leak_detection.model.measuremanagement.MeasureBean;
import com.smart_leak_detection.model.sensormanagement.Sensor;
import com.smart_leak_detection.model.sensormanagement.SensorBean;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.Date;
import javax.ejb.EJB;

public class ReceivingData extends Thread {

    @EJB
    private SensorBean sensorBean;
    
    @EJB
    private MeasureBean measureBean;
    
    private Channel channel;
    private Config config;
    private Sensor sensor;
    private Measure measure;
    private Date date = new Date();
    String firstNL, secondNL, thirdNL;
    String valueF, valueS, valueT;

    public ReceivingData(Channel channel, Config config) {
        this.channel = channel;
        this.config = config;
        System.out.println("Receiver AVVIATO receive port: " + config.PORT);
    }

    @Override
    public void run() {
        System.out.println("Receiver IN ESECUZIONE");
        try {
            ByteBuffer buf;
            while (true) {
                System.out.println("Receiver IN ATTESA DI UN PACCHETTO");
                buf = channel.receiveData();
                System.out.println("Receiver DATI RICEVUTI");

                //FIX-ME si deve fare la codifica del pacchetto ed estrarre i dati
                String type = "";
                String noiselogger = "";
                String timestamp = "";
                String value = "";
                String battery = "";

                if (type.compareTo("Large") == 0) { //save new measure
                    this.sensor = this.sensorBean.find(noiselogger); //Retrieve Company name


                    this.measure.setId("" + date.getTime());
                    this.measure.setCompany(this.sensor.getCompany());
                    this.measure.setNoiselogger(noiselogger);
                    this.measure.setTimestamp(timestamp);
                    this.measure.setBattery(battery);
                    this.measure.setValue(value);

                    if (value.compareTo("0") != 0) { //Leak detected, save first value
                        this.firstNL = noiselogger;
                        this.valueF = value;
                    }
                    //save the measure
                    this.measureBean.save(this.measure);
                    //FIX-ME aggiornare kml con nuovi dati del noise logger
                    System.out.println("MISURA INSERITA");
                } else {
                    if (this.firstNL.compareTo(noiselogger) != 0 && this.secondNL.compareTo("") == 0) { //save second value
                        this.secondNL = noiselogger;
                        this.valueS = value;
                    } else { //save third value
                        this.thirdNL = noiselogger; 
                        this.valueT = value;

                        //FIX-ME trovare punto di perdita e mettere placemark kml
                    }
                }


            }
        } catch (IOException e) {
            System.out.println("Exception: " + e.getMessage());

        }

    }
}
