package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPICollateral extends BaseEntity{

	public Integer collId;
	public String collType;
	public BigDecimal collVal;
	public String collDesc;
	private String remarks;
	private String userId;
	private Date lastUpdate;
	private Integer recNo;
	private String branchCd;
	private String revDate;
	

	
	public String getRevDate() {
		return revDate;
	}
	public void setRevDate(String revDate) {
		this.revDate = revDate;
	}
	public Integer getCollId() {
		return collId;
	}
	public void setCollId(Integer collId) {
		this.collId = collId;
	}
	public String getCollType() {
		return collType;
	}
	public void setCollType(String collType) {
		this.collType = collType;
	}
	public BigDecimal getCollVal() {
		return collVal;
	}
	public void setCollVal(BigDecimal collVal) {
		this.collVal = collVal;
	}
	public String getCollDesc() {
		return collDesc;
	}
	public void setCollDesc(String collDesc) {
		this.collDesc = collDesc;
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
	public Integer getRecNo() {
		return recNo;
	}
	public void setRecNo(Integer recNo) {
		this.recNo = recNo;
	}
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	
	
	
	
	

}
