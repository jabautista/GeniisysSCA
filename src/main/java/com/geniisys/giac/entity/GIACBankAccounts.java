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
 * The Class GIACBank.
 */
public class GIACBankAccounts extends BaseEntity{
	
	/** The bank_cd. */
	private String bankCd;
	
	/** The bank acct cd. */
	private String bankAcctCd;
	
	/** The bank acct type. */
	private String bankAcctType;
	private String dspBankAcctType;
	
	/** The bank acct flag. */
	private String bankAcctFlag;
	private String dspBankAcctFlag;
	
	/** The opening date. */
	private Date openingDate;
	
	/** The bank acct no. */
	private String bankAcctNo;
	
	/** The bank id. */
	private Integer glBankId;
	
	/** The branch bank. */
	private String branchBank;
	
	/** The branch cd. */
	private String branchCd;
	private String dspBranchName;
	
	/** The bank name. */
	private String bankName;
	private String dspBankSname;
	private String dspBankName;
	private String strClosingDate;
	private String strOpeningDate;
	private Integer glAcctId;
	private Integer slCd;
	private String dspSlTypeName;
	private Integer dspGlAcctCategory;
	private Integer dspGlControlAcct;
	private Integer dspGlSubAcct1;
	private Integer dspGlSubAcct2;
	private Integer dspGlSubAcct3;
	private Integer dspGlSubAcct4;
	private Integer dspGlSubAcct5;
	private Integer dspGlSubAcct6;
	private Integer dspGlSubAcct7;
	private String dspGlAcctName;
	private String remarks;
	
	public Integer getDspGlAcctCategory() {
		return dspGlAcctCategory;
	}

	public void setDspGlAcctCategory(Integer dspGlAcctCategory) {
		this.dspGlAcctCategory = dspGlAcctCategory;
	}

	public Integer getDspGlControlAcct() {
		return dspGlControlAcct;
	}

	public void setDspGlControlAcct(Integer dspGlControlAcct) {
		this.dspGlControlAcct = dspGlControlAcct;
	}

	public Integer getDspGlSubAcct1() {
		return dspGlSubAcct1;
	}

	public void setDspGlSubAcct1(Integer dspGlSubAcct1) {
		this.dspGlSubAcct1 = dspGlSubAcct1;
	}

	public Integer getDspGlSubAcct2() {
		return dspGlSubAcct2;
	}

	public void setDspGlSubAcct2(Integer dspGlSubAcct2) {
		this.dspGlSubAcct2 = dspGlSubAcct2;
	}

	public Integer getDspGlSubAcct3() {
		return dspGlSubAcct3;
	}

	public void setDspGlSubAcct3(Integer dspGlSubAcct3) {
		this.dspGlSubAcct3 = dspGlSubAcct3;
	}

	public Integer getDspGlSubAcct4() {
		return dspGlSubAcct4;
	}

	public void setDspGlSubAcct4(Integer dspGlSubAcct4) {
		this.dspGlSubAcct4 = dspGlSubAcct4;
	}

	public Integer getDspGlSubAcct5() {
		return dspGlSubAcct5;
	}

	public void setDspGlSubAcct5(Integer dspGlSubAcct5) {
		this.dspGlSubAcct5 = dspGlSubAcct5;
	}

	public Integer getDspGlSubAcct6() {
		return dspGlSubAcct6;
	}

	public void setDspGlSubAcct6(Integer dspGlSubAcct6) {
		this.dspGlSubAcct6 = dspGlSubAcct6;
	}

	public Integer getDspGlSubAcct7() {
		return dspGlSubAcct7;
	}

	public void setDspGlSubAcct7(Integer dspGlSubAcct7) {
		this.dspGlSubAcct7 = dspGlSubAcct7;
	}

	public String getDspGlAcctName() {
		return dspGlAcctName;
	}

	public void setDspGlAcctName(String dspGlAcctName) {
		this.dspGlAcctName = dspGlAcctName;
	}

	//
	private String pkDummy;
	
	public GIACBankAccounts(){
		
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
	 * @return the bankAcctType
	 */
	public String getBankAcctType() {
		return bankAcctType;
	}

	/**
	 * @param bankAcctType the bankAcctType to set
	 */
	public void setBankAcctType(String bankAcctType) {
		this.bankAcctType = bankAcctType;
	}

	/**
	 * @return the bankAcctFlag
	 */
	public String getBankAcctFlag() {
		return bankAcctFlag;
	}

	/**
	 * @param bankAcctFlag the bankAcctFlag to set
	 */
	public void setBankAcctFlag(String bankAcctFlag) {
		this.bankAcctFlag = bankAcctFlag;
	}

	/**
	 * @return the openingDate
	 */
	public Date getOpeningDate() {
		return openingDate;
	}

	/**
	 * @param openingDate the openingDate to set
	 */
	public void setOpeningDate(Date openingDate) {
		this.openingDate = openingDate;
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
	 * @return the glBankId
	 */
	public Integer getGlBankId() {
		return glBankId;
	}

	/**
	 * @param glBankId the glBankId to set
	 */
	public void setGlBankId(Integer glBankId) {
		this.glBankId = glBankId;
	}

	/**
	 * @return the branchBank
	 */
	public String getBranchBank() {
		return branchBank;
	}

	/**
	 * @param branchBank the branchBank to set
	 */
	public void setBranchBank(String branchBank) {
		this.branchBank = branchBank;
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

	public void setBankName(String bankName) {
		this.bankName = bankName;
	}

	public String getBankName() {
		return bankName;
	}

	public String getPkDummy() {
		return pkDummy;
	}

	public void setPkDummy(String pkDummy) {
		this.pkDummy = pkDummy;
	}

	public String getDspBankSname() {
		return dspBankSname;
	}

	public void setDspBankSname(String dspBankSname) {
		this.dspBankSname = dspBankSname;
	}

	public String getDspBankName() {
		return dspBankName;
	}

	public void setDspBankName(String dspBankName) {
		this.dspBankName = dspBankName;
	}

	public String getStrClosingDate() {
		return strClosingDate;
	}

	public void setStrClosingDate(String strClosingDate) {
		this.strClosingDate = strClosingDate;
	}

	public String getStrOpeningDate() {
		return strOpeningDate;
	}

	public void setStrOpeningDate(String strOpeningDate) {
		this.strOpeningDate = strOpeningDate;
	}

	public Integer getGlAcctId() {
		return glAcctId;
	}

	public void setGlAcctId(Integer glAcctId) {
		this.glAcctId = glAcctId;
	}

	public Integer getSlCd() {
		return slCd;
	}

	public void setSlCd(Integer slCd) {
		this.slCd = slCd;
	}

	public String getDspSlTypeName() {
		return dspSlTypeName;
	}

	public void setDspSlTypeName(String dspSlTypeName) {
		this.dspSlTypeName = dspSlTypeName;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getDspBankAcctType() {
		return dspBankAcctType;
	}

	public void setDspBankAcctType(String dspBankAcctType) {
		this.dspBankAcctType = dspBankAcctType;
	}

	public String getDspBranchName() {
		return dspBranchName;
	}

	public void setDspBranchName(String dspBranchName) {
		this.dspBranchName = dspBranchName;
	}

	public String getDspBankAcctFlag() {
		return dspBankAcctFlag;
	}

	public void setDspBankAcctFlag(String dspBankAcctFlag) {
		this.dspBankAcctFlag = dspBankAcctFlag;
	}
		
}
