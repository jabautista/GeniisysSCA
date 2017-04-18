package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIOrigInvoice extends BaseEntity{
	
	private Integer parId;
	private Integer itemGrp;
	private Integer policyId;
	private String issCd;
	private Integer premSeqNo;
	private BigDecimal premAmt;
	private BigDecimal taxAmt;
	private BigDecimal otherCharges;
	private BigDecimal amountDue;
	private String refInvNo;
	private String policyCurrency;
	private String property;
	private String insured;
	private BigDecimal riCommAmt;
	private Integer currencyCd;
	private String currencyDesc;
	private BigDecimal currencyRate;
	private String remarks;
	
	public Integer getParId() {
		return parId;
	}
	public void setParId(Integer parId) {
		this.parId = parId;
	}
	public Integer getItemGrp() {
		return itemGrp;
	}
	public void setItemGrp(Integer itemGrp) {
		this.itemGrp = itemGrp;
	}
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public Integer getPremSeqNo() {
		return premSeqNo;
	}
	public void setPremSeqNo(Integer premSeqNo) {
		this.premSeqNo = premSeqNo;
	}
	public BigDecimal getPremAmt() {
		return premAmt;
	}
	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}
	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}
	public BigDecimal getOtherCharges() {
		return otherCharges;
	}
	public void setOtherCharges(BigDecimal otherCharges) {
		this.otherCharges = otherCharges;
	}
	public BigDecimal getAmountDue() {
		return amountDue;
	}
	public void setAmountDue(BigDecimal amountDue) {
		this.amountDue = amountDue;
	}
	public String getRefInvNo() {
		return refInvNo;
	}
	public void setRefInvNo(String refInvNo) {
		this.refInvNo = refInvNo;
	}
	public String getPolicyCurrency() {
		return policyCurrency;
	}
	public void setPolicyCurrency(String policyCurrency) {
		this.policyCurrency = policyCurrency;
	}
	public String getProperty() {
		return property;
	}
	public void setProperty(String property) {
		this.property = property;
	}
	public String getInsured() {
		return insured;
	}
	public void setInsured(String insured) {
		this.insured = insured;
	}
	public BigDecimal getRiCommAmt() {
		return riCommAmt;
	}
	public void setRiCommAmt(BigDecimal riCommAmt) {
		this.riCommAmt = riCommAmt;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public String getCurrencyDesc() {
		return currencyDesc;
	}
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}
	public BigDecimal getCurrencyRate() {
		return currencyRate;
	}
	public void setCurrencyRate(BigDecimal currencyRate) {
		this.currencyRate = currencyRate;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	

}
