package com.geniisys.common.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIISNotaryPublic extends BaseEntity {

	private Integer npNo;
	private String npName;
	private String ptrNo;
	private Date issueDate;
	private Date expiryDate;
	private String placeIssue;
	private String userId;
	private String remarks;

	public Integer getNpNo() {
		return npNo;
	}

	public void setNpNo(Integer npNo) {
		this.npNo = npNo;
	}

	public String getNpName() {
		return npName;
	}

	public void setNpName(String npName) {
		this.npName = npName;
	}

	public String getPtrNo() {
		return ptrNo;
	}

	public void setPtrNo(String ptrNo) {
		this.ptrNo = ptrNo;
	}

	public Date getIssueDate() {
		return issueDate;
	}

	public void setIssueDate(Date issueDate) {
		this.issueDate = issueDate;
	}

	public Date getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}

	public String getPlaceIssue() {
		return placeIssue;
	}

	public void setPlaceIssue(String placeIssue) {
		this.placeIssue = placeIssue;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

}
