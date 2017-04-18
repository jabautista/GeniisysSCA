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
 * The Class GIPIWPerilDiscount.
 */
public class GIPIWPerilDiscount extends BaseEntity{

	/** The par id. */
	private int parId;
	
	/** The item no. */
	private String itemNo;
	
	/** The line cd. */
	private String lineCd;
	
	/** The peril cd. */
	private String perilCd;
	
	/** The peril name. */
	private String perilName;
	
	/** The subline cd. */
	private String sublineCd;
	
	/** The discount rt. */
	private BigDecimal discountRt;
	
	/** The level tag. */
	private String levelTag;
	
	/** The discount amt. */
	private BigDecimal discountAmt;
	
	/** The discount tag. */
	private String discountTag;
	
	/** The net gross tag. */
	private String netGrossTag;
	
	/** The orig peril prem amt. */
	private BigDecimal origPerilPremAmt;
	
	/** The sequence no. */
	private String sequenceNo;
	
	/** The remarks. */
	private String remarks;
	
	/** The net prem amt. */
	private BigDecimal netPremAmt;
	
	/** The orig peril ann prem amt. */
	private BigDecimal origPerilAnnPremAmt;
	
	/** The orig item ann prem amt. */
	private BigDecimal origItemAnnPremAmt;
	
	/** The orig pol ann prem amt. */
	private BigDecimal origPolAnnPremAmt;
	
	/** The surcharge rt. */
	private BigDecimal surchargeRt;
	
	/** The surcharge amt. */
	private BigDecimal surchargeAmt;
	
	public GIPIWPerilDiscount(){
		
	}
	
	public GIPIWPerilDiscount(final int parId,final String itemNo,
			final String lineCd,final String perilCd,final String sublineCd,
			final BigDecimal discountRt, final String levelTag, final BigDecimal discountAmt,
			final String netGrossTag, final BigDecimal origPerilPremAmt, 
			final String sequenceNo, final String remarks, final BigDecimal netPremAmt,
			final BigDecimal origPerilAnnPremAmt,final BigDecimal origItemAnnPremAmt, final BigDecimal origPolAnnPremAmt,
			final BigDecimal surchargeRt, final BigDecimal surchargeAmt){
		this.parId = parId;
		this.itemNo = itemNo;
		this.lineCd = lineCd;
		this.perilCd = perilCd;
		this.sublineCd = sublineCd;
		this.discountRt = discountRt;
		this.levelTag = levelTag;
		this.discountAmt = discountAmt;
		this.netGrossTag = netGrossTag;
		this.origPerilPremAmt = origPerilPremAmt;
		this.sequenceNo = sequenceNo;
		this.remarks = remarks;
		this.netPremAmt = netPremAmt;
		this.origPerilAnnPremAmt = origPerilAnnPremAmt;
		this.origItemAnnPremAmt = origItemAnnPremAmt;
		this.origPolAnnPremAmt = origPolAnnPremAmt;
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
	 * Gets the item no.
	 * 
	 * @return the item no
	 */
	public String getItemNo() {
		return itemNo;
	}
	
	/**
	 * Sets the item no.
	 * 
	 * @param itemNo the new item no
	 */
	public void setItemNo(String itemNo) {
		this.itemNo = itemNo;
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
	 * Gets the peril cd.
	 * 
	 * @return the peril cd
	 */
	public String getPerilCd() {
		return perilCd;
	}
	
	/**
	 * Sets the peril cd.
	 * 
	 * @param perilCd the new peril cd
	 */
	public void setPerilCd(String perilCd) {
		this.perilCd = perilCd;
	}
	
	/**
	 * Gets the peril name.
	 * 
	 * @return the peril name
	 */
	public String getPerilName() {
		return perilName;
	}
	
	/**
	 * Sets the peril name.
	 * 
	 * @param perilName the new peril name
	 */
	public void setPerilName(String perilName) {
		this.perilName = perilName;
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
	 * Gets the level tag.
	 * 
	 * @return the level tag
	 */
	public String getLevelTag() {
		return levelTag;
	}
	
	/**
	 * Sets the level tag.
	 * 
	 * @param levelTag the new level tag
	 */
	public void setLevelTag(String levelTag) {
		this.levelTag = levelTag;
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
	 * Gets the discount tag.
	 * 
	 * @return the discount tag
	 */
	public String getDiscountTag() {
		return discountTag;
	}
	
	/**
	 * Sets the discount tag.
	 * 
	 * @param discountTag the new discount tag
	 */
	public void setDiscountTag(String discountTag) {
		this.discountTag = discountTag;
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
	 * Gets the orig peril prem amt.
	 * 
	 * @return the orig peril prem amt
	 */
	public BigDecimal getOrigPerilPremAmt() {
		return origPerilPremAmt;
	}
	
	/**
	 * Sets the orig peril prem amt.
	 * 
	 * @param origPerilPremAmt the new orig peril prem amt
	 */
	public void setOrigPerilPremAmt(BigDecimal origPerilPremAmt) {
		this.origPerilPremAmt = origPerilPremAmt;
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
	 * Gets the orig peril ann prem amt.
	 * 
	 * @return the orig peril ann prem amt
	 */
	public BigDecimal getOrigPerilAnnPremAmt() {
		return origPerilAnnPremAmt;
	}
	
	/**
	 * Sets the orig peril ann prem amt.
	 * 
	 * @param origPerilAnnPremAmt the new orig peril ann prem amt
	 */
	public void setOrigPerilAnnPremAmt(BigDecimal origPerilAnnPremAmt) {
		this.origPerilAnnPremAmt = origPerilAnnPremAmt;
	}
	
	/**
	 * Gets the orig item ann prem amt.
	 * 
	 * @return the orig item ann prem amt
	 */
	public BigDecimal getOrigItemAnnPremAmt() {
		return origItemAnnPremAmt;
	}
	
	/**
	 * Sets the orig item ann prem amt.
	 * 
	 * @param origItemAnnPremAmt the new orig item ann prem amt
	 */
	public void setOrigItemAnnPremAmt(BigDecimal origItemAnnPremAmt) {
		this.origItemAnnPremAmt = origItemAnnPremAmt;
	}
	
	/**
	 * Gets the orig pol ann prem amt.
	 * 
	 * @return the orig pol ann prem amt
	 */
	public BigDecimal getOrigPolAnnPremAmt() {
		return origPolAnnPremAmt;
	}
	
	/**
	 * Sets the orig pol ann prem amt.
	 * 
	 * @param origPolAnnPremAmt the new orig pol ann prem amt
	 */
	public void setOrigPolAnnPremAmt(BigDecimal origPolAnnPremAmt) {
		this.origPolAnnPremAmt = origPolAnnPremAmt;
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
