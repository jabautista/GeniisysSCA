package com.geniisys.giac.entity;

import java.math.BigDecimal;
import com.geniisys.framework.util.BaseEntity;

public class GIACInputVat extends BaseEntity{

	private Integer gaccTranId;
	private Integer transactionType;
	private Integer payeeNo;
	private String payeeClassCd;
	private String referenceNo;
	private BigDecimal baseAmt;  
	private BigDecimal inputVatAmt;
	private Integer glAcctId;
	private Integer vatGlAcctId;
	private Integer itemNo;
	private Integer slCd;
	private String orPrintTag;
	private String remarks;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private Integer vatSlCd;
	//non base table
	private String glAcctCategory;
	private String glControlAcct;
	private String glSubAcct1;
	private String glSubAcct2;
	private String glSubAcct3;
	private String glSubAcct4;
	private String glSubAcct5;
	private String glSubAcct6;
	private String glSubAcct7;
	private String gsltSlTypeCd;
	private String glAcctName;
	private String slName;
	private String vatSlName;
	private String dspPayeeName;
	private String transactionTypeDesc;
	private String payeeClassDesc;
	private String transactionTypeAndDesc;
	private String disbAmt;
	
	public Integer getGaccTranId() {
		return gaccTranId;
	}
	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}
	public Integer getTransactionType() {
		return transactionType;
	}
	public void setTransactionType(Integer transactionType) {
		this.transactionType = transactionType;
	}
	public Integer getPayeeNo() {
		return payeeNo;
	}
	public void setPayeeNo(Integer payeeNo) {
		this.payeeNo = payeeNo;
	}
	public String getPayeeClassCd() {
		return payeeClassCd;
	}
	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
	}
	public String getReferenceNo() {
		return referenceNo;
	}
	public void setReferenceNo(String referenceNo) {
		this.referenceNo = referenceNo;
	}
	public BigDecimal getBaseAmt() {
		return baseAmt;
	}
	public void setBaseAmt(BigDecimal baseAmt) {
		this.baseAmt = baseAmt;
	}
	public BigDecimal getInputVatAmt() {
		return inputVatAmt;
	}
	public void setInputVatAmt(BigDecimal inputVatAmt) {
		this.inputVatAmt = inputVatAmt;
	}
	public Integer getGlAcctId() {
		return glAcctId;
	}
	public void setGlAcctId(Integer glAcctId) {
		this.glAcctId = glAcctId;
	}
	public Integer getVatGlAcctId() {
		return vatGlAcctId;
	}
	public void setVatGlAcctId(Integer vatGlAcctId) {
		this.vatGlAcctId = vatGlAcctId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public Integer getSlCd() {
		return slCd;
	}
	public void setSlCd(Integer slCd) {
		this.slCd = slCd;
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
	public Integer getVatSlCd() {
		return vatSlCd;
	}
	public void setVatSlCd(Integer vatSlCd) {
		this.vatSlCd = vatSlCd;
	}
	public String getGlAcctCategory() {
		return glAcctCategory;
	}
	public void setGlAcctCategory(String glAcctCategory) {
		this.glAcctCategory = glAcctCategory;
	}
	public String getGlControlAcct() {
		return glControlAcct;
	}
	public void setGlControlAcct(String glControlAcct) {
		this.glControlAcct = glControlAcct;
	}
	public String getGlSubAcct1() {
		return glSubAcct1;
	}
	public void setGlSubAcct1(String glSubAcct1) {
		this.glSubAcct1 = glSubAcct1;
	}
	public String getGlSubAcct2() {
		return glSubAcct2;
	}
	public void setGlSubAcct2(String glSubAcct2) {
		this.glSubAcct2 = glSubAcct2;
	}
	public String getGlSubAcct3() {
		return glSubAcct3;
	}
	public void setGlSubAcct3(String glSubAcct3) {
		this.glSubAcct3 = glSubAcct3;
	}
	public String getGlSubAcct4() {
		return glSubAcct4;
	}
	public void setGlSubAcct4(String glSubAcct4) {
		this.glSubAcct4 = glSubAcct4;
	}
	public String getGlSubAcct5() {
		return glSubAcct5;
	}
	public void setGlSubAcct5(String glSubAcct5) {
		this.glSubAcct5 = glSubAcct5;
	}
	public String getGlSubAcct6() {
		return glSubAcct6;
	}
	public void setGlSubAcct6(String glSubAcct6) {
		this.glSubAcct6 = glSubAcct6;
	}
	public String getGlSubAcct7() {
		return glSubAcct7;
	}
	public void setGlSubAcct7(String glSubAcct7) {
		this.glSubAcct7 = glSubAcct7;
	}
	public String getGsltSlTypeCd() {
		return gsltSlTypeCd;
	}
	public void setGsltSlTypeCd(String gsltSlTypeCd) {
		this.gsltSlTypeCd = gsltSlTypeCd;
	}
	public String getGlAcctName() {
		return glAcctName;
	}
	public void setGlAcctName(String glAcctName) {
		this.glAcctName = glAcctName;
	}
	public String getSlName() {
		return slName;
	}
	public void setSlName(String slName) {
		this.slName = slName;
	}
	public String getVatSlName() {
		return vatSlName;
	}
	public void setVatSlName(String vatSlName) {
		this.vatSlName = vatSlName;
	}
	public String getDspPayeeName() {
		return dspPayeeName;
	}
	public void setDspPayeeName(String dspPayeeName) {
		this.dspPayeeName = dspPayeeName;
	}
	public String getTransactionTypeDesc() {
		return transactionTypeDesc;
	}
	public void setTransactionTypeDesc(String transactionTypeDesc) {
		this.transactionTypeDesc = transactionTypeDesc;
	}
	public String getPayeeClassDesc() {
		return payeeClassDesc;
	}
	public void setPayeeClassDesc(String payeeClassDesc) {
		this.payeeClassDesc = payeeClassDesc;
	}
	public void setTransactionTypeAndDesc(String transactionTypeAndDesc) {
		this.transactionTypeAndDesc = transactionTypeAndDesc;
	}
	public String getTransactionTypeAndDesc() {
		return transactionTypeAndDesc;
	}
	public void setDisbAmt(String disbAmt) {
		this.disbAmt = disbAmt;
	}
	public String getDisbAmt() {
		return disbAmt;
	}
}
