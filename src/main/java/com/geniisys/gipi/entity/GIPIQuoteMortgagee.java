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
 * The Class GIPIQuoteMortgagee.
 */
public class GIPIQuoteMortgagee extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -3196813838646163774L;

	/** The quote id. */
	private Integer quoteId;
	
	/** The iss cd. */
	private String issCd;
	
	/** The item no. */
	private Integer itemNo;
	
	/** The mortg cd. */
	private String mortgCd;
	
	/** The mortg name. */
	private String mortgName;
	
	/** The amount. */
	private BigDecimal amount;
	
	/** The remarks. */
	private String remarks;
	
	/** The cpi rec no. */
	private Integer cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;

	/**
	 * Instantiates a new gIPI quote mortgagee.
	 */
	public GIPIQuoteMortgagee() {

	}

	/**
	 * Instantiates a new gIPI quote mortgagee.
	 * 
	 * @param quoteId the quote id
	 * @param issCd the iss cd
	 * @param itemNo the item no
	 * @param mortgCd the mortg cd
	 * @param amount the amount
	 * @param userId the user id
	 */
	public GIPIQuoteMortgagee(Integer quoteId, String issCd, Integer itemNo,
			String mortgCd, BigDecimal amount, String userId) {

		this.quoteId = quoteId;
		this.issCd = issCd;
		this.itemNo = itemNo;
		this.mortgCd = mortgCd;
		this.amount = amount;
		super.setUserId(userId);
		super.setLastUpdate(new Date());

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
	 * @param quoteId the new quote id
	 */
	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
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
	 * Gets the mortg cd.
	 * 
	 * @return the mortg cd
	 */
	public String getMortgCd() {
		return mortgCd;
	}

	/**
	 * Sets the mortg cd.
	 * 
	 * @param mortgCd the new mortg cd
	 */
	public void setMortgCd(String mortgCd) {
		this.mortgCd = mortgCd;
	}

	/**
	 * Gets the mortg name.
	 * 
	 * @return the mortg name
	 */
	public String getMortgName() {
		return mortgName;
	}

	/**
	 * Sets the mortg name.
	 * 
	 * @param mortgName the new mortg name
	 */
	public void setMortgName(String mortgName) {
		this.mortgName = mortgName;
	}

	/**
	 * Gets the amount.
	 * 
	 * @return the amount
	 */
	public BigDecimal getAmount() {
		return amount;
	}

	/**
	 * Sets the amount.
	 * 
	 * @param amount the new amount
	 */
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
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
	 * Gets the cpi rec no.
	 * 
	 * @return the cpi rec no
	 */
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	/**
	 * Sets the cpi rec no.
	 * 
	 * @param cpiRecNo the new cpi rec no
	 */
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	/**
	 * Gets the cpi branch cd.
	 * 
	 * @return the cpi branch cd
	 */
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	/**
	 * Sets the cpi branch cd.
	 * 
	 * @param cpiBranchCd the new cpi branch cd
	 */
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

}
