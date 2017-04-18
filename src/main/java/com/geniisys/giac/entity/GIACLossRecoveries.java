package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACLossRecoveries extends BaseEntity{

	private Integer gaccTranId;
	private Integer transactionType;
	private Integer claimId;
	private Integer recoveryId;
	private String payorClassCd;
	private Integer payorCd;
	private BigDecimal collectionAmt;
	private Integer currencyCd;
	private BigDecimal convertRate;
	private BigDecimal foreignCurrAmt;
	private String orPrintTag;
	private String remarks;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String acctEntTag;
	//non-base-table
	private String transactionTypeDesc;
	private String lineCd;
	private String issCd;
	private String recYear;
	private String recSeqNo;
	private String dspClaimNo;
	private String dspPolicyNo;
	private String dspLossDate;		// shan 06.14.2013 from Date type for PHILFIRE-QA SR-13432
	private String dspAssuredName;
	private String recTypeCd;
	private String recTypeDesc;
	private String payorName;
	private String payorClassDesc;
	private String dspCurrencyDesc;
	
	public Integer getGaccTranId() {
		return gaccTranId;
	}
	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}
	public Integer getTransactionType() {
		return transactionType;
	}
	public void setTransactionType(Integer transactionType) {
		this.transactionType = transactionType;
	}
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public Integer getRecoveryId() {
		return recoveryId;
	}
	public void setRecoveryId(Integer recoveryId) {
		this.recoveryId = recoveryId;
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
	public BigDecimal getCollectionAmt() {
		return collectionAmt;
	}
	public void setCollectionAmt(BigDecimal collectionAmt) {
		this.collectionAmt = collectionAmt;
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
	public BigDecimal getForeignCurrAmt() {
		return foreignCurrAmt;
	}
	public void setForeignCurrAmt(BigDecimal foreignCurrAmt) {
		this.foreignCurrAmt = foreignCurrAmt;
	}
	public String getOrPrintTag() {
		return orPrintTag;
	}
	public void setOrPrintTag(String orPrintTag) {
		this.orPrintTag = orPrintTag;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
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
	public String getAcctEntTag() {
		return acctEntTag;
	}
	public void setAcctEntTag(String acctEntTag) {
		this.acctEntTag = acctEntTag;
	}
	public String getTransactionTypeDesc() {
		return transactionTypeDesc;
	}
	public void setTransactionTypeDesc(String transactionTypeDesc) {
		this.transactionTypeDesc = transactionTypeDesc;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public String getRecYear() {
		return recYear;
	}
	public void setRecYear(String recYear) {
		this.recYear = recYear;
	}
	public String getRecSeqNo() {
		return recSeqNo;
	}
	public void setRecSeqNo(String recSeqNo) {
		this.recSeqNo = recSeqNo;
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
	public String getDspAssuredName() {
		return dspAssuredName;
	}
	public void setDspAssuredName(String dspAssuredName) {
		this.dspAssuredName = dspAssuredName;
	}
	public String getRecTypeCd() {
		return recTypeCd;
	}
	public void setRecTypeCd(String recTypeCd) {
		this.recTypeCd = recTypeCd;
	}
	public String getRecTypeDesc() {
		return recTypeDesc;
	}
	public void setRecTypeDesc(String recTypeDesc) {
		this.recTypeDesc = recTypeDesc;
	}
	public String getPayorName() {
		return payorName;
	}
	public void setPayorName(String payorName) {
		this.payorName = payorName;
	}
	public String getPayorClassDesc() {
		return payorClassDesc;
	}
	public void setPayorClassDesc(String payorClassDesc) {
		this.payorClassDesc = payorClassDesc;
	}
	public String getDspCurrencyDesc() {
		return dspCurrencyDesc;
	}
	public void setDspCurrencyDesc(String dspCurrencyDesc) {
		this.dspCurrencyDesc = dspCurrencyDesc;
	}
	
}
