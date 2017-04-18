package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACBranch extends BaseEntity{
	
	/** The gfun Fund Code. */
	private String gfunFundCd;
	
	/** The branch Code. */
	private String branchCd;
	
	/** The acct Branch Code */
	private Integer acctBranchCd;
	
	/** The branch name. */
	private String branchName;
	
	/** The remarks. */
	private String remarks;
	
	/** The cpi record No. */
	private String cpiRecNo;
	
	/** The cpi branch Code. */
	private String cpiBranchCd;
	
	/** The prnt Branch Cd. */
	private String prntBranchCd;
	
	/** The bank_cd. */
	private String bankCd;
	
	/** The bank Acct cd. */
	private String bankAcctCd;
	
	/** The comp cd. */
	private String compCd;
	
	/** The fund Desc. */
	private String fundDesc;
	private String checkDvPrint;
	private String dspCheckDvPrint;
	private String dspBankName;	
	private String dspBankAcctNo;
	private String birPermit;
	private String branchTin;
	private String address1;
	private String address2;
	private String address3;
	private String telNo;
	
	public GIACBranch(){
		
	}

	/**
	 * Gets the gfun fund code.
	 */
	public String getGfunFundCd() {
		return gfunFundCd;
	}

	/**
	 * Sets the gfun fund code.
	 */
	public void setGfunFundCd(String gfunFundCd) {
		this.gfunFundCd = gfunFundCd;
	}
	
	/**
	 * Gets the branch cd.
	 */
	public String getBranchCd() {
		return branchCd;
	}

	/**
	 * Sets the branch cd.
	 */
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}

	/**
	 * Gets the acct branch cd.
	 */
	public Integer getAcctBranchCd() {
		return acctBranchCd;
	}

	/**
	 * Sets the Acct branch cd.
	 */
	public void setAcctBranchCd(Integer acctBranchCd) {
		this.acctBranchCd = acctBranchCd;
	}

	/**
	 * Gets the branch name.
	 */
	public String getBranchName() {
		return branchName;
	}

	/**
	 * Sets the branch name.
	 */
	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}

	/**
	 * Gets the remarks.
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * Sets the remarks.
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	/**
	 * Gets the cpi rec no.
	 */
	public String getCpiRecNo() {
		return cpiRecNo;
	}

	/**
	 * Sets the cpi rec no.
	 */
	public void setCpiRecNo(String cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	/**
	 * Gets the branch code.
	 */
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	/**
	 * Sets the cpi branch cd.
	 */
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	/**
	 * Gets the prnt branch cd.
	 */
	public String getPrntBranchCd() {
		return prntBranchCd;
	}

	/**
	 * Sets the prnt branch cd.
	 */
	public void setPrntBranchCd(String prntBranchCd) {
		this.prntBranchCd = prntBranchCd;
	}

	/**
	 * Gets the bank code.
	 */
	public String getBankCd() {
		return bankCd;
	}

	/**
	 * Sets the bank code.
	 */
	public void setBankCd(String bankCd) {
		this.bankCd = bankCd;
	}

	/**
	 * Gets the bank account code.
	 */
	public String getBankAcctCd() {
		return bankAcctCd;
	}

	/**
	 * Sets the bank acct code.
	 */
	public void setBankAcctCd(String bankAcctCd) {
		this.bankAcctCd = bankAcctCd;
	}

	/**
	 * Gets the comp code.
	 */
	public String getCompCd() {
		return compCd;
	}

	/**
	 * Sets the comp code.
	 */
	public void setCompCd(String compCd) {
		this.compCd = compCd;
	}

	/**
	 * Gets the Fund Desc.
	 */
	public String getFundDesc() {
		return fundDesc;
	}

	/**
	 * Sets thefund Desc.
	 */
	public void setFundDesc(String fundDesc) {
		this.fundDesc = fundDesc;
	}

	public String getCheckDvPrint() {
		return checkDvPrint;
	}

	public void setCheckDvPrint(String checkDvPrint) {
		this.checkDvPrint = checkDvPrint;
	}

	public String getDspBankName() {
		return dspBankName;
	}

	public void setDspBankName(String dspBankName) {
		this.dspBankName = dspBankName;
	}

	public String getDspBankAcctNo() {
		return dspBankAcctNo;
	}

	public void setDspBankAcctNo(String dspBankAcctNo) {
		this.dspBankAcctNo = dspBankAcctNo;
	}

	public String getBirPermit() {
		return birPermit;
	}

	public void setBirPermit(String birPermit) {
		this.birPermit = birPermit;
	}

	public String getBranchTin() {
		return branchTin;
	}

	public void setBranchTin(String branchTin) {
		this.branchTin = branchTin;
	}

	public String getAddress1() {
		return address1;
	}

	public void setAddress1(String address1) {
		this.address1 = address1;
	}

	public String getAddress2() {
		return address2;
	}

	public void setAddress2(String address2) {
		this.address2 = address2;
	}

	public String getAddress3() {
		return address3;
	}

	public void setAddress3(String address3) {
		this.address3 = address3;
	}

	public String getTelNo() {
		return telNo;
	}

	public void setTelNo(String telNo) {
		this.telNo = telNo;
	}

	public String getDspCheckDvPrint() {
		return dspCheckDvPrint;
	}

	public void setDspCheckDvPrint(String dspCheckDvPrint) {
		this.dspCheckDvPrint = dspCheckDvPrint;
	}
	
	
	
}
