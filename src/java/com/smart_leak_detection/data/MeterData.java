package com.smart_leak_detection.data;

import com.smart_leak_detection.data.gurux.DlmsServerAddress;
import com.smart_leak_detection.data.gurux.GuruxHelper;
import com.smart_leak_detection.data.gurux.GuruxWrapper;
import com.smart_leak_detection.data.gurux.MeterReadings;
import com.smart_leak_detection.data.gurux.SAP;
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;


import java.math.BigInteger;
import org.apache.log4j.Logger;

public class MeterData {

    public String gatewayId;
    public String meterId = "ITR";
    public String ip;
    private Logger logger = Logger.getLogger(MeterData.class);

    public MeterData(String ip) {
        this.ip = ip;
        if (this.ip.compareTo("localhost") == 0) {
            this.gatewayId = "TelitGG863_3316042807_LOCAL";
        } else {
            this.gatewayId = "TelitGG863_3316042807_FIELD";
        }
    }

    public MeterReadings getData() {
        logger.info("try to execute getMeterReadings");
        MeterReadings res = new MeterReadings();
        DlmsServerAddress gwServerAddress = getGatewayServerAddress(this.gatewayId);
        logger.info("INDIRIZZO: " + gwServerAddress.address);
        if (gwServerAddress != null) {
            ArrayList<SAP> saps = GuruxWrapper.getSAPAssignment(gwServerAddress.address, gwServerAddress.port);
            for (SAP sap : saps) {
                if (saps.size() == 1) {
                    logger.info("sap.name = " + sap.name + " meterId = " + this.meterId);
                    if (sap.name.contains(this.meterId)) {
                        logger.info("execute getMeterReadings: SAP address: " + sap.address);
                        res = GuruxWrapper.getMeterReadings(gwServerAddress.address, gwServerAddress.port, 1);
                        return res;
                    }
                } else {
                    logger.info("sap.name = " + sap.name + " meterId = " + this.meterId);
                    if (sap.name.contains(this.meterId)) {
                        logger.info("execute getMeterReadings: SAP address: " + sap.address);
                        res = GuruxWrapper.getMeterReadings(gwServerAddress.address, gwServerAddress.port, 2);
                        return res;
                    }
                }
            }
        }
        return res;
    }

    private DlmsServerAddress getGatewayServerAddress(String gatewayId) {
        DlmsServerAddress res = null;

        if (gatewayId.equals("TelitGG863_3316042807_FIELD")) {
            res = new DlmsServerAddress(this.ip, 4059, "TelitGG863_3316042807"); //change with Gateway IP address
        } else if (gatewayId.equals("TelitGG863_3316042807_LOCAL")) {
            res = new DlmsServerAddress("192.168.121.3", 4059, "TelitGG863_3316042807");
        } else if (gatewayId.equals("TelitGG863_3316042807_LAB")) {
            res = new DlmsServerAddress("163.162.40.250", 4059, "TelitGG863_3316042807");
        }
        return res;
    }
}
