package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLExpPayees extends BaseEntity{
	
	private Integer claimId;
	private String payeeClassCd;
	private String payeeClassDesc;
	private Integer adjCompanyCd;
	private String adjCompanyName;
	private Integer privAdjCd;
	private String adjName;
	private String mailAddr1;
	private String mailAddr2;
	private String mailAddr3;
	private String phoneNo;
	private Date assignDate;
	private BigDecimal clmPaid;
	private String remarks;
	
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
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
	public Integer getAdjCompanyCd() {
		return adjCompanyCd;
	}
	public void setAdjCompanyCd(Integer adjCompanyCd) {
		this.adjCompanyCd = adjCompanyCd;
	}
	public String getAdjCompanyName() {
		return adjCompanyName;
	}
	public void setAdjCompanyName(String adjCompanyName) {
		this.adjCompanyName = adjCompanyName;
	}
	public Integer getPrivAdjCd() {
		return privAdjCd;
	}
	public void setPrivAdjCd(Integer privAdjCd) {
		this.privAdjCd = privAdjCd;
	}
	public String getAdjName() {
		return adjName;
	}
	public void setAdjName(String adjName) {
		this.adjName = adjName;
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
	public Date getAssignDate() {
		return assignDate;
	}
	public void setAssignDate(Date assignDate) {
		this.assignDate = assignDate;
	}
	
	public Object getStrAssignDate() { 
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (assignDate != null) {
			return df.format(assignDate);			
		} else {
			return null;
		}
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
	 
}
