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
 * The Class GIACOrderOfPayment
 */
public class GIACOrderOfPayment extends BaseEntity{

	/** The GACC Tran ID. */
	private Integer gaccTranId;
	
	/** The GIBR Gfun fund Code. */
	private String gibrGfunFundCd;
	
	/** The GIBR Branch Code. */
	private String gibrBranchCd;
	
	/** The payor. */
	private String payor;
	
	/** The DCB No. */
	private Integer dcbNo;
	
	/** The Cashier Code. */
	private Integer cashierCd;
	
	/** The OR Pref Suf. */
	private String orPrefSuf;
	
	/** The OR No. */
	private Long orNo;
	
	/** The Remit Date. */
	private Date remitDate;
	
	/** The OR Flag. */
	private String orFlag;
	
	/** The Prov Receipt No. */
	private String provReceiptNo;
	
	/** The particulars. */
	private String particulars;
	
	/** The Intm No. */
	private Integer intmNo;
	
	/** The Fund Desc. */
	private String fundDesc;
	
	/** The Branch Name. */
	private String branchName;
	
	/** The Address 1. */
	private String address1;
	
	/** The Address 2. */
	private String address2;
	
	/** The Address 3. */
	private String address3;
	
	/** The OR Date. */
	private Date orDate;
	
	/** The Gross Amt. */
	private BigDecimal grossAmt;
	
	/** The Currency Cd. */
	private Integer currencyCd;
	
	/** The Gross Tag. */
	private String grossTag;

	/** The Upload Tag. */
	private String uploadTag;
	
	/** The Collection Amt. */
	private BigDecimal collectionAmt;
	
	/** The OR Tag. */
	private String orTag;

	/** The Tran No. */
	private String transactionNo;

	/** The OP No. */
	private Integer opNo;

	/** The OP Date */
	private Date opDate;

	/** The OP Flag */
	private String opFlag;
	
	/** The OP Tag */
	private String opTag;

	/** The currency short name */
	
	//private String currencyShortName;
	
	/** The default currency short name */
	
	//private String defaultCurrencyName;	
	
	/** The TIN No. */
	private String tinNo;

	/** The Cancel Date */
	private Date cancelDate;

	/** The Cancel DCB No. */
	private Integer cancelDcbNo;

	/** The OR Cancel Tag */
	private String orCancelTag;

	/** The With PDC */
	private String withPdc;
	
	private String riCommTag;
	
	
	public GIACOrderOfPayment(){
		
	}

	
	public GIACOrderOfPayment(Integer gaccTranId, String gibrGfunFundCd, String gibrBranchCd, String payor, String address1, String address2, String address3, String particulars, String orTag, Date orDate, Integer dcbNo, BigDecimal grossAmt, Integer cashierCd, String grossTag, BigDecimal collectionAmt, String orFlag, String opFlag, Integer currencyCd, Integer intmNo, String tinNo, String uploadTag, Date remitDate, String provReceiptNo){
		this.gaccTranId = gaccTranId;
		this.gibrGfunFundCd = gibrGfunFundCd;
		this.gibrBranchCd = gibrBranchCd;
		this.payor = payor;
		this.address1 = address1;
		this.address2 = address2;
		this.address3 = address3;
		this.particulars = particulars;
		this.orTag = orTag;
		this.orDate = orDate;
		this.dcbNo = dcbNo;
		this.grossAmt = grossAmt;
		this.cashierCd = cashierCd;
		this.grossTag = grossTag;
		this.collectionAmt = collectionAmt;
		this.orFlag = orFlag;
		this.opFlag = opFlag;
		this.currencyCd = currencyCd;
		this.intmNo = intmNo;
		this.tinNo = tinNo;
		this.uploadTag = uploadTag;
		this.remitDate = remitDate;
		this.provReceiptNo = provReceiptNo;
	}

	public GIACOrderOfPayment(Integer gaccTranId, String gibrGfunFundCd,
			String gibrBranchCd, String payor, Integer dcbNo,
			Integer cashierCd, String orPrefSuf, Long orNo, Date remitDate,
			String orFlag, String provReceiptNo, String particulars,
			Integer intmNo, String address1, String address2, String address3,
			Date orDate, BigDecimal grossAmt, Integer currencyCd, String grossTag,
			String uploadTag, BigDecimal collectionAmt, String orTag,
			Integer opNo, Date opDate, String opFlag, String opTag, String tinNo, Date cancelDate,
			Integer cancelDcbNo, String orCancelTag, String withPdc) {
		this.gaccTranId = gaccTranId;
		this.gibrGfunFundCd = gibrGfunFundCd;
		this.gibrBranchCd = gibrBranchCd;
		this.payor = payor;
		this.address1 = address1;
		this.address2 = address2;
		this.address3 = address3;
		this.particulars = particulars;
		this.orTag = orTag;
		this.orDate = orDate;
		this.dcbNo = dcbNo;
		this.grossAmt = grossAmt;
		this.cashierCd = cashierCd;
		this.grossTag = grossTag;
		this.collectionAmt = collectionAmt;
		this.orFlag = orFlag;
		this.opFlag = opFlag;
		this.opTag = opTag;
		this.currencyCd = currencyCd;
		this.orPrefSuf = orPrefSuf;
		this.orNo = orNo;
		this.remitDate = remitDate;
		this.provReceiptNo = provReceiptNo;
		this.intmNo = intmNo;
		this.uploadTag = uploadTag;
		this.opNo = opNo;
		this.opDate = opDate;
		this.tinNo = tinNo;
		this.cancelDate = cancelDate;
		this.cancelDcbNo = cancelDcbNo;
		this.orCancelTag = orCancelTag;
		this.withPdc = withPdc;
	}
	
	public GIACOrderOfPayment(Integer gaccTranId, String gibrGfunFundCd, String gibrBranchCd, String payor, String address1, String address2, String address3, String particulars, String orTag, Date orDate, Integer dcbNo, BigDecimal grossAmt, Integer cashierCd, String grossTag, BigDecimal collectionAmt, String orFlag, String opFlag, Integer currencyCd, Integer intmNo, String tinNo, String uploadTag, Date remitDate, String provReceiptNo, Long orNo, String orPrefSuf){
		this.gaccTranId = gaccTranId;
		this.gibrGfunFundCd = gibrGfunFundCd;
		this.gibrBranchCd = gibrBranchCd;
		this.payor = payor;
		this.address1 = address1;
		this.address2 = address2;
		this.address3 = address3;
		this.particulars = particulars;
		this.orTag = orTag;
		this.orDate = orDate;
		this.dcbNo = dcbNo;
		this.grossAmt = grossAmt;
		this.cashierCd = cashierCd;
		this.grossTag = grossTag;
		this.collectionAmt = collectionAmt;
		this.orFlag = orFlag;
		this.opFlag = opFlag;
		this.currencyCd = currencyCd;
		this.intmNo = intmNo;
		this.tinNo = tinNo;
		this.uploadTag = uploadTag;
		this.remitDate = remitDate;
		this.provReceiptNo = provReceiptNo;
		this.orNo = orNo;
		this.orPrefSuf = orPrefSuf;
	}


	/**
	 * Gets the GACC Tran ID.
	 */
	public Integer getGaccTranId() {
		return gaccTranId;
	}

	/**
	 * Sets the GACC Tran ID.
	 */
	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}

	/**
	 * Gets the GIBR Gfun Fund CD.
	 */
	public String getGibrGfunFundCd() {
		return gibrGfunFundCd;
	}

	/**
	 * Sets the GIBR Gfun Fund CD.
	 */
	public void setGibrGfunFundCd(String gibrGfunFundCd) {
		this.gibrGfunFundCd = gibrGfunFundCd;
	}

	/**
	 * Gets the GIBR Branch CD.
	 */
	public String getGibrBranchCd() {
		return gibrBranchCd;
	}

	/**
	 * Sets the GIBR Branch CD.
	 */
	public void setGibrBranchCd(String gibrBranchCd) {
		this.gibrBranchCd = gibrBranchCd;
	}

	/**
	 * Gets the Payor.
	 */
	public String getPayor() {
		return payor;
	}

	/**
	 * Sets the Payor.
	 */
	public void setPayor(String payor) {
		this.payor = payor;
	}

	/**
	 * Gets the DCB No.
	 */
	public Integer getDcbNo() {
		return dcbNo;
	}

	/**
	 * Sets the DCB No.
	 */
	public void setDcbNo(Integer dcbNo) {
		this.dcbNo = dcbNo;
	}

	/**
	 * Gets the Cashier CD.
	 */
	public Integer getCashierCd() {
		return cashierCd;
	}

	/**
	 * Sets the Cashier CD.
	 */
	public void setCashierCd(Integer cashierCd) {
		this.cashierCd = cashierCd;
	}

	/**
	 * Gets the OR Pref Suf.
	 */
	public String getOrPrefSuf() {
		return orPrefSuf;
	}

	/**
	 * Sets the OR Pref Suf.
	 */
	public void setOrPrefSuf(String orPrefSuf) {
		this.orPrefSuf = orPrefSuf;
	}

	/**
	 * Gets the OR No.
	 */
	public Long getOrNo() {
		return orNo;
	}

	/**
	 * Sets the OR No.
	 */
	public void setOrNo(Long orNo) {
		this.orNo = orNo;
	}

	/**
	 * Gets the Remit Date.
	 */
	public Date getRemitDate() {
		return remitDate;
	}

	/**
	 * Sets the Remit Date.
	 */
	public void setRemitDate(Date remitDate) {
		this.remitDate = remitDate;
	}

	/**
	 * Gets the OR Flag.
	 */
	public String getOrFlag() {
		return orFlag;
	}

	/**
	 * Sets the OR Flag.
	 */
	public void setOrFlag(String orFlag) {
		this.orFlag = orFlag;
	}

	/**
	 * Gets the Prov Receipt No.
	 */
	public String getProvReceiptNo() {
		return provReceiptNo;
	}

	/**
	 * Sets the Prov Receipt No.
	 */
	public void setProvReceiptNo(String provReceiptNo) {
		this.provReceiptNo = provReceiptNo;
	}

	/**
	 * Gets the Particulars.
	 */
	public String getParticulars() {
		return particulars;
	}

	/**
	 * Sets the Particulars.
	 */
	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}

	/**
	 * Gets the Intm No.
	 */
	public Integer getIntmNo() {
		return intmNo;
	}

	/**
	 * Sets the Intm No.
	 */
	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}


	/**
	 * @return the address1
	 */
	public String getAddress1() {
		return address1;
	}

	/**
	 * @param address1 the address1 to set
	 */
	public void setAddress1(String address1) {
		this.address1 = address1;
	}

	/**
	 * @return the address2
	 */
	public String getAddress2() {
		return address2;
	}

	/**
	 * @param address2 the address2 to set
	 */
	public void setAddress2(String address2) {
		this.address2 = address2;
	}

	/**
	 * @return the address3
	 */
	public String getAddress3() {
		return address3;
	}

	/**
	 * @param address3 the address3 to set
	 */
	public void setAddress3(String address3) {
		this.address3 = address3;
	}

	/**
	 * @return the orDate
	 */
	public Date getOrDate() {
		return orDate;
	}

	/**
	 * @param orDate the orDate to set
	 */
	public void setOrDate(Date orDate) {
		this.orDate = orDate;
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
	 * @return the grossTag
	 */
	public String getGrossTag() {
		return grossTag;
	}

	/**
	 * @param grossTag the grossTag to set
	 */
	public void setGrossTag(String grossTag) {
		this.grossTag = grossTag;
	}

	/**
	 * @return the uploadTag
	 */
	public String getUploadTag() {
		return uploadTag;
	}

	/**
	 * @param uploadTag the uploadTag to set
	 */
	public void setUploadTag(String uploadTag) {
		this.uploadTag = uploadTag;
	}

	/**
	 * @return the collectionAmt
	 */
	public BigDecimal getCollectionAmt() {
		return collectionAmt;
	}

	/**
	 * @param collectionAmt the collectionAmt to set
	 */
	public void setCollectionAmt(BigDecimal collectionAmt) {
		this.collectionAmt = collectionAmt;
	}

	/**
	 * @return the orTag
	 */
	public String getOrTag() {
		return orTag;
	}

	/**
	 * @param orTag the orTag to set
	 */
	public void setOrTag(String orTag) {
		this.orTag = orTag;
	}
	
	
	public String getFundDesc() {
		return fundDesc;
	}

	public void setFundDesc(String fundDesc) {
		this.fundDesc = fundDesc;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}
	
	public String getTransactionNo() {
		return transactionNo;
	}

	public void setTransactionNo(String tranNo) {
		this.transactionNo = tranNo;
	}
	/*
	public String getCurrencyShortName() {
		return currencyShortName;
	}

	public void setCurrencyShortName(String currencyShortName) {
		this.currencyShortName = currencyShortName;
	}

	public String getDefaultCurrencyName() {
		return defaultCurrencyName;
	}

	public void setDefaultCurrencyName(String defaultCurrencyName) {
		this.defaultCurrencyName = defaultCurrencyName;
	}
*/
	public Integer getOpNo() {
		return opNo;
	}

	public void setOpNo(Integer opNo) {
		this.opNo = opNo;
	}

	public Date getOpDate() {
		return opDate;
	}

	public void setOpDate(Date opDate) {
		this.opDate = opDate;
	}

	public String getOpFlag() {
		return opFlag;
	}

	public void setOpFlag(String opFlag) {
		this.opFlag = opFlag;
	}
	
	
	public String getOpTag() {
		return opTag;
	}


	public void setOpTag(String opTag) {
		this.opTag = opTag;
	}


	public String getTinNo() {
		return tinNo;
	}


	public void setTinNo(String tinNo) {
		this.tinNo = tinNo;
	}


	public Date getCancelDate() {
		return cancelDate;
	}


	public void setCancelDate(Date cancelDate) {
		this.cancelDate = cancelDate;
	}


	public Integer getCancelDcbNo() {
		return cancelDcbNo;
	}


	public void setCancelDcbNo(Integer cancelDcbNo) {
		this.cancelDcbNo = cancelDcbNo;
	}


	public String getOrCancelTag() {
		return orCancelTag;
	}


	public void setOrCancelTag(String orCancelTag) {
		this.orCancelTag = orCancelTag;
	}


	public String getWithPdc() {
		return withPdc;
	}


	public void setWithPdc(String withPdc) {
		this.withPdc = withPdc;
	}


	public String getRiCommTag() {
		return riCommTag;
	}


	public void setRiCommTag(String riCommTag) {
		this.riCommTag = riCommTag;
	}
}
