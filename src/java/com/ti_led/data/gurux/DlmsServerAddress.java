package com.ti_led.data.gurux;

public class DlmsServerAddress {
	public String address;
	public int port;
	public String etsiGatewayId;
	
	public DlmsServerAddress(String address,int port, String etsiGatewayId){
		this.address=address;
		this.port=port;
		this.etsiGatewayId=etsiGatewayId;
	}
}
