package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLClmRecovery extends BaseEntity{

	private Integer recoveryId;
	private Integer claimId;
	private String lineCd;
	private Integer recYear;
	private Integer recSeqNo;
	private String recTypeCd;
	private BigDecimal recoverableAmt;
	private BigDecimal recoveredAmt;
	private String tpItemDesc;
	private String plateNo;
	private Integer currencyCd;
	private BigDecimal convertRate;
	private String lawyerClassCd;
	private Integer lawyerCd;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String cancelTag;
	private String issCd;
	private Date recFileDate;
	private Date demandLetterDate;
	private Date demandLetterDate2;
	private Date demandLetterDate3;
	private String tpDriverName;
	private String tpDrvrAdd;
	private String tpPlateNo;
	private String caseNo;
	private String court;
	
	private String dspLawyerName;
	private String dspRecStatDesc;
	private String dspRecTypeDesc;
	private String dspCurrencyDesc;
	private String msgAlert;
	private String dspCheckValid;
	private String dspCheckAll;
	
	/*GICLS054*/
	private String dspLineCd; 
	private String dspIssCd;
	private Integer dspRecYear;
	private Integer dspRecSeqNo;
	private String dspRefNo;
	private String recoveryPaytId;
	private String payorClassCd;
	private Integer payorCd;
	private String dspPayorName;
	private Integer acctTranId;
	private String tranDate;
	private Date cancelDate;
	private String entryTag;
	private String distSw;
	private Integer acctTranId2;
	private String tranDate2;
	private String statSw;
	private Integer recoveryAcctId;
	
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
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public Integer getRecYear() {
		return recYear;
	}
	public void setRecYear(Integer recYear) {
		this.recYear = recYear;
	}
	public Integer getRecSeqNo() {
		return recSeqNo;
	}
	public void setRecSeqNo(Integer recSeqNo) {
		this.recSeqNo = recSeqNo;
	}
	public String getRecTypeCd() {
		return recTypeCd;
	}
	public void setRecTypeCd(String recTypeCd) {
		this.recTypeCd = recTypeCd;
	}
	public BigDecimal getRecoverableAmt() {
		return recoverableAmt;
	}
	public void setRecoverableAmt(BigDecimal recoverableAmt) {
		this.recoverableAmt = recoverableAmt;
	}
	public BigDecimal getRecoveredAmt() {
		return recoveredAmt;
	}
	public void setRecoveredAmt(BigDecimal recoveredAmt) {
		this.recoveredAmt = recoveredAmt;
	}
	public String getTpItemDesc() {
		return tpItemDesc;
	}
	public void setTpItemDesc(String tpItemDesc) {
		this.tpItemDesc = tpItemDesc;
	}
	public String getPlateNo() {
		return plateNo;
	}
	public void setPlateNo(String plateNo) {
		this.plateNo = plateNo;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public BigDecimal getConvertRate() {
		return convertRate;
	}
	public void setConvertRate(BigDecimal convertRate) {
		this.convertRate = convertRate;
	}
	public String getLawyerClassCd() {
		return lawyerClassCd;
	}
	public void setLawyerClassCd(String lawyerClassCd) {
		this.lawyerClassCd = lawyerClassCd;
	}
	public Integer getLawyerCd() {
		return lawyerCd;
	}
	public void setLawyerCd(Integer lawyerCd) {
		this.lawyerCd = lawyerCd;
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
	public String getCancelTag() {
		return cancelTag;
	}
	public void setCancelTag(String cancelTag) {
		this.cancelTag = cancelTag;
	}
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public Date getRecFileDate() {
		return recFileDate;
	}
	public void setRecFileDate(Date recFileDate) {
		this.recFileDate = recFileDate;
	}
	public Date getDemandLetterDate() {
		return demandLetterDate;
	}
	public void setDemandLetterDate(Date demandLetterDate) {
		this.demandLetterDate = demandLetterDate;
	}
	public Date getDemandLetterDate2() {
		return demandLetterDate2;
	}
	public void setDemandLetterDate2(Date demandLetterDate2) {
		this.demandLetterDate2 = demandLetterDate2;
	}
	public Date getDemandLetterDate3() {
		return demandLetterDate3;
	}
	public void setDemandLetterDate3(Date demandLetterDate3) {
		this.demandLetterDate3 = demandLetterDate3;
	}
	public String getTpDriverName() {
		return tpDriverName;
	}
	public void setTpDriverName(String tpDriverName) {
		this.tpDriverName = tpDriverName;
	}
	public String getTpDrvrAdd() {
		return tpDrvrAdd;
	}
	public void setTpDrvrAdd(String tpDrvrAdd) {
		this.tpDrvrAdd = tpDrvrAdd;
	}
	public String getTpPlateNo() {
		return tpPlateNo;
	}
	public void setTpPlateNo(String tpPlateNo) {
		this.tpPlateNo = tpPlateNo;
	}
	public String getCaseNo() {
		return caseNo;
	}
	public void setCaseNo(String caseNo) {
		this.caseNo = caseNo;
	}
	public String getCourt() {
		return court;
	}
	public void setCourt(String court) {
		this.court = court;
	}
	public String getDspLawyerName() {
		return dspLawyerName;
	}
	public void setDspLawyerName(String dspLawyerName) {
		this.dspLawyerName = dspLawyerName;
	}
	public String getDspRecStatDesc() {
		return dspRecStatDesc;
	}
	public void setDspRecStatDesc(String dspRecStatDesc) {
		this.dspRecStatDesc = dspRecStatDesc;
	}
	public String getDspRecTypeDesc() {
		return dspRecTypeDesc;
	}
	public void setDspRecTypeDesc(String dspRecTypeDesc) {
		this.dspRecTypeDesc = dspRecTypeDesc;
	}
	public String getDspCurrencyDesc() {
		return dspCurrencyDesc;
	}
	public void setDspCurrencyDesc(String dspCurrencyDesc) {
		this.dspCurrencyDesc = dspCurrencyDesc;
	}
	public String getMsgAlert() {
		return msgAlert;
	}
	public void setMsgAlert(String msgAlert) {
		this.msgAlert = msgAlert;
	}
	public String getDspCheckValid() {
		return dspCheckValid;
	}
	public void setDspCheckValid(String dspCheckValid) {
		this.dspCheckValid = dspCheckValid;
	}
	public String getDspCheckAll() {
		return dspCheckAll;
	}
	public void setDspCheckAll(String dspCheckAll) {
		this.dspCheckAll = dspCheckAll;
	}
	
	public String getDspLineCd() {
		return dspLineCd;
	}
	public void setDspLineCd(String dspLineCd) {
		this.dspLineCd = dspLineCd;
	}
	public String getDspIssCd() {
		return dspIssCd;
	}
	public void setDspIssCd(String dspIssCd) {
		this.dspIssCd = dspIssCd;
	}
	public Integer getDspRecYear() {
		return dspRecYear;
	}
	public void setDspRecYear(Integer dspRecYear) {
		this.dspRecYear = dspRecYear;
	}
	public Integer getDspRecSeqNo() {
		return dspRecSeqNo;
	}
	public void setDspRecSeqNo(Integer dspRecSeqNo) {
		this.dspRecSeqNo = dspRecSeqNo;
	}
	public String getDspRefNo() {
		return dspRefNo;
	}
	public void setDspRefNo(String dspRefNo) {
		this.dspRefNo = dspRefNo;
	}
	public String getRecoveryPaytId() {
		return recoveryPaytId;
	}
	public void setRecoveryPaytId(String recoveryPaytId) {
		this.recoveryPaytId = recoveryPaytId;
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
	public String getDspPayorName() {
		return dspPayorName;
	}
	public void setDspPayorName(String dspPayorName) {
		this.dspPayorName = dspPayorName;
	}
	public Integer getAcctTranId() {
		return acctTranId;
	}
	public void setAcctTranId(Integer acctTranId) {
		this.acctTranId = acctTranId;
	}
	public String getTranDate() {
		return tranDate;
	}
	public void setTranDate(String tranDate) {
		this.tranDate = tranDate;
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
	public String getTranDate2() {
		return tranDate2;
	}
	public void setTranDate2(String tranDate2) {
		this.tranDate2 = tranDate2;
	}
	public String getStatSw() {
		return statSw;
	}
	public void setStatSw(String statSw) {
		this.statSw = statSw;
	}
	public Integer getRecoveryAcctId() {
		return recoveryAcctId;
	}
	public void setRecoveryAcctId(Integer recoveryAcctId) {
		this.recoveryAcctId = recoveryAcctId;
	}
	
	
}
