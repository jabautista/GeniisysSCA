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
 * The Class GIPIQuoteDeductiblesSummary.
 * MERGE THIS CLASS WITH GIPIQuoteDeductibles.java -- they point to the same db entity
 */
@SuppressWarnings("rawtypes")
public class GIPIQuoteDeductiblesSummary extends Entity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 4066580626138409143L;
	
	/** The quote id. */
	private Integer quoteId;
	
	/** The item no. */
	private Integer itemNo;
	
	/** The peril cd. */
	private Integer perilCd;
	
	/** The peril name. */
	private String perilName;
	
	/** The ded deductible cd. */
	private String dedDeductibleCd;
	
	/** The deductible title. */
	private String deductibleTitle;
	
	/** The deductible text. */
	private String deductibleText;
	
	/** The deductible amt. */
	private BigDecimal deductibleAmt;
	
	/** The deductible rate. */
	private BigDecimal deductibleRate;	

	/** The deductible type	 */
	private String deductibleType;
	
	public GIPIQuoteDeductibles toGIPIQuoteDeductible(){
		GIPIQuoteDeductibles deds = 
			new GIPIQuoteDeductibles(this.quoteId, 
									this.itemNo, this.perilCd, 
									this.dedDeductibleCd, this.deductibleAmt, 
									this.deductibleRate, this.deductibleText, 
									this.getUserId(), new Date());
		return deds;
	}
	
	/**
	 * Gets the quote id.
	 * @return the quote id
	 */
	public Integer getQuoteId() {
		return quoteId;
	}

	/**
	 * Sets the quote id.
	 * 
	 * @param quoteId the new quote id
	 */
	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}

	/**
	 * Gets the item no.
	 * 
	 * @return the item no
	 */
	public Integer getItemNo() {
		return itemNo;
	}

	/**
	 * Sets the item no.
	 * 
	 * @param itemNo the new item no
	 */
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	/**
	 * Gets the peril cd.
	 * 
	 * @return the peril cd
	 */
	public Integer getPerilCd() {
		return perilCd;
	}

	/**
	 * Sets the peril cd.
	 * 
	 * @param perilCd the new peril cd
	 */
	public void setPerilCd(Integer perilCd) {
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

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#getId()
	 */
	@Override
	public Object getId() {
		// TODO Auto-generated method stub
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
	 * @param deductibleType the deductibleType to set
	 */
	public void setDeductibleType(String deductibleType) {
		this.deductibleType = deductibleType;
	}

	/**
	 * @return the deductibleType
	 */
	public String getDeductibleType() {
		return deductibleType;
	}

}
