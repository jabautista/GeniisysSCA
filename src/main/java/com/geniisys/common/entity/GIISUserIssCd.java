/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import java.util.List;


/**
 * The Class GIISUserIssCd.
 */
public class GIISUserIssCd extends GIISISSource {

	/** The user id. */
	private String userID;
	
	/** The tran cd. */
	private Integer tranCd;
	
	private String gutUserId;
	
	/** The lines. */
	private List<GIISUserLine> lines;

	/**
	 * Instantiates a new gIIS user iss cd.
	 */
	public GIISUserIssCd() {
		
	}
	
	/**
	 * Instantiates a new gIIS user iss cd.
	 * 
	 * @param userID the user id
	 * @param tranCd the tran cd
	 * @param issCd the iss cd
	 * @param userId the user id
	 * @param lines the lines
	 */
	public GIISUserIssCd(String userID, Integer tranCd, String issCd, String userId, List<GIISUserLine> lines) {
		this.userID = userID;
		this.tranCd = tranCd;
		super.setIssCd(issCd);
		super.setUserId(userId);
		this.lines = lines;
	}
	
	/**
	 * Gets the lines.
	 * 
	 * @return the lines
	 */
	public List<GIISUserLine> getLines() {
		return lines;
	}

	/**
	 * Sets the lines.
	 * 
	 * @param lines the new lines
	 */
	public void setLines(List<GIISUserLine> lines) {
		this.lines = lines;
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

	public String getGutUserId() {
		return gutUserId;
	}

	public void setGutUserId(String gutUserId) {
		this.gutUserId = gutUserId;
	}

}
