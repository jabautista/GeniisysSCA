package com.geniisys.gipi.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class DateFormatter {

	public static final int MM_FS_DD_FS_YYYY = 1;	
	public static final int MM_D_DD_D_YYYY = 2;	
	
	public static Date formatDate(String strDate, int key, int sdfKey) throws ParseException{
		SimpleDateFormat sdf = new SimpleDateFormat(getSDFPattern(sdfKey));
		boolean match = false;
		Pattern pattern = Pattern.compile(getDatePattern(key));
		Matcher matcher = pattern.matcher(strDate);
		String[] dateStringArr = {};
		
		while(matcher.find()){
			match = true;
		}
		
		if(!match){
			dateStringArr = strDate.split("\\s");
			return sdf.parse(getMonthNumber(dateStringArr[1]) + getSeparator(key) + dateStringArr[2] + getSeparator(key) + dateStringArr[5]);
		}else{
			return sdf.parse(strDate);
		}		
	}
	
	private static String getSDFPattern(int sdfKey){
		String sdfPattern = "";
		
		switch(sdfKey){
			case 1	: sdfPattern = "MM/dd/yyyy"; break;
			case 2	: sdfPattern = "MM-dd-yyyy"; break;
		}
		
		return sdfPattern;
	}
	
	private static String getDatePattern(int key){
		String pattern = "";
		
		switch(key){
			case 1	: pattern = "^\\d{1,2}(\\/)\\d{1,2}\\1\\d{4}$"; break;
			case 2	: pattern = "^\\d{1,2}(\\-)\\d{1,2}\\1\\d{4}$"; break;
			default	: pattern = "";
		}
		
		return pattern;
	}
	
	private static String getSeparator(int key){
		String separator = "";
		
		switch(key){
			case 1	: separator = "/"; break;
			case 2	: separator = "-"; break;
		}
		
		return separator;
	}
	
	private static String getMonthNumber(String monthName){
		String monthNumber = "";
		
		if(monthName.equals("Jan") || monthName.equals("January") ){
			monthNumber = "01";
		}else if(monthName.equals("Feb") || monthName.equals("February") ){
			monthNumber = "02";
		}else if(monthName.equals("Mar") || monthName.equals("March")){
			monthNumber = "03";
		}else if(monthName.equals("Apr") || monthName.equals("April")){
			monthNumber = "04";
		}else if(monthName.equals("May")){
			monthNumber = "05";
		}else if(monthName.equals("Jun") || monthName.equals("June")){
			monthNumber = "06";
		}else if(monthName.equals("Jul") || monthName.equals("July")){
			monthNumber = "07";
		}else if(monthName.equals("Aug") || monthName.equals("August")){
			monthNumber = "08";
		}else if(monthName.equals("Sep") || monthName.equals("September")){
			monthNumber = "09";
		}else if(monthName.equals("Oct") || monthName.equals("October")){
			monthNumber = "10";
		}else if(monthName.equals("Nov") || monthName.equals("November")){
			monthNumber = "11";
		}else if(monthName.equals("Dec") || monthName.equals("December")){
			monthNumber = "12";
		}
		
		return monthNumber;
	}
}
