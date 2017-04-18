/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.entity;

import java.util.Date;

import com.geniisys.giis.entity.BaseEntity;


/**
 * The Class GIACDCBUser.
 */
public class GIACDCBUser extends BaseEntity{

	/** The gibr Fund Code. */
	private String gibrFundCd;

	/** The gibr Branch Code. */
	private String gibrBranchCd;

	/** The gibr Cashier Code. */
	private int cashierCd;

	/** The dcb user id. */
	private String dcbUserId;

	private String validTag;

	private Date effectivityDt;

	private Date expiryDt;
	
	//added by shan 12.06.2013
	private String dcbUserName;
	private String printName;
	private String bankCd;
	private String bankName;
	private String bankAcctCd;
	private String bankAcctNo;
	private String remarks;

	public GIACDCBUser() {

	}

	/**
	 * @return the gibrFundCd
	 */
	public String getGibrFundCd() {
		return gibrFundCd;
	}

	/**
	 * @param gibrFundCd
	 *            the gibrFundCd to set
	 */
	public void setGibrFundCd(String gibrFundCd) {
		this.gibrFundCd = gibrFundCd;
	}

	/**
	 * @return the gibrBranchCd
	 */
	public String getGibrBranchCd() {
		return gibrBranchCd;
	}

	/**
	 * @param gibrBranchCd
	 *            the gibrBranchCd to set
	 */
	public void setGibrBranchCd(String gibrBranchCd) {
		this.gibrBranchCd = gibrBranchCd;
	}

	/**
	 * @return the cashierCd
	 */
	public int getCashierCd() {
		return cashierCd;
	}

	/**
	 * @param cashierCd
	 *            the cashierCd to set
	 */
	public void setCashierCd(int cashierCd) {
		this.cashierCd = cashierCd;
	}

	/**
	 * @return the dcbUserId
	 */
	public String getDcbUserId() {
		return dcbUserId;
	}

	/**
	 * @param dcbUserId
	 *            the dcbUserId to set
	 */
	public void setDcbUserId(String dcbUserId) {
		this.dcbUserId = dcbUserId;
	}

	public String getValidTag() {
		return validTag;
	}

	public void setValidTag(String validTag) {
		this.validTag = validTag;
	}

	public Date getEffectivityDt() {
		return effectivityDt;
	}

	public void setEffectivityDt(Date effectivityDt) {
		this.effectivityDt = effectivityDt;
	}

	public Date getExpiryDt() {
		return expiryDt;
	}

	public void setExpiryDt(Date expiryDt) {
		this.expiryDt = expiryDt;
	}

	public String getDcbUserName() {
		return dcbUserName;
	}

	public void setDcbUserName(String dcbUserName) {
		this.dcbUserName = dcbUserName;
	}

	public String getPrintName() {
		return printName;
	}

	public void setPrintName(String printName) {
		this.printName = printName;
	}

	public String getBankCd() {
		return bankCd;
	}

	public void setBankCd(String bankCd) {
		this.bankCd = bankCd;
	}

	public String getBankName() {
		return bankName;
	}

	public void setBankName(String bankName) {
		this.bankName = bankName;
	}

	public String getBankAcctCd() {
		return bankAcctCd;
	}

	public void setBankAcctCd(String bankAcctCd) {
		this.bankAcctCd = bankAcctCd;
	}

	public String getBankAcctNo() {
		return bankAcctNo;
	}

	public void setBankAcctNo(String bankAcctNo) {
		this.bankAcctNo = bankAcctNo;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
}
