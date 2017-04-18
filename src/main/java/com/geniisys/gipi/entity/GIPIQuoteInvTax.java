/**
 * 
\ * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.seer.framework.util.Entity;


/**
 * The Class GIPIQuoteInvTax.
 */
@SuppressWarnings("rawtypes")
public class GIPIQuoteInvTax extends Entity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 4715168426667351671L;	
	
	/** The line cd. */
	private String lineCd;
	
	/** The iss cd. */
	private String issCd;
	
	/** The quote inv no. */
	private Integer quoteInvNo;
	
	/** The tax cd. */
	private Integer taxCd;
	
	/** The tax id. */
	private Integer taxId;
	
	/** The tax amt. */
	private BigDecimal taxAmt;
	
	/** The rate. */
	private BigDecimal rate;
	
	/** The fixed tax allocation. */
	private String fixedTaxAllocation;
	
	/** The item grp. */
	private Integer itemGrp;
	
	/** The tax allocation. */
	private String taxAllocation;

	/** Comma separated list of peril_cd's */
	private String requiredTaxListing;
	
	private String taxDescription;
	
	private String primarySw;
	
	/**
	 * Instantiates a new gIPI quote inv tax.
	 */
	public GIPIQuoteInvTax(){
		
	}
	
	/**
	 * Instantiates a new gIPI quote inv tax.
	 * 
	 * @param lineCd the line cd
	 * @param issCd the iss cd
	 * @param quoteInvNo the quote inv no
	 * @param taxCd the tax cd
	 * @param taxId the tax id
	 * @param taxAmt the tax amt
	 * @param rate the rate
	 * @param fixedTaxAllocation the fixed tax allocation
	 * @param itemGrp the item grp
	 * @param taxAllocation the tax allocation
	 */
	public GIPIQuoteInvTax(String lineCd, String issCd, Integer quoteInvNo, Integer taxCd,
			Integer taxId, BigDecimal taxAmt, BigDecimal rate, String fixedTaxAllocation,
			Integer itemGrp, String taxAllocation){
		
		this.lineCd		= lineCd;
		this.issCd		= issCd;
		this.quoteInvNo = quoteInvNo;
		this.taxCd		= taxCd;
		this.taxId		= taxId;
		this.taxAmt		= taxAmt;
		this.rate		= rate;
		this.itemGrp	= itemGrp;
		this.taxAllocation		= taxAllocation;
		this.fixedTaxAllocation	= fixedTaxAllocation;
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
	 * @param lineCd the new line cd
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	/**
	 * Gets the iss cd.
	 * @return the iss cd
	 */
	public String getIssCd() {
		return issCd;
	}

	/**
	 * Sets the iss cd.
	 * @param issCd the new iss cd
	 */
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	/**
	 * Gets the quote inv no.
	 * @return the quote inv no
	 */
	public Integer getQuoteInvNo() {
		return quoteInvNo;
	}

	/**
	 * Sets the quote inv no.
	 * @param quoteInvNo the new quote inv no
	 */
	public void setQuoteInvNo(Integer quoteInvNo) {
		this.quoteInvNo = quoteInvNo;
	}

	/**
	 * Gets the tax cd.
	 * @return the tax cd
	 */
	public Integer getTaxCd() {
		return taxCd;
	}

	/**
	 * Sets the tax cd.
	 * @param taxCd the new tax cd
	 */
	public void setTaxCd(Integer taxCd) {
		this.taxCd = taxCd;
	}

	/**
	 * Gets the tax id.
	 * @return the tax id
	 */
	public Integer getTaxId() {
		return taxId;
	}

	/**
	 * Sets the tax id.
	 * @param taxId the new tax id
	 */
	public void setTaxId(Integer taxId) {
		this.taxId = taxId;
	}

	/**
	 * Gets the tax amt.
	 * @return the tax amt
	 */
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}

	/**
	 * Sets the tax amt.
	 * @param taxAmt the new tax amt
	 */
	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}

	/**
	 * Gets the rate.
	 * @return the rate
	 */
	public BigDecimal getRate() {
		return rate;
	}

	/**
	 * Sets the rate.
	 * @param rate the new rate
	 */
	public void setRate(BigDecimal rate) {
		this.rate = rate;
	}

	/**
	 * Gets the fixed tax allocation.
	 * @return the fixed tax allocation
	 */
	public String getFixedTaxAllocation() {
		return fixedTaxAllocation;
	}

	/**
	 * Sets the fixed tax allocation.
	 * @param fixedTaxAllocation the new fixed tax allocation
	 */
	public void setFixedTaxAllocation(String fixedTaxAllocation) {
		this.fixedTaxAllocation = fixedTaxAllocation;
	}

	/**
	 * Gets the item grp.
	 * @return the item grp
	 */
	public Integer getItemGrp() {
		return itemGrp;
	}

	/**
	 * Sets the item grp.
	 * @param itemGrp the new item grp
	 */
	public void setItemGrp(Integer itemGrp) {
		this.itemGrp = itemGrp;
	}

	/**
	 * Gets the tax allocation.
	 * @return the tax allocation
	 */
	public String getTaxAllocation() {
		return taxAllocation;
	}

	/**
	 * Sets the tax allocation.
	 * @param taxAllocation the new tax allocation
	 */
	public void setTaxAllocation(String taxAllocation) {
		this.taxAllocation = taxAllocation;
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
		// TODO Auto-generated method stub
	}

	/**
	 * @param requiredTaxListing the requiredTaxListing to set
	 */
	public void setRequiredTaxListing(String requiredTaxListing) {
		this.requiredTaxListing = requiredTaxListing;
	}

	/**
	 * @return the requiredTaxListing
	 */
	public String getRequiredTaxListing() {
		return requiredTaxListing;
	}

	/**
	 * @param taxDescription the taxDescription to set
	 */
	public void setTaxDescription(String taxDescription) {
		this.taxDescription = taxDescription;
	}

	/**
	 * @return the taxDescription
	 */
	public String getTaxDescription() {
		return taxDescription;
	}

	public void setPrimarySw(String primarySw) {
		this.primarySw = primarySw;
	}

	public String getPrimarySw() {
		return primarySw;
	}
}