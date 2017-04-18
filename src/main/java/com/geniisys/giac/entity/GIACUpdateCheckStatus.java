package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;

public class GIACUpdateCheckStatus extends BaseEntity{
	
	private String fundCd;
	
	private String branchCd;
	
	private String bankName;
	
	private String bankAcctNo;
	
	private String bankAcctCd;
	
	private String bankCd;
	
	private Integer gaccTranId;
	
	private Integer itemNo;
	
	private String checkPrefSuf;
	
	private /*Integer*/ Long checkNo;	// changed to accommodate values larger than Integer.MAX_VALUE : shan 08.15.2014
	
	private String checkDate;
	
	private String payee;
	
	private BigDecimal amount;
	
	private String checkReleaseDate;
	
	private String clearingDate;

    private String gibrBranchCd;
	
	private String branchName;
	/**
	 * @return the fundCd
	 */
	public String getFundCd() {
		return fundCd;
	}

	/**
	 * @param fundCd the fundCd to set
	 */
	public void setFundCd(String fundCd) {
		this.fundCd = fundCd;
	}

	/**
	 * @return the branchCd
	 */
	public String getBranchCd() {
		return branchCd;
	}

	/**
	 * @param branchCd the branchCd to set
	 */
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}

	/**
	 * @return the bankName
	 */
	public String getBankName() {
		return bankName;
	}

	/**
	 * @param bankName the bankName to set
	 */
	public void setBankName(String bankName) {
		this.bankName = bankName;
	}

	/**
	 * @return the bankAcctNo
	 */
	public String getBankAcctNo() {
		return bankAcctNo;
	}

	/**
	 * @param bankAcctNo the bankAcctNo to set
	 */
	public void setBankAcctNo(String bankAcctNo) {
		this.bankAcctNo = bankAcctNo;
	}

	/**
	 * @return the bankAcctCd
	 */
	public String getBankAcctCd() {
		return bankAcctCd;
	}

	/**
	 * @param bankAcctCd the bankAcctCd to set
	 */
	public void setBankAcctCd(String bankAcctCd) {
		this.bankAcctCd = bankAcctCd;
	}

	/**
	 * @return the bankCd
	 */
	public String getBankCd() {
		return bankCd;
	}

	/**
	 * @param bankCd the bankCd to set
	 */
	public void setBankCd(String bankCd) {
		this.bankCd = bankCd;
	}

	/**
	 * @return the gaccTranId
	 */
	public Integer getGaccTranId() {
		return gaccTranId;
	}

	/**
	 * @param gaccTranId the gaccTranId to set
	 */
	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}

	/**
	 * @return the itemNo
	 */
	public Integer getItemNo() {
		return itemNo;
	}

	/**
	 * @param itemNo the itemNo to set
	 */
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	/**
	 * @return the checkPrefSuf
	 */
	public String getCheckPrefSuf() {
		return checkPrefSuf;
	}

	/**
	 * @param checkPrefSuf the checkPrefSuf to set
	 */
	public void setCheckPrefSuf(String checkPrefSuf) {
		this.checkPrefSuf = checkPrefSuf;
	}

	/**
	 * @return the checkNo
	 */
	public /*Integer*/ Long getCheckNo() {
		return checkNo;
	}

	/**
	 * @param checkNo the checkNo to set
	 */
	public void setCheckNo(/*Integer*/ Long checkNo) {
		this.checkNo = checkNo;
	}

	/**
	 * @return the checkDate
	 */
	public String getCheckDate() {
		return checkDate;
	}

	/**
	 * @param checkDate the checkDate to set
	 */
	public void setCheckDate(String checkDate) {
		this.checkDate = checkDate;
	}

	/**
	 * @return the payee
	 */
	public String getPayee() {
		return payee;
	}

	/**
	 * @param payee the payee to set
	 */
	public void setPayee(String payee) {
		this.payee = payee;
	}

	/**
	 * @return the amount
	 */
	public BigDecimal getAmount() {
		return amount;
	}

	/**
	 * @param amount the amount to set
	 */
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	/**
	 * @return the checkReleaseDate
	 */
	public String getCheckReleaseDate() {
		return checkReleaseDate;
	}

	/**
	 * @param checkReleaseDate the checkReleaseDate to set
	 */
	public void setCheckReleaseDate(String checkReleaseDate) {
		this.checkReleaseDate = checkReleaseDate;
	}

	/**
	 * @return the clearingDate
	 */
	public String getClearingDate() {
		return clearingDate;
	}

	/**
	 * @param clearingDate the clearingDate to set
	 */
	public void setClearingDate(String clearingDate) {
		this.clearingDate = clearingDate;
	}

	/**
	 * @return the gibrBranchCd
	 */
	public String getGibrBranchCd() {
		return gibrBranchCd;
	}

	/**
	 * @param gibrBranchCd the gibrBranchCd to set
	 */
	public void setGibrBranchCd(String gibrBranchCd) {
		this.gibrBranchCd = gibrBranchCd;
	}

	/**
	 * @return the branchName
	 */
	public String getBranchName() {
		return branchName;
	}

	/**
	 * @param branchName the branchName to set
	 */
	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}

}
