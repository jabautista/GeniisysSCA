/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import java.math.BigDecimal;

import com.seer.framework.util.Entity;


/**
 * The Class GIISTaxCharges.
 */
@SuppressWarnings({ "rawtypes" })
public class GIISTaxCharges extends Entity{	

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -8912298312049387858L;
	
	/** The tax cd. */
	private Integer taxCd;
	
	/** The line cd. */
	private String lineCd;
	
	/** The iss cd. */
	private String issCd;
	
	/** The tax desc. */
	private String taxDesc;
	
	/** The rate. */
	private BigDecimal rate;
	
	/** The peril sw. */
	private String perilSw;
	
	/** The tax id. */
	private Integer taxId;
	
	/** The allocation tag. */
	private String allocationTag;
	
	/** The primary sw. */
	private String primarySw;
	
	/** The no rate tag. */
	private String noRateTag;
	
	/** The perilCd */
	private Integer perilCd;
	
	private String taxType;
	
	//added by Kenneth L. 11.22.2013
	private String functionName;
	
	private BigDecimal taxAmount;
	
	private Integer sequence;
	
	private String effStartDate;
	
	private String effEndDate;
	
	private Integer drGlCd;
	
	private Integer crGlCd;
	
	private Integer drSub1;
	
	private Integer crSub1;
	
	private String includeTag;
	
	private String inceptSw;
	
	private String expiredSw;
	
	private String polEndtSw;
	
	private String takeupAllocTag;

	private String remarks;
	
	private String issueDateTag;
	
	private String cocCharge;
	
	private Integer maxSequence;
	
	private String strLastUpdate;
	
	private String strExists;
	
	private String refundSw; //added by robert GENQA 4844 08.10.15
	
	public Integer getMaxSequence() {
		return maxSequence;
	}

	public void setMaxSequence(Integer maxSequence) {
		this.maxSequence = maxSequence;
	}

	public Integer getMaxTaxId() {
		return maxTaxId;
	}

	public void setMaxTaxId(Integer maxTaxId) {
		this.maxTaxId = maxTaxId;
	}

	private Integer maxTaxId;
	
	//end Kenneth L. 11.22.2013
	
	public String getTaxType() {
		return taxType;
	}

	public void setTaxType(String taxType) {
		this.taxType = taxType;
	}

	//Properties that are not in the table - irwin 7.27.2012
	private BigDecimal tempTaxAmt;
	
	public BigDecimal getTempTaxAmt() {
		return tempTaxAmt;
	}

	public void setTempTaxAmt(BigDecimal tempTaxAmt) {
		this.tempTaxAmt = tempTaxAmt;
	}

	/**
	 * Gets the tax cd.
	 * 
	 * @return the tax cd
	 */
	public Integer getTaxCd() {
		return taxCd;
	}

	/**
	 * Sets the tax cd.
	 * 
	 * @param taxCd the new tax cd
	 */
	public void setTaxCd(Integer taxCd) {
		this.taxCd = taxCd;
	}

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
	 * Gets the tax desc.
	 * 
	 * @return the tax desc
	 */
	public String getTaxDesc() {
		return taxDesc;
	}

	/**
	 * Sets the tax desc.
	 * 
	 * @param taxDesc the new tax desc
	 */
	public void setTaxDesc(String taxDesc) {
		this.taxDesc = taxDesc;
	}

	/**
	 * Gets the rate.
	 * 
	 * @return the rate
	 */
	public BigDecimal getRate() {
		return rate;
	}

	/**
	 * Sets the rate.
	 * 
	 * @param rate the new rate
	 */
	public void setRate(BigDecimal rate) {
		this.rate = rate;
	}

	/**
	 * Gets the peril sw.
	 * 
	 * @return the peril sw
	 */
	public String getPerilSw() {
		return perilSw;
	}

	/**
	 * Sets the peril sw.
	 * 
	 * @param perilSw the new peril sw
	 */
	public void setPerilSw(String perilSw) {
		this.perilSw = perilSw;
	}

	/**
	 * Gets the tax id.
	 * 
	 * @return the tax id
	 */
	public Integer getTaxId() {
		return taxId;
	}

	/**
	 * Sets the tax id.
	 * 
	 * @param taxId the new tax id
	 */
	public void setTaxId(Integer taxId) {
		this.taxId = taxId;
	}

	/**
	 * Gets the allocation tag.
	 * 
	 * @return the allocation tag
	 */
	public String getAllocationTag() {
		return allocationTag;
	}

	/**
	 * Sets the allocation tag.
	 * 
	 * @param allocationTag the new allocation tag
	 */
	public void setAllocationTag(String allocationTag) {
		this.allocationTag = allocationTag;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#getId()
	 */
	@Override
	public Object getId() {
		return null;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#setId(java.lang.Object)
	 */
	@Override
	public void setId(Object id) {
		
	}

	/**
	 * Sets the primary sw.
	 * 
	 * @param primarySw the new primary sw
	 */
	public void setPrimarySw(String primarySw) {
		this.primarySw = primarySw;
	}

	/**
	 * Gets the primary sw.
	 * 
	 * @return the primary sw
	 */
	public String getPrimarySw() {
		return primarySw;
	}

	/**
	 * @return the noRateTag
	 */
	public String getNoRateTag() {
		return noRateTag;
	}

	/**
	 * @param noRateTag the noRateTag to set
	 */
	public void setNoRateTag(String noRateTag) {
		this.noRateTag = noRateTag;
	}

	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}

	public Integer getPerilCd() {
		return perilCd;
	}

	//added by Kenneth L. 11.22.2013
	public String getFunctionName() {
		return functionName;
	}

	public void setFunctionName(String functionName) {
		this.functionName = functionName;
	}

	public BigDecimal getTaxAmount() {
		return taxAmount;
	}

	public void setTaxAmount(BigDecimal taxAmount) {
		this.taxAmount = taxAmount;
	}

	public Integer getSequence() {
		return sequence;
	}

	public void setSequence(Integer sequence) {
		this.sequence = sequence;
	}

	public String getEffStartDate() {
		return effStartDate;
	}

	public void setEffStartDate(String effStartDate) {
		this.effStartDate = effStartDate;
	}

	public String getEffEndDate() {
		return effEndDate;
	}

	public void setEffEndDate(String effEndDate) {
		this.effEndDate = effEndDate;
	}

	public Integer getDrGlCd() {
		return drGlCd;
	}

	public void setDrGlCd(Integer drGlCd) {
		this.drGlCd = drGlCd;
	}

	public Integer getCrGlCd() {
		return crGlCd;
	}

	public void setCrGlCd(Integer crGlCd) {
		this.crGlCd = crGlCd;
	}

	public Integer getDrSub1() {
		return drSub1;
	}

	public void setDrSub1(Integer drSub1) {
		this.drSub1 = drSub1;
	}

	public Integer getCrSub1() {
		return crSub1;
	}

	public void setCrSub1(Integer crSub1) {
		this.crSub1 = crSub1;
	}

	public String getIncludeTag() {
		return includeTag;
	}

	public void setIncludeTag(String includeTag) {
		this.includeTag = includeTag;
	}

	public String getInceptSw() {
		return inceptSw;
	}

	public void setInceptSw(String inceptSw) {
		this.inceptSw = inceptSw;
	}

	public String getExpiredSw() {
		return expiredSw;
	}

	public void setExpiredSw(String expiredSw) {
		this.expiredSw = expiredSw;
	}

	public String getPolEndtSw() {
		return polEndtSw;
	}

	public void setPolEndtSw(String polEndtSw) {
		this.polEndtSw = polEndtSw;
	}

	public String getTakeupAllocTag() {
		return takeupAllocTag;
	}

	public void setTakeupAllocTag(String takeupAllocTag) {
		this.takeupAllocTag = takeupAllocTag;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getIssueDateTag() {
		return issueDateTag;
	}

	public void setIssueDateTag(String issueDateTag) {
		this.issueDateTag = issueDateTag;
	}

	public String getCocCharge() {
		return cocCharge;
	}

	public void setCocCharge(String cocCharge) {
		this.cocCharge = cocCharge;
	}
	//end Kenneth L. 11.22.2013

	public void setStrLastUpdate(String strLastUpdate) {
		this.strLastUpdate = strLastUpdate;
	}

	public String getStrLastUpdate() {
		return strLastUpdate;
	}

	public void setStrExists(String strExists) {
		this.strExists = strExists;
	}

	public String getStrExists() {
		return strExists;
	}
	//added by robert GENQA 4844 08.10.15
	public String getRefundSw() {
		return refundSw;
	}

	public void setRefundSw(String refundSw) {
		this.refundSw = refundSw;
	}
	//end robert GENQA 4844 08.10.15
}