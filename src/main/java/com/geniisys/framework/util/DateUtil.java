/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.framework.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import org.apache.log4j.Logger;



/**
 * The Class DateUtil.
 */
public final class DateUtil {
	private static Logger log = Logger.getLogger(DateUtil.class);
	/**
	 * Instantiates a new date util.
	 */
	private DateUtil() {
	}
	
	/**
	 * Gets the elapsed days.
	 * 
	 * @param date the date
	 * 
	 * @return the elapsed days
	 */
	public static int getElapsedDays(Date date) {
		return elapsed(date, Calendar.DATE);
		
	}
	
	/**
	 * Gets the elapsed days.
	 * 
	 * @param d1 the d1
	 * @param d2 the d2
	 * 
	 * @return the elapsed days
	 */
	public static int getElapsedDays(Date d1, Date d2) {
		return elapsed(d1, d2, Calendar.DATE);
	}
	
	/**
	 * Gets the elapsed months.
	 * 
	 * @param date the date
	 * 
	 * @return the elapsed months
	 */
	public static int getElapsedMonths(Date date) {
		return elapsed(date, Calendar.MONTH);
	}
	
	/**
	 * Gets the elapsed months.
	 * 
	 * @param d1 the d1
	 * @param d2 the d2
	 * 
	 * @return the elapsed months
	 */
	public static int getElapsedMonths(Date d1, Date d2) {
		return elapsed(d1, d2, Calendar.MONTH);
	}
	
	/**
	 * Gets the elapsed years.
	 * 
	 * @param date the date
	 * 
	 * @return the elapsed years
	 */
	public static int getElapsedYears(Date date) {
		return elapsed(date, Calendar.YEAR);
	}
	
	/**
	 * Gets the elapsed years.
	 * 
	 * @param d1 the d1
	 * @param d2 the d2
	 * 
	 * @return the elapsed years
	 */
	public static int getElapsedYears(Date d1, Date d2) {
		return elapsed(d1, d2, Calendar.YEAR);
	}
	
	/**
	 * Elapsed.
	 * 
	 * @param g1 the g1
	 * @param g2 the g2
	 * @param type the type
	 * 
	 * @return the int
	 */
	private static int elapsed(GregorianCalendar g1, GregorianCalendar g2, int type) {
		GregorianCalendar gc1, gc2;
		int elapsed = 0;
		if (g2.after(g1)) {
			gc2 = (GregorianCalendar) g2.clone();
			gc1 = (GregorianCalendar) g1.clone();
		} else  {
			gc2 = (GregorianCalendar) g1.clone();
			gc1 = (GregorianCalendar) g2.clone();
		}
		if (type == Calendar.MONTH || type == Calendar.YEAR) {
			gc1.clear(Calendar.DATE);
			gc2.clear(Calendar.DATE);
		}
		if (type == Calendar.YEAR) {
			gc1.clear(Calendar.MONTH);
			gc2.clear(Calendar.MONTH);
		}
		while (gc1.before(gc2)) {
			gc1.add(type, 1);
			elapsed++;
		}
		return elapsed;
	}
	
	/**
	 * Elapsed.
	 * 
	 * @param date the date
	 * @param type the type
	 * 
	 * @return the int
	 */
	private static int elapsed(Date date, int type) {
		return elapsed(date, new Date(), type);
	}
	
	/**
	 * Elapsed.
	 * 
	 * @param d1 the d1
	 * @param d2 the d2
	 * @param type the type
	 * 
	 * @return the int
	 */
	private static int elapsed(Date d1, Date d2, int type) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(d1);
		GregorianCalendar g1 = new GregorianCalendar(
				cal.get(Calendar.YEAR), cal.get(Calendar.MONTH), cal.get(Calendar.DATE));
		cal.setTime(d2);
		GregorianCalendar g2 = new GregorianCalendar(
				cal.get(Calendar.YEAR), cal.get(Calendar.MONTH), cal.get(Calendar.DATE));
		return elapsed(g1, g2, type);
	}
	
	/**
	 * Parses a string into a date object
	 * @param strDate in MM-dd-yyyy format
	 * @return if successful, returns Date object, else returns null date;
	 */
	public static Date toDate(String strDate){
		try{
			log.info("strDate = " + strDate);
			SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
			Date d = sdf.parse(strDate);
			return d;
		}catch (ParseException e) {
			log.error("Error Parsing String: " + e.getMessage());
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * Parses a string into a date object
	 * @param strDate in MM-dd-yyyy HH:mm:ss format
	 * @return if successful, returns Date object, else returns null date;
	 */
	public static Date toDateWithTime(String strDate){
		try{
			log.info("strDate = " + strDate);
			SimpleDateFormat sdfWithTime = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
			Date d = sdfWithTime.parse(strDate);
			return d;
		}catch (ParseException e) {
			log.error("Error Parsing String: " + e.getMessage());
			e.printStackTrace();
			return null;
		}
		
	}
	
	/**
	 * set 0 to time
	 * */
	public static Date setZeroTimeValues(Date date){
		date.setHours(0);
		date.setMinutes(0);
		date.setSeconds(0);
		return date;
	}
	
}