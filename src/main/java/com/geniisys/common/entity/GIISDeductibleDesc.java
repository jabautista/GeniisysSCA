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
 * The Class GIISDeductibleDesc.
 */
public class GIISDeductibleDesc extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 7182565711781435474L;
	
	/** The deductible title. */
	private String deductibleTitle;
	
	/** The line cd. */
	private String lineCd;
	
	/** The subline cd. */
	private String sublineCd;
	
	/** The deductible cd. */
	private String deductibleCd;
	
	/** The deductible type. */
	private String deductibleType;
	
	/** The deductible type desc. */
	private String deductibleTypeDesc;
	
	/** The deductible text. */
	private String deductibleText;
	
	/** The deductible amt. */
	private BigDecimal deductibleAmt;
	
	/** The deductible rate. */
	private BigDecimal deductibleRate;
	private BigDecimal minimumAmount;
	private BigDecimal maximumAmount;
	private String rangeSw;
		
	/** The remarks **/
	private String remarks;
	
	
	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public BigDecimal getMinimumAmount() {
		return minimumAmount;
	}

	public void setMinimumAmount(BigDecimal minimumAmount) {
		this.minimumAmount = minimumAmount;
	}

	public BigDecimal getMaximumAmount() {
		return maximumAmount;
	}

	public void setMaximumAmount(BigDecimal maximumAmount) {
		this.maximumAmount = maximumAmount;
	}

	public String getRangeSw() {
		return rangeSw;
	}

	public void setRangeSw(String rangeSw) {
		this.rangeSw = rangeSw;
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
	 * Gets the deductible cd.
	 * 
	 * @return the deductible cd
	 */
	public String getDeductibleCd() {
		return deductibleCd;
	}

	/**
	 * Sets the deductible cd.
	 * 
	 * @param deductibleCd the new deductible cd
	 */
	public void setDeductibleCd(String deductibleCd) {
		this.deductibleCd = deductibleCd;
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
	 * Gets the deductible amt.
	 * 
	 * @return the deductible amt
	 */
	public BigDecimal getDeductibleAmt() {
		return deductibleAmt;
	}

	/**
	 * Sets the deductible amt.
	 * 
	 * @param deductibleAmt the new deductible amt
	 */
	public void setDeductibleAmt(BigDecimal deductibleAmt) {
		this.deductibleAmt = deductibleAmt;
	}

	/**
	 * Sets the deductible type.
	 * 
	 * @param deductibleType the new deductible type
	 */
	public void setDeductibleType(String deductibleType) {
		this.deductibleType = deductibleType;
	}

	/**
	 * Gets the deductible type.
	 * 
	 * @return the deductible type
	 */
	public String getDeductibleType() {
		return deductibleType;
	}

	/**
	 * Sets the deductible type desc.
	 * 
	 * @param deductibleTypeDesc the new deductible type desc
	 */
	public void setDeductibleTypeDesc(String deductibleTypeDesc) {
		this.deductibleTypeDesc = deductibleTypeDesc;
	}

	/**
	 * Gets the deductible type desc.
	 * 
	 * @return the deductible type desc
	 */
	public String getDeductibleTypeDesc() {
		return deductibleTypeDesc;
	}

}
