/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;


/**
 * The Class GIISModule.
 */
public class GIISModule extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -7668734606449985416L;
	
	/** The user group. */
	private Integer userGroup;
	
	/** The module id. */
	private String moduleId;
	
	/** The module desc. */
	private String moduleDesc;
	
	/** The remarks. */
	private String remarks;
	
	/** The access tag. */
	private String accessTag;
	
	/** The module grp. */
	private String moduleGrp;
	
	/** The module type. */
	private String moduleType;
	
	/** The tran cd. */
	private Integer tranCd;
	
	private Integer modAccessTag;
	private String webEnabled;
	private String dspModuleTypeDesc;
	
	/**
	 * Gets the module desc.
	 * 
	 * @return the module desc
	 */
	public String getModuleDesc() {
		return moduleDesc;
	}

	/**
	 * Sets the module desc.
	 * 
	 * @param moduleDesc the new module desc
	 */
	public void setModuleDesc(String moduleDesc) {
		this.moduleDesc = moduleDesc;
	}

	/**
	 * Gets the module grp.
	 * 
	 * @return the module grp
	 */
	public String getModuleGrp() {
		return moduleGrp;
	}

	/**
	 * Sets the module grp.
	 * 
	 * @param moduleGrp the new module grp
	 */
	public void setModuleGrp(String moduleGrp) {
		this.moduleGrp = moduleGrp;
	}

	/**
	 * Gets the module type.
	 * 
	 * @return the module type
	 */
	public String getModuleType() {
		return moduleType;
	}

	/**
	 * Sets the module type.
	 * 
	 * @param moduleType the new module type
	 */
	public void setModuleType(String moduleType) {
		this.moduleType = moduleType;
	}

	/**
	 * Gets the user group.
	 * 
	 * @return the user group
	 */
	public Integer getUserGroup() {
		return userGroup;
	}

	/**
	 * Sets the user group.
	 * 
	 * @param userGroup the new user group
	 */
	public void setUserGroup(Integer userGroup) {
		this.userGroup = userGroup;
	}

	/**
	 * Gets the module id.
	 * 
	 * @return the module id
	 */
	public String getModuleId() {
		return moduleId;
	}

	/**
	 * Sets the module id.
	 * 
	 * @param moduleId the new module id
	 */
	public void setModuleId(String moduleId) {
		this.moduleId = moduleId;
	}

	/**
	 * Gets the remarks.
	 * 
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * Sets the remarks.
	 * 
	 * @param remarks the new remarks
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
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

	public String getWebEnabled() {
		return webEnabled;
	}

	public void setWebEnabled(String webEnabled) {
		this.webEnabled = webEnabled;
	}

	public Integer getModAccessTag() {
		return modAccessTag;
	}

	public void setModAccessTag(Integer modAccessTag) {
		this.modAccessTag = modAccessTag;
	}

	public String getDspModuleTypeDesc() {
		return dspModuleTypeDesc;
	}

	public void setDspModuleTypeDesc(String dspModuleTypeDesc) {
		this.dspModuleTypeDesc = dspModuleTypeDesc;
	}

}