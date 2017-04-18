/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIISBookingMonth.
 */
public class GIISBookingMonth extends BaseEntity {
	
	/** The booking month. */
	private String bookingMonth;
	
	/** The booking year. */
	private Integer bookingYear;
	
	/** The booking month num. */
	private String bookingMonthNum;
	
	/** The date. */
	private Date date;
	
	public GIISBookingMonth(){		
	}
	
	public GIISBookingMonth(String bookingMonth, Integer bookingYear,
			String bookingMonthNum, Date date) {
		this.bookingMonth = bookingMonth;
		this.bookingYear = bookingYear;
		this.bookingMonthNum = bookingMonthNum;
		this.date = date;
	}
	
	/**
	 * Gets the booking month num.
	 * 
	 * @return the booking month num
	 */
	public String getBookingMonthNum() {
		return bookingMonthNum;
	}
	
	/**
	 * Sets the booking month num.
	 * 
	 * @param bookingMonthNum the new booking month num
	 */
	public void setBookingMonthNum(String bookingMonthNum) {
		this.bookingMonthNum = bookingMonthNum;
	}
	
	/**
	 * Gets the date.
	 * 
	 * @return the date
	 */
	public Date getDate() {
		return date;
	}
	
	/**
	 * Sets the date.
	 * 
	 * @param date the new date
	 */
	public void setDate(Date date) {
		this.date = date;
	}
	
	/**
	 * Gets the booking month.
	 * 
	 * @return the booking month
	 */
	public String getBookingMonth() {
		return bookingMonth;
	}
	
	/**
	 * Sets the booking month.
	 * 
	 * @param bookingMonth the new booking month
	 */
	public void setBookingMonth(String bookingMonth) {
		this.bookingMonth = bookingMonth;
	}
	
	/**
	 * Gets the booking year.
	 * 
	 * @return the booking year
	 */
	public Integer getBookingYear() {
		return bookingYear;
	}
	
	/**
	 * Sets the booking year.
	 * 
	 * @param bookingYear the new booking year
	 */
	public void setBookingYear(Integer bookingYear) {
		this.bookingYear = bookingYear;
	}
	
	
}
