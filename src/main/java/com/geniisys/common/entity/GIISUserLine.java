/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;


/**
 * The Class GIISUserLine.
 */
public class GIISUserLine extends GIISLine {

	/** The user id. */
	private String userID;
	
	/** The tran cd. */
	private Integer tranCd;
	
	/** The iss cd. */
	private String issCd;
	
	private String gutUserId;

	/**
	 * Instantiates a new gIIS user line.
	 */
	public GIISUserLine() {
		
	}
	
	/**
	 * Instantiates a new gIIS user line.
	 * 
	 * @param userID the user id
	 * @param tranCd the tran cd
	 * @param issCd the iss cd
	 * @param lineCd the line cd
	 * @param userId the user id
	 */
	public GIISUserLine(String userID, Integer tranCd, String issCd, String lineCd, String userId) {
		this.userID = userID;
		this.tranCd = tranCd;
		this.issCd = issCd;
		super.setLineCd(lineCd);
		super.setUserId(userId);
	}
	
	/**
	 * Gets the user id.
	 * 
	 * @return the user id
	 */
	public String getUserID() {
		return userID;
	}

	/**
	 * Sets the user id.
	 * 
	 * @param userID the new user id
	 */
	public void setUserID(String userID) {
		this.userID = userID;
	}

	/**
	 * Gets the tran cd.
	 * 
	 * @return the tran cd
	 */
	public Integer getTranCd() {
		return tranCd;
	}

	/**
	 * Sets the tran cd.
	 * 
	 * @param tranCd the new tran cd
	 */
	public void setTranCd(Integer tranCd) {
		this.tranCd = tranCd;
	}

	/**
	 * Gets the iss cd.
	 * 
	 * @return the iss cd
	 */
	public String getIssCd() {
		return issCd;
	}

	/**
	 * Sets the iss cd.
	 * 
	 * @param issCd the new iss cd
	 */
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public String getGutUserId() {
		return gutUserId;
	}

	public void setGutUserId(String gutUserId) {
		this.gutUserId = gutUserId;
	}

}
