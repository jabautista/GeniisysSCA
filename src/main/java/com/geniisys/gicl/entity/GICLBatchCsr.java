/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Oct 19, 2010
 ***************************************************/
package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLBatchCsr extends BaseEntity{
	
	private Integer batchCsrId;
	private String fundCd;
	private String issueCode; //issCd;
	private Integer batchYear;
	private Integer batchSequenceNumber; //batchSeqNo;
	private String payeeClassCode;
	private String payeeClassDesc;
	private Integer payeeCode; //payeeCd;
	private String payeeName;
	private Integer referenceId; // refId;
	private Integer reqDtlNo;
	private Integer tranId;
	private String particulars;
	private BigDecimal paidAmount;
	private BigDecimal netAmount;
	private BigDecimal adviceAmount;
	private String batchFlag;
	private String claimDetailSwitch; //claimDtlSw;
	private Integer currencyCode;
	private String currencyDesc;
	private BigDecimal convertRate;
	private String userId;
	private Date csrLastUpdate;
	private BigDecimal paidForeignCurrencyAmount; //paidFCurrAmount;
	private BigDecimal netForeignCurrencyAmount; //netFCurrAmount;
	private BigDecimal adviceForeignCurrencyAmount; //advFCurrAmount;
	private String batchCsrNo;
	private BigDecimal lossAmount; 
	
	public GICLBatchCsr() {

	}

	public void setBatchCsrId(Integer batchCsrId) {
		this.batchCsrId = batchCsrId;
	}


	public Integer getBatchCsrId() {
		return batchCsrId;
	}


	public String getFundCd() {
		return fundCd;
	}

	public void setFundCd(String fundCd) {
		this.fundCd = fundCd;
	}

	public String getIssueCode() {
		return issueCode;
	}

	public void setIssueCode(String issueCode) {
		this.issueCode = issueCode;
	}

	public Integer getBatchYear() {
		return batchYear;
	}

	public void setBatchYear(Integer batchYear) {
		this.batchYear = batchYear;
	}

	public Integer getBatchSequenceNumber() {
		return batchSequenceNumber;
	}

	public void setBatchSequenceNumber(Integer batchSequenceNumber) {
		this.batchSequenceNumber = batchSequenceNumber;
	}

	public String getPayeeClassCode() {
		return payeeClassCode;
	}

	public void setPayeeClassCode(String payeeClassCode) {
		this.payeeClassCode = payeeClassCode;
	}

	public Integer getPayeeCode() {
		return payeeCode;
	}

	public void setPayeeCode(Integer payeeCode) {
		this.payeeCode = payeeCode;
	}

	public void setPayeeClassDesc(String payeeClassDesc) {
		this.payeeClassDesc = payeeClassDesc;
	}

	public String getPayeeClassDesc() {
		return payeeClassDesc;
	}

	public void setPayeeName(String payeeName) {
		this.payeeName = payeeName;
	}

	public String getPayeeName() {
		return payeeName;
	}

	public Integer getReferenceId() {
		return referenceId;
	}

	public void setReferenceId(Integer referenceId) {
		this.referenceId = referenceId;
	}

	public Integer getReqDtlNo() {
		return reqDtlNo;
	}

	public void setReqDtlNo(Integer reqDtlNo) {
		this.reqDtlNo = reqDtlNo;
	}

	public Integer getTranId() {
		return tranId;
	}

	public void setTranId(Integer tranId) {
		this.tranId = tranId;
	}

	public String getParticulars() {
		return particulars;
	}

	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}

	public BigDecimal getPaidAmount() {
		return paidAmount;
	}

	public void setPaidAmount(BigDecimal paidAmount) {
		this.paidAmount = paidAmount;
	}

	public BigDecimal getNetAmount() {
		return netAmount;
	}

	public void setNetAmount(BigDecimal netAmount) {
		this.netAmount = netAmount;
	}

	public BigDecimal getAdviceAmount() {
		return adviceAmount;
	}

	public void setAdviceAmount(BigDecimal adviceAmount) {
		this.adviceAmount = adviceAmount;
	}

	public String getBatchFlag() {
		return batchFlag;
	}

	public void setBatchFlag(String batchFlag) {
		this.batchFlag = batchFlag;
	}

	public String getClaimDetailSwitch() {
		return claimDetailSwitch;
	}

	public void setClaimDetailSwitch(String claimDetailSwitch) {
		this.claimDetailSwitch = claimDetailSwitch;
	}

	public Integer getCurrencyCode() {
		return currencyCode;
	}

	public void setCurrencyCode(Integer currencyCode) {
		this.currencyCode = currencyCode;
	}

	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}

	public String getCurrencyDesc() {
		return currencyDesc;
	}

	public BigDecimal getConvertRate() {
		return convertRate;
	}

	public void setConvertRate(BigDecimal convertRate) {
		this.convertRate = convertRate;
	}

	public BigDecimal getPaidForeignCurrencyAmount() {
		return paidForeignCurrencyAmount;
	}
	
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	

	public void setCsrLastUpdate(Date csrLastUpdate) {
		this.csrLastUpdate = csrLastUpdate;
	}

	public Object getCsrLastUpdate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (csrLastUpdate != null) {
			return df.format(csrLastUpdate);			
		} else {
			return null;
		}
	}

	public void setPaidForeignCurrencyAmount(BigDecimal paidForeignCurrencyAmount) {
		this.paidForeignCurrencyAmount = paidForeignCurrencyAmount;
	}

	public BigDecimal getNetForeignCurrencyAmount() {
		return netForeignCurrencyAmount;
	}

	public void setNetForeignCurrencyAmount(BigDecimal netForeignCurrencyAmount) {
		this.netForeignCurrencyAmount = netForeignCurrencyAmount;
	}

	public BigDecimal getAdviceForeignCurrencyAmount() {
		return adviceForeignCurrencyAmount;
	}

	public void setAdviceForeignCurrencyAmount(
			BigDecimal adviceForeignCurrencyAmount) {
		this.adviceForeignCurrencyAmount = adviceForeignCurrencyAmount;
	}

	public void setBatchCsrNo(String batchCsrNo) {
		this.batchCsrNo = batchCsrNo;
	}

	public String getBatchCsrNo() {
		return batchCsrNo;
	}

	public void setLossAmount(BigDecimal lossAmount) {
		this.lossAmount = lossAmount;
	}

	public BigDecimal getLossAmount() {
		return lossAmount;
	}
	
}
