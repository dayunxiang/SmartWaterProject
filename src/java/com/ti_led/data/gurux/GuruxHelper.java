package com.ti_led.data.gurux;

import java.io.DataInputStream;
import java.net.Socket;
import java.util.ArrayList;

import org.apache.log4j.Logger;

import gurux.dlms.Authentication;
import gurux.dlms.DLMSObjectCollection;
import gurux.dlms.GXDLMS;
import gurux.dlms.GXDLMSObject;
import gurux.dlms.InterfaceType;
import gurux.dlms.ObjectType;
import gurux.dlms.RequestTypes;
import gurux.dlms.manufacturerSettings.GXManufacturer;
import gurux.dlms.manufacturerSettings.GXManufacturerCollection;
import gurux.dlms.manufacturerSettings.GXManufacturerFinder;
import gurux.dlms.manufacturerSettings.MediaType;
import java.net.InetSocketAddress;
import java.net.URL;
import java.security.CodeSource;
import java.security.ProtectionDomain;

public class GuruxHelper {

    GXDLMS dlms;
    GXManufacturer manufacturer;
    String manufacturerId;
    String host;
    int port;
    short serverDlmsAddress;
    Socket sock;
    private Logger logger = Logger.getLogger(GuruxHelper.class);

    public GuruxHelper(String manufacturerId, String host, int port, int serverDlmsAddress) {
        dlms = new GXDLMS();
        this.manufacturerId = manufacturerId;
        this.host = host;
        this.port = port;
        this.serverDlmsAddress = (short) serverDlmsAddress;
    }

    public void initializeDLMS() throws Exception {
        //Initialize Manufacturer Settings from XML file (Chaneg for ServiceMix)
//		GXManufacturerCollection items = GXManufacturerFinder.parse("/home/smx/smx/etc/ManufacturerSettings");                
        Class cls = this.getClass();
        ProtectionDomain pDomain = cls.getProtectionDomain();
        CodeSource cSource = pDomain.getCodeSource();
        URL loc = cSource.getLocation();
        String path = loc.getPath().split("W")[0] + "resources/ManufacturerSettings/";
        GXManufacturerCollection items = GXManufacturerFinder.parse(path);
        manufacturer = items.findByID(manufacturerId);
        if (manufacturer != null) {
            logger.info("trovato manufacturerId=" + manufacturerId);
        }
        //Initialize DLMS
        dlms.setInterfaceType(manufacturer.getUseIEC47() ? InterfaceType.Net : InterfaceType.General);
        dlms.setUseLogicalNameReferencing(manufacturer.getUseLN());
        Object val = manufacturer.getAuthentication(MediaType.None, Authentication.None).getClientID();
        long value = Long.parseLong(val.toString());
        dlms.setClientID(GXManufacturer.convertTo(value, val.getClass()));
        dlms.setServerID(serverDlmsAddress);
        dlms.setAuthentication(Authentication.None);
    }

    public void initializeConnection() throws Exception {
        if (sock != null) {
            close();
        }
//        sock = new Socket(host, port);
        sock = new Socket();
        sock.connect(new InetSocketAddress(host, port), 30000);
        byte[] reply = null;
        byte[] data = null;

        //Generate AARQ request.
        data = dlms.AARQRequest(null);
        //Split requests to multible packets if needed.
        //If password is used all data might not fit to one packet.
        byte[][] arr = dlms.SplitDataToPackets(data);
        int len = arr.length;
        for (int pos = 0; pos != len; ++pos) {
            data = dlms.Read(arr[pos], pos + 1, len, ObjectType.None, 0);
            reply = readDLMSPacket(data);
        }
        //Parse reply.
        dlms.ParseAAREResponse(reply);
    }

    public DLMSObjectCollection getAssociations() throws Exception {
        byte[] data = dlms.GetObjects(gurux.dlms.RegisterObjectType.AssociationView);
        byte[] reply = readDataBlock(data);
        DLMSObjectCollection objects = dlms.ParseObjects(reply, ObjectType.None);
        for (Object it : objects) {
            GXDLMSObject ln = (GXDLMSObject) it;
            logger.info("Logicalname: " + ln.getLogicalName() + " InterfaceType: " + ln.getInterfaceType());
        }
        return objects;
    }

    public ArrayList getSAPList(DLMSObjectCollection objects) throws Exception {
        ArrayList saps = null;
        DLMSObjectCollection sapAssignments = objects.GetObjects(new ObjectType[]{ObjectType.SapAssignment});
        if (sapAssignments.size() == 1) {
            GXDLMSObject sapAssignment = (GXDLMSObject) sapAssignments.get(0);
            saps = (ArrayList) readObject(sapAssignment, 2);
        }
        return saps;
    }

    public ArrayList getValuesList(DLMSObjectCollection objects) throws Exception {
        ArrayList<Value> values = new ArrayList<Value>();
        DLMSObjectCollection registers = objects.GetObjects(new ObjectType[]{ObjectType.Register, ObjectType.ExtendedRegister, ObjectType.DemandRegister, ObjectType.RegisterActivation, ObjectType.Data});
        for (Object it : registers) {
            Value value = new Value();

            GXDLMSObject reg = (GXDLMSObject) it;
            value.logicalName = reg.getLogicalName();
            value.val = readObject(reg, 2);
            values.add(value);
        }
        return values;
    }

    Object readObject(GXDLMSObject item, int attributeIndex) throws Exception {
        byte[] data = dlms.Read(item.toString(), 1, 1, item.getInterfaceType(), attributeIndex);
        data = readDataBlock(data);
        return manufacturer.changeType(item.getLogicalName(), item.getInterfaceType(), attributeIndex, data);
    }

    byte[] readDataBlock(byte[] data) throws Exception {
        byte[] reply = readDLMSPacket(data);
        byte[] allData = null;
        allData = dlms.GetDataFromPacket(reply, allData);
        //If there is nothing to send.
        if (allData == null) {
            return null;
        }
        int maxProgress = dlms.GetMaxProgressStatus(allData);
        java.util.Set<gurux.dlms.RequestTypes> moredata = dlms.IsMoreDataAvailable(reply);
        int lastProgress = 0;
        float progress = 0;
        while (!moredata.isEmpty()) {
            while (moredata.contains(gurux.dlms.RequestTypes.Frame)) {
                data = dlms.ReceiverReady(gurux.dlms.RequestTypes.Frame);
                reply = readDLMSPacket(data);
                allData = dlms.GetDataFromPacket(reply, allData);
                //Show progress.
                if (maxProgress != 1) {
                    progress = dlms.GetCurrentProgressStatus(allData);
                    progress = progress / maxProgress * 80;
                    if (lastProgress != (int) progress) {
                        for (int pos = lastProgress; pos < (int) progress; ++pos) {
                            logger.info("-");
                        }
                        lastProgress = (int) progress;
                    }
                }
                if (!dlms.IsMoreDataAvailable(reply).contains(RequestTypes.Frame)) {
                    moredata.remove(RequestTypes.Frame);
                    break;
                }
            }
            if (moredata.contains(gurux.dlms.RequestTypes.DataBlock)) {
                //Send Receiver Ready.
                data = dlms.ReceiverReady(RequestTypes.DataBlock);
                reply = readDLMSPacket(data);
                allData = dlms.GetDataFromPacket(reply, allData);
                moredata = dlms.IsMoreDataAvailable(reply);
                //Show progress.
                if (maxProgress != 1) {
                    progress = dlms.GetCurrentProgressStatus(allData);
                    progress = progress / maxProgress * 80;
                    if (lastProgress != (int) progress) {
                        for (int pos = lastProgress; pos < (int) progress; ++pos) {
                            logger.info("+");
                        }
                        lastProgress = (int) progress;
                    }
                }
            }
        }
        if (maxProgress != 1) {
            logger.info("Received all data");
        }
        return allData;
    }

    String toHex(byte[] bytes) {
        return javax.xml.bind.DatatypeConverter.printHexBinary(bytes);
    }

    void close() throws Exception {
        if (sock != null) {
            logger.info("DisconnectRequest");
            readDLMSPacket(dlms.DisconnectRequest());
            sock.close();
        }
    }

    byte[] send(byte[] data) throws Exception {
        if (data != null && data.length != 0) {
            if (sock != null) {
                sock.getOutputStream().write(data);
            }

        }
        return getReply();
    }

    byte[] getReply() throws Exception {
        java.nio.ByteBuffer buff = java.nio.ByteBuffer.allocate(1024);
        DataInputStream s;
        if (sock != null) {
            s = new DataInputStream(sock.getInputStream());
        } else {
            return null;
        }

        Thread.sleep(200);
        byte b[] = new byte[1024];
        int len = s.read(b);
        buff.put(b, 0, len);
//        while (buff.position() < 1024 & ch != -1)
//        {
//            ch = s.read();
//            buff.put((byte) ch);
//        }
        byte[] tmp = new byte[buff.position()];
        buff.position(0);
        buff.get(tmp);
        return tmp;
    }

    public byte[] readDLMSPacket(byte[] data) throws Exception {
        if (data == null) {
            return null;
        }

        logger.debug("Sent: " + toHex(data));
        byte[] reply = send(data);
        logger.debug("Received: " + toHex(reply));
        while (!dlms.IsDLMSPacketComplete(reply)) {
            java.nio.ByteBuffer buff = java.nio.ByteBuffer.allocate(1024);
            buff.put(reply);
            buff.put(getReply());
            reply = new byte[buff.position()];
            buff.position(0);
            buff.get(reply);
            logger.debug("Received: " + toHex(reply));
        }
        Object[][] errors = dlms.CheckReplyErrors(data, reply);
        if (errors != null) {
            throw new Exception(errors[0][1].toString());
        }
        return reply;
    }
//    public static void main(String[] args) {
////		GuruxHelper gh = new GuruxHelper("itr", "163.162.18.132", 4059, 1);
////		try{
////			gh.initializeDLMS();
////			gh.initializeConnection();
////			DLMSObjectCollection objects = gh.getAssociations();
////			gh.getSAPList(objects);
////		}
////		catch(Exception e){
////			e.printStackTrace();
////		}
//        GuruxHelper gh = new GuruxHelper("itr", "163.162.18.132", 4059, 1);
//        try {
//            gh.initializeDLMS();
//            gh.initializeConnection();
//            DLMSObjectCollection objects = gh.getAssociations();
//            gh.getValuesList(objects);
//            gh.close();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
}
