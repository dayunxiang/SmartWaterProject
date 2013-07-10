package com.smart_leak_detection.data;

import com.smart_leak_detection.data.protocol.Config;
import com.smart_leak_detection.data.protocol.Channel;
import javax.ejb.Stateless;
import javax.servlet.ServletContextEvent;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.core.Context;


public class DataListener implements javax.servlet.ServletContextListener {
    
    Config sendConfig = new Config(10204);
    Channel sendChannel = new Channel(sendConfig);
//    Config recConfig = new Config(10104);
//    Channel recChannel = new Channel(recConfig);
    SendingData sendThread = new SendingData(sendChannel, sendConfig);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        sendThread.start();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
       
        if (sendThread != null) {
            this.sendChannel.close();
            sendThread.interrupt();
        }
    }
}
