package com.geniisys.common.entity;

import java.util.Date;

public class GIIScollateralDtl {
	
	private Integer collId;
	private Integer collDetailId;
	private Date revDate;
	private Date rlsDate;
	private String remarks;
	private String userId;
	private Date lastUpdate;
	private Integer recNo;
	private String branchCd;
	
	
	public Integer getCollId() {
		return collId;
	}
	public void setCollId(Integer collId) {
		this.collId = collId;
	}
	public Integer getCollDetailId() {
		return collDetailId;
	}
	public void setCollDetailId(Integer collDetailId) {
		this.collDetailId = collDetailId;
	}
	public Date getRevDate() {
		return revDate;
	}
	public void setRevDate(Date revDate) {
		this.revDate = revDate;
	}
	public Date getRlsDate() {
		return rlsDate;
	}
	public void setRlsDate(Date rlsDate) {
		this.rlsDate = rlsDate;
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
