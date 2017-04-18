package com.geniisys.giuts.entity;

import java.math.BigDecimal;
import java.util.Date;

public class GIUTSChangeInPaymentTerm {
	private String issCd; 
	private Integer premSeqNo;
	private Integer itemGrp;
	private String property;
	private String remarks;
	private BigDecimal premAmt;
	private BigDecimal taxAmt;
	private BigDecimal otherCharges;
	private BigDecimal notarialFee;
	private Date dueDate;
	private String paytTerms;
	private Date expiryDate;  
	private Integer policyId;
	private String paytTermsDesc;
	private Integer noOfPayt;
	private BigDecimal totalAmt;
	private Integer taxCd;
	private String taxAllocation;
	private String taxDescription;
	
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
	public Integer getItemGrp() {
		return itemGrp;
	}
	public void setItemGrp(Integer itemGrp) {
		this.itemGrp = itemGrp;
	}
	public String getProperty() {
		return property;
	}
	public void setProperty(String property) {
		this.property = property;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
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
	public BigDecimal getNotarialFee() {
		return notarialFee;
	}
	public void setNotarialFee(BigDecimal notarialFee) {
		this.notarialFee = notarialFee;
	}
	public Date getDueDate() {
		return dueDate;
	}
	public void setDueDate(Date dueDate) {
		this.dueDate = dueDate;
	}
	public String getPaytTerms() {
		return paytTerms;
	}
	public void setPaytTerms(String paytTerms) {
		this.paytTerms = paytTerms;
	}
	public Date getExpiryDate() {
		return expiryDate;
	}
	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public String getPaytTermsDesc() {
		return paytTermsDesc;
	}
	public void setPaytTermsDesc(String paytTermsDesc) {
		this.paytTermsDesc = paytTermsDesc;
	}
	public Integer getNoOfPayt() {
		return noOfPayt;
	}
	public void setNoOfPayt(Integer noOfPayt) {
		this.noOfPayt = noOfPayt;
	}
	public void setTotalAmt(BigDecimal totalAmt) {
		this.totalAmt = totalAmt;
	}
	public BigDecimal getTotalAmt() {
		return totalAmt;
	}
	public void setTaxAllocation(String taxAllocation) {
		this.taxAllocation = taxAllocation;
	}
	public String getTaxAllocation() {
		return taxAllocation;
	}
	public void setTaxCd(Integer taxCd) {
		this.taxCd = taxCd;
	}
	public Integer getTaxCd() {
		return taxCd;
	}
	public void setTaxDescription(String taxDescription) {
		this.taxDescription = taxDescription;
	}
	public String getTaxDescription() {
		return taxDescription;
	}
	
	
}
