package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACPdcReplace extends BaseEntity{

	private Integer pdcId;
	private Integer itemNo;
	private String payMode;
	private String bankCd;
	private String bankSname;
	private String bankName;
	private String checkNo;
	private String checkClass;
	private String checkClassDesc;
	private Date checkDate;
	private BigDecimal amount;
	private Integer currencyCd;
	private String currencyDesc;
	private BigDecimal grossAmt;
	private BigDecimal commissionAmt;
	private BigDecimal vatAmt;
	private String refNo;
	
	public GIACPdcReplace(){
		
	}
	
	public GIACPdcReplace(Integer pdcId, Integer itemNo, String payMode,
			String bankCd, String bankSname, String checkNo, String checkClass,
			Date checkDate, BigDecimal amount, Integer currencyCd, BigDecimal grossAmt,
			BigDecimal commissionAmt, BigDecimal vatAmt, String refNo) {
		super();
		this.pdcId = pdcId;
		this.itemNo = itemNo;
		this.payMode = payMode;
		this.bankCd = bankCd;
		this.bankSname = bankSname;
		this.checkNo = checkNo;
		this.checkClass = checkClass;
		this.checkDate = checkDate;
		this.amount = amount;
		this.currencyCd = currencyCd;
		this.grossAmt = grossAmt;
		this.commissionAmt = commissionAmt;
		this.vatAmt = vatAmt;
		this.refNo = refNo;
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

	public String getPayMode() {
		return payMode;
	}

	public void setPayMode(String payMode) {
		this.payMode = payMode;
	}

	public String getBankCd() {
		return bankCd;
	}

	public void setBankCd(String bankCd) {
		this.bankCd = bankCd;
	}

	public String getBankSname() {
		return bankSname;
	}

	public void setBankSname(String bankSname) {
		this.bankSname = bankSname;
	}

	public String getCheckNo() {
		return checkNo;
	}

	public void setCheckNo(String checkNo) {
		this.checkNo = checkNo;
	}

	public String getCheckClass() {
		return checkClass;
	}

	public void setCheckClass(String checkClass) {
		this.checkClass = checkClass;
	}

	public Date getCheckDate() {
		return checkDate;
	}

	public void setCheckDate(Date checkDate) {
		this.checkDate = checkDate;
	}

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	public Integer getCurrencyCd() {
		return currencyCd;
	}

	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
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

	public String getRefNo() {
		return refNo;
	}

	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}

	public void setBankName(String bankName) {
		this.bankName = bankName;
	}

	public String getBankName() {
		return bankName;
	}

	public void setCheckClassDesc(String checkClassDesc) {
		this.checkClassDesc = checkClassDesc;
	}

	public String getCheckClassDesc() {
		return checkClassDesc;
	}

	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}

	public String getCurrencyDesc() {
		return currencyDesc;
	}
	
	
	
}
