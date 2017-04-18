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
 * The Class GIISUserGrpTran.
 */
public class GIISUserGrpTran extends GIISTransaction {

	/** The user grp. */
	private Integer userGrp;
	
	/** The access tag. */
	private String accessTag;
	
	/** The modules. */
	private List<GIISUserGrpModule> modules;
	
	/** The issue sources. */
	private List<GIISUserGrpDtl> issueSources;
	
	private String incAllTag;
	private String incAllModules;
	
	/**
	 * Instantiates a new gIIS user grp tran.
	 */
	public GIISUserGrpTran() {
		
	}
	
	/**
	 * Instantiates a new gIIS user grp tran.
	 * 
	 * @param userGrp the user grp
	 * @param tranCd the tran cd
	 * @param remarks the remarks
	 * @param accessTag the access tag
	 * @param userId the user id
	 */
	public GIISUserGrpTran(Integer userGrp, Integer tranCd, String remarks, String accessTag, String userId) {
		super.setTranCd(tranCd);
		this.userGrp = userGrp;
		super.setRemarks(remarks);
		this.accessTag = accessTag;
		super.setUserId(userId);
	}
	
	/**
	 * Gets the user grp.
	 * 
	 * @return the user grp
	 */
	public Integer getUserGrp() {
		return userGrp;
	}
	
	/**
	 * Sets the user grp.
	 * 
	 * @param userGrp the new user grp
	 */
	public void setUserGrp(Integer userGrp) {
		this.userGrp = userGrp;
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
	
	/**
	 * Gets the modules.
	 * 
	 * @return the modules
	 */
	public List<GIISUserGrpModule> getModules() {
		return modules;
	}
	
	/**
	 * Sets the modules.
	 * 
	 * @param modules the new modules
	 */
	public void setModules(List<GIISUserGrpModule> modules) {
		this.modules = modules;
	}
	
	/**
	 * Gets the issue sources.
	 * 
	 * @return the issue sources
	 */
	public List<GIISUserGrpDtl> getIssueSources() {
		return issueSources;
	}
	
	/**
	 * Sets the issue sources.
	 * 
	 * @param issueSources the new issue sources
	 */
	public void setIssueSources(List<GIISUserGrpDtl> issueSources) {
		this.issueSources = issueSources;
	}

	public String getIncAllTag() {
		return incAllTag;
	}

	public void setIncAllTag(String incAllTag) {
		this.incAllTag = incAllTag;
	}

	public String getIncAllModules() {
		return incAllModules;
	}

	public void setIncAllModules(String incAllModules) {
		this.incAllModules = incAllModules;
	}
	
}
