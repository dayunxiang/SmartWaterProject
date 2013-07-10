package com.smart_leak_detection.data;

import com.smart_leak_detection.data.protocol.Channel;
import com.smart_leak_detection.data.protocol.Config;
import java.lang.Thread;
import com.smart_leak_detection.model.measuremanagement.Measure;
import com.smart_leak_detection.model.measuremanagement.MeasureBean;
import com.smart_leak_detection.model.measuremanagement.dto.MeasureDTO;
import com.smart_leak_detection.model.sensormanagement.Sensor;
import com.smart_leak_detection.model.sensormanagement.SensorBean;
import com.smart_leak_detection.model.usermanagement.User;
import com.smart_leak_detection.model.usermanagement.UserBean;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.security.Principal;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.core.Context;

public class ReceivingData extends Thread {

    private Channel channel;
    private Config config;
    private MeasureDTO measure = new MeasureDTO();
    private UserBean userBean;
    private Date date = new Date();
    private MeasureBean measureBean;
    String firstNL, secondNL, thirdNL;
    String valueF, valueS, valueT;

    public ReceivingData(Channel channel, Config config, MeasureBean measureBean, UserBean userBean) {
        this.channel = channel;
        this.config = config;
        this.measureBean = measureBean;
        this.userBean = userBean;
        System.out.println("Receiver AVVIATO receive port: " + config.PORT);
        System.out.println("Receiver AVVIATO measure bean: " + this.measureBean);

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
                String type = "Large";
                String noiselogger = "";
                String timestamp = "";
                String value = "";
                String battery = "";
                String company = "Prova";

                if (type.compareTo("Large") == 0) {


                    this.measure.setId("" + date.getTime());
                    this.measure.setNoiselogger(noiselogger);
                    this.measure.setTimestamp(timestamp);
                    this.measure.setBattery(battery);
                    this.measure.setValue(value);
                    this.measure.setCompany(company);
                    //save new measure
                    Measure m = new Measure(this.measure);
                    this.measureBean.save(m);
                    System.out.println("Measure SALVATO!");

                    if (value.compareTo("0") != 0 && this.firstNL.compareTo("") == 0) { //Leak detected, save first value
                        this.firstNL = noiselogger;
                        this.valueF = value;

                        //send email to all company users
                        String host = "smtp.gmail.com";
                        String from = "smart.leak.detection@gmail.com";
                        String pass = "smartleakdetection";
                        Properties props = System.getProperties();
                        props.put("mail.smtp.starttls.enable", "true");
                        props.put("mail.smtp.host", host);
                        props.put("mail.smtp.user", from);
                        props.put("mail.smtp.password", pass);
                        props.put("mail.smtp.port", "587");
                        props.put("mail.smtp.auth", "true");

                        List<User> list = userBean.findAll(company);
                        String[] to = new String[list.size()];
                        for (int i = 0; i < list.size(); i++) {
                            to[i] = list.get(i).getEmail();
                        }

                        Session session = Session.getDefaultInstance(props, null);
                        MimeMessage message = new MimeMessage(session);
                        message.setFrom(new InternetAddress(from));

                        InternetAddress[] toAddress = new InternetAddress[to.length];

                        for (int i = 0; i < to.length; i++) {        // To get the array of addresses
                            toAddress[i] = new InternetAddress(to[i]);
                        }
                        System.out.println(Message.RecipientType.TO);

                        for (int i = 0; i < toAddress.length; i++) {
                            message.addRecipient(Message.RecipientType.TO, toAddress[i]);
                        }
                        message.setSubject("Smart Leak Detection - Perdita Rilevata");
                        message.setContent("<h1>Smart Leak Detection</h1> <br> <div> Perdita rilevata dal noise logger:" + noiselogger + " </div>", "text/html");
                        Transport transport = session.getTransport("smtp");
                        transport.connect(host, from, pass);
                        transport.sendMessage(message, message.getAllRecipients());
                        transport.close();

                    }
                    //FIX-ME aggiornare kml con nuovi dati del noise logger
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

        } catch (MessagingException ex) {
            Logger.getLogger(ReceivingData.class.getName()).log(Level.SEVERE, null, ex);
        }

    }
}
