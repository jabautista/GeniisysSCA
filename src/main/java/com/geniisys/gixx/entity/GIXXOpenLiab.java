package com.geniisys.gixx.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIXXOpenLiab extends BaseEntity {

	private Integer extractId;
	private Integer geogCd;
	private BigDecimal limitLiability;
	private String voyLimit;
	private Integer currencyCd;
	private Float currencyRt;
	private String multiGeogTag;
	private String premTag;
	private String recFlag;
	private String withInvoiceTag;
	private Integer policyId;
	
	private String geogDesc;
	private String currencyDesc;
	
	
	public Integer getExtractId() {
		return extractId;
	}
	public void setExtractId(Integer extractId) {
		this.extractId = extractId;
	}
	public Integer getGeogCd() {
		return geogCd;
	}
	public void setGeogCd(Integer geogCd) {
		this.geogCd = geogCd;
	}
	public BigDecimal getLimitLiability() {
		return limitLiability;
	}
	public void setLimitLiability(BigDecimal limitLiability) {
		this.limitLiability = limitLiability;
	}
	public String getVoyLimit() {
		return voyLimit;
	}
	public void setVoyLimit(String voyLimit) {
		this.voyLimit = voyLimit;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public Float getCurrencyRt() {
		return currencyRt;
	}
	public void setCurrencyRt(Float currencyRt) {
		this.currencyRt = currencyRt;
	}
	public String getMultiGeogTag() {
		return multiGeogTag;
	}
	public void setMultiGeogTag(String multiGeogTag) {
		this.multiGeogTag = multiGeogTag;
	}
	public String getPremTag() {
		return premTag;
	}
	public void setPremTag(String premTag) {
		this.premTag = premTag;
	}
	public String getRecFlag() {
		return recFlag;
	}
	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}
	public String getWithInvoiceTag() {
		return withInvoiceTag;
	}
	public void setWithInvoiceTag(String withInvoiceTag) {
		this.withInvoiceTag = withInvoiceTag;
	}
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public String getGeogDesc() {
		return geogDesc;
	}
	public void setGeogDesc(String geogDesc) {
		this.geogDesc = geogDesc;
	}
	public String getCurrencyDesc() {
		return currencyDesc;
	}
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}
	
	
	
}
