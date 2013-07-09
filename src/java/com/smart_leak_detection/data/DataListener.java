package com.smart_leak_detection.data;

import com.smart_leak_detection.data.protocol.Config;
import com.smart_leak_detection.data.protocol.Channel;
import javax.servlet.ServletContextEvent;

public class DataListener implements javax.servlet.ServletContextListener {
    Config config = new Config(8077);
    Channel channels = new Channel(config);
    ReceivingData recThread = new ReceivingData(channels, config);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        recThread.start();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (recThread != null) {
            this.channels.close();
            recThread.interrupt();
        }
    }
}
