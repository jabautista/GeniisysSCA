package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLRecoveryPayt extends BaseEntity {

	private Integer recoveryId;
	private Integer recoveryPaytId;
	private Integer claimId;
	private String payorClassCd;
	private Integer payorCd;
	private BigDecimal recoveredAmt;
	private Integer acctTranId;
	private Date tranDate;
	private String cancelTag;
	private Date cancelDate;
	private String entryTag;
	private String distSw;
	private Integer acctTranId2;
	private Date tranDate2;
	private Integer recoveryAcctId;
	private String statSw;
	
	private String dspRecoveryNo;
	private String dspPayorName;
	private String dspAssdName;
	private String dspRefNo;
	private String dspClaimNo;
	private String dspPolicyNo;
	private String dspLossDate;
	private String dspLossCtgry;
	private String dspClmStatCd;
	private String dspInHouAdj;
	
	private String acctExists;
	private String tranFlag;
	private String cpiRecNo;
	private String cpiBranchCd;
	private String dspRefCd;
	private String dspCheckCancel;
	private String dspCheckDist;
	
	public Integer getRecoveryId() {
		return recoveryId;
	}

	public void setRecoveryId(Integer recoveryId) {
		this.recoveryId = recoveryId;
	}

	public Integer getRecoveryPaytId() {
		return recoveryPaytId;
	}

	public void setRecoveryPaytId(Integer recoveryPaytId) {
		this.recoveryPaytId = recoveryPaytId;
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

	public Integer getAcctTranId() {
		return acctTranId;
	}

	public void setAcctTranId(Integer acctTranId) {
		this.acctTranId = acctTranId;
	}

	public Date getTranDate() {
		return tranDate;
	}

	public void setTranDate(Date tranDate) {
		this.tranDate = tranDate;
	}

	public String getCancelTag() {
		return cancelTag;
	}

	public void setCancelTag(String cancelTag) {
		this.cancelTag = cancelTag;
	}

	public Date getCancelDate() {
		return cancelDate;
	}

	public void setCancelDate(Date cancelDate) {
		this.cancelDate = cancelDate;
	}

	public String getEntryTag() {
		return entryTag;
	}

	public void setEntryTag(String entryTag) {
		this.entryTag = entryTag;
	}

	public String getDistSw() {
		return distSw;
	}

	public void setDistSw(String distSw) {
		this.distSw = distSw;
	}

	public Integer getAcctTranId2() {
		return acctTranId2;
	}

	public void setAcctTranId2(Integer acctTranId2) {
		this.acctTranId2 = acctTranId2;
	}

	public Date getTranDate2() {
		return tranDate2;
	}

	public void setTranDate2(Date tranDate2) {
		this.tranDate2 = tranDate2;
	}

	public Integer getRecoveryAcctId() {
		return recoveryAcctId;
	}

	public void setRecoveryAcctId(Integer recoveryAcctId) {
		this.recoveryAcctId = recoveryAcctId;
	}

	public String getStatSw() {
		return statSw;
	}

	public void setStatSw(String statSw) {
		this.statSw = statSw;
	}
	
	public String getDspRecoveryNo() {
		return dspRecoveryNo;
	}

	public void setDspRecoveryNo(String dspRecoveryNo) {
		this.dspRecoveryNo = dspRecoveryNo;
	}

	public String getDspPayorName() {
		return dspPayorName;
	}

	public void setDspPayorName(String dspPayorName) {
		this.dspPayorName = dspPayorName;
	}

	public String getDspAssdName() {
		return dspAssdName;
	}

	public void setDspAssdName(String dspAssdName) {
		this.dspAssdName = dspAssdName;
	}

	public String getDspRefNo() {
		return dspRefNo;
	}

	public void setDspRefNo(String dspRefNo) {
		this.dspRefNo = dspRefNo;
	}

	public String getDspClaimNo() {
		return dspClaimNo;
	}

	public void setDspClaimNo(String dspClaimNo) {
		this.dspClaimNo = dspClaimNo;
	}

	public String getDspPolicyNo() {
		return dspPolicyNo;
	}

	public void setDspPolicyNo(String dspPolicyNo) {
		this.dspPolicyNo = dspPolicyNo;
	}

	public String getDspLossDate() {
		return dspLossDate;
	}

	public void setDspLossDate(String dspLossDate) {
		this.dspLossDate = dspLossDate;
	}

	public String getDspLossCtgry() {
		return dspLossCtgry;
	}

	public void setDspLossCtgry(String dspLossCtgry) {
		this.dspLossCtgry = dspLossCtgry;
	}

	public String getDspClmStatCd() {
		return dspClmStatCd;
	}

	public void setDspClmStatCd(String dspClmStatCd) {
		this.dspClmStatCd = dspClmStatCd;
	}

	public String getDspInHouAdj() {
		return dspInHouAdj;
	}

	public void setDspInHouAdj(String dspInHouAdj) {
		this.dspInHouAdj = dspInHouAdj;
	}

	public String getAcctExists() {
		return acctExists;
	}

	public void setAcctExists(String acctExists) {
		this.acctExists = acctExists;
	}

	public String getTranFlag() {
		return tranFlag;
	}

	public void setTranFlag(String tranFlag) {
		this.tranFlag = tranFlag;
	}

	public String getCpiRecNo() {
		return cpiRecNo;
	}

	public void setCpiRecNo(String cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	public String getDspRefCd() {
		return dspRefCd;
	}

	public void setDspRefCd(String dspRefCd) {
		this.dspRefCd = dspRefCd;
	}

	public String getDspCheckCancel() {
		return dspCheckCancel;
	}

	public void setDspCheckCancel(String dspCheckCancel) {
		this.dspCheckCancel = dspCheckCancel;
	}

	public String getDspCheckDist() {
		return dspCheckDist;
	}

	public void setDspCheckDist(String dspCheckDist) {
		this.dspCheckDist = dspCheckDist;
	}
	
}
