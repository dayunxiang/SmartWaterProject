package com.smart_leak_detection.data.protocol;

import java.io.*;
import java.net.*;
import java.net.DatagramSocket;
import java.nio.ByteBuffer;
import java.net.DatagramPacket;

public class Channel {

    private Config config;
    private DatagramSocket socket;
    private String remoteAddress;

    public Channel( final Config c ) {
        this.config = c;
        try {
            this.socket = createChannel( this.config.PORT, 0);
        }
        catch ( Exception x ) {
            System.out.println( "Exception in Channels constructor: " + x.getMessage() );
            throw new RuntimeException( "Unable to create UDP channels" );
        }
    }

    public void close() {
        this.socket.close();
        this.remoteAddress = null;
    }

    public ByteBuffer receiveData() throws IOException { //FIXME if sull'indirizzo IP
        DatagramPacket dp = new DatagramPacket( new byte[config.MTU] , config.MTU );
        this.socket.receive( dp );
        return ByteBuffer.wrap( dp.getData() );
    }

    public void sendData( int message ) throws IOException {
        ByteBuffer buf = ByteBuffer.allocate( config.MTU );
        buf.putInt( message );
        buf.position( 0 );
        byte[] toSend = buf.array();
        DatagramPacket packet = new DatagramPacket( toSend, toSend.length, InetAddress.getByName( config.ADDRESS ), config.PORT);
        this.socket.send( packet );
   }

    /** Private methods */
    private DatagramSocket createChannel( int port, int timeout ) throws SocketException, IOException {
        DatagramSocket socket = new DatagramSocket( port );
        socket.setSoTimeout( timeout );
        return socket;
    }
    
    public String getRemoteIP(){
        return this.remoteAddress;
    }
}
