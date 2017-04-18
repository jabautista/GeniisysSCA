/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;


import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIISSubline.
 */
public class GIISSubline extends BaseEntity {

	/** The line cd. */
	private String lineCd;
	
	/** The line name */
	private String lineName;
	
	
	/** The subline cd. */
	private String sublineCd;
	
	/** The acct subline cd. */
	private int acctSublineCd;
	
	/** The minimum premium amt*/
	private int minPremAmt;
	
	/** The subline name. */
	private String sublineName;
	
	/** The open policy sw. */
	private String openPolicySw;
	
	/** The op flag. */
	private String opFlag;
	
	/** The subline time. */
	private String sublineTime;
	
	/** The subline grp. */
	private String sublineGrp;
	
	/** The subline flag. */
	private String sublineFlag;
	
	/** The time sw. */
	private String timeSw;
	
	/** The allied prt tag. */
	private String alliedPrtTag;
	
	/** The exclude tag. */
	private String excludeTag;
	
	/** The remarks. */
	private String remarks;
	
	/** The cpi rec no. */
	private int cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;
	
	/** The no tax sw. */
	private String noTaxSw;
	
	/** The benefit flag. */
	private String benefitFlag;
	
	/** The prof comm tag. */
	private String profCommTag;
	
	/** The non renewal tag. */
	private String nonRenewalTag;
	
	/** The edst tag. */
	private String edstSw;

	/**
	 * Gets the line cd.
	 * 
	 * @return the line cd
	 */
	public String getLineCd() {
		return lineCd;
	}

	/**
	 * Sets the line cd.
	 * 
	 * @param lineCd the new line cd
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	/**
	 * Gets the subline cd.
	 * 
	 * @return the subline cd
	 */
	public String getSublineCd() {
		return sublineCd;
	}

	/**
	 * Sets the subline cd.
	 * 
	 * @param sublineCd the new subline cd
	 */
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	/**
	 * Gets the acct subline cd.
	 * 
	 * @return the acct subline cd
	 */
	public int getAcctSublineCd() {
		return acctSublineCd;
	}

	/**
	 * Sets the acct subline cd.
	 * 
	 * @param acctSublineCd the new acct subline cd
	 */
	public void setAcctSublineCd(int acctSublineCd) {
		this.acctSublineCd = acctSublineCd;
	}

	/**
	 * Gets the subline name.
	 * 
	 * @return the subline name
	 */
	public String getSublineName() {
		return sublineName;
	}

	/**
	 * Sets the subline name.
	 * 
	 * @param sublineName the new subline name
	 */
	public void setSublineName(String sublineName) {
		this.sublineName = sublineName;
	}

	/**
	 * Gets the open policy sw.
	 * 
	 * @return the open policy sw
	 */
	public String getOpenPolicySw() {
		return openPolicySw;
	}

	/**
	 * Sets the open policy sw.
	 * 
	 * @param openPolicySw the new open policy sw
	 */
	public void setOpenPolicySw(String openPolicySw) {
		this.openPolicySw = openPolicySw;
	}

	/**
	 * Gets the subline time.
	 * 
	 * @return the subline time
	 */
	public String getSublineTime() {
		return sublineTime;
	}

	/**
	 * Sets the subline time.
	 * 
	 * @param sublineTime the new subline time
	 */
	public void setSublineTime(String sublineTime) {
		this.sublineTime = sublineTime;
	}

	/**
	 * Gets the subline grp.
	 * 
	 * @return the subline grp
	 */
	public String getSublineGrp() {
		return sublineGrp;
	}

	/**
	 * Sets the subline grp.
	 * 
	 * @param sublineGrp the new subline grp
	 */
	public void setSublineGrp(String sublineGrp) {
		this.sublineGrp = sublineGrp;
	}

	/**
	 * Gets the subline flag.
	 * 
	 * @return the subline flag
	 */
	public String getSublineFlag() {
		return sublineFlag;
	}

	/**
	 * Sets the subline flag.
	 * 
	 * @param sublineFlag the new subline flag
	 */
	public void setSublineFlag(String sublineFlag) {
		this.sublineFlag = sublineFlag;
	}

	/**
	 * Gets the op flag.
	 * 
	 * @return the op flag
	 */
	public String getOpFlag() {
		return opFlag;
	}

	/**
	 * Sets the op flag.
	 * 
	 * @param opFlag the new op flag
	 */
	public void setOpFlag(String opFlag) {
		this.opFlag = opFlag;
	}

	/**
	 * Gets the time sw.
	 * 
	 * @return the time sw
	 */
	public String getTimeSw() {
		return timeSw;
	}

	/**
	 * Sets the time sw.
	 * 
	 * @param timeSw the new time sw
	 */
	public void setTimeSw(String timeSw) {
		this.timeSw = timeSw;
	}

	/**
	 * Gets the allied prt tag.
	 * 
	 * @return the allied prt tag
	 */
	public String getAlliedPrtTag() {
		return alliedPrtTag;
	}

	/**
	 * Sets the allied prt tag.
	 * 
	 * @param alliedPrtTag the new allied prt tag
	 */
	public void setAlliedPrtTag(String alliedPrtTag) {
		this.alliedPrtTag = alliedPrtTag;
	}

	/**
	 * Gets the exclude tag.
	 * 
	 * @return the exclude tag
	 */
	public String getExcludeTag() {
		return excludeTag;
	}

	/**
	 * Sets the exclude tag.
	 * 
	 * @param excludeTag the new exclude tag
	 */
	public void setExcludeTag(String excludeTag) {
		this.excludeTag = excludeTag;
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
	public int getCpiRecNo() {
		return cpiRecNo;
	}

	/**
	 * Sets the cpi rec no.
	 * 
	 * @param cpiRecNo the new cpi rec no
	 */
	public void setCpiRecNo(int cpiRecNo) {
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
	 * Gets the no tax sw.
	 * 
	 * @return the no tax sw
	 */
	public String getNoTaxSw() {
		return noTaxSw;
	}

	/**
	 * Sets the no tax sw.
	 * 
	 * @param noTaxSw the new no tax sw
	 */
	public void setNoTaxSw(String noTaxSw) {
		this.noTaxSw = noTaxSw;
	}

	/**
	 * Gets the benefit flag.
	 * 
	 * @return the benefit flag
	 */
	public String getBenefitFlag() {
		return benefitFlag;
	}

	/**
	 * Sets the benefit flag.
	 * 
	 * @param benefitFlag the new benefit flag
	 */
	public void setBenefitFlag(String benefitFlag) {
		this.benefitFlag = benefitFlag;
	}

	/**
	 * Gets the prof comm tag.
	 * 
	 * @return the prof comm tag
	 */
	public String getProfCommTag() {
		return profCommTag;
	}

	/**
	 * Sets the prof comm tag.
	 * 
	 * @param profCommTag the new prof comm tag
	 */
	public void setProfCommTag(String profCommTag) {
		this.profCommTag = profCommTag;
	}

	/**
	 * Gets the non renewal tag.
	 * 
	 * @return the non renewal tag
	 */
	public String getNonRenewalTag() {
		return nonRenewalTag;
	}

	/**
	 * Sets the non renewal tag.
	 * 
	 * @param nonRenewalTag the new non renewal tag
	 */
	public void setNonRenewalTag(String nonRenewalTag) {
		this.nonRenewalTag = nonRenewalTag;
	}
	
	/**
	 * Sets the line name.
	 * 
	 * @param lineCd the new line name
	 */
	public void setLineName(String lineName) {
		this.lineName = lineName;
	}
	
	/**
	 * Gets the line name.
	 * 
	 * @param lineCd the new line name
	 */
	public String getLineName() {
		return lineName;
	}
	
	public int getMinPremAmt() {
		return minPremAmt;
	}

	public void setMinPremAmt(Integer minPremAmt) {
		this.minPremAmt = minPremAmt;
	}

	public void setEdstSw(String edstSw) {
		this.edstSw = edstSw;
	}

	public String getEdstSw() {
		return edstSw;
	}

}
