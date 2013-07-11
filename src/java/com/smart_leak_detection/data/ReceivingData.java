package com.smart_leak_detection.data;

import com.smart_leak_detection.data.protocol.Channel;
import com.smart_leak_detection.data.protocol.Config;
import com.smart_leak_detection.model.measuremanagement.Measure;
import com.smart_leak_detection.model.measuremanagement.MeasureBean;
import com.smart_leak_detection.model.measuremanagement.dto.MeasureDTO;
import com.smart_leak_detection.model.usermanagement.User;
import com.smart_leak_detection.model.usermanagement.UserBean;
import de.micromata.opengis.kml.v_2_2_0.Coordinate;
import de.micromata.opengis.kml.v_2_2_0.Document;
import de.micromata.opengis.kml.v_2_2_0.Feature;
import de.micromata.opengis.kml.v_2_2_0.Kml;
import de.micromata.opengis.kml.v_2_2_0.Placemark;
import de.micromata.opengis.kml.v_2_2_0.Point;
import java.io.File;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.Date;
import java.util.Iterator;
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

    private Channel channel;
    private Config config;
    private MeasureDTO measure = new MeasureDTO();
    private UserBean userBean;
    private Date date = new Date();
    private MeasureBean measureBean;
    String firstNL = "Noise_Logger_Example1";
    String secondNL = "Secondo";
    String thirdNL = "Terzo";
    int valueF, valueS, valueT;
    boolean isStrict = false;

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

            //while (true) {
            System.out.println("Receiver IN ATTESA DI UN PACCHETTO");
            //buf = channel.receiveData();
            System.out.println("Receiver DATI RICEVUTI");

            //FIX-ME si deve fare la codifica del pacchetto ed estrarre i dati
            String type = "Large";
            String noiselogger = "Noise_Logger_Example1";
            String timestamp = "11";
            int value = 20;
            String battery = "111";
            String company = "CONSEL - Consorzio Elis";

            if (!this.isStrict && noiselogger.compareTo(this.firstNL) == 0) {
                //Leggo se è attiva solo la maglia larga ed i dati sono del primo NL
                this.measure.setId("" + date.getTime());
                this.measure.setNoiselogger(noiselogger);
                this.measure.setTimestamp(timestamp);
                this.measure.setBattery(battery);
                this.measure.setValue("" + value);
                this.measure.setCompany(company);
                //save new measure
                Measure m = new Measure(this.measure);
                measureBean.save(m);
                System.out.println("Measure SALVATO!");

                String description = "Timestamp last value: "
                        + timestamp
                        + "\nValue level:"
                        + value
                        + "\nStatus:OK \nBattery:"
                        + battery;
                String path = "/Users/pelldav/University/Tesi/SmartWaterProject/web/file/Noise_loggers_copia.kml";


                Kml kml = Kml.unmarshal(new File(path));
                Document document = (Document) kml.getFeature(); //Get the document features

                Iterator<Feature> iterator = document.getFeature().iterator(); //Create an iterator for the placemark
                Feature feature = null;
                Placemark placemark = null;
                double latitude = 0;
                double longitude = 0;
                while (iterator.hasNext()) {
                    feature = iterator.next();
                    if (feature instanceof Placemark) {
                        placemark = (Placemark) feature;
                        if (placemark.getName().compareTo(noiselogger) == 0) {
                            placemark.setDescription(description);
                            Point point = (Point) placemark.getGeometry();
                            List<Coordinate> coordinates = point.getCoordinates();
                            for (Coordinate coordinate : coordinates) {
                                latitude = coordinate.getLatitude();
                                longitude = coordinate.getLongitude();
                            }
                            break;
                        }
                    }
                }

                if (value != 0 && this.firstNL.compareTo("") == 0) { //Leak detected, save first value
                    this.firstNL = noiselogger;
                    this.valueF = Integer.valueOf(value);

                    //modify style kml to display leak                        
                    feature.setStyleUrl("#noiseStyle2");
                    //FIX-ME vedere di disegnare un cerchio sulla mappa centrato sul noise logger
                    
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
                kml.marshal(new File(path + ".app"));

//                }
//                if (isStrict) {
//                    if (this.firstNL.compareTo(noiselogger) != 0 && this.secondNL.compareTo("") == 0) { //save second value
//                        this.valueS = value;
//                    } else { //save third value
//                        this.valueT = value;
//
//                        //Elaborate data
//                        if (this.valueS > this.valueT) {
//                            //FIX-ME tratto tra il primo ed il secondo NL
//                        } else {
//                            //FIX-ME tratto tra primo e terzo NL
//                        }
//
//                        this.isStrict = false; //reset maglia fitta
//                    }
//                }


            }
        } catch (IOException e) {
            System.out.println("Exception: " + e.getMessage());

        } catch (MessagingException ex) {
            Logger.getLogger(ReceivingData.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    public void setStrict() {
        this.isStrict = true;
    }
}
