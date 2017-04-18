/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.framework.util;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * The Class BaseEntity.
 */
public class BaseEntity {

	/** The user id. */
	private String userId;
	private String appUser;
	/** The last update. */
	private Date lastUpdate;
	
	/** The create user. */
	private String createUser;
	
	/** The create date. */
	private Date createDate;
	
	private Integer rowNum;
	private Integer rowCount;
	
	//private Integer recordStatus = 0; // default - CREATE
	/** Record Status States - Added for JSON Implementation - rencela - 02/17/2011*/
	public static final Integer DELETE_OBJECT = -1;
	public static final Integer CREATE_OBJECT = 0;
	public static final Integer UPDATE_OBJECT = 1;
	
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
	 * @author Irwin Tabisora
	 * */
	public Object getStrLastUpdate(){
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(lastUpdate != null){
			return sdf.format(lastUpdate).toString();
		} else {
			return null;
		}
		
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
	 * @return the creates the user
	 */
	public String getCreateUser(){
		return createUser;
	}
	
	/**
	 * Sets the creates the user.
	 * @param createUser the new creates the user
	 */
	public void setCreateUser(String createUser){
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

	public Integer getRowNum() {
		return rowNum;
	}

	public void setRowNum(Integer rowNum) {
		this.rowNum = rowNum;
	}

	public Integer getRowCount() {
		return rowCount;
	}

	public void setRowCount(Integer rowCount) {
		this.rowCount = rowCount;
	}

	public void setAppUser(String appUser) {
		this.appUser = appUser;
	}

	public String getAppUser() {
		return appUser;
	}

	/**
	 * @param recordStatus the recordStatus to set
	 
	public void setRecordStatus(Integer recordStatus) {
		this.recordStatus = recordStatus;
	}
	*/
	/**
	 * @return the recordStatus
	 
	public Integer getRecordStatus() {
		return recordStatus;
	}
	*/
}
