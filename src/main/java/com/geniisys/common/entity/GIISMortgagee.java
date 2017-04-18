package com.geniisys.common.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIISMortgagee extends BaseEntity{
	private String issCd;
	private String mortgCd;
	private String mortgName;
	private String remarks;
	private String userId;
	private Date lastUpdate;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String deleteSw;
	private Integer mortgageeId;
	private String mailAddr1;
	private String mailAddr2;
	private String mailAddr3;
	private String tin;
	private String contactPers;
	private String designation;

	
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public String getMortgCd() {
		return mortgCd;
	}
	public void setMortgCd(String mortgCd) {
		this.mortgCd = mortgCd;
	}
	public String getMortgName() {
		return mortgName;
	}
	public void setMortgName(String mortgName) {
		this.mortgName = mortgName;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public Date getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
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
	public String getDeleteSw() {
		return deleteSw;
	}
	public void setDeleteSw(String deleteSw) {
		this.deleteSw = deleteSw;
	}
	public Integer getMortgageeId() {
		return mortgageeId;
	}
	public void setMortgageeId(Integer mortgageeId) {
		this.mortgageeId = mortgageeId;
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
	public String getTin() {
		return tin;
	}
	public void setTin(String tin) {
		this.tin = tin;
	}
	public String getContactPers() {
		return contactPers;
	}
	public void setContactPers(String contactPers) {
		this.contactPers = contactPers;
	}
	public String getDesignation() {
		return designation;
	}
	public void setDesignation(String designation) {
		this.designation = designation;
	}	
}
