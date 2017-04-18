/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;


/**
 * The Class GIISUserGrpModule.
 */
public class GIISUserGrpModule extends GIISModule {

	/** The user grp. */
	private Integer userGrp;
	
	/** The tran cd. */
	private Integer tranCd;
	
	private String accessTagDesc;
	private String incTag;

	/**
	 * Instantiates a new gIIS user grp module.
	 */
	public GIISUserGrpModule() {
		
	}
	
	/**
	 * Instantiates a new gIIS user grp module.
	 * 
	 * @param userGrp the user grp
	 * @param tranCd the tran cd
	 * @param moduleId the module id
	 * @param remarks the remarks
	 * @param accessTag the access tag
	 */
	public GIISUserGrpModule(Integer userGrp, Integer tranCd, String moduleId, String remarks, String accessTag) {
		this.userGrp = userGrp;
		this.tranCd = tranCd;
		super.setModuleId(moduleId);
		super.setRemarks(remarks);
		super.setAccessTag(accessTag);
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

	/* (non-Javadoc)
	 * @see com.geniisys.common.entity.GIISModule#getTranCd()
	 */
	@Override
	public Integer getTranCd() {
		return tranCd;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.entity.GIISModule#setTranCd(int)
	 */
	@Override
	public void setTranCd(Integer tranCd) {
		this.tranCd = tranCd;
	}

	public String getAccessTagDesc() {
		return accessTagDesc;
	}

	public void setAccessTagDesc(String accessTagDesc) {
		this.accessTagDesc = accessTagDesc;
	}

	public String getIncTag() {
		return incTag;
	}

	public void setIncTag(String incTag) {
		this.incTag = incTag;
	}

}
