/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIWinvTax.
 */
public class GIPIWinvTax extends BaseEntity {

	/** The par id. */
	private int parId;
	
	/** The item grp. */
	private int itemGrp;
	
	/** The tax cd. */
	private Integer taxCd;
	
	/** The line cd. */
	private String lineCd;
	
	/** The tax allocation. */
	private String taxAllocation;
	
	/** The fixed tax allocation. */
	private String fixedTaxAllocation;
	
	/** The iss cd. */
	private String issCd;
	
	/** The tax amt. */
	private BigDecimal taxAmt;
	
	/** The tax id. */
	private int taxId;
	
	/** The rate. */
	private BigDecimal rate;
	
	/** The takeup seq no. */
	private Integer takeupSeqNo;
	
	/** The tax desc. */
	private String taxDesc;
	
	/** The peril sw. */
	private String perilSw;
	
	/** The sum tax amt. */
	private BigDecimal sumTaxAmt;
	
	/** The primary sw. */
	private String primarySw;
	
	private String noRateTag;

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
	 * Gets the sum tax amt.
	 * 
	 * @return the sum tax amt
	 */
	public BigDecimal getSumTaxAmt() {
		return sumTaxAmt;
	}

	/**
	 * Sets the sum tax amt.
	 * 
	 * @param sumTaxAmt the new sum tax amt
	 */
	public void setSumTaxAmt(BigDecimal sumTaxAmt) {
		this.sumTaxAmt = sumTaxAmt;
	}

	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public int getParId() {
		return parId;
	}

	/**
	 * Sets the par id.
	 * 
	 * @param parId the new par id
	 */
	public void setParId(int parId) {
		this.parId = parId;
	}

	/**
	 * Gets the item grp.
	 * 
	 * @return the item grp
	 */
	public int getItemGrp() {
		return itemGrp;
	}

	/**
	 * Sets the item grp.
	 * 
	 * @param itemGrp the new item grp
	 */
	public void setItemGrp(int itemGrp) {
		this.itemGrp = itemGrp;
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
	 * Gets the tax allocation.
	 * 
	 * @return the tax allocation
	 */
	public String getTaxAllocation() {
		return taxAllocation;
	}

	/**
	 * Sets the tax allocation.
	 * 
	 * @param taxAllocation the new tax allocation
	 */
	public void setTaxAllocation(String taxAllocation) {
		this.taxAllocation = taxAllocation;
	}

	/**
	 * Gets the fixed tax allocation.
	 * 
	 * @return the fixed tax allocation
	 */
	public String getFixedTaxAllocation() {
		return fixedTaxAllocation;
	}

	/**
	 * Sets the fixed tax allocation.
	 * 
	 * @param fixedTaxAllocation the new fixed tax allocation
	 */
	public void setFixedTaxAllocation(String fixedTaxAllocation) {
		this.fixedTaxAllocation = fixedTaxAllocation;
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
	 * Gets the tax amt.
	 * 
	 * @return the tax amt
	 */
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}

	/**
	 * Sets the tax amt.
	 * 
	 * @param taxAmt the new tax amt
	 */
	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}

	/**
	 * Gets the tax id.
	 * 
	 * @return the tax id
	 */
	public int getTaxId() {
		return taxId;
	}

	/**
	 * Sets the tax id.
	 * 
	 * @param taxId the new tax id
	 */
	public void setTaxId(int taxId) {
		this.taxId = taxId;
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
	 * Gets the takeup seq no.
	 * 
	 * @return the takeup seq no
	 */
	public Integer getTakeupSeqNo() {
		return takeupSeqNo;
	}

	/**
	 * Sets the takeup seq no.
	 * 
	 * @param takeupSeqNo the new takeup seq no
	 */
	public void setTakeupSeqNo(Integer takeupSeqNo) {
		this.takeupSeqNo = takeupSeqNo;
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
	
}
