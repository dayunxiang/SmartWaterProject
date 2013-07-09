package com.smart_leak_detection.data;

import com.smart_leak_detection.data.protocol.Config;
import com.smart_leak_detection.data.protocol.Channel;
import javax.ejb.Stateless;
import javax.servlet.ServletContextEvent;


public class DataListener implements javax.servlet.ServletContextListener {
    Config sendConfig = new Config(10201);
    Channel sendChannel = new Channel(sendConfig);
    Config recConfig = new Config(10101);
    Channel recChannel = new Channel(recConfig);
    ReceivingData recThread = new ReceivingData(recChannel, recConfig);
    SendingData sendThread = new SendingData(sendChannel, sendConfig);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        recThread.start();
        sendThread.start();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (recThread != null) {
            this.recChannel.close();
            recThread.interrupt();
        }
        if (sendThread != null) {
            this.sendChannel.close();
            sendThread.interrupt();
        }
    }
}
