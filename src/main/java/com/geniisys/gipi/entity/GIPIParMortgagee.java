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
 * The Class GIPIParMortgagee.
 */
public class GIPIParMortgagee extends BaseEntity {
	
	/** The par id. */
	private Integer parId;
	
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
	
	private String deleteSw; //kenneth SR 5483 05.26.2016

	/**
	 * Instantiates a new gIPI par mortgagee.
	 */
	public GIPIParMortgagee() {

	}

	/**
	 * Instantiates a new gIPI par mortgagee.
	 * 
	 * @param parId the par id
	 * @param issCd the iss cd
	 * @param itemNo the item no
	 * @param mortgCd the mortg cd
	 * @param amount the amount
	 * @param remarks the remarks
	 * @param lastUpdate the last update
	 * @param userId the user id
	 */
	public GIPIParMortgagee(final int parId, final String issCd,
			final int itemNo, final String mortgCd, final BigDecimal amount,
			final String remarks, final Date lastUpdate, final String userId) {
		this.parId = parId;
		this.issCd = issCd;
		this.itemNo = itemNo;
		this.mortgCd = mortgCd;
		this.amount = amount;
		this.remarks = remarks;
		super.setLastUpdate(lastUpdate);
		super.setUserId(userId);
	}

	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public Integer getParId() {
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
	public void setItemNo(int itemNo) {
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

	public String getDeleteSw() {
		return deleteSw;
	}

	public void setDeleteSw(String deleteSw) {
		this.deleteSw = deleteSw;
	}

}
