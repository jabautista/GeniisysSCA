package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACApdcPaytDtl extends BaseEntity{

	private Integer apdcId;
	private Integer pdcId;
	private Integer itemNo;
	private String bankCd;
	private String bankName;
	private String bankSname;
	private String checkClass;
	private String checkClassDesc;
	private String checkNo;
	private Date checkDate;
	private BigDecimal checkAmt;
	private Integer currencyCd;
	private String currencyName;
	private String currencyDesc;
	private BigDecimal currencyRt;
	private BigDecimal fcurrencyAmt;
	private String particulars;
	private String payor;
	private String address1;
	private String address2;
	private String address3;
	private String tin;
	private String checkFlag;
	private String checkStatus;
	private String userId;
	private Double gaccTranId;
	private Date lastUpdate;
	private BigDecimal grossAmt;
	private BigDecimal commissionAmt;
	private BigDecimal vatAmt;
	private BigDecimal fcGrossAmt;
	private BigDecimal fcCommAmt;
	private BigDecimal fcTaxAmt;
	private Date replaceDate;
	private String payMode;
	private String intmNo;
	private String dcbNo;
	private String bankBranch;
	private String remarks;
	private String intermediary;
	private String orFlag;
	
	public GIACApdcPaytDtl() {
		
	}

	public GIACApdcPaytDtl(Integer apdcId, Integer pdcId, Integer itemNo, String bankCd,
			String bankName, String bankSname, String checkClass, String checkNo, Date checkDate,
			BigDecimal checkAmt, Integer currencyCd, BigDecimal currencyRt, String currencyName, String currencyDesc,
			BigDecimal fcurrencyAmt, String particulars, String payor,
			String address1, String address2, String address3, String tin,
			String checkFlag, String checkStatus, String userId, Double gaccTranId, Date lastUpdate,
			BigDecimal grossAmt, BigDecimal commissionAmt, BigDecimal vatAmt,
			BigDecimal fcGrossAmt, BigDecimal fcCommAmt, BigDecimal fcTaxAmt,
			Date replaceDate, String payMode, String intmNo, String dcbNo,
			String bankBranch, String remarks, String intermediary) {
		super();
		this.apdcId = apdcId;
		this.pdcId = pdcId;
		this.itemNo = itemNo;
		this.bankCd = bankCd;
		this.bankName = bankName;
		this.bankSname = bankSname;
		this.checkClass = checkClass;
		this.checkNo = checkNo;
		this.checkDate = checkDate;
		this.checkAmt = checkAmt;
		this.currencyCd = currencyCd;
		this.currencyRt = currencyRt;
		this.currencyName = currencyName;
		this.currencyDesc = currencyDesc;
		this.fcurrencyAmt = fcurrencyAmt;
		this.particulars = particulars;
		this.payor = payor;
		this.address1 = address1;
		this.address2 = address2;
		this.address3 = address3;
		this.tin = tin;
		this.checkFlag = checkFlag;
		this.checkStatus = checkStatus;
		this.userId = userId;
		this.gaccTranId = gaccTranId;
		this.lastUpdate = lastUpdate;
		this.grossAmt = grossAmt;
		this.commissionAmt = commissionAmt;
		this.vatAmt = vatAmt;
		this.fcGrossAmt = fcGrossAmt;
		this.fcCommAmt = fcCommAmt;
		this.fcTaxAmt = fcTaxAmt;
		this.replaceDate = replaceDate;
		this.payMode = payMode;
		this.intmNo = intmNo;
		this.dcbNo = dcbNo;
		this.bankBranch = bankBranch;
		this.remarks = remarks;
		this.intermediary = intermediary;
	}

	public String getIntermediary() {
		return intermediary;
	}

	public void setIntermediary(String intermediary) {
		this.intermediary = intermediary;
	}

	public String getCurrencyName() {
		return currencyName;
	}

	public void setCurrencyName(String currencyName) {
		this.currencyName = currencyName;
	}
	
	public String getCurrencyDesc() {
		return currencyDesc;
	}

	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}

	public String getCheckStatus() {
		return checkStatus;
	}

	public void setCheckStatus(String checkStatus) {
		this.checkStatus = checkStatus;
	}

	public Integer getApdcId() {
		return apdcId;
	}

	public void setApdcId(Integer apdcId) {
		this.apdcId = apdcId;
	}

	public Integer getPdcId() {
		return pdcId;
	}

	public void setPdcId(Integer pdcId) {
		this.pdcId = pdcId;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
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

	public String getBankSname() {
		return bankSname;
	}

	public void setBankSname(String bankSname) {
		this.bankSname = bankSname;
	}
	
	public String getCheckClass() {
		return checkClass;
	}

	public void setCheckClass(String checkClass) {
		this.checkClass = checkClass;
	}

	public String getCheckNo() {
		return checkNo;
	}

	public void setCheckNo(String checkNo) {
		this.checkNo = checkNo;
	}

	public Date getCheckDate() {
		return checkDate;
	}

	public void setCheckDate(Date checkDate) {
		this.checkDate = checkDate;
	}

	public BigDecimal getCheckAmt() {
		return checkAmt;
	}

	public void setCheckAmt(BigDecimal checkAmt) {
		this.checkAmt = checkAmt;
	}

	public Integer getCurrencyCd() {
		return currencyCd;
	}

	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}

	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}

	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}

	public BigDecimal getFcurrencyAmt() {
		return fcurrencyAmt;
	}

	public void setFcurrencyAmt(BigDecimal fcurrencyAmt) {
		this.fcurrencyAmt = fcurrencyAmt;
	}

	public String getParticulars() {
		return particulars;
	}

	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}

	public String getPayor() {
		return payor;
	}

	public void setPayor(String payor) {
		this.payor = payor;
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

	public String getTin() {
		return tin;
	}

	public void setTin(String tin) {
		this.tin = tin;
	}

	public String getCheckFlag() {
		return checkFlag;
	}

	public void setCheckFlag(String checkFlag) {
		this.checkFlag = checkFlag;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Double getGaccTranId() {
		return gaccTranId;
	}

	public void setGaccTranId(Double gaccTranId) {
		this.gaccTranId = gaccTranId;
	}

	public Date getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}

	public BigDecimal getGrossAmt() {
		return grossAmt;
	}

	public void setGrossAmt(BigDecimal grossAmt) {
		this.grossAmt = grossAmt;
	}

	public BigDecimal getCommissionAmt() {
		return commissionAmt;
	}

	public void setCommissionAmt(BigDecimal commissionAmt) {
		this.commissionAmt = commissionAmt;
	}

	public BigDecimal getVatAmt() {
		return vatAmt;
	}

	public void setVatAmt(BigDecimal vatAmt) {
		this.vatAmt = vatAmt;
	}

	public BigDecimal getFcGrossAmt() {
		return fcGrossAmt;
	}

	public void setFcGrossAmt(BigDecimal fcGrossAmt) {
		this.fcGrossAmt = fcGrossAmt;
	}

	public BigDecimal getFcCommAmt() {
		return fcCommAmt;
	}

	public void setFcCommAmt(BigDecimal fcCommAmt) {
		this.fcCommAmt = fcCommAmt;
	}

	public BigDecimal getFcTaxAmt() {
		return fcTaxAmt;
	}

	public void setFcTaxAmt(BigDecimal fcTaxAmt) {
		this.fcTaxAmt = fcTaxAmt;
	}

	public Date getReplaceDate() {
		return replaceDate;
	}

	public void setReplaceDate(Date replaceDate) {
		this.replaceDate = replaceDate;
	}

	public String getPayMode() {
		return payMode;
	}

	public void setPayMode(String payMode) {
		this.payMode = payMode;
	}

	public String getIntmNo() {
		return intmNo;
	}

	public void setIntmNo(String intmNo) {
		this.intmNo = intmNo;
	}

	public String getDcbNo() {
		return dcbNo;
	}

	public void setDcbNo(String dcbNo) {
		this.dcbNo = dcbNo;
	}

	public String getBankBranch() {
		return bankBranch;
	}

	public void setBankBranch(String bankBranch) {
		this.bankBranch = bankBranch;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public void setCheckClassDesc(String checkClassDesc) {
		this.checkClassDesc = checkClassDesc;
	}

	public String getCheckClassDesc() {
		return checkClassDesc;
	}

	public void setOrFlag(String orFlag) {
		this.orFlag = orFlag;
	}

	public String getOrFlag() {
		return orFlag;
	}
	
}
