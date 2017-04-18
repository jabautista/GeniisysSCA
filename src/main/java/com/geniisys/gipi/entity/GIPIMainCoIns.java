package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIMainCoIns extends BaseEntity {

	private Integer parId;
	private BigDecimal premAmt;
	private BigDecimal tsiAmt;
	private Integer policyId;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String arcExtDate;

	public Integer getParId() {
		return parId;
	}

	public void setParId(Integer parId) {
		this.parId = parId;
	}

	public BigDecimal getPremAmt() {
		return premAmt;
	}

	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}

	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}

	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
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

	public String getArcExtDate() {
		return arcExtDate;
	}

	public void setArcExtDate(String arcExtDate) {
		this.arcExtDate = arcExtDate;
	}

}
