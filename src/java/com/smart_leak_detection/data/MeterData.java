package com.smart_leak_detection.data;

import com.smart_leak_detection.data.gurux.DlmsServerAddress;
import com.smart_leak_detection.data.gurux.GuruxWrapper;
import com.smart_leak_detection.data.gurux.MeterReadings;
import com.smart_leak_detection.data.gurux.SAP;
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;


import java.math.BigInteger;

public class MeterData {

    public String gatewayId = "TelitGG863_3316042807_LOCAL";
    public String meterId = "ITR";

    public MeterData() {
    }

    public MeterReadings getData() {
        System.out.println("try to execute getMeterReadings");
        MeterReadings res = new MeterReadings();
        DlmsServerAddress gwServerAddress = getGatewayServerAddress(this.gatewayId);
        System.out.println("INDIRIZZO: " + gwServerAddress.address);
        if (gwServerAddress != null) {
            ArrayList<SAP> saps = GuruxWrapper.getSAPAssignment(gwServerAddress.address, gwServerAddress.port);
            for (SAP sap : saps) {
                System.out.println("sap.name = " + sap.name + " meterId = " + this.meterId);
                if (sap.name.contains(this.meterId)) {
                    System.out.println("execute getMeterReadings: SAP address: " + sap.address);
                    res = GuruxWrapper.getMeterReadings(gwServerAddress.address, gwServerAddress.port, 2);
                   return res;
                }
            }
        }
        return res;
    }

    private DlmsServerAddress getGatewayServerAddress(String gatewayId) {
        DlmsServerAddress res = null;

        if (gatewayId.equals("TelitGG863_3316042807_FIELD")) {
            res = new DlmsServerAddress("10.64.183.248", 4059, "TelitGG863_3316042807"); //change with Gateway IP address
        } else if (gatewayId.equals("TelitGG863_3316042807_LOCAL")) {
            res = new DlmsServerAddress("192.168.121.3", 4059, "TelitGG863_3316042807");
        } else if (gatewayId.equals("TelitGG863_3316042807_LAB")) {
            res = new DlmsServerAddress("163.162.40.250", 4059, "TelitGG863_3316042807");
        }
        return res;
    }

    String getXmlPacket(String contentTypes, String payload) {
        Date now = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
        String creationDate = formatter.format(now);

        String res =
                "<contentInstance>"
                + "<contentTypes>" + contentTypes + "</contentTypes>"
                + "<content>"
                + "<telitSmartMeteringPacket>"
                + "<creationDate>" + creationDate + "</creationDate>"
                + payload
                + "</telitSmartMeteringPacket>"
                + "</content>"
                + "</contentInstance>";
        return res;
    }
}
