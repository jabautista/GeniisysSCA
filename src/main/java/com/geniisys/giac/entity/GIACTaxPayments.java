package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;

public class GIACTaxPayments extends BaseEntity{

	private Integer gaccTranId;
	private Integer itemNo;
	private Integer transactionType;
	private String fundCd;
	private Integer taxCd;
	private String branchCd;
	private BigDecimal taxAmt;
	private String orPrintTag;
	private String remarks;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private Integer slCd;
	private String slTypeCd;
	
	private String slName;
	private String taxName;
	private String transactionDesc;
	private String branchName;
	private String fundDesc;
	private String transaction;
	
	public Integer getGaccTranId() {
		return gaccTranId;
	}
	
	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}
	
	public Integer getItemNo() {
		return itemNo;
	}
	
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	
	public Integer getTransactionType() {
		return transactionType;
	}
	
	public void setTransactionType(Integer transactionType) {
		this.transactionType = transactionType;
	}
	
	public String getFundCd() {
		return fundCd;
	}
	
	public void setFundCd(String fundCd) {
		this.fundCd = fundCd;
	}
	
	public Integer getTaxCd() {
		return taxCd;
	}
	
	public void setTaxCd(Integer taxCd) {
		this.taxCd = taxCd;
	}
	
	public String getBranchCd() {
		return branchCd;
	}
	
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}
	
	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}
	
	public String getOrPrintTag() {
		return orPrintTag;
	}
	
	public void setOrPrintTag(String orPrintTag) {
		this.orPrintTag = orPrintTag;
	}
	
	public String getRemarks() {
		return remarks;
	}
	
	public void setRemarks(String remarks) {
		this.remarks = remarks;
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
	
	public Integer getSlCd() {
		return slCd;
	}
	
	public void setSlCd(Integer slCd) {
		this.slCd = slCd;
	}
	
	public String getSlTypeCd() {
		return slTypeCd;
	}
	
	public void setSlTypeCd(String slTypeCd) {
		this.slTypeCd = slTypeCd;
	}

	public String getSlName() {
		return slName;
	}

	public void setSlName(String slName) {
		this.slName = slName;
	}

	public String getTaxName() {
		return taxName;
	}

	public void setTaxName(String taxName) {
		this.taxName = taxName;
	}

	public String getTransactionDesc() {
		return transactionDesc;
	}

	public void setTransactionDesc(String transactionDesc) {
		this.transactionDesc = transactionDesc;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}

	public String getFundDesc() {
		return fundDesc;
	}

	public void setFundDesc(String fundDesc) {
		this.fundDesc = fundDesc;
	}

	public String getTransaction() {
		return transaction;
	}

	public void setTransaction(String transaction) {
		this.transaction = transaction;
	}
	
}
