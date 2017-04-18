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
 * The Class GIISValidIP.
 */
public class GIISValidIP extends BaseEntity {

	/** The ip address. */
	private String ipAddress;
	
	/** The valid user id. */
	private String validUserId;
	
	/** The create user. */
	private String createUser;
	
	/** The create date. */
	private Date createDate;
	private String macAddress;
	/**
	 * Gets the ip address.
	 * 
	 * @return the ip address
	 */
	public String getIpAddress() {
		return ipAddress;
	}

	/**
	 * Sets the ip address.
	 * 
	 * @param ipAddress the new ip address
	 */
	public void setIpAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}

	/**
	 * Gets the valid user id.
	 * 
	 * @return the valid user id
	 */
	public String getValidUserId() {
		return validUserId;
	}

	/**
	 * Sets the valid user id.
	 * 
	 * @param validUserId the new valid user id
	 */
	public void setValidUserId(String validUserId) {
		this.validUserId = validUserId;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseEntity#getCreateUser()
	 */
	@Override
	public String getCreateUser() {
		return createUser;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseEntity#setCreateUser(java.lang.String)
	 */
	@Override
	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseEntity#getCreateDate()
	 */
	@Override
	public Date getCreateDate() {
		return createDate;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseEntity#setCreateDate(java.util.Date)
	 */
	@Override
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public void setMacAddress(String macAddress) {
		this.macAddress = macAddress;
	}

	public String getMacAddress() {
		return macAddress;
	}

}
