package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIOrigInvTax extends BaseEntity{

	private Integer parId;
	private Integer itemGrp;
	private Integer taxCd;
	private String taxDesc;
	private String lineCd;
	private String taxAllocation;
	private String fixedTaxAllocation;
	private Integer policyId;
	private BigDecimal taxAmt;
	private BigDecimal shareTaxAmt;
	private Integer taxId;
	private BigDecimal rate;
	
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
	public Integer getTaxCd() {
		return taxCd;
	}
	public void setTaxCd(Integer taxCd) {
		this.taxCd = taxCd;
	}
	public String getTaxDesc() {
		return taxDesc;
	}
	public void setTaxDesc(String taxDesc) {
		this.taxDesc = taxDesc;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getTaxAllocation() {
		return taxAllocation;
	}
	public void setTaxAllocation(String taxAllocation) {
		this.taxAllocation = taxAllocation;
	}
	public String getFixedTaxAllocation() {
		return fixedTaxAllocation;
	}
	public void setFixedTaxAllocation(String fixedTaxAllocation) {
		this.fixedTaxAllocation = fixedTaxAllocation;
	}
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}
	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}
	public void setShareTaxAmt(BigDecimal shareTaxAmt) {
		this.shareTaxAmt = shareTaxAmt;
	}
	public BigDecimal getShareTaxAmt() {
		return shareTaxAmt;
	}
	public Integer getTaxId() {
		return taxId;
	}
	public void setTaxId(Integer taxId) {
		this.taxId = taxId;
	}
	public BigDecimal getRate() {
		return rate;
	}
	public void setRate(BigDecimal rate) {
		this.rate = rate;
	}
	
}
