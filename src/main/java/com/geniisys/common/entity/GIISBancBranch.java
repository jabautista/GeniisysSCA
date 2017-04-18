package com.geniisys.common.entity;

import java.util.Date;

import com.geniisys.giis.entity.BaseEntity;

public class GIISBancBranch extends BaseEntity{

	private String branchCd;
	private String branchDesc;
	private String areaCd;
	private Date effDate;
	private String remarks;
	private String managerCd;
	private String bankAcctCd;
	private Date mgrEffDate;
	private String dspManagerName;
	
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	public String getBranchDesc() {
		return branchDesc;
	}
	public void setBranchDesc(String branchDesc) {
		this.branchDesc = branchDesc;
	}
	public String getAreaCd() {
		return areaCd;
	}
	public void setAreaCd(String areaCd) {
		this.areaCd = areaCd;
	}
	public Date getEffDate() {
		return effDate;
	}
	public void setEffDate(Date effDate) {
		this.effDate = effDate;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getManagerCd() {
		return managerCd;
	}
	public void setManagerCd(String managerCd) {
		this.managerCd = managerCd;
	}
	public String getBankAcctCd() {
		return bankAcctCd;
	}
	public void setBankAcctCd(String bankAcctCd) {
		this.bankAcctCd = bankAcctCd;
	}
	public Date getMgrEffDate() {
		return mgrEffDate;
	}
	public void setMgrEffDate(Date mgrEffDate) {
		this.mgrEffDate = mgrEffDate;
	}
	public String getDspManagerName() {
		return dspManagerName;
	}
	public void setDspManagerName(String dspManagerName) {
		this.dspManagerName = dspManagerName;
	}
	
}
