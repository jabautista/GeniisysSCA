package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLLossExpBill extends BaseEntity{
	
	private Integer claimId;
	private Integer claimLossId;
	private String payeeClassCd;
	private String dspPayeeClass;
	private Integer payeeCd;
	private String dspPayee;
	private String docType;
	private String docTypeDesc;
	private String docNumber;
	private BigDecimal amount;
	private String remarks;
	private Date billDate;
	
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public Integer getClaimLossId() {
		return claimLossId;
	}
	public void setClaimLossId(Integer claimLossId) {
		this.claimLossId = claimLossId;
	}
	public String getPayeeClassCd() {
		return payeeClassCd;
	}
	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
	}
	public void setDspPayeeClass(String dspPayeeClass) {
		this.dspPayeeClass = dspPayeeClass;
	}
	public String getDspPayeeClass() {
		return dspPayeeClass;
	}
	public Integer getPayeeCd() {
		return payeeCd;
	}
	public void setPayeeCd(Integer payeeCd) {
		this.payeeCd = payeeCd;
	}
	public void setDspPayee(String dspPayee) {
		this.dspPayee = dspPayee;
	}
	public String getDspPayee() {
		return dspPayee;
	}
	public String getDocType() {
		return docType;
	}
	public void setDocType(String docType) {
		this.docType = docType;
	}
	public void setDocTypeDesc(String docTypeDesc) {
		this.docTypeDesc = docTypeDesc;
	}
	public String getDocTypeDesc() {
		return docTypeDesc;
	}
	public String getDocNumber() {
		return docNumber;
	}
	public void setDocNumber(String docNumber) {
		this.docNumber = docNumber;
	}
	public BigDecimal getAmount() {
		return amount;
	}
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public Date getBillDate() {
		return billDate;
	}
	public void setBillDate(Date billDate) {
		this.billDate = billDate;
	}
	
	
}
