/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;



/**
 * The Class GIISLine.
 */
public class GIISLine extends BaseEntity {

	/** The line cd. */
	private String lineCd;
	
	/** The line name. */
	private String lineName;
	
	/** The acctline cd. */
	private Integer acctlineCd;
	
	/** The pack pol flag. */
	private String packPolFlag;
	
	/** The sc tag. */
	private String scTag;
	
	/** The remarks. */
	private String remarks;
	
	/** The cpi rec no. */
	private Integer cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;
	
	/** The subline sw. */
	private String sublineSW;
	
	/** The menu line cd. */
	private String menuLineCd;
	
	/** The prof comm tag. */
	private String profCommTag;
	
	/** The recaps line cd. */
	private String recapsLineCd;
	
	/** The non renewal tag. */
	private String nonRenewalTag;
	
	private String issCd;
	
	private String issName;
	
	private BigDecimal minPremAmt;
	
	private String specialDistSw;
	
	private String edstSw;
	
	private String enrolleeTag;
	
	private String otherCertTag;

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
	 * Gets the acctline cd.
	 * 
	 * @return the acctline cd
	 */
	public Integer getAcctlineCd() {
		return acctlineCd;
	}

	/**
	 * Sets the acctline cd.
	 * 
	 * @param acctlineCd the new acctline cd
	 */
	public void setAcctlineCd(Integer acctlineCd) {
		this.acctlineCd = acctlineCd;
	}

	/**
	 * Gets the line name.
	 * 
	 * @return the line name
	 */
	public String getLineName() {
		return lineName;
	}

	/**
	 * Sets the line name.
	 * 
	 * @param lineName the new line name
	 */
	public void setLineName(String lineName) {
		this.lineName = lineName;
	}

	/**
	 * Gets the pack pol flag.
	 * 
	 * @return the pack pol flag
	 */
	public String getPackPolFlag() {
		return packPolFlag;
	}

	/**
	 * Sets the pack pol flag.
	 * 
	 * @param packPolFlag the new pack pol flag
	 */
	public void setPackPolFlag(String packPolFlag) {
		this.packPolFlag = packPolFlag;
	}

	/**
	 * Gets the sc tag.
	 * 
	 * @return the sc tag
	 */
	public String getScTag() {
		return scTag;
	}

	/**
	 * Sets the sc tag.
	 * 
	 * @param scTag the new sc tag
	 */
	public void setScTag(String scTag) {
		this.scTag = scTag;
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
	 * Gets the subline sw.
	 * 
	 * @return the subline sw
	 */
	public String getSublineSW() {
		return sublineSW;
	}

	/**
	 * Sets the subline sw.
	 * 
	 * @param sublineSW the new subline sw
	 */
	public void setSublineSW(String sublineSW) {
		this.sublineSW = sublineSW;
	}

	/**
	 * Gets the menu line cd.
	 * 
	 * @return the menu line cd
	 */
	public String getMenuLineCd() {
		return menuLineCd;
	}

	/**
	 * Sets the menu line cd.
	 * 
	 * @param menuLineCd the new menu line cd
	 */
	public void setMenuLineCd(String menuLineCd) {
		this.menuLineCd = menuLineCd;
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
	 * Gets the recaps line cd.
	 * 
	 * @return the recaps line cd
	 */
	public String getRecapsLineCd() {
		return recapsLineCd;
	}

	/**
	 * Sets the recaps line cd.
	 * 
	 * @param recapsLineCd the new recaps line cd
	 */
	public void setRecapsLineCd(String recapsLineCd) {
		this.recapsLineCd = recapsLineCd;
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
	 * @param issCd the issCd to set
	 */
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	/**
	 * @return the issCd
	 */
	public String getIssCd() {
		return issCd;
	}

	/**
	 * @param issName the issName to set
	 */
	public void setIssName(String issName) {
		this.issName = issName;
	}

	/**
	 * @return the issName
	 */
	public String getIssName() {
		return issName;
	}
	
	public BigDecimal getMinPremAmt() {
		return minPremAmt;
	}

	public void setMinPremAmt(BigDecimal minPremAmt) {
		this.minPremAmt = minPremAmt;
	}

	/**
	 * @return the specialDistSw
	 */
	public String getSpecialDistSw() {
		return specialDistSw;
	}

	/**
	 * @param specialDistSw the specialDistSw to set
	 */
	public void setSpecialDistSw(String specialDistSw) {
		this.specialDistSw = specialDistSw;
	}

	/**
	 * @return the edstSw
	 */
	public String getEdstSw() {
		return edstSw;
	}

	/**
	 * @param edstSw the edstSw to set
	 */
	public void setEdstSw(String edstSw) {
		this.edstSw = edstSw;
	}

	/**
	 * @return the enrolleeTag
	 */
	public String getEnrolleeTag() {
		return enrolleeTag;
	}

	/**
	 * @param enrolleeTag the enrolleeTag to set
	 */
	public void setEnrolleeTag(String enrolleeTag) {
		this.enrolleeTag = enrolleeTag;
	}

	public String getOtherCertTag() {
		return otherCertTag;
	}

	public void setOtherCertTag(String otherCertTag) {
		this.otherCertTag = otherCertTag;
	}

}
