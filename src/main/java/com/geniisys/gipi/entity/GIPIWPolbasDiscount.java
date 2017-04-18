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
 * The Class GIPIWPolbasDiscount.
 */
public class GIPIWPolbasDiscount extends BaseEntity{

	/** The par id. */
	private int parId;
	
	/** The line cd. */
	private String lineCd;
	
	/** The subline cd. */
	private String sublineCd;
	
	/** The discount rt. */
	private BigDecimal discountRt;
	
	/** The discount amt. */
	private BigDecimal discountAmt;
	
	/** The net gross tag. */
	private String netGrossTag;
	
	/** The orig prem amt. */
	private BigDecimal origPremAmt;
	
	/** The sequence no. */
	private String sequenceNo;
	
	/** The remarks. */
	private String remarks;
	
	/** The net prem amt. */
	private BigDecimal netPremAmt;
	
	/** The surcharge rt. */
	private BigDecimal surchargeRt;
	
	/** The surcharge amt. */
	private BigDecimal surchargeAmt;

	
	public GIPIWPolbasDiscount() {
		
	}
	
	public GIPIWPolbasDiscount(final int parId,final String lineCd,final String sublineCd,
								final BigDecimal discountRt, final BigDecimal discountAmt,
								final String netGrossTag, final BigDecimal origPremAmt, 
								final String sequenceNo, final String remarks, final BigDecimal netPremAmt,
								final BigDecimal surchargeRt, final BigDecimal surchargeAmt){
		this.parId = parId;
		this.lineCd = lineCd;
		this.sublineCd = sublineCd;
		this.discountRt = discountRt;
		this.discountAmt = discountAmt;
		this.netGrossTag = netGrossTag;
		this.origPremAmt = origPremAmt;
		this.sequenceNo = sequenceNo;
		this.remarks = remarks;
		this.netPremAmt = netPremAmt;
		this.surchargeRt = surchargeRt;
		this.surchargeAmt = surchargeAmt;
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
	 * Gets the sequence no.
	 * 
	 * @return the sequence no
	 */
	public String getSequenceNo() {
		return sequenceNo;
	}
	
	/**
	 * Sets the sequence no.
	 * 
	 * @param sequenceNo the new sequence no
	 */
	public void setSequenceNo(String sequenceNo) {
		this.sequenceNo = sequenceNo;
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
	
}
