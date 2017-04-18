package com.geniisys.common.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIISBondClass extends BaseEntity {

	private String classNo;
	private String fixedFlag;
	private BigDecimal fixedAmt;
	private BigDecimal fixedRt;
	private BigDecimal minAmt;
	private String userId;
	private String remarks;

	public String getClassNo() {
		return classNo;
	}

	public void setClassNo(String classNo) {
		this.classNo = classNo;
	}

	public String getFixedFlag() {
		return fixedFlag;
	}

	public void setFixedFlag(String fixedFlag) {
		this.fixedFlag = fixedFlag;
	}

	public BigDecimal getFixedAmt() {
		return fixedAmt;
	}

	public void setFixedAmt(BigDecimal fixedAmt) {
		this.fixedAmt = fixedAmt;
	}

	public BigDecimal getFixedRt() {
		return fixedRt;
	}

	public void setFixedRt(BigDecimal fixedRt) {
		this.fixedRt = fixedRt;
	}

	public BigDecimal getMinAmt() {
		return minAmt;
	}

	public void setMinAmt(BigDecimal minAmt) {
		this.minAmt = minAmt;
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
