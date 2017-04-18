package com.geniisys.common.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIISSublineMain  extends BaseEntity {
	
	/** The line cd. */
	private String lineCd;
	
	/** The subline cd. */
	private String sublineCd;
	
	/** The acct subline cd. */
	private int acctSublineCd;
	
	/** The minimum premium amt*/
	private BigDecimal minPremAmt;
	
	/** The subline name. */
	private String sublineName;
	
	/** The open policy sw. */
	private String openPolicySw;
	
	/** The op flag. */
	private String opFlag;
	
	/** The subline time. */
	private String sublineTime;
	
	/** The time sw. */
	private String timeSw;
	
	/** The allied prt tag. */
	private String alliedPrtTag;
	
	/** The exclude tag. */
	private String excludeTag;
	
	/** The remarks. */
	private String remarks;
	
	/** The no tax sw. */
	private String noTaxSw;
	
	/** The prof comm tag. */
	private String profCommTag;
	
	/** The non renewal tag. */
	private String nonRenewalTag;
	
	/** The edst tag. */
	private String edstSw;
	
	//added by kenneth L. 03.20.2014
	private String enrolleeTag;
	
	/** The micro sw. */
	private String microSw; //Added by apollo 05.20.2015 sr#4245

	/**
	 * @param lineCd the lineCd to set
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	/**
	 * @return the lineCd
	 */
	public String getLineCd() {
		return lineCd;
	}

	/**
	 * @param sublineCd the sublineCd to set
	 */
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	/**
	 * @return the sublineCd
	 */
	public String getSublineCd() {
		return sublineCd;
	}

	/**
	 * @param acctSublineCd the acctSublineCd to set
	 */
	public void setAcctSublineCd(int acctSublineCd) {
		this.acctSublineCd = acctSublineCd;
	}

	/**
	 * @return the acctSublineCd
	 */
	public int getAcctSublineCd() {
		return acctSublineCd;
	}

	/**
	 * @param minPremAmt the minPremAmt to set
	 */
	public void setMinPremAmt(BigDecimal minPremAmt) {
		this.minPremAmt = minPremAmt;
	}

	/**
	 * @return the minPremAmt
	 */
	public BigDecimal getMinPremAmt() {
		return minPremAmt;
	}

	/**
	 * @param sublineName the sublineName to set
	 */
	public void setSublineName(String sublineName) {
		this.sublineName = sublineName;
	}

	/**
	 * @return the sublineName
	 */
	public String getSublineName() {
		return sublineName;
	}

	/**
	 * @param openPolicySw the openPolicySw to set
	 */
	public void setOpenPolicySw(String openPolicySw) {
		this.openPolicySw = openPolicySw;
	}

	/**
	 * @return the openPolicySw
	 */
	public String getOpenPolicySw() {
		return openPolicySw;
	}

	/**
	 * @param opFlag the opFlag to set
	 */
	public void setOpFlag(String opFlag) {
		this.opFlag = opFlag;
	}

	/**
	 * @return the opFlag
	 */
	public String getOpFlag() {
		return opFlag;
	}

	/**
	 * @param sublineTime the sublineTime to set
	 */
	public void setSublineTime(String sublineTime) {
		this.sublineTime = sublineTime;
	}

	/**
	 * @return the sublineTime
	 */
	public String getSublineTime() {
		return sublineTime;
	}

	/**
	 * @param timeSw the timeSw to set
	 */
	public void setTimeSw(String timeSw) {
		this.timeSw = timeSw;
	}

	/**
	 * @return the timeSw
	 */
	public String getTimeSw() {
		return timeSw;
	}

	/**
	 * @param alliedPrtTag the alliedPrtTag to set
	 */
	public void setAlliedPrtTag(String alliedPrtTag) {
		this.alliedPrtTag = alliedPrtTag;
	}

	/**
	 * @return the alliedPrtTag
	 */
	public String getAlliedPrtTag() {
		return alliedPrtTag;
	}

	/**
	 * @param excludeTag the excludeTag to set
	 */
	public void setExcludeTag(String excludeTag) {
		this.excludeTag = excludeTag;
	}

	/**
	 * @return the excludeTag
	 */
	public String getExcludeTag() {
		return excludeTag;
	}

	/**
	 * @param remarks the remarks to set
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	/**
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * @param profCommTag the profCommTag to set
	 */
	public void setProfCommTag(String profCommTag) {
		this.profCommTag = profCommTag;
	}

	/**
	 * @return the profCommTag
	 */
	public String getProfCommTag() {
		return profCommTag;
	}

	/**
	 * @param nonRenewalTag the nonRenewalTag to set
	 */
	public void setNonRenewalTag(String nonRenewalTag) {
		this.nonRenewalTag = nonRenewalTag;
	}

	/**
	 * @return the nonRenewalTag
	 */
	public String getNonRenewalTag() {
		return nonRenewalTag;
	}

	/**
	 * @param edstSw the edstSw to set
	 */
	public void setEdstSw(String edstSw) {
		this.edstSw = edstSw;
	}

	/**
	 * @return the edstSw
	 */
	public String getEdstSw() {
		return edstSw;
	}

	/**
	 * @param noTaxSw the noTaxSw to set
	 */
	public void setNoTaxSw(String noTaxSw) {
		this.noTaxSw = noTaxSw;
	}

	/**
	 * @return the noTaxSw
	 */
	public String getNoTaxSw() {
		return noTaxSw;
	}

	public void setEnrolleeTag(String enrolleeTag) {
		this.enrolleeTag = enrolleeTag;
	}

	public String getEnrolleeTag() {
		return enrolleeTag;
	}
	
	/**
	 * @param microSw the microSw to set
	 */
	public void setMicroSw(String microSw) {
		this.microSw = microSw;
	}

	/**
	 * @return the microSw
	 */
	public String getMicroSw() {
		return microSw;
	}
}
