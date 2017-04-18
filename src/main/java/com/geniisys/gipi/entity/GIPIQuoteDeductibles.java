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

import com.geniisys.framework.util.BaseEntity;

/**
 * The Class GIPIQuoteDeductibles.
 */
public class GIPIQuoteDeductibles extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 4066580626138409143L;

	/** The quote id. */
	private Integer quoteId;

	/** The item no. */
	private Integer itemNo;

	/** The peril cd. */
	private Integer perilCd;

	/** The ded deductible cd. */
	private String dedDeductibleCd;

	/** The deductible text. */
	private String deductibleText;

	/** The deductible amt. */
	private BigDecimal deductibleAmt;

	/** The deductible rate. */
	private BigDecimal deductibleRate;
	
	//nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles
	/** The ded line cd. */
	private String dedLineCd;
	
	/** The ded subline cd. */
	private String dedSublineCd;
	
	/** The aggregate sw. */
	private String aggregateSW;
	
	/** The ceiling sw. */
	private String ceilingSw;
	
	/** The create date. */
	private Date createDate;
	
	/** The create user. */
	private String createUser;
	
	/** The max amt. */
	private BigDecimal maxAmt;

	/** The min amt. */
	private BigDecimal minAmt;

	/** The range sw. */
	private String rangeSw;
	//nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles end
	
	/**
	 * Creates a GIPIQuoteDeductiblesSummary object copy of this object
	 * 
	 * @return
	 */
	public GIPIQuoteDeductiblesSummary toGIPIQuoteDeductiblesSummary() {
		GIPIQuoteDeductiblesSummary sum = new GIPIQuoteDeductiblesSummary();
		sum.setUserId(this.getUserId());
		sum.setQuoteId(this.getQuoteId());
		sum.setPerilCd(this.getPerilCd());
		sum.setLastUpdate(new Date());
		sum.setItemNo(this.getItemNo());
		sum.setDeductibleText(this.getDeductibleText());
		sum.setDeductibleRate(this.getDeductibleRate());
		sum.setDeductibleAmt(this.getDeductibleAmt());
		sum.setDedDeductibleCd(this.getDedDeductibleCd());
		sum.setCreateUser(this.getCreateUser());
		sum.setCreateDate(this.getCreateDate());
		return sum;
	}

	/**
	 * Gets the quote id.
	 * 
	 * @return the quote id
	 */
	public Integer getQuoteId() {
		return quoteId;
	}

	/**
	 * Sets the quote id.
	 * 
	 * @param quoteId
	 *            the new quote id
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
	 * @param itemNo
	 *            the new item no
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
	 * @param perilCd
	 *            the new peril cd
	 */
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
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
	 * @param dedDeductibleCd
	 *            the new ded deductible cd
	 */
	public void setDedDeductibleCd(String dedDeductibleCd) {
		this.dedDeductibleCd = dedDeductibleCd;
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
	 * @param deductibleText
	 *            the new deductible text
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
	 * @param deductibleAmt
	 *            the new deductible amt
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
	 * @param deductibleRate
	 *            the new deductible rate
	 */
	public void setDeductibleRate(BigDecimal deductibleRate) {
		this.deductibleRate = deductibleRate;
	}

	/**
	 * Instantiates a new gIPI quote deductibles.
	 */
	public GIPIQuoteDeductibles() {

	}

	/**
	 * Instantiates a new gIPI quote deductibles.
	 * 
	 * @param quoteId
	 *            the quote id
	 * @param itemNo
	 *            the item no
	 * @param perilCd
	 *            the peril cd
	 * @param dedDeductibleCd
	 *            the ded deductible cd
	 * @param deductibleAmt
	 *            the deductible amt
	 * @param deductibleRate
	 *            the deductible rate
	 * @param deductibleText
	 *            the deductible text
	 * @param userId
	 *            the user id
	 * @param lastUpdate
	 *            the last update
	 */
	public GIPIQuoteDeductibles(Integer quoteId, Integer itemNo,
			Integer perilCd, String dedDeductibleCd, BigDecimal deductibleAmt,
			BigDecimal deductibleRate, String deductibleText, String userId,
			Date lastUpdate) {

		this.quoteId = quoteId;
		this.itemNo = itemNo;
		this.perilCd = perilCd;
		this.dedDeductibleCd = dedDeductibleCd;
		this.deductibleAmt = deductibleAmt;
		this.deductibleRate = deductibleRate;
		this.deductibleText = deductibleText;
		super.setUserId(userId);
		super.setLastUpdate(lastUpdate);

	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getDedLineCd() {
		return dedLineCd;
	}

	public void setDedLineCd(String dedLineCd) {
		this.dedLineCd = dedLineCd;
	}

	public String getDedSublineCd() {
		return dedSublineCd;
	}

	public void setDedSublineCd(String dedSublineCd) {
		this.dedSublineCd = dedSublineCd;
	}

	public String getAggregateSW() {
		return aggregateSW;
	}

	public void setAggregateSW(String aggregateSW) {
		this.aggregateSW = aggregateSW;
	}

	public String getCeilingSw() {
		return ceilingSw;
	}

	public void setCeilingSw(String ceilingSw) {
		this.ceilingSw = ceilingSw;
	}
	
	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public BigDecimal getMaxAmt() {
		return maxAmt;
	}

	public void setMaxAmt(BigDecimal maxAmt) {
		this.maxAmt = maxAmt;
	}

	public BigDecimal getMinAmt() {
		return minAmt;
	}

	public void setMinAmt(BigDecimal minAmt) {
		this.minAmt = minAmt;
	}

	public String getRangeSw() {
		return rangeSw;
	}

	public void setRangeSw(String rangeSw) {
		this.rangeSw = rangeSw;
	}
}
