/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

/**
 * The Class GIACCollectionDtl.
 */
public class GIACCollectionDtl extends BaseEntity{
	
	/** The tran id. */
	private Integer gaccTranId;
	
	/** The item no. */
	private Integer itemNo;
	
	/** The currency cd. */
	private Integer currencyCd;
	
	/** The currency rate. */
	private BigDecimal currencyRt;
	
	/** The payment mode. */
	private String payMode;
	
	/** The amount. */
	private BigDecimal amt;
	
	/** The check date. */
	private Date checkDate;
	
	/** The check no. */
	private String checkNo;
	
	/** The particulars. */
	private String particulars;
	
	/** The bankCd. */
	private String bankCd;
	
	/** The check class. */
	private String checkClass;
	
	/** The f currency amount. */
	private BigDecimal fCurrencyAmt;
	
	/** The gross amount. */
	private BigDecimal grossAmt;
	
	/** The comm amount. */
	private BigDecimal commAmt;
	
	/** The vat amount. */
	private BigDecimal vatAmt;
	
	/** The fc gross amount. */
	private BigDecimal fcGrossAmt;
	
	/** The fc comm amount. */
	private BigDecimal fcCommAmt;

	/** The tax amount. */
	private BigDecimal taxAmt;

	/** The Intermediary No. */
	private Integer intmNo;

	/** The Bank Name */
	private String bankName;
	
	/** The DCB Bank Name */
	private String dcbBankName;

	/** The Currency */
	private String currency;
	
	/** The dcb bank cd. */
	private String dcbBankCd;

	/** The dcb bank acct cd. */
	private String dcbBankAcctCd;
	
	private Integer dueDcbNo;
	
	private Date dueDcbDate;
	
	private Integer cmTranId;
	
	private Integer itemId; //added by john 12.9.2014 for pdc item id
	
	private String rvMeaning; // dren 07.16.2015 : SR 0017729 - Added for GIACS035PayModeLOV
	
	public GIACCollectionDtl(){
		
	}
	
	
	
	public GIACCollectionDtl(Integer gaccTranId, Integer itemNo, Integer currencyCd, BigDecimal currencyRt, String payMode, BigDecimal amt, Date checkDate, String checkNo, String particulars, String bankCd, String checkClass, BigDecimal fCurrencyAmt, BigDecimal grossAmt, BigDecimal commAmt, BigDecimal vatAmt, BigDecimal fcGrossAmt, BigDecimal fcCommAmt, BigDecimal taxAmt, String dcbBankCd, String dcbBankAcctCd){
		this.gaccTranId = gaccTranId;
		this.itemNo = itemNo;
		this.currencyCd = currencyCd;
		this.currencyRt = currencyRt;
		this.payMode = payMode;
		this.amt = amt;
		this.checkDate = checkDate;
		this.checkNo = checkNo;
		this.particulars = particulars;
		this.bankCd = bankCd;
		this.checkClass = checkClass;
		this.fCurrencyAmt = fCurrencyAmt;
		this.grossAmt = grossAmt;
		this.commAmt = commAmt;
		this.vatAmt = vatAmt;
		this.fcGrossAmt = fcGrossAmt;
		this.fcCommAmt = fcCommAmt;
		this.taxAmt = taxAmt;
		this.dcbBankCd = dcbBankCd;
		this.dcbBankAcctCd = dcbBankAcctCd;
	}

	public GIACCollectionDtl(Integer gaccTranId, Integer itemNo, Integer currencyCd, BigDecimal currencyRt, String payMode, BigDecimal amt, Date checkDate, String checkNo, String particulars, String bankCd, String checkClass, BigDecimal fCurrencyAmt, BigDecimal grossAmt, BigDecimal commAmt, BigDecimal vatAmt, BigDecimal fcGrossAmt, BigDecimal fcCommAmt, BigDecimal taxAmt, Integer intmNo, String bankName, String dcbBankName, String currency, String dcbBankCd, String dcbBankAcctCd, String dcbBankAcctNo){
		this.gaccTranId = gaccTranId;
		this.itemNo = itemNo;
		this.currencyCd = currencyCd;
		this.currencyRt = currencyRt;
		this.payMode = payMode;
		this.amt = amt;
		this.checkDate = checkDate;
		this.checkNo = checkNo;
		this.particulars = particulars;
		this.bankCd = bankCd;
		this.checkClass = checkClass;
		this.fCurrencyAmt = fCurrencyAmt;
		this.grossAmt = grossAmt;
		this.commAmt = commAmt;
		this.vatAmt = vatAmt;
		this.fcGrossAmt = fcGrossAmt;
		this.fcCommAmt = fcCommAmt;
		this.taxAmt = taxAmt;
		this.intmNo = intmNo;
		this.bankName = bankName;
		this.dcbBankName = dcbBankName;
		this.currency = currency;
		this.dcbBankCd = dcbBankCd;
		this.dcbBankAcctCd = dcbBankAcctCd;
	}

	
	/**
	 * @return the dueDcbNo
	 */
	public Integer getDueDcbNo() {
		return dueDcbNo;
	}



	/**
	 * @param dueDcbNo the dueDcbNo to set
	 */
	public void setDueDcbNo(Integer dueDcbNo) {
		this.dueDcbNo = dueDcbNo;
	}



	/**
	 * @return the dueDcbDate
	 */
	public Date getDueDcbDate() {
		return dueDcbDate;
	}



	/**
	 * @param dueDcbDate the dueDcbDate to set
	 */
	public void setDueDcbDate(Date dueDcbDate) {
		this.dueDcbDate = dueDcbDate;
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
	 * @return the currencyCd
	 */
	public Integer getCurrencyCd() {
		return currencyCd;
	}

	/**
	 * @param currencyCd the currencyCd to set
	 */
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}

	/**
	 * @return the currencyRt
	 */
	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}

	/**
	 * @param currencyRt the currencyRt to set
	 */
	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}

	/**
	 * @return the payMode
	 */
	public String getPayMode() {
		return payMode;
	}

	/**
	 * @param payMode the payMode to set
	 */
	public void setPayMode(String payMode) {
		this.payMode = payMode;
	}

	/**
	 * @return the amt
	 */
	public BigDecimal getAmt() {
		return amt;
	}

	/**
	 * @param amt the amt to set
	 */
	public void setAmt(BigDecimal amt) {
		this.amt = amt;
	}

	/**
	 * @return the checkDate
	 */
	public Date getCheckDate() {
		return checkDate;
	}

	/**
	 * @param checkDate the checkDate to set
	 */
	public void setCheckDate(Date checkDate) {
		this.checkDate = checkDate;
	}

	/**
	 * @return the checkNo
	 */
	public String getCheckNo() {
		return checkNo;
	}

	/**
	 * @param checkNo the checkNo to set
	 */
	public void setCheckNo(String checkNo) {
		this.checkNo = checkNo;
	}

	/**
	 * @return the particulars
	 */
	public String getParticulars() {
		return particulars;
	}

	/**
	 * @param particulars the particulars to set
	 */
	public void setParticulars(String particulars) {
		this.particulars = particulars;
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
	 * @return the checkClass
	 */
	public String getCheckClass() {
		return checkClass;
	}

	/**
	 * @param checkClass the checkClass to set
	 */
	public void setCheckClass(String checkClass) {
		this.checkClass = checkClass;
	}

	/**
	 * @return the fCurrencyAmt
	 */
	public BigDecimal getfCurrencyAmt() {
		return fCurrencyAmt;
	}

	/**
	 * @param fCurrencyAmt the fCurrencyAmt to set
	 */
	public void setfCurrencyAmt(BigDecimal fCurrencyAmt) {
		this.fCurrencyAmt = fCurrencyAmt;
	}

	/**
	 * @return the grossAmt
	 */
	public BigDecimal getGrossAmt() {
		return grossAmt;
	}

	/**
	 * @param grossAmt the grossAmt to set
	 */
	public void setGrossAmt(BigDecimal grossAmt) {
		this.grossAmt = grossAmt;
	}

	/**
	 * @return the commAmt
	 */
	public BigDecimal getCommAmt() {
		return commAmt;
	}

	/**
	 * @param commAmt the commAmt to set
	 */
	public void setCommAmt(BigDecimal commAmt) {
		this.commAmt = commAmt;
	}

	/**
	 * @return the vatAmt
	 */
	public BigDecimal getVatAmt() {
		return vatAmt;
	}

	/**
	 * @param vatAmt the vatAmt to set
	 */
	public void setVatAmt(BigDecimal vatAmt) {
		this.vatAmt = vatAmt;
	}

	/**
	 * @return the fcGrossAmt
	 */
	public BigDecimal getFcGrossAmt() {
		return fcGrossAmt;
	}

	/**
	 * @param fcGrossAmt the fcGrossAmt to set
	 */
	public void setFcGrossAmt(BigDecimal fcGrossAmt) {
		this.fcGrossAmt = fcGrossAmt;
	}

	/**
	 * @return the fcCommAmt
	 */
	public BigDecimal getFcCommAmt() {
		return fcCommAmt;
	}

	/**
	 * @param fcCommAmt the fcCommAmt to set
	 */
	public void setFcCommAmt(BigDecimal fcCommAmt) {
		this.fcCommAmt = fcCommAmt;
	}

	/**
	 * @return the taxAmt
	 */
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}

	/**
	 * @param taxAmt the taxAmt to set
	 */
	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}

	public Integer getIntmNo() {
		return intmNo;
	}

	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}

	public String getBankName() {
		return bankName;
	}

	public void setBankName(String bankName) {
		this.bankName = bankName;
	}

	
	public String getDcbBankName() {
		return dcbBankName;
	}

	public void setDcbBankName(String dcbBankName) {
		this.dcbBankName = dcbBankName;
	}

	public String getCurrency() {
		return currency;
	}

	public void setCurrency(String currency) {
		this.currency = currency;
	}
	
	/**
	 * @return the dcbBankCd
	 */
	public String getDcbBankCd() {
		return dcbBankCd;
	}

	/**
	 * @param dcbBankCd the dcbBankCd to set
	 */
	public void setDcbBankCd(String dcbBankCd) {
		this.dcbBankCd = dcbBankCd;
	}

	/**
	 * @return the dcbBankAcctCd
	 */
	public String getDcbBankAcctCd() {
		return dcbBankAcctCd;
	}

	/**
	 * @param dcbBankAcctCd the dcbBankAcctCd to set
	 */
	public void setDcbBankAcctCd(String dcbBankAcctCd) {
		this.dcbBankAcctCd = dcbBankAcctCd;
	}



	public Integer getCmTranId() {
		return cmTranId;
	}



	public void setCmTranId(Integer cmTranId) {
		this.cmTranId = cmTranId;
	}



	public Integer getItemId() {
		return itemId;
	}



	public void setItemId(Integer itemId) {
		this.itemId = itemId;
	}


	public String getRvMeaning() {
		return rvMeaning;
	}
	public void setRvMeaning(String rvMeaning) {
		this.rvMeaning = rvMeaning;
	}
}
