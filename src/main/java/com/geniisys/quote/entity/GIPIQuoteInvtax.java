package com.geniisys.quote.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIQuoteInvtax extends BaseEntity{
	
	private String lineCd;
	private String issCd;
	private Integer quoteInvNo;
	private Integer taxCd;
	private Integer taxId;
	private BigDecimal taxAmt;
	private BigDecimal rate;
	private String fixedTaxAllocation;
	private Integer itemGrp;
	private String taxAllocation;
	
	private String taxDesc;
	private String primarySw;
	private String perilSw;
	private String noRateTag;
	private Integer quoteId;
	
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public Integer getQuoteInvNo() {
		return quoteInvNo;
	}
	public void setQuoteInvNo(Integer quoteInvNo) {
		this.quoteInvNo = quoteInvNo;
	}
	public Integer getTaxCd() {
		return taxCd;
	}
	public void setTaxCd(Integer taxCd) {
		this.taxCd = taxCd;
	}
	public Integer getTaxId() {
		return taxId;
	}
	public void setTaxId(Integer taxId) {
		this.taxId = taxId;
	}
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}
	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}
	public BigDecimal getRate() {
		return rate;
	}
	public void setRate(BigDecimal rate) {
		this.rate = rate;
	}
	public String getFixedTaxAllocation() {
		return fixedTaxAllocation;
	}
	public void setFixedTaxAllocation(String fixedTaxAllocation) {
		this.fixedTaxAllocation = fixedTaxAllocation;
	}
	public Integer getItemGrp() {
		return itemGrp;
	}
	public void setItemGrp(Integer itemGrp) {
		this.itemGrp = itemGrp;
	}
	public String getTaxAllocation() {
		return taxAllocation;
	}
	public void setTaxAllocation(String taxAllocation) {
		this.taxAllocation = taxAllocation;
	}
	public String getTaxDesc() {
		return taxDesc;
	}
	public void setTaxDesc(String taxDesc) {
		this.taxDesc = taxDesc;
	}
	public String getPrimarySw() {
		return primarySw;
	}
	public void setPrimarySw(String primarySw) {
		this.primarySw = primarySw;
	}
	public String getPerilSw() {
		return perilSw;
	}
	public void setPerilSw(String perilSw) {
		this.perilSw = perilSw;
	}
	public String getNoRateTag() {
		return noRateTag;
	}
	public void setNoRateTag(String noRateTag) {
		this.noRateTag = noRateTag;
	}
	public Integer getQuoteId() {
		return quoteId;
	}
	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}
	
}
