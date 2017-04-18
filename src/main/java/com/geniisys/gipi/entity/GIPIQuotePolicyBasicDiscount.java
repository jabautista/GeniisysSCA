/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.seer.framework.util.Entity;


/**
 * The Class GIPIQuotePolicyBasicDiscount.
 */
@SuppressWarnings("rawtypes")
public class GIPIQuotePolicyBasicDiscount extends Entity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 3063875623832872050L;
	
	/** The quote id. */
	private int quoteId;
	
	/** The sequence no. */
	private int sequenceNo;
	
	/** The line cd. */
	private String lineCd;
	
	/** The subline cd. */
	private String sublineCd;
	
	/** The discount rt. */
	private BigDecimal discountRt;
	
	/** The discount amt. */
	private BigDecimal discountAmt;
	
	/** The surcharge rt. */
	private BigDecimal surchargeRt;
	
	/** The surcharge amt. */
	private BigDecimal surchargeAmt;
	
	/** The orig prem amt. */
	private BigDecimal origPremAmt;
	
	/** The net prem amt. */
	private BigDecimal netPremAmt;
	
	/** The net gross tag. */
	private String netGrossTag;
	
	/** The remarks. */
	private String remarks;
	
	/**
	 * Instantiates a new gIPI quote policy basic discount.
	 * 
	 * @param quoteId the quote id
	 * @param sequenceNo the sequence no
	 * @param lineCd the line cd
	 * @param sublineCd the subline cd
	 * @param discountRt the discount rt
	 * @param discountAmt the discount amt
	 * @param surchargeRt the surcharge rt
	 * @param surchargeAmt the surcharge amt
	 * @param origPremAmt the orig prem amt
	 * @param netPremAmt the net prem amt
	 * @param netGrossTag the net gross tag
	 * @param lastUpdate the last update
	 * @param remarks the remarks
	 */
	public GIPIQuotePolicyBasicDiscount(int quoteId, int sequenceNo,
			String lineCd, String sublineCd, BigDecimal discountRt,
			BigDecimal discountAmt, BigDecimal surchargeRt,
			BigDecimal surchargeAmt, BigDecimal origPremAmt,
			BigDecimal netPremAmt, String netGrossTag, Date lastUpdate,
			String remarks) {
		this();
		this.quoteId = quoteId;
		this.sequenceNo = sequenceNo;
		this.lineCd = lineCd;
		this.sublineCd = sublineCd;
		this.discountRt = discountRt;
		this.discountAmt = discountAmt;
		this.surchargeRt = surchargeRt;
		this.surchargeAmt = surchargeAmt;
		this.origPremAmt = origPremAmt;
		this.netPremAmt = netPremAmt;
		this.netGrossTag = netGrossTag;
		super.setLastUpdate(lastUpdate);
		this.remarks = remarks;
	}
	
	/**
	 * Instantiates a new gIPI quote policy basic discount.
	 */
	public GIPIQuotePolicyBasicDiscount(){
		super();
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#getId()
	 */
	@Override
	public Object getId() {
		return this.sequenceNo;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#setId(java.lang.Object)
	 */
	@Override
	public void setId(Object id) {
		this.sequenceNo = (Integer)id;		
	}

	/**
	 * Gets the quote id.
	 * 
	 * @return the quote id
	 */
	public int getQuoteId() {
		return quoteId;
	}

	/**
	 * Sets the quote id.
	 * 
	 * @param quoteId the new quote id
	 */
	public void setQuoteId(int quoteId) {
		this.quoteId = quoteId;
	}

	/**
	 * Gets the sequence no.
	 * 
	 * @return the sequence no
	 */
	public int getSequenceNo() {
		return sequenceNo;
	}

	/**
	 * Sets the sequence no.
	 * 
	 * @param sequenceNo the new sequence no
	 */
	public void setSequenceNo(int sequenceNo) {
		this.sequenceNo = sequenceNo;
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
	 * Gets the discount rt.
	 * 
	 * @return the discount rt
	 */
	public BigDecimal getDiscountRt() {
		return discountRt;
	}

	/**
	 * Sets the discount rt.
	 * 
	 * @param discountRt the new discount rt
	 */
	public void setDiscountRt(BigDecimal discountRt) {
		this.discountRt = discountRt;
	}

	/**
	 * Gets the discount amt.
	 * 
	 * @return the discount amt
	 */
	public BigDecimal getDiscountAmt() {
		return discountAmt;
	}

	/**
	 * Sets the discount amt.
	 * 
	 * @param discountAmt the new discount amt
	 */
	public void setDiscountAmt(BigDecimal discountAmt) {
		this.discountAmt = discountAmt;
	}

	/**
	 * Gets the surcharge rt.
	 * 
	 * @return the surcharge rt
	 */
	public BigDecimal getSurchargeRt() {
		return surchargeRt;
	}

	/**
	 * Sets the surcharge rt.
	 * 
	 * @param surchargeRt the new surcharge rt
	 */
	public void setSurchargeRt(BigDecimal surchargeRt) {
		this.surchargeRt = surchargeRt;
	}

	/**
	 * Gets the surcharge amt.
	 * 
	 * @return the surcharge amt
	 */
	public BigDecimal getSurchargeAmt() {
		return surchargeAmt;
	}

	/**
	 * Sets the surcharge amt.
	 * 
	 * @param surchargeAmt the new surcharge amt
	 */
	public void setSurchargeAmt(BigDecimal surchargeAmt) {
		this.surchargeAmt = surchargeAmt;
	}

	/**
	 * Gets the orig prem amt.
	 * 
	 * @return the orig prem amt
	 */
	public BigDecimal getOrigPremAmt() {
		return origPremAmt;
	}

	/**
	 * Sets the orig prem amt.
	 * 
	 * @param origPremAmt the new orig prem amt
	 */
	public void setOrigPremAmt(BigDecimal origPremAmt) {
		this.origPremAmt = origPremAmt;
	}

	/**
	 * Gets the net prem amt.
	 * 
	 * @return the net prem amt
	 */
	public BigDecimal getNetPremAmt() {
		return netPremAmt;
	}

	/**
	 * Sets the net prem amt.
	 * 
	 * @param netPremAmt the new net prem amt
	 */
	public void setNetPremAmt(BigDecimal netPremAmt) {
		this.netPremAmt = netPremAmt;
	}

	/**
	 * Gets the net gross tag.
	 * 
	 * @return the net gross tag
	 */
	public String getNetGrossTag() {
		return netGrossTag;
	}

	/**
	 * Sets the net gross tag.
	 * 
	 * @param netGrossTag the new net gross tag
	 */
	public void setNetGrossTag(String netGrossTag) {
		this.netGrossTag = netGrossTag;
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

}
