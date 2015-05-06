package br.ufes.ia.wumpus.prolog;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.zip.GZIPOutputStream;

//import jpl.Query;


import org.apache.commons.codec.binary.Base64;

public class JsonProlog {
	
	public static String converteBase64(String str){

	    byte byteAry[] = null;

	    try{
	        byteAry = str.getBytes("UTF-8");    
	    }catch( UnsupportedEncodingException e){
	        System.out.println("Unsupported character set");
	    }

	    for(int i = 0; i < byteAry.length; i++) {
	        if(byteAry[i] == 48)
	            byteAry[i] = 0;
	        if(byteAry[i] == 49)
	            byteAry[i] = 1;
	        if(byteAry[i] == 50)
	            byteAry[i] = 2;
	        if(byteAry[i] == 51)
	            byteAry[i] = 3;
	        if(byteAry[i] == 52)
	            byteAry[i] = 4;
	        if(byteAry[i] == 53)
	            byteAry[i] = 5;
	        if(byteAry[i] == 54)
	            byteAry[i] = 6;
	        if(byteAry[i] == 55)
	            byteAry[i] = 7;
	        if(byteAry[i] == 56)
	            byteAry[i] = 8;
	        if(byteAry[i] == 57)
	            byteAry[i] = 9;
	    }
	    ByteArrayOutputStream buffer = new ByteArrayOutputStream();

	    try {
	        OutputStream deflater = new GZIPOutputStream(buffer);
	        deflater.write(byteAry);
	        deflater.close();
	    }catch (IOException e) {
	        throw new IllegalStateException(e);
	    }
	    String results = Base64.encodeBase64String(buffer.toByteArray());
	    return results;
	}  
	
	public static String getJson(HttpURLConnection conn, String urlProlog) {
		URL url;
		BufferedReader rd;
		String line;
		String result = "";
		try {
		    url = new URL(urlProlog);
		    conn = (HttpURLConnection) url.openConnection();
		    conn.setRequestMethod("GET");
		    rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		    while ((line = rd.readLine()) != null) {
		       result += line;
		    }
		    rd.close();
		} catch (IOException e) {
		    e.printStackTrace();
		} catch (Exception e) {
		    e.printStackTrace();
		}
		//result = Helper.convertStringJsonParaSimbolo(result);
		return result;
	}	

	/*
	public static String getJson(Query query) {
		
	      String result = "";
	      return result;
	}
	*/
	
//	public static void sendKeysCombo(String[] keys) {
//		try {
//
//			Robot robot = new Robot();
//
//			Class<?> cl = KeyEvent.class;
//
//			int [] intKeys = new int [keys.length];
//
//			for (int i = 0; i < keys.length; i++) {
//				Field field = cl.getDeclaredField(keys[i]);
//				intKeys[i] = field.getInt(field);
//				robot.keyPress(intKeys[i]);
//			}
//
//			for (int i = keys.length - 1; i >= 0; i--)
//				robot.keyRelease(intKeys[i]);
//		}
//		catch (Throwable e) {
//
//		}
//	}
	
}
