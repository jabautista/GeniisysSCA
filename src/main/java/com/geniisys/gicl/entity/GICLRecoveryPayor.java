package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLRecoveryPayor extends BaseEntity{
	
	private Integer recoveryId;
	private Integer claimId;
	private String payorClassCd;
	private Integer payorCd;
	private BigDecimal recoveredAmt;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	//non-base
	private String classDesc;
	private String payorName;
	
	public Integer getRecoveryId() {
		return recoveryId;
	}
	public void setRecoveryId(Integer recoveryId) {
		this.recoveryId = recoveryId;
	}
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public String getPayorClassCd() {
		return payorClassCd;
	}
	public void setPayorClassCd(String payorClassCd) {
		this.payorClassCd = payorClassCd;
	}
	public Integer getPayorCd() {
		return payorCd;
	}
	public void setPayorCd(Integer payorCd) {
		this.payorCd = payorCd;
	}
	public BigDecimal getRecoveredAmt() {
		return recoveredAmt;
	}
	public void setRecoveredAmt(BigDecimal recoveredAmt) {
		this.recoveredAmt = recoveredAmt;
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
	public String getClassDesc() {
		return classDesc;
	}
	public void setClassDesc(String classDesc) {
		this.classDesc = classDesc;
	}
	public String getPayorName() {
		return payorName;
	}
	public void setPayorName(String payorName) {
		this.payorName = payorName;
	}
	
}
