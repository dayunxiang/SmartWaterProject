package com.smart_leak_detection.data.protocol;


public class Config {

    // Ok, these are not consts, but they're all UPPERCASE since they're all defaults
    public int PORT = 8101;
    public String ADDRESS   = "localhost";
    public int MTU = 1472;

    public Config(int port ) {
        this.PORT = port;
    };
}
