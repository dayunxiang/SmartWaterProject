package com.smart_leak_detection.data;

import com.smart_leak_detection.data.gurux.MeterReadings;
import com.smart_leak_detection.model.mapsmanagement.MapsData;
import com.smart_leak_detection.model.mapsmanagement.MapsDataBean;
import com.smart_leak_detection.model.mapsmanagement.dto.MapsDataDTO;
import com.smart_leak_detection.model.measuremanagement.Measure;
import com.smart_leak_detection.model.measuremanagement.MeasureBean;
import com.smart_leak_detection.model.measuremanagement.dto.MeasureDTO;
import com.smart_leak_detection.model.usermanagement.User;
import com.smart_leak_detection.model.usermanagement.UserBean;

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

//    private Channel channel;
//    private Config config;
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
//        this.channel = channel;
//        this.config = config;
        this.ip = ip;
        this.meterData = new MeterData(this.ip);
        this.measureBean = measureBean;
        this.userBean = userBean;
        this.mapsDataBean = mapsDataBean;
        System.out.println("Receiver AVVIATO");

    }

    @Override
    public void run() {
        MeterReadings data;
        System.out.println("Receiver IN ESECUZIONE");
//        try {
            while (true) {
                date = new Date();
                System.out.println("Receiver IN ATTESA DI UN PACCHETTO");
                //buf = channel.receiveData();
                data = this.meterData.getData();
                System.out.println("Receiver: Name:" + data.name + " Valve Status: " + data.valveStatus + "Data meter: " + data.meter);
                String s = data.meter.toString();
                List<String> parts = new ArrayList<String>();
                int size = s.length();
                if (size == 7) {
                    parts.add(s.substring(0, 3));
                    parts.add(s.substring(3, 5));
                    parts.add(s.substring(5, 7));
                } else {
                    parts.add(s.substring(0, 2));
                    parts.add(s.substring(2, 4));
                    parts.add(s.substring(4, 6));
                }
//                for (int j = 0; j < size; j += 2) {
//                    parts.add(s.substring(j, Math.min(j + 2, size)));
//                }
                int battery = Integer.decode("0x" + parts.get(1)); //Get int value
                int value = Integer.decode("0x" + parts.get(0)); //Get int value
                value = value * 1023 / 255;
                String noiselogger = Integer.decode("0x" + parts.get(2)).toString();
                if (Integer.valueOf(noiselogger) < 10) {
                    noiselogger = noiselogger.split("0")[1];
                }
                System.out.println("Noiselogger: " + noiselogger + " Valore: " + value + " Battery: " + battery);

//                String timestamp = "" + date.getYear() + "-" + date.getDay() + "-" + date.getMonth() + " " + date.getHours() + ":" + date.getMinutes();
                DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm");
                Date date = new Date();
                String timestamp = dateFormat.format(date);
                this.measure = this.measureBean.find(noiselogger); //Retrive company for the noiselogger
                String company = this.measure.getCompany();

                if (!this.isStrict && noiselogger.compareTo(this.firstNL) == 0 && !alarmSet) {
//                if (!this.isStrict) { //ripristinare quello sopra appea funzionerà tutto
                    //Leggo se è attiva solo la maglia larga ed i dati sono del primo NL
                    this.alarmSet = true;
                    this.measureDto.setId("" + date.getTime());
                    this.measureDto.setNoiselogger(noiselogger);
                    this.measureDto.setTimestamp(timestamp);
                    this.measureDto.setBattery("" + battery);
                    this.measureDto.setValue("" + value);
                    this.measureDto.setCompany(company);
                    //save new measure
                    this.measure = new Measure(this.measureDto);
                    measureBean.save(measure);
                    System.out.println("Measure SALVATO!");

                    //Retrieve old measure
                    this.mapsData = this.mapsDataBean.find(noiselogger);
                    //update value
                    this.mapsData.setBattery(battery);
                    this.mapsData.setTimestamp(timestamp);
                    this.mapsData.setValue(value);
                    if (value > 300) { //Leak detected, save first value
//                    if (value != 0) { //ripristinare una volta effettuato il test   
                        this.valueF = value;

                        //modify style kml to display leak                        
                        this.mapsData.setStyle("#alarmStyle");
                        this.mapsDataBean.update(mapsData); //update last measure for the noiselogger
                        System.out.println("MapsData UPDATE");



                        //send email to all company users
//                        String host = "smtp.gmail.com";
//                        String from = "servizio.tiled@gmail.com";
//                        String pass = "smartleakdetection";
//                        Properties props = System.getProperties();
//                        props.put("mail.smtp.starttls.enable", "true");
//                        props.put("mail.smtp.host", host);
//                        props.put("mail.smtp.user", from);
//                        props.put("mail.smtp.password", pass);
//                        props.put("mail.smtp.port", "587");
//                        props.put("mail.smtp.auth", "true");
//
//                        List<User> list = userBean.findAll(company);
//                        String[] to = new String[list.size()];
//                        for (int i = 0; i < list.size(); i++) {
//                            to[i] = list.get(i).getEmail();
//                        }
//
//                        Session session = Session.getDefaultInstance(props, null);
//                        MimeMessage message = new MimeMessage(session);
//                        message.setFrom(new InternetAddress(from));
//
//                        InternetAddress[] toAddress = new InternetAddress[to.length];
//
//                        for (int i = 0; i < to.length; i++) {        // To get the array of addresses
//                            toAddress[i] = new InternetAddress(to[i]);
//                        }
//                        System.out.println(Message.RecipientType.TO);
//
//                        for (int i = 0; i < toAddress.length; i++) {
//                            message.addRecipient(Message.RecipientType.TO, toAddress[i]);
//                        }
//                        message.setSubject("TI-LeD - Notifica rilevazione area di perdita");
//                        message.setContent("<h1>TI-LeD</h1> <br> <div> Gentile utente,<br><br>"
//                                + "Il sistema TI-LeD ha appena rilevato una area di perdita nella zone del noise logger #" + noiselogger
//                                + ".<br>Le ricordiamo di attivare quanto prima la maglia fitta per individuare il punto esatto della perdita."
//                                + "<br><br>Cordiali saluti,<br>TI-LeD Team</div>", "text/html");
//                        Transport transport = session.getTransport("smtp");
//                        transport.connect(host, from, pass);
//                        transport.sendMessage(message, message.getAllRecipients());
//                        System.out.println("EMAIL INVIATA");
//                        transport.close();



                    } else {
                        this.mapsDataBean.update(mapsData); //update last measure for the noiselogger
                    }
                }
                if (isStrict) {
                    if (this.secondNL.compareTo(noiselogger) == 0 && value > 400) { //save second value
                        this.valueS = value;
                        this.mapsData = this.mapsDataBean.find(noiselogger);
                        //update value to display in maps for #strictStyle also battery and status
                        this.mapsData.setBattery(battery);
                        this.mapsData.setTimestamp(timestamp);
                        this.mapsData.setValue(value);
                        this.mapsDataBean.update(mapsData); //update last measure for the noiselogger
                    }
                    if (this.thirdNL.compareTo(noiselogger) == 0 && value > 400) { //save third value
                        this.valueT = value;
                        //update value to display in maps for #strictStyle also battery and status
                        this.mapsData.setBattery(battery);
                        this.mapsData.setTimestamp(timestamp);
                        this.mapsData.setValue(value);
                        this.mapsDataBean.update(mapsData); //update last measure for the noiselogger

                    }
                    if (this.valueS != 0 && this.valueT != 0) {
                        MapsDataDTO leak = new MapsDataDTO();
                        leak.setBattery(0);
                        leak.setNoiselogger("leak");
                        leak.setStatus("leak");
                        leak.setStyle("leak");
                        leak.setTimestamp("leak");
                        leak.setValue(0);
//                        //send email to all company users
//                        String host = "smtp.gmail.com";
//                        String from = "servizio.tiled@gmail.com";
//                        String pass = "smartleakdetection";
//                        Properties props = System.getProperties();
//                        props.put("mail.smtp.starttls.enable", "true");
//                        props.put("mail.smtp.host", host);
//                        props.put("mail.smtp.user", from);
//                        props.put("mail.smtp.password", pass);
//                        props.put("mail.smtp.port", "587");
//                        props.put("mail.smtp.auth", "true");
//
//                        List<User> list = userBean.findAll(company);
//                        String[] to = new String[list.size()];
//                        for (int i = 0; i < list.size(); i++) {
//                            to[i] = list.get(i).getEmail();
//                        }
//
//                        Session session = Session.getDefaultInstance(props, null);
//                        MimeMessage message = new MimeMessage(session);
//                        message.setFrom(new InternetAddress(from));
//
//                        InternetAddress[] toAddress = new InternetAddress[to.length];
//
//                        for (int i = 0; i < to.length; i++) {        // To get the array of addresses
//                            toAddress[i] = new InternetAddress(to[i]);
//                        }
//                        System.out.println(Message.RecipientType.TO);
//
//                        for (int i = 0; i < toAddress.length; i++) {
//                            message.addRecipient(Message.RecipientType.TO, toAddress[i]);
//                        }
//                        message.setSubject("TI-LeD - Individuato punto di perdita");
//                        message.setContent("<h1>TI-LeD</h1> <br> <div>Gentile utente,<br><br>"
//                                + "in seguito alla attivazione della maglia fitta, il sistema TI-LeD ha localizzato una perdita sulla Sua rete.<br>"
//                                + "Può consultare la mappa tramite il nostro portale per visualizzare la posizione precisa.<br><br>"
//                                + "Cordiali saluti,<br>TI-LeD Team</div>", "text/html");
////                        Transport transport = session.getTransport("smtp");
//                        transport.connect(host, from, pass);
//                        transport.sendMessage(message, message.getAllRecipients());
//                        System.out.println("EMAIL INVIATA");
//                        transport.close();

                        //Elaborate data
                        if (this.valueS > this.valueT) {
                            leak.setLatitude(45.11065555);
                            leak.setLongitude(7.66566111);
                            MapsData mapsLeak = new MapsData(leak);
                            this.mapsDataBean.save(mapsLeak);
                            //Send Data
                            System.out.println("PERDITA PRIMO TRATTO: valore2: " + this.valueS + " valore3: " + this.valueT);
                        } else {
                            leak.setLatitude(45.10998333);
                            leak.setLongitude(7.6661);
                            MapsData mapsLeak = new MapsData(leak);
                            this.mapsDataBean.save(mapsLeak);
                            //Send email
                            System.out.println("PERDITA SECONDO TRATTO valore2: " + this.valueS + " valore3: " + this.valueT);
                        }
                        this.isStrict = false; //reset maglia fitta
                    }
                }
//                Thread.sleep(5000);
            }

//        } 
//        catch (MessagingException ex) {
//            Logger.getLogger(ReceivingData.class.getName()).log(Level.SEVERE, null, ex);
//        }
    }

    public void setStrict() {
        this.isStrict = true;
        System.out.println("ATTIVO MAGLIA FITTA");
    }
}
