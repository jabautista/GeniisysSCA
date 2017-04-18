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
 * The Class GIPIWDeductible.
 */
public class GIPIWDeductible extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -6624220824528032028L;
	
	/** The par id. */
	private int parId;
	
	/** The item no. */
	private int itemNo;
	
	/** The peril cd. */
	private int perilCd;
	
	/** The peril name. */
	private String perilName;
	
	/** The ded line cd. */
	private String dedLineCd;
	
	/** The ded subline cd. */
	private String dedSublineCd;
	
	/** The aggregate sw. */
	private String aggregateSw;
	
	/** The ceiling sw. */
	private String ceilingSw;
	
	/** The ded deductible cd. */
	private String dedDeductibleCd;
	
	/** The deductible title. */
	private String deductibleTitle;
	
	/** The deductible amount. */
	private BigDecimal deductibleAmount;
	
	/** The deductible rate. */
	private BigDecimal deductibleRate;
	
	/** The deductible text. */
	private String deductibleText;
	
	/** The minimum amount. */
	private BigDecimal minimumAmount;
	
	/** The maximum amount. */
	private BigDecimal maximumAmount;
	
	/** The range sw. */
	private String rangeSw;
	private String deductibleType;
	
	private BigDecimal totalDeductible;  //added by steven 8.17.2012
	/**
	 * Instantiates a new gIPIW deductible.
	 */
	public GIPIWDeductible() {
	}

	/**
	 * Instantiates a new gIPIW deductible.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @param perilCd the peril cd
	 * @param perilName the peril name
	 * @param dedLineCd the ded line cd
	 * @param dedSublineCd the ded subline cd
	 * @param aggregateSw the aggregate sw
	 * @param ceilingSw the ceiling sw
	 * @param dedDeductibleCd the ded deductible cd
	 * @param deductibleTitle the deductible title
	 * @param deductibleAmount the deductible amount
	 * @param deductibleRate the deductible rate
	 * @param deductibleText the deductible text
	 * @param minimumAmount the minimum amount
	 * @param maximumAmount the maximum amount
	 * @param rangeSw the range sw
	 */
	public GIPIWDeductible(int parId, int itemNo, int perilCd, String perilName,
			String dedLineCd, String dedSublineCd, String aggregateSw,
			String ceilingSw, String dedDeductibleCd, String deductibleTitle,
			BigDecimal deductibleAmount, BigDecimal deductibleRate,
			String deductibleText, BigDecimal minimumAmount,
			BigDecimal maximumAmount, String rangeSw) {
		this.parId = parId;
		this.itemNo = itemNo;
		this.perilCd = perilCd;
		this.perilName = perilName;
		this.dedLineCd = dedLineCd;
		this.dedSublineCd = dedSublineCd;
		this.aggregateSw = aggregateSw;
		this.ceilingSw = ceilingSw;
		this.dedDeductibleCd = dedDeductibleCd;
		this.deductibleTitle = deductibleTitle;
		this.deductibleAmount = deductibleAmount;
		this.deductibleRate = deductibleRate;
		this.deductibleText = deductibleText;
		this.minimumAmount = minimumAmount;
		this.maximumAmount = maximumAmount;
		this.rangeSw = rangeSw;
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
	public int getItemNo() {
		return itemNo;
	}

	/**
	 * Sets the item no.
	 * 
	 * @param itemNo the new item no
	 */
	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}

	/**
	 * Gets the peril cd.
	 * 
	 * @return the peril cd
	 */
	public int getPerilCd() {
		return perilCd;
	}

	/**
	 * Sets the peril cd.
	 * 
	 * @param perilCd the new peril cd
	 */
	public void setPerilCd(int perilCd) {
		this.perilCd = perilCd;
	}

	/**
	 * Gets the ded line cd.
	 * 
	 * @return the ded line cd
	 */
	public String getDedLineCd() {
		return dedLineCd;
	}

	/**
	 * Sets the ded line cd.
	 * 
	 * @param dedLineCd the new ded line cd
	 */
	public void setDedLineCd(String dedLineCd) {
		this.dedLineCd = dedLineCd;
	}

	/**
	 * Gets the ded subline cd.
	 * 
	 * @return the ded subline cd
	 */
	public String getDedSublineCd() {
		return dedSublineCd;
	}

	/**
	 * Sets the ded subline cd.
	 * 
	 * @param dedSublineCd the new ded subline cd
	 */
	public void setDedSublineCd(String dedSublineCd) {
		this.dedSublineCd = dedSublineCd;
	}

	/**
	 * Gets the aggregate sw.
	 * 
	 * @return the aggregate sw
	 */
	public String getAggregateSw() {
		return aggregateSw;
	}

	/**
	 * Sets the aggregate sw.
	 * 
	 * @param aggregateSw the new aggregate sw
	 */
	public void setAggregateSw(String aggregateSw) {
		this.aggregateSw = aggregateSw;
	}

	/**
	 * Gets the ceiling sw.
	 * 
	 * @return the ceiling sw
	 */
	public String getCeilingSw() {
		return ceilingSw;
	}

	/**
	 * Sets the ceiling sw.
	 * 
	 * @param ceilingSw the new ceiling sw
	 */
	public void setCeilingSw(String ceilingSw) {
		this.ceilingSw = ceilingSw;
	}

	/**
	 * Gets the ded deductible cd.
	 * 
	 * @return the ded deductible cd
	 */
	public String getDedDeductibleCd() {
		return dedDeductibleCd;
	}

	/**
	 * Sets the ded deductible cd.
	 * 
	 * @param dedDeductibleCd the new ded deductible cd
	 */
	public void setDedDeductibleCd(String dedDeductibleCd) {
		this.dedDeductibleCd = dedDeductibleCd;
	}

	/**
	 * Gets the deductible title.
	 * 
	 * @return the deductible title
	 */
	public String getDeductibleTitle() {
		return deductibleTitle;
	}

	/**
	 * Sets the deductible title.
	 * 
	 * @param deductibleTitle the new deductible title
	 */
	public void setDeductibleTitle(String deductibleTitle) {
		this.deductibleTitle = deductibleTitle;
	}

	/**
	 * Gets the deductible amount.
	 * 
	 * @return the deductible amount
	 */
	public BigDecimal getDeductibleAmount() {
		return deductibleAmount;
	}

	/**
	 * Sets the deductible amount.
	 * 
	 * @param deductibleAmount the new deductible amount
	 */
	public void setDeductibleAmount(BigDecimal deductibleAmount) {
		this.deductibleAmount = deductibleAmount;
	}

	/**
	 * Gets the deductible rate.
	 * 
	 * @return the deductible rate
	 */
	public BigDecimal getDeductibleRate() {
		return deductibleRate;
	}

	/**
	 * Sets the deductible rate.
	 * 
	 * @param deductibleRate the new deductible rate
	 */
	public void setDeductibleRate(BigDecimal deductibleRate) {
		this.deductibleRate = deductibleRate;
	}

	/**
	 * Gets the deductible text.
	 * 
	 * @return the deductible text
	 */
	public String getDeductibleText() {
		return deductibleText;
	}

	/**
	 * Sets the deductible text.
	 * 
	 * @param deductibleText the new deductible text
	 */
	public void setDeductibleText(String deductibleText) {
		this.deductibleText = deductibleText;
	}

	/**
	 * Gets the minimum amount.
	 * 
	 * @return the minimum amount
	 */
	public BigDecimal getMinimumAmount() {
		return minimumAmount;
	}

	/**
	 * Sets the minimum amount.
	 * 
	 * @param minimumAmount the new minimum amount
	 */
	public void setMinimumAmount(BigDecimal minimumAmount) {
		this.minimumAmount = minimumAmount;
	}

	/**
	 * Gets the maximum amount.
	 * 
	 * @return the maximum amount
	 */
	public BigDecimal getMaximumAmount() {
		return maximumAmount;
	}

	/**
	 * Sets the maximum amount.
	 * 
	 * @param maximumAmount the new maximum amount
	 */
	public void setMaximumAmount(BigDecimal maximumAmount) {
		this.maximumAmount = maximumAmount;
	}

	/**
	 * Gets the range sw.
	 * 
	 * @return the range sw
	 */
	public String getRangeSw() {
		return rangeSw;
	}

	/**
	 * Sets the range sw.
	 * 
	 * @param rangeSw the new range sw
	 */
	public void setRangeSw(String rangeSw) {
		this.rangeSw = rangeSw;
	}

	/**
	 * Gets the serialversionuid.
	 * 
	 * @return the serialversionuid
	 */
	public static long getSerialversionuid() {
		return serialVersionUID;
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
	 * Gets the peril name.
	 * 
	 * @return the peril name
	 */
	public String getPerilName() {
		return perilName;
	}

	public void setDeductibleType(String deductibleType) {
		this.deductibleType = deductibleType;
	}

	public String getDeductibleType() {
		return deductibleType;
	}

	/**
	 * @return the totalDeductible
	 */
	public BigDecimal getTotalDeductible() {
		return totalDeductible;
	}

	/**
	 * @param totalDeductible the totalDeductible to set
	 */
	public void setTotalDeductible(BigDecimal totalDeductible) {
		this.totalDeductible = totalDeductible;
	}
	
	
}
