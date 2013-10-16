package com.ti_led.data.gurux;

import gurux.dlms.DLMSObjectCollection;

import java.util.ArrayList;
import org.apache.log4j.Logger;

public class GuruxWrapper {

    private static Logger logger = Logger.getLogger(GuruxWrapper.class);

    static public ArrayList<SAP> getSAPAssignment(String host, int port) {
        ArrayList<SAP> res = new ArrayList<SAP>();
        GuruxHelper gh = new GuruxHelper("itr", host, port, 1);
        try {
            gh.initializeDLMS();
            gh.initializeConnection();
            DLMSObjectCollection objects = gh.getAssociations();
            ArrayList saps = gh.getSAPList(objects);
            for (int i = 0; i < saps.size(); i++) {
                ArrayList sap = (ArrayList) saps.get(i);
                SAP s = new SAP();
                s.address = (Integer) sap.get(0);
                String name = new String((byte[]) sap.get(1));
                s.name = removeNullChars(name);
                logger.info("Sap id:" + s.name + " address: " + s.address);
                res.add(s);
            }
        } catch (Exception e) {
            logger.info("Errore: " + e.getMessage());
            e.printStackTrace();
            res = null;
        }
        try {
            gh.close();
        } catch (Exception e) {
            logger.info("Errore: " + e.getMessage());
            e.printStackTrace();
        }
        return res;
    }

    static public MeterReadings getMeterReadings(String host, int port, int serverAddress) {
        MeterReadings res = null;
        GuruxHelper gh = new GuruxHelper("itr", host, port, serverAddress);
        try {
            res = new MeterReadings();
            gh.initializeDLMS();
            gh.initializeConnection();
            DLMSObjectCollection objects = gh.getAssociations();
            System.out.println("OGGETTI RICEVUTI: " + objects.toString());
            ArrayList<Value> values = gh.getValuesList(objects);
            System.out.println("NUMERO VALORI: " + values.size());
            for (int i = 0; i < values.size(); i++) {
                Value value = values.get(i);
                if (value.logicalName.equals("0.0.42.0.0.255")) {
                    System.out.println("VALORE LETTO: " + value.val);
                    res.name = convertSapName((String) value.val);
                } else if (value.logicalName.equals("7.0.1.0.0.255")) {
                    res.meter = (java.math.BigInteger) value.val;
                } else if (value.logicalName.equals("0.0.96.3.10.255")) {
                    res.valveStatus = (Byte) value.val;
                }
            }
            logger.info("Meter name:" + res.name + " meter: " + res.meter + " valveStatus: " + res.valveStatus);
        } catch (Exception e) {
            logger.info("Errore: " + e.getMessage());
            e.printStackTrace();
        }
        try {
            gh.close();
        } catch (Exception e) {
            logger.info("Errore: " + e.getMessage());
            e.printStackTrace();
        }
        return res;
    }

    private static String convertSapName(String value) {
        String res = "";
        String[] hexChars = value.split(" ");
        char[] chars = new char[hexChars.length];
        try {
            for (int i = 0; i < chars.length; i++) {
                chars[i] = (char) Integer.parseInt(hexChars[i].trim(), 16);
            }
            res = new String(chars);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return res;
    }

    public static String removeNullChars(String text) {
        int length = text.length();
        StringBuffer buffer = new StringBuffer(length);
        for (int i = 0; i < length; i++) {
            char ch = text.charAt(i);
            if (ch != 0) {
                buffer.append(ch);
            }
        }
        return buffer.toString();
    }
//	public static void main(String[] args) {
////		GuruxWrapper.getSAPAssignment("163.162.18.132", 4059);
//		GuruxWrapper.getMeterReadings("163.162.18.132", 4059, 3);
//	}
}
