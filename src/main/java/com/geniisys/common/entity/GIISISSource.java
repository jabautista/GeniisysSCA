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
 * The Class GIISISSource.
 */
public class GIISISSource extends BaseEntity {

	/** The iss cd. */
	public String issCd;
	
	/** The acct iss cd. */
	private Integer acctIssCd;
	
	/** The iss name. */
	private String issName;
	
	/** The gen inv sw. */
	private String genInvSw;
	
	/** The iss grp. */
	private Integer issGrp;
	
	/** The prnt iss cd. */
	private String prntIssCd;
	
	/** The iss level. */
	private Integer issLevel;
	
	/** The address1. */
	private String address1;
	
	/** The address2. */
	private String address2;
	
	/** The address3. */
	private String address3;
	
	/** The remarks. */
	private String remarks;
	
	/** The cpi rec no. */
	private Integer cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;
	
	/** The gouc ouc id. */
	private Integer goucOucId;
	
	/** The ho tag. */
	private String hoTag;
	
	/** The region cd. */
	private Integer regionCd;
	
	/** The claim branch cd. */
	private String claimBranchCd;
	
	/** The claim tag. */
	private String claimTag;
	
	/** The cred br tag. */
	private String credBrTag;
	
	/** The online sw. */
	private String onlineSw;
	
	private String city;
	
	private String branchTinCd;
	
	private String branchWebsite;
	
	private String telNo;
	
	private String branchFaxNo;
	
	private String activeTag;
	
	private String regionDesc;
	
	private Integer oldAcctIssCd;

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

	/**
	 * Gets the acct iss cd.
	 * 
	 * @return the acct iss cd
	 */
	public Integer getAcctIssCd() {
		return acctIssCd;
	}

	/**
	 * Sets the acct iss cd.
	 * 
	 * @param acctIssCd the new acct iss cd
	 */
	public void setAcctIssCd(Integer acctIssCd) {
		this.acctIssCd = acctIssCd;
	}

	/**
	 * Gets the iss name.
	 * 
	 * @return the iss name
	 */
	public String getIssName() {
		return issName;
	}

	/**
	 * Sets the iss name.
	 * 
	 * @param issName the new iss name
	 */
	public void setIssName(String issName) {
		this.issName = issName;
	}

	/**
	 * Gets the gen inv sw.
	 * 
	 * @return the gen inv sw
	 */
	public String getGenInvSw() {
		return genInvSw;
	}

	/**
	 * Sets the gen inv sw.
	 * 
	 * @param genInvSw the new gen inv sw
	 */
	public void setGenInvSw(String genInvSw) {
		this.genInvSw = genInvSw;
	}

	/**
	 * Gets the iss grp.
	 * 
	 * @return the iss grp
	 */
	public Integer getIssGrp() {
		return issGrp;
	}

	/**
	 * Sets the iss grp.
	 * 
	 * @param issGrp the new iss grp
	 */
	public void setIssGrp(Integer issGrp) {
		this.issGrp = issGrp;
	}

	/**
	 * Gets the prnt iss cd.
	 * 
	 * @return the prnt iss cd
	 */
	public String getPrntIssCd() {
		return prntIssCd;
	}

	/**
	 * Sets the prnt iss cd.
	 * 
	 * @param prntIssCd the new prnt iss cd
	 */
	public void setPrntIssCd(String prntIssCd) {
		this.prntIssCd = prntIssCd;
	}

	/**
	 * Gets the iss level.
	 * 
	 * @return the iss level
	 */
	public Integer getIssLevel() {
		return issLevel;
	}

	/**
	 * Sets the iss level.
	 * 
	 * @param issLevel the new iss level
	 */
	public void setIssLevel(Integer issLevel) {
		this.issLevel = issLevel;
	}

	/**
	 * Gets the address1.
	 * 
	 * @return the address1
	 */
	public String getAddress1() {
		return address1;
	}

	/**
	 * Sets the address1.
	 * 
	 * @param address1 the new address1
	 */
	public void setAddress1(String address1) {
		this.address1 = address1;
	}

	/**
	 * Gets the address2.
	 * 
	 * @return the address2
	 */
	public String getAddress2() {
		return address2;
	}

	/**
	 * Sets the address2.
	 * 
	 * @param address2 the new address2
	 */
	public void setAddress2(String address2) {
		this.address2 = address2;
	}

	/**
	 * Gets the address3.
	 * 
	 * @return the address3
	 */
	public String getAddress3() {
		return address3;
	}

	/**
	 * Sets the address3.
	 * 
	 * @param address3 the new address3
	 */
	public void setAddress3(String address3) {
		this.address3 = address3;
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
	 * Gets the cpi rec no.
	 * 
	 * @return the cpi rec no
	 */
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	/**
	 * Sets the cpi rec no.
	 * 
	 * @param cpiRecNo the new cpi rec no
	 */
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	/**
	 * Gets the cpi branch cd.
	 * 
	 * @return the cpi branch cd
	 */
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	/**
	 * Sets the cpi branch cd.
	 * 
	 * @param cpiBranchCd the new cpi branch cd
	 */
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	/**
	 * Gets the gouc ouc id.
	 * 
	 * @return the gouc ouc id
	 */
	public Integer getGoucOucId() {
		return goucOucId;
	}

	/**
	 * Sets the gouc ouc id.
	 * 
	 * @param goucOucId the new gouc ouc id
	 */
	public void setGoucOucId(Integer goucOucId) {
		this.goucOucId = goucOucId;
	}

	/**
	 * Gets the ho tag.
	 * 
	 * @return the ho tag
	 */
	public String getHoTag() {
		return hoTag;
	}

	/**
	 * Sets the ho tag.
	 * 
	 * @param hoTag the new ho tag
	 */
	public void setHoTag(String hoTag) {
		this.hoTag = hoTag;
	}

	/**
	 * Gets the region cd.
	 * 
	 * @return the region cd
	 */
	public Integer getRegionCd() {
		return regionCd;
	}

	/**
	 * Sets the region cd.
	 * 
	 * @param regionCd the new region cd
	 */
	public void setRegionCd(Integer regionCd) {
		this.regionCd = regionCd;
	}

	/**
	 * Gets the claim branch cd.
	 * 
	 * @return the claim branch cd
	 */
	public String getClaimBranchCd() {
		return claimBranchCd;
	}

	/**
	 * Sets the claim branch cd.
	 * 
	 * @param claimBranchCd the new claim branch cd
	 */
	public void setClaimBranchCd(String claimBranchCd) {
		this.claimBranchCd = claimBranchCd;
	}

	/**
	 * Gets the claim tag.
	 * 
	 * @return the claim tag
	 */
	public String getClaimTag() {
		return claimTag;
	}

	/**
	 * Sets the claim tag.
	 * 
	 * @param claimTag the new claim tag
	 */
	public void setClaimTag(String claimTag) {
		this.claimTag = claimTag;
	}

	/**
	 * Gets the cred br tag.
	 * 
	 * @return the cred br tag
	 */
	public String getCredBrTag() {
		return credBrTag;
	}

	/**
	 * Sets the cred br tag.
	 * 
	 * @param credBrTag the new cred br tag
	 */
	public void setCredBrTag(String credBrTag) {
		this.credBrTag = credBrTag;
	}

	/**
	 * Gets the online sw.
	 * 
	 * @return the online sw
	 */
	public String getOnlineSw() {
		return onlineSw;
	}

	/**
	 * Sets the online sw.
	 * 
	 * @param onlineSw the new online sw
	 */
	public void setOnlineSw(String onlineSw) {
		this.onlineSw = onlineSw;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getBranchTinCd() {
		return branchTinCd;
	}

	public void setBranchTinCd(String branchTinCd) {
		this.branchTinCd = branchTinCd;
	}

	public String getBranchWebsite() {
		return branchWebsite;
	}

	public void setBranchWebsite(String branchWebsite) {
		this.branchWebsite = branchWebsite;
	}

	public String getTelNo() {
		return telNo;
	}

	public void setTelNo(String telNo) {
		this.telNo = telNo;
	}

	public String getBranchFaxNo() {
		return branchFaxNo;
	}

	public void setBranchFaxNo(String branchFaxNo) {
		this.branchFaxNo = branchFaxNo;
	}

	public String getActiveTag() {
		return activeTag;
	}

	public void setActiveTag(String activeTag) {
		this.activeTag = activeTag;
	}

	public String getRegionDesc() {
		return regionDesc;
	}

	public void setRegionDesc(String regionDesc) {
		this.regionDesc = regionDesc;
	}

	public Integer getOldAcctIssCd() {
		return oldAcctIssCd;
	}

	public void setOldAcctIssCd(Integer oldAcctIssCd) {
		this.oldAcctIssCd = oldAcctIssCd;
	}
	
}
