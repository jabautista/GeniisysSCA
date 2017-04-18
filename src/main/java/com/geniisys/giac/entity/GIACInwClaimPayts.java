package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACInwClaimPayts extends BaseEntity {

	Integer gaccTranId;
	
	Integer claimId;
	
	Integer clmLossId;
	
	String orPrintTag;
	
	Integer transactionType;
	
	Integer adviceId;
	
	String payeeType;
	
	String dspPayeeDesc;
	
	String payeeClassCd;
	
	Integer payeeCd;
	
	String dspPayeeName;
	
	BigDecimal disbursementAmt;
	
	BigDecimal inputVATAmt;
	
	BigDecimal wholdingTaxAmt;
	
	BigDecimal netDisbAmt;
	
	String remarks;
	
	String userId;
	
	Date lastUpdate;
	
	Integer currencyCd;
	
	String currDesc;
	
	BigDecimal convertRate;
	
	BigDecimal foreignCurrAmt;
	
	String dspLineCd;
	
	String dspIssCd;
	
	Integer dspAdviceYear;
	
	Integer dspAdviceSeqNo;
	
	String dspPerilName;

	String dspPerilSname;
	
	String dspClaimNo;
	
	String dspPolicyNo;
	
	String dspAssuredName;
	
	String vCheck;

	public Integer getGaccTranId() {
		return gaccTranId;
	}

	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}

	public Integer getClaimId() {
		return claimId;
	}

	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}

	public Integer getClmLossId() {
		return clmLossId;
	}

	public void setClmLossId(Integer clmLossId) {
		this.clmLossId = clmLossId;
	}

	public String getOrPrintTag() {
		return orPrintTag;
	}

	public void setOrPrintTag(String orPrintTag) {
		this.orPrintTag = orPrintTag;
	}

	public Integer getTransactionType() {
		return transactionType;
	}

	public void setTransactionType(Integer transactionType) {
		this.transactionType = transactionType;
	}

	public Integer getAdviceId() {
		return adviceId;
	}

	public void setAdviceId(Integer adviceId) {
		this.adviceId = adviceId;
	}

	public String getPayeeType() {
		return payeeType;
	}

	public void setPayeeType(String payeeType) {
		this.payeeType = payeeType;
	}

	public String getDspPayeeDesc() {
		return dspPayeeDesc;
	}

	public void setDspPayeeDesc(String dspPayeeDesc) {
		this.dspPayeeDesc = dspPayeeDesc;
	}

	public String getPayeeClassCd() {
		return payeeClassCd;
	}

	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
	}

	public Integer getPayeeCd() {
		return payeeCd;
	}

	public void setPayeeCd(Integer payeeCd) {
		this.payeeCd = payeeCd;
	}

	public String getDspPayeeName() {
		return dspPayeeName;
	}

	public void setDspPayeeName(String dspPayeeName) {
		this.dspPayeeName = dspPayeeName;
	}

	public BigDecimal getDisbursementAmt() {
		return disbursementAmt;
	}

	public void setDisbursementAmt(BigDecimal disbursementAmt) {
		this.disbursementAmt = disbursementAmt;
	}

	public BigDecimal getInputVATAmt() {
		return inputVATAmt;
	}

	public void setInputVATAmt(BigDecimal inputVATAmt) {
		this.inputVATAmt = inputVATAmt;
	}

	public BigDecimal getWholdingTaxAmt() {
		return wholdingTaxAmt;
	}

	public void setWholdingTaxAmt(BigDecimal wholdingTaxAmt) {
		this.wholdingTaxAmt = wholdingTaxAmt;
	}

	public BigDecimal getNetDisbAmt() {
		return netDisbAmt;
	}

	public void setNetDisbAmt(BigDecimal netDisbAmt) {
		this.netDisbAmt = netDisbAmt;
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

	public Integer getCurrencyCd() {
		return currencyCd;
	}

	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}

	public String getCurrDesc() {
		return currDesc;
	}

	public void setCurrDesc(String currDesc) {
		this.currDesc = currDesc;
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

	public Integer getDspAdviceYear() {
		return dspAdviceYear;
	}

	public void setDspAdviceYear(Integer dspAdviceYear) {
		this.dspAdviceYear = dspAdviceYear;
	}

	public Integer getDspAdviceSeqNo() {
		return dspAdviceSeqNo;
	}

	public void setDspAdviceSeqNo(Integer dspAdviceSeqNo) {
		this.dspAdviceSeqNo = dspAdviceSeqNo;
	}

	public String getDspPerilName() {
		return dspPerilName;
	}

	public void setDspPerilName(String dspPerilName) {
		this.dspPerilName = dspPerilName;
	}
	
	public String getDspPerilSname() {
		return dspPerilSname;
	}

	public void setDspPerilSname(String dspPerilSname) {
		this.dspPerilSname = dspPerilSname;
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

	public String getDspAssuredName() {
		return dspAssuredName;
	}

	public void setDspAssuredName(String dspAssuredName) {
		this.dspAssuredName = dspAssuredName;
	}

	public String getvCheck() {
		return vCheck;
	}

	public void setvCheck(String vCheck) {
		this.vCheck = vCheck;
	}
}
