package cn.gxnu.ipdata;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;
import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

import org.apache.commons.lang3.StringUtils;

public class IPDataHandler {
	private static String IP_DATA_PATH = "/home/yuzhe/Downloads/17monipdb.dat";
	private static DataInputStream inputStream = null;
	private static int dataLength = -1;
	private static byte[] ipData = null;
	private static Map<String, String> cacheMap = null;
	private static byte[] allData = null;
	
	static{
		File file = new File(IP_DATA_PATH);
		try {
			inputStream = new DataInputStream(new FileInputStream(file));
			dataLength = (int)file.length();
			cacheMap = new HashMap<String, String>();
			allData = new byte[dataLength];
			inputStream.read(allData, 0, dataLength);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	
	private static void init(){
		if (inputStream == null || dataLength <= 4) {
			return;
		}
		
		dataLength = (int)getbytesToIntH(allData, 0, 4);
		
		if (dataLength < 4) {
			try {
				throw new Exception("Invalid 17monipdb.dat file");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		ipData = getBytes(allData, 4, dataLength);
	}
	
	private static int str2Ip(String ip) throws UnknownHostException {
		InetAddress address = InetAddress.getByName(ip);
		byte[] bytes = address.getAddress();	
		
		int a, b, c, d;
		a = byte2int(bytes[0]);
		b = byte2int(bytes[1]);
		c = byte2int(bytes[2]);
		d = byte2int(bytes[3]);
		int result = (a << 24) | (b << 16) | (c << 8) | d;
		return result;
	}
	
	private static int byte2int(byte b) {
		int l = b & 0x07f;
		if (b < 0) {
			l |= 0x80;
		}
		return l;
	}
	
	/**
	 * 模拟php将ip转换成long类型整数
	 * 
	 * */
	private static long ip2long(String ip) throws UnknownHostException {
		int ipNum = str2Ip(ip);
		return int2long(ipNum);
	}
	
	private static long int2long(int i) {
		long l = i & 0x7fffffffL;
		if (i < 0) {
			l |= 0x080000000L;
		}
		return l;
	}
	
	
	private static long getbytesToInt(byte[] bytes, int offerSet,int size){
		if ((offerSet+size) > bytes.length || size <= 0) {
			return -1;
		}
		byte[] b = new byte[size];
		for (int i = 0; i < b.length; i++) {
			b[i] = bytes[offerSet+i];
		}
		
		ByteBuffer byteBuffer = ByteBuffer.wrap(b);
		//低位低地址
		byteBuffer.order(ByteOrder.LITTLE_ENDIAN);
		
		 long temp = -1;
		if (byteBuffer.hasRemaining()) {
			temp = byteBuffer.getInt();
		}
		return temp;
	}
	
	
	private static long getbytesToIntH(byte[] bytes, int offerSet,int size){
		if ((offerSet+size) > bytes.length || size <= 0) {
			return -1;
		}
		byte[] b = new byte[size];
		for (int i = 0; i < b.length; i++) {
			b[i] = bytes[offerSet+i];
		}
		
		ByteBuffer byteBuffer = ByteBuffer.wrap(b);
		//低位高地址
		byteBuffer.order(ByteOrder.BIG_ENDIAN);
		
		 long temp = -1;
		if (byteBuffer.hasRemaining()) {
			temp = byteBuffer.getInt();
		}
		return temp;
	}

	private static int getIntByBytes(byte[] b,int offSet)
	{
		if ((offSet+3) > b.length) {
			return -1;
		}
		byte[] bs = new byte[4];
		for (int i = 0; i < 3; i++) {
			bs[i] = b[offSet+i];
		}
		bs[3] = 0;
		
		ByteBuffer byteBuffer = ByteBuffer.wrap(bs);
		byteBuffer.order(ByteOrder.LITTLE_ENDIAN);
		
		int temp = -1;
		if (byteBuffer.hasRemaining()) {
			temp = byteBuffer.getInt();
		}
		return temp;
	}
	
	private static byte[] getBytes(byte[] bytes,int offerSet,int size){
		if (bytes == null || (bytes.length < (offerSet + size)) ) {
			return null;
		}
		
		byte[] b = new byte[size];
		for (int i = 0; i < size; i++) {
			b[i] = bytes[offerSet+i];
		}
		return b;
	}
	
	
	public static String findGeography(String address){
		if (StringUtils.isBlank(address)) {
			return "";
		}
		
		String ip = "127.0.0.1";
		try {
			ip = Inet4Address.getByName(address).getHostAddress();
		} catch (UnknownHostException e) {
			e.printStackTrace();
		} 
		
		String[] ipArray = StringUtils.split(ip, ".");
		int ipHeadValue = Integer.parseInt(ipArray[0]);
		if (ipArray.length !=4 || ipHeadValue < 0 || ipHeadValue > 255) {
			return "";
		}
		
		//从缓存拿去数据，如果存在
		if (cacheMap.containsKey(ip)) {
			return cacheMap.get(ip);
		}
		
		//确认数据存在
		if (ipData == null || ipData.length < 4) {
			init();
		}
		
		long numIp = 1;
		try {
			numIp = ip2long(address);
		} catch (UnknownHostException e1) {
			e1.printStackTrace();
		}
		
		
		int tempOffSet = ipHeadValue* 4;
		long start = getbytesToInt(ipData, tempOffSet, 4);
		int max_len = dataLength - 1028;
		
		long tempIp = 1;
		long resultOffSet = 0;
		int resultSize = 0;
		
		for (start = start*8 + 1024; start < max_len; start+=8) {
			tempIp = getbytesToIntH(ipData, (int)start, 4);
			if (tempIp >= numIp) {
				resultOffSet = getIntByBytes(ipData, (int)(start+4));
				resultSize = (char)ipData[(int)start+7];
				break;
			}
		}
		
		if (resultOffSet <= 0) {
			return "";
		}
		
		byte[] add = getBytes(allData, (int)(dataLength+resultOffSet-1024), resultSize);

		try {
			if (add == null) {
				cacheMap.put(ip, new String("no data found!!"));
			} else {
				cacheMap.put(ip, new String(add,"UTF-8"));
			}
			
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		return cacheMap.get(ip);
	}
}