/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Jul 14, 2011
 ***************************************************/
/**
 * 
 */
package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

/**
 * @author rencela
 */
public class GICLLossExpenseTax extends BaseEntity{
	private Integer claimId;
	private Integer clmLossId;
	private Integer taxId;
	private Integer taxCd;
	private String taxName;
	private String taxType;
	private String lossExpCd;
	private BigDecimal baseAmt; 
	private BigDecimal taxAmt; 
	private BigDecimal taxPct; 
	private String advTag; 
	private String netTag;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String withTax;
	private String slTypeCd;
	private Integer slCd;
	
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public Integer getClmLossId() {
		return clmLossId;
	}
	public void setClmLossId(Integer clmLossId) {
		this.clmLossId = clmLossId;
	}
	public Integer getTaxId() {
		return taxId;
	}
	public void setTaxId(Integer taxId) {
		this.taxId = taxId;
	}
	public Integer getTaxCd() {
		return taxCd;
	}
	public void setTaxCd(Integer taxCd) {
		this.taxCd = taxCd;
	}
	public String getTaxName() {
		return taxName;
	}
	public void setTaxName(String taxName) {
		this.taxName = taxName;
	}
	public String getTaxType() {
		return taxType;
	}
	public void setTaxType(String taxType) {
		this.taxType = taxType;
	}
	public String getLossExpCd() {
		return lossExpCd;
	}
	public void setLossExpCd(String lossExpCd) {
		this.lossExpCd = lossExpCd;
	}
	public BigDecimal getBaseAmt() {
		return baseAmt;
	}
	public void setBaseAmt(BigDecimal baseAmt) {
		this.baseAmt = baseAmt;
	}
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}
	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}
	public BigDecimal getTaxPct() {
		return taxPct;
	}
	public void setTaxPct(BigDecimal taxPct) {
		this.taxPct = taxPct;
	}
	public String getAdvTag() {
		return advTag;
	}
	public void setAdvTag(String advTag) {
		this.advTag = advTag;
	}
	public String getNetTag() {
		return netTag;
	}
	public void setNetTag(String netTag) {
		this.netTag = netTag;
	}
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	public void setWithTax(String withTax) {
		this.withTax = withTax;
	}
	public String getWithTax() {
		return withTax;
	}
	public String getSlTypeCd() {
		return slTypeCd;
	}
	public void setSlTypeCd(String slTypeCd) {
		this.slTypeCd = slTypeCd;
	}
	public Integer getSlCd() {
		return slCd;
	}
	public void setSlCd(Integer slCd) {
		this.slCd = slCd;
	}
	
	
}