package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACOrPref extends BaseEntity {

	private String fundCd;
	private String branchCd;
	private String branchName;
	private String orPrefSuf;
	private String orType;
	private String orTypeMean;
	private String remarks;
	
	public String getFundCd() {
		return fundCd;
	}
	public void setFundCd(String fundCd) {
		this.fundCd = fundCd;
	}
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	public String getBranchName() {
		return branchName;
	}
	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}
	public String getOrPrefSuf() {
		return orPrefSuf;
	}
	public void setOrPrefSuf(String orPrefSuf) {
		this.orPrefSuf = orPrefSuf;
	}
	public String getOrType() {
		return orType;
	}
	public void setOrType(String orType) {
		this.orType = orType;
	}
	public String getOrTypeMean() {
		return orTypeMean;
	}
	public void setOrTypeMean(String orTypeMean) {
		this.orTypeMean = orTypeMean;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	
}
