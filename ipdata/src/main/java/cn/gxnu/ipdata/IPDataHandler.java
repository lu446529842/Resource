package cn.gxnu.ipdata;

/*************************************************************************
	> File Name: IPDataHandler.java
	> Author: ldq
	> Mail: 446529842@qq.com 
	> Created Time: Sat 08 Mar 2014 02:19:59 PM EST
 ************************************************************************/
/************************************************************************
 *1.fix ip to  int overflow issue
 *2.reduce memory use
 *3.clean the code ,make int more shorter and simple
 *4.default limit  size of ip data 17monipdb.dat is 2GB（not test yet）。  
 ************************************************************************/

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

import org.apache.commons.lang.StringUtils;

public class IPDataHandler {
	private static String IP_DATA_PATH = "/home/yuzhe/workspace/IPDataBase/src/main/java/com/meiliwan/IPDataBase/17monipdb.dat";
	private static DataInputStream inputStream = null;
	private static long fileLength = -1;
	private static int dataLength = -1;
	private static Map<String, String> cacheMap = null;
	private static byte[] allData = null;
	
	static{
		File file = new File(IP_DATA_PATH);
		try {
			inputStream = new DataInputStream(new FileInputStream(file));
			fileLength = file.length();
			cacheMap = new HashMap<String, String>();
			if (fileLength >Integer.MAX_VALUE) {
				throw new Exception("the filelength over 2GB");
			}
			
			dataLength = (int) fileLength;
			allData = new byte[dataLength];
			inputStream.read(allData, 0, dataLength);
			dataLength = (int)getbytesTolong(allData, 0, 4,ByteOrder.BIG_ENDIAN);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	private static long getbytesTolong(byte[] bytes, int offerSet,int size,ByteOrder byteOrder){
		if ((offerSet+size) > bytes.length || size <= 0) {
			return -1;
		}
		byte[] b = new byte[size];
		for (int i = 0; i < b.length; i++) {
			b[i] = bytes[offerSet+i];
		}
		
		ByteBuffer byteBuffer = ByteBuffer.wrap(b);
		byteBuffer.order(byteOrder);
		
		long temp = -1;
		if (byteBuffer.hasRemaining()) {
			temp = byteBuffer.getInt();
		}
		return temp;
	}
	
	private static long ip2long(String ip) throws UnknownHostException {
		InetAddress address = InetAddress.getByName(ip);
		byte[] bytes = address.getAddress();	
		long reslut = getbytesTolong(bytes, 0, 4,ByteOrder.BIG_ENDIAN);
		return reslut;
	}
	

	private static int getIntByBytes(byte[] b,int offSet)
	{
		if (b == null || (b.length < (offSet+3))) {
			return -1;
		}
		
		byte[] bytes = Arrays.copyOfRange(allData, offSet, offSet+3);
		byte[] bs = new byte[4];
		bs[3] = 0;
		for (int i = 0; i < 3;i++) {
			bs[i]=bytes[i];
		}
		
		return (int)getbytesTolong(bs, 0, 4, ByteOrder.LITTLE_ENDIAN);
	}

	
	public static String findGeography(String address){
		if (StringUtils.isBlank(address)) {
			return "illegal address";
		}
		
		if (dataLength < 4 || allData == null) {
			return "illegal ip data";
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
			return "illegal ip";
		}
		
		if (cacheMap.containsKey(ip)) {
			return cacheMap.get(ip);
		}
		
		
		long numIp = 1;
		try {
			numIp = ip2long(address);
		} catch (UnknownHostException e1) {
			e1.printStackTrace();
		}
		
		
		int tempOffSet = ipHeadValue* 4 + 4;
		long start = getbytesTolong(allData, tempOffSet, 4,ByteOrder.LITTLE_ENDIAN);
		int max_len = dataLength - 1028;
		long resultOffSet = 0;
		int resultSize = 0;
		
		for (start = start*8 + 1024; start < max_len; start+=8) {
			if (getbytesTolong(allData, (int)start+4, 4,ByteOrder.BIG_ENDIAN) >= numIp) {
				resultOffSet = getIntByBytes(allData, (int)(start+4+4));
				resultSize = (char)allData[(int)start+7+4];
				break;
			}
		}
		
		if (resultOffSet <= 0) {
			return "resultOffSet too small";
		}
		
		byte[] add = Arrays.copyOfRange(allData, (int)(dataLength+resultOffSet-1024), (int)(dataLength+resultOffSet-1024 + resultSize));
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
