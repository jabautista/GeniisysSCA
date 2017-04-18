package com.geniisys.common.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIISBondClassSubline extends BaseEntity {
	private String classNo;
	private String lineCd;
	private String sublineCd;
	private String clauseType;
	private BigDecimal waiverLimit;
	private String userId;
	private String remarks;

	public String getClassNo() {
		return classNo;
	}

	public void setClassNo(String classNo) {
		this.classNo = classNo;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getSublineCd() {
		return sublineCd;
	}

	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	public String getClauseType() {
		return clauseType;
	}

	public void setClauseType(String clauseType) {
		this.clauseType = clauseType;
	}

	public BigDecimal getWaiverLimit() {
		return waiverLimit;
	}

	public void setWaiverLimit(BigDecimal waiverLimit) {
		this.waiverLimit = waiverLimit;
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
