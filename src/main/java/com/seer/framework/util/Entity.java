/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.util;

import java.io.Serializable;
import java.util.Date;

import org.apache.log4j.Logger;


/**
 * The Class Entity.
 * 
 * @param <T> the generic type
 */
@SuppressWarnings("serial")
public abstract class Entity<T> implements Serializable {

	/** The user id. */
	private String userId;
	
	/** The last update. */
	private Date lastUpdate;
	
	/** The create user. */
	private String createUser;
	
	/** The create date. */
	private Date createDate;
	private String appUser;

	/** The log. */
	protected static Logger log = Logger.getLogger(Entity.class);

	/** The Constant EMPTY. */
	public static final String EMPTY = "";
	
	/** Added for TableGrid Implementation BJGA 01.10.2011**/
	private Integer rowNum;
	private Integer rowCount;

	/** Record Status States - Added for JSON Implementation - rencela - 02/17/2011*/
	public static final Integer DELETE_OBJECT = -1;
	public static final Integer CREATE_OBJECT = 0;
	public static final Integer UPDATE_OBJECT = 1;
	
	private Integer recordStatus; // default - CREATE //removed default value of 0 to prevent the issue of old records having a record status of 0 - irwin
	
	/** The is new. */
	protected boolean isNew;

	/**
	 * Checks if is new.
	 * @return Returns the isNew.
	 */
	public boolean isNew() {
		return isNew;
	}

	/**
	 * Sets the new.
	 * 
	 * @param isNew
	 *            The isNew to set.
	 */
	public void setNew(boolean isNew) {
		this.isNew = isNew;
	}

	/*
	 * (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return ToStringUtil.getText(this);
		// return ToStringUtil.getTextAvoidCyclicRefs(this, Entity.class,
		// "getId");
	}

	/**
	 * Sets the id.
	 * @param id - the new id
	 */
	public abstract void setId(T id);

	/**
	 * Gets the id.
	 * 
	 * @return the id
	 */
	public abstract T getId();

	/**
	 * Validate string length.
	 * 
	 * @param string
	 *            the string
	 * @param min
	 *            the min
	 * @param max
	 *            the max
	 * 
	 * @return true if string is within length, false otherwise
	 */
	public boolean validateStringLength(String string, int min, int max) {
		if (string == null)
			return false;

		int strLen = string.length();
		Debug.print("Length of string (" + string + ") is: " + string.length());

		if ((strLen < min) || (strLen > max)) {
			return false;
		} else {
			return true;
		}
	}

	/**
	 * Validate not null.
	 * 
	 * @param obj
	 *            the obj
	 * 
	 * @return true if object is not null, false otherwise
	 */
	public boolean validateNotNull(Object obj) {
		boolean status = true;
		if (obj != null) {
			if (obj.getClass() == String.class) {
				String temp = (String) obj;
				if ((temp != null) && (temp.length() < 1)) {
					status = false;
				}
			}
		} else {
			status = false;
		}
		return status;
	}

	/**
	 * Validate number range.
	 * @param num - the num
	 * @param min - the min
	 * @param max - the max
	 * @return true if integer is within range, false otherwise
	 */
	public boolean validateNumberRange(int num, int min, int max) {
		Debug.print("Number is: " + num);
		if ((num < min) || (num > max)) {
			return false;
		} else {
			return true;
		}
	}

	/**
	 * Validate number range.
	 * @param num - the num
	 * @param min - the min
	 * @param max - the max
	 * @return true if number is within range, false otherwise
	 */
	public boolean validateNumberRange(double num, double min, double max) {
		if ((num < min) || (num > max)) {
			return false;
		} else {
			return true;
		}
	}

	/**
	 * Validate date span.
	 * @param d1 - start date
	 * @param d2 - end date
	 * @param flag - the flag
	 * @return true if dates meet specified flag, false otherwise
	 */
	public boolean validateDateSpan(Date d1, Date d2, String flag) {
		boolean isValid = false;

		// Note: the value 0 if the argument Date is equal to this Date;
		// a value less than 0 if this Date is before the Date argument;
		// and a value greater than 0 if this Date is after the Date argument.
		int result = d1.compareTo(d2);

		if (flag.equals(">")) {
			isValid = (result > 0);
		} else if (flag.equals("<")) {
			isValid = (result < 0);
		} else if (flag.equals(">=")) {
			isValid = (result >= 0);
		} else if (flag.equals("<=")) {
			isValid = (result <= 0);
		} else // equal
		{	isValid = (result == 0);
		}
		return isValid;
	}

	/**
	 * Check if string if it is null, if true pass the value into string1, else retain string1
	 * @param string - the string to be checked
	 * @param value -  the value that will replace string1 if it is null
	 * @return string value
	 */
	public static String checkIfNull(String string1, String value) {
		if (string1 == null) {
			string1 = value;
		}
		return string1;
	}

	/**
	 * Gets the user id.
	 * @return the user id
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * Sets the user id.
	 * @param userId the new user id
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}

	/**
	 * Gets the last update.
	 * @return the last update
	 */
	public Date getLastUpdate() {
		return lastUpdate;
	}

	/**
	 * Sets the last update.
	 * @param lastUpdate the new last update
	 */
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}

	/**
	 * Gets the creates the user.
	 * 
	 * @return the creates the user
	 */
	public String getCreateUser() {
		return createUser;
	}

	/**
	 * Sets the creates the user.
	 * 
	 * @param createUser the new creates the user
	 */
	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	/**
	 * Gets the creates the date.
	 * 
	 * @return the creates the date
	 */
	public Date getCreateDate() {
		return createDate;
	}

	/**
	 * Sets the creates the date.
	 * 
	 * @param createDate the new creates the date
	 */
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	/**
	 * @param rowNum the rowNum to set
	 */
	public void setRowNum(Integer rowNum) {
		this.rowNum = rowNum;
	}

	/**
	 * @return the rowNum
	 */
	public Integer getRowNum() {
		return rowNum;
	}

	/**
	 * @param rowCount the rowCount to set
	 */
	public void setRowCount(Integer rowCount) {
		this.rowCount = rowCount;
	}

	/**
	 * @return the rowCount
	 */
	public Integer getRowCount() {
		return rowCount;
	}

	/**
	 * @param recordStatus the recordStatus to set
	 */
	public void setRecordStatus(Integer recordStatus) {
		this.recordStatus = recordStatus;
	}

	/**
	 * @return the recordStatus
	 */
	public Integer getRecordStatus() {
		return recordStatus;
	}

	public void setAppUser(String appUser) {
		this.appUser = appUser;
	}

	public String getAppUser() {
		return appUser;
	}
}