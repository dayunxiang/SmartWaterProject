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
package com.ti_led.data;

import com.ti_led.data.gurux.MeterReadings;
import com.ti_led.model.mapsmanagement.MapsData;
import com.ti_led.model.mapsmanagement.MapsDataBean;
import com.ti_led.model.mapsmanagement.dto.MapsDataDTO;
import com.ti_led.model.measuremanagement.Measure;
import com.ti_led.model.measuremanagement.MeasureBean;
import com.ti_led.model.measuremanagement.dto.MeasureDTO;
import com.ti_led.model.usermanagement.User;
import com.ti_led.model.usermanagement.UserBean;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;

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

public class ReceivingData extends Thread {

    private MeasureDTO measureDto = new MeasureDTO();
    private Measure measure = new Measure();
    private UserBean userBean;
    private Date date;
    private MeasureBean measureBean;
    private MapsDataBean mapsDataBean;
    private MeterData meterData;
    private MapsData mapsData;
    private String ip;
    String firstNL = "25";
    String secondNL = "24";
    String thirdNL = "41";
    int valueF = 0, valueS = 0, valueT = 0;
    boolean isStrict = false;
    boolean alarmSet = false;

    public ReceivingData(String ip, MeasureBean measureBean, UserBean userBean, MapsDataBean mapsDataBean) {
        this.ip = ip;
        this.meterData = new MeterData(this.ip);
        this.measureBean = measureBean;
        this.userBean = userBean;
        this.mapsDataBean = mapsDataBean;
        System.out.println("Receiver AVVIATO");

    }

    @Override
    public void run() {
        String noiselogger = "25";
        String value = "720";
        System.out.println("Receiver IN ESECUZIONE");

        try {
            Thread.sleep(15000);
            Measure measure = new Measure();
            DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm");
            Date date = new Date();
            String timestamp = dateFormat.format(date);
            measure = this.measureBean.find(noiselogger); //Retrive company for the noiselogger
            String company = measure.getCompany();

            MeasureDTO measureDto = new MeasureDTO();
            measureDto.setId("" + date.getTime());
            measureDto.setNoiselogger(noiselogger);
            measureDto.setTimestamp(timestamp);
            measureDto.setBattery("80");
            measureDto.setValue(value);
            measureDto.setCompany(company);

            measure = new Measure(measureDto);
            MapsData mapsData = new MapsData();
            mapsData = this.mapsDataBean.find(noiselogger);
            //update value
            mapsData.setBattery(80);
            mapsData.setTimestamp(timestamp);
            mapsData.setValue(Integer.valueOf(value));
            this.measureBean.save(measure);

            if (Integer.valueOf(value) > 600) { //Leak detected, save first value

                //modify style kml to display leak                        
                mapsData.setStyle("#alarmStyle");
                this.mapsDataBean.update(mapsData); //update last measure for the noiselogger
                System.out.println("MapsData UPDATE");
                //send email to all company users
                String host = "smtp.gmail.com";
                String from = "servizio.tiled@gmail.com";
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
                message.setSubject("TI-LeD - Notifica rilevazione area di perdita");
                message.setContent("<h1>TI-LeD</h1> <br> <div> Gentile utente,<br><br>"
                        + "il sistema TI-LeD ha appena rilevato una area di perdita nella zona del noise logger #" + noiselogger
                        + ".<br>Le ricordiamo di attivare quanto prima la maglia stretta per individuare il punto esatto della perdita."
                        + "<br><br>Cordiali saluti,<br>TI-LeD Team</div>", "text/html");
                Transport transport = session.getTransport("smtp");
                transport.connect(host, from, pass);
                transport.sendMessage(message, message.getAllRecipients());
                System.out.println("EMAIL INVIATA");
                transport.close();
            } else {
                this.mapsDataBean.update(mapsData); //update last measure for the noiselogger
            }
        } catch (Exception e) {
            System.out.println("Error");
        }

        System.out.println("rilevazione creata" + measure);

        System.out.println("successfully added new measure: '" + measure.getCompany() + "':'" + measure.getId() + "'");

    }

    public void setStrict() {
        this.isStrict = true;
        System.out.println("ATTIVO MAGLIA STRETTA");
    }
}
