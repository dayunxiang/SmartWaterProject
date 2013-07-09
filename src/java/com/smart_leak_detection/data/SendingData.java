package com.smart_leak_detection.data;

import com.smart_leak_detection.data.protocol.Config;
import com.smart_leak_detection.data.protocol.Channel;
import java.lang.Thread;
import java.io.IOException;
import java.nio.ByteBuffer;

public class SendingData extends Thread {

    private Channel channels;
    private Config config;

    public SendingData(Channel channels, Config config) {
        this.channels = channels;
        this.config = config;
        System.out.println("Sender AVVIATO sender port: " + config.PORT);
    }

    @Override
    public void run() {
        System.out.println("Sender IN ESECUZIONE");
//        try {
//            int activation = 0;
//            while (true) {
//                System.out.println("INVIO DATI");
//                channels.sendData(activation);
//            }
//        } catch (IOException e) {
//            System.err.println("Exception: " + e.getMessage());
//        }

    }
}
