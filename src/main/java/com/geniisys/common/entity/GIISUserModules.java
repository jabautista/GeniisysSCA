/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;


/**
 * The Class GIISUserModules.
 */
public class GIISUserModules extends GIISModule {

	/** The user id. */
	private String userID;
	
	private String appUser;
	private String umUserId;
	private String incTag;
	private String dspAccessTag;
	private String incAllTag;
	
	public String getAppUser() {
		return appUser;
	}

	public void setAppUser(String appUser) {
		this.appUser = appUser;
	}

	public String getUmUserId() {
		return umUserId;
	}

	public void setUmUserId(String umUserId) {
		this.umUserId = umUserId;
	}

	public String getIncTag() {
		return incTag;
	}

	public void setIncTag(String incTag) {
		this.incTag = incTag;
	}

	public String getDspAccessTag() {
		return dspAccessTag;
	}

	public void setDspAccessTag(String dspAccessTag) {
		this.dspAccessTag = dspAccessTag;
	}

	public String getIncAllTag() {
		return incAllTag;
	}

	public void setIncAllTag(String incAllTag) {
		this.incAllTag = incAllTag;
	}

	/**
	 * Instantiates a new gIIS user modules.
	 */
	public GIISUserModules() {
		
	}
	
	/**
	 * Instantiates a new gIIS user modules.
	 * 
	 * @param userID the user id
	 * @param moduleId the module id
	 * @param remarks the remarks
	 * @param accessTag the access tag
	 * @param tranCd the tran cd
	 * @param userId the user id
	 */
	public GIISUserModules(String userID, String moduleId, String remarks, String accessTag, Integer tranCd, String userId) {
		this.userID = userID;
		super.setModuleId(moduleId);
		super.setRemarks(remarks);
		super.setAccessTag(accessTag);
		super.setTranCd(tranCd);
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

}
