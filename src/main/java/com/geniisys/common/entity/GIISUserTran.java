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
 * The Class GIISUserTran.
 */
public class GIISUserTran extends GIISTransaction {

	/** The user id. */
	private String userID;
	
	/** The access tag. */
	private String accessTag;
	private String incAllTag;
	private String gutUserId;
	
	/** The modules. */
	private List<GIISUserModules> modules;
	
	/** The iss sources. */
	private List<GIISUserIssCd> issSources;

	/**
	 * Instantiates a new gIIS user tran.
	 */
	public GIISUserTran() {

	}

	/**
	 * Instantiates a new gIIS user tran.
	 * 
	 * @param userID the user id
	 * @param tranCd the tran cd
	 * @param accessTag the access tag
	 * @param userId the user id
	 */
	public GIISUserTran(String userID, Integer tranCd, String accessTag, String userId) {
		this.userID = userID;
		super.setTranCd(tranCd);
		this.accessTag = accessTag;
		super.setUserId(userId);
	}

	/**
	 * Gets the iss sources.
	 * 
	 * @return the iss sources
	 */
	public List<GIISUserIssCd> getIssSources() {
		return issSources;
	}

	/**
	 * Sets the iss sources.
	 * 
	 * @param issSources the new iss sources
	 */
	public void setIssSources(List<GIISUserIssCd> issSources) {
		this.issSources = issSources;
	}

	/**
	 * Gets the modules.
	 * 
	 * @return the modules
	 */
	public List<GIISUserModules> getModules() {
		return modules;
	}

	/**
	 * Sets the modules.
	 * 
	 * @param modules the new modules
	 */
	public void setModules(List<GIISUserModules> modules) {
		this.modules = modules;
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
	 * Gets the access tag.
	 * 
	 * @return the access tag
	 */
	public String getAccessTag() {
		return accessTag;
	}

	/**
	 * Sets the access tag.
	 * 
	 * @param accessTag the new access tag
	 */
	public void setAccessTag(String accessTag) {
		this.accessTag = accessTag;
	}

	public String getIncAllTag() {
		return incAllTag;
	}

	public void setIncAllTag(String incAllTag) {
		this.incAllTag = incAllTag;
	}

	public String getGutUserId() {
		return gutUserId;
	}

	public void setGutUserId(String gutUserId) {
		this.gutUserId = gutUserId;
	}

}
