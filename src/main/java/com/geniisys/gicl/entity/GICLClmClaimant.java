package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLClmClaimant extends BaseEntity{
	private Integer	claimId;
	private Integer clmntNo;
	private Integer clmClmntNo;
	private String payeeClassCd;
	private String payeeClassDesc;
	private String payee;
	private String mailAddr1;
	private String mailAddr2;
	private String mailAddr3;
	private String phoneNo;
	private String faxNo;
	private BigDecimal clmPaid;
	private String remarks;
	private Integer mcPayeeCd;
	private String mcPayeeName;
	
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public Integer getClmntNo() {
		return clmntNo;
	}
	public void setClmntNo(Integer clmntNo) {
		this.clmntNo = clmntNo;
	}
	public Integer getClmClmntNo() {
		return clmClmntNo;
	}
	public void setClmClmntNo(Integer clmClmntNo) {
		this.clmClmntNo = clmClmntNo;
	}
	public String getPayeeClassCd() {
		return payeeClassCd;
	}
	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
	}
	public String getPayeeClassDesc() {
		return payeeClassDesc;
	}
	public void setPayeeClassDesc(String payeeClassDesc) {
		this.payeeClassDesc = payeeClassDesc;
	}
	public String getPayee() {
		return payee;
	}
	public void setPayee(String payee) {
		this.payee = payee;
	}
	public String getMailAddr1() {
		return mailAddr1;
	}
	public void setMailAddr1(String mailAddr1) {
		this.mailAddr1 = mailAddr1;
	}
	public String getMailAddr2() {
		return mailAddr2;
	}
	public void setMailAddr2(String mailAddr2) {
		this.mailAddr2 = mailAddr2;
	}
	public String getMailAddr3() {
		return mailAddr3;
	}
	public void setMailAddr3(String mailAddr3) {
		this.mailAddr3 = mailAddr3;
	}
	public String getPhoneNo() {
		return phoneNo;
	}
	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}
	public String getFaxNo() {
		return faxNo;
	}
	public void setFaxNo(String faxNo) {
		this.faxNo = faxNo;
	}
	public BigDecimal getClmPaid() {
		return clmPaid;
	}
	public void setClmPaid(BigDecimal clmPaid) {
		this.clmPaid = clmPaid;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public Integer getMcPayeeCd() {
		return mcPayeeCd;
	}
	public void setMcPayeeCd(Integer mcPayeeCd) {
		this.mcPayeeCd = mcPayeeCd;
	}
	public String getMcPayeeName() {
		return mcPayeeName;
	}
	public void setMcPayeeName(String mcPayeeName) {
		this.mcPayeeName = mcPayeeName;
	}
 
}
