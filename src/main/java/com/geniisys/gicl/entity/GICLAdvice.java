/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Oct 13, 2010
 ***************************************************/
package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;
import com.seer.framework.util.StringFormatter;

public class GICLAdvice extends BaseEntity{
	private Date		adviceDate;
	private String	 	adviceFlag;
	private Integer 	adviceId;
	private Integer 	adviceSequenceNumber;
	private Integer 	adviceYear;
	private BigDecimal 	adviceAmount;
	private BigDecimal	advForeignCurrencyAmount;
	private Integer		advFlaId; // advFlaId
	private String 		approvedTag;
	private Integer		batchCsrId;
	private BigDecimal	batchDvId;
	private Integer 	claimId;
	private BigDecimal	convertRate;
	private String 		cpiBranchCode;
	private Integer 	cpiRecNo;
	private Integer 	currencyCode;
	private String 		issueCode;
	private String 		lineCode;
	private BigDecimal	netAmount;
	private BigDecimal	netForeignCurrencyAmount;
	private Integer		originalCurrencyCode;
	private BigDecimal	originalCurrencyRate;
	private BigDecimal	paidAmount;
	private BigDecimal 	paidForeignCurrencyAmount;
	private String 		payeeRemarks;
	private String 		remarks;
	
	// properties not included in DB row
	private String 		adviceNo;
	private String 		currencyDescription;
	private String		claimNo;
	private String		policyNo;
	private Integer		assdNo;
	private String 		assuredName;
	private Date		lossDate;
	private String dspLossCatDes;
	private String lossCatCd;
	private String clmStatCd;
	private String dspClmStatDesc;
	private String payeeClassCd;
	private String payeeCd;
	private String dspPayee;
	private String dspPayeeClass;
	private BigDecimal dspPaidAmt;
	private BigDecimal dspPaidFcurrAmt;
	private BigDecimal	convRt;
	private Integer 	lossCurrCd;
	private String dspCurrency;
	private String sublineCode;
	private String generateSw;
	private Integer clmLossId;
	private BigDecimal paidAmt;
	private BigDecimal netAmt;
	private String payeeType;
	
	
	public BigDecimal getPaidAmt() {
		return paidAmt;
	}

	public void setPaidAmt(BigDecimal paidAmt) {
		this.paidAmt = paidAmt;
	}

	public BigDecimal getNetAmt() {
		return netAmt;
	}

	public void setNetAmt(BigDecimal netAmt) {
		this.netAmt = netAmt;
	}

	public String getPayeeType() {
		return payeeType;
	}

	public void setPayeeType(String payeeType) {
		this.payeeType = payeeType;
	}

	public Integer getClmLossId() {
		return clmLossId;
	}

	public void setClmLossId(Integer clmLossId) {
		this.clmLossId = clmLossId;
	}

	public String getDspCurrency() {
		return dspCurrency;
	}

	public void setDspCurrency(String dspCurrency) {
		this.dspCurrency = dspCurrency;
	}

	public BigDecimal getConvRt() {
		return convRt;
	}

	public void setConvRt(BigDecimal convRt) {
		this.convRt = convRt;
	}

	public Integer getLossCurrCd() {
		return lossCurrCd;
	}

	public void setLossCurrCd(Integer lossCurrCd) {
		this.lossCurrCd = lossCurrCd;
	}

	public String getPayeeClassCd() {
		return payeeClassCd;
	}

	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
	}

	public String getDspPayee() {
		return dspPayee;
	}

	public void setDspPayee(String dspPayee) {
		this.dspPayee = dspPayee;
	}

	public String getDspPayeeClass() {
		return dspPayeeClass;
	}

	public void setDspPayeeClass(String dspPayeeClass) {
		this.dspPayeeClass = dspPayeeClass;
	}

	public String getClmStatCd() {
		return clmStatCd;
	}

	public void setClmStatCd(String clmStatCd) {
		this.clmStatCd = clmStatCd;
	}

	public String getDspClmStatDesc() {
		return dspClmStatDesc;
	}

	public void setDspClmStatDesc(String dspClmStatDesc) {
		this.dspClmStatDesc = dspClmStatDesc;
	}

	public String getDspLossCatDes() {
		return dspLossCatDes;
	}

	public void setDspLossCatDes(String dspLossCatDes) {
		this.dspLossCatDes = dspLossCatDes;
	}

	public String getLossCatCd() {
		return lossCatCd;
	}

	public void setLossCatCd(String lossCatCd) {
		this.lossCatCd = lossCatCd;
	}

	public Integer getAdviceId() {
		return adviceId;
	}

	public void setAdviceId(Integer adviceId) {
		this.adviceId = adviceId;
	}

	public Integer getClaimId() {
		return claimId;
	}

	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}

	public String getLineCode() {
		return lineCode;
	}
	
	public void setLineCode(String lineCode) {
		this.lineCode = lineCode;
	}
	
	public String getIssueCode() {
		return issueCode;
	}
	
	public void setIssueCode(String issueCode) {
		this.issueCode = issueCode;
	}
	
	public Integer getAdviceYear() {
		return adviceYear;
	}
	
	public void setAdviceYear(Integer adviceYear) {
		this.adviceYear = adviceYear;
	}
	
	public Integer getAdviceSequenceNumber() {
		return adviceSequenceNumber;
	}
	
	public void setAdviceSequenceNumber(Integer adviceSequenceNumber) {
		this.adviceSequenceNumber = adviceSequenceNumber;
	}
	
	public String getAdviceFlag() {
		return adviceFlag;
	}
	
	public void setAdviceFlag(String adviceFlag) {
		this.adviceFlag = adviceFlag;
	}
	
	public BigDecimal getAdviceAmount() {
		return adviceAmount;
	}
	
	public void setAdviceAmount(BigDecimal adviceAmount) {
		this.adviceAmount = adviceAmount;
	}
	
	public BigDecimal getNetAmount() {
		return netAmount;
	}
	
	public void setNetAmount(BigDecimal netAmount) {
		this.netAmount = netAmount;
	}

	public BigDecimal getPaidAmount() {
		return paidAmount;
	}

	public void setPaidAmount(BigDecimal paidAmount) {
		this.paidAmount = paidAmount;
	}

	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	public String getCpiBranchCode() {
		return cpiBranchCode;
	}

	public void setCpiBranchCode(String cpiBranchCode) {
		this.cpiBranchCode = cpiBranchCode;
	}

	public String getApprovedTag() {
		return approvedTag;
	}

	public void setApprovedTag(String approvedTag) {
		this.approvedTag = approvedTag;
	}

	public Integer getAdvFlaId() {
		return advFlaId;
	}

	public void setAdvFlaId(Integer advFlaId) {
		this.advFlaId = advFlaId;
	}

	public Integer getCurrencyCode() {
		return currencyCode;
	}

	public void setCurrencyCode(Integer currencyCode) {
		this.currencyCode = currencyCode;
	}


	public BigDecimal getConvertRate() {
		return convertRate;
	}


	public void setConvertRate(BigDecimal convertRate) {
		this.convertRate = convertRate;
	}


	public Integer getBatchCsrId() {
		return batchCsrId;
	}


	public void setBatchCsrId(Integer batchCsrId) {
		this.batchCsrId = batchCsrId;
	}


	public Date getAdviceDate() {
		return adviceDate;
	}


	public void setAdviceDate(Date adviceDate) {
		this.adviceDate = adviceDate;
	}
	
	public String getStrAdviceDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(adviceDate != null){
			return sdf.format(adviceDate).toString();
		} else {
			return null;
		}
	}

	public BigDecimal getPaidForeignCurrencyAmount() {
		return paidForeignCurrencyAmount;
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

	public BigDecimal getAdvForeignCurrencyAmount() {
		return advForeignCurrencyAmount;
	}

	public void setAdvForeignCurrencyAmount(BigDecimal advForeignCurrencyAmount) {
		this.advForeignCurrencyAmount = advForeignCurrencyAmount;
	}

	public BigDecimal getBatchDvId() {
		return batchDvId;
	}

	public void setBatchDvId(BigDecimal batchDvId) {
		this.batchDvId = batchDvId;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public Integer getOriginalCurrencyCode() {
		return originalCurrencyCode;
	}

	public void setOriginalCurrencyCode(Integer originalCurrencyCode) {
		this.originalCurrencyCode = originalCurrencyCode;
	}

	public BigDecimal getOriginalCurrencyRate() {
		return originalCurrencyRate;
	}

	public void setOriginalCurrencyRate(BigDecimal originalCurrencyRate) {
		this.originalCurrencyRate = originalCurrencyRate;
	}
	
	/**
	 * 
	 */
	public GICLAdvice() {
		adviceAmount 	= new BigDecimal(0);
		adviceAmount 	= new BigDecimal(0);
		netAmount 		= new BigDecimal(0);
		paidAmount 		= new BigDecimal(0);
		convertRate	 	= new BigDecimal(0);
		paidForeignCurrencyAmount 	= new BigDecimal(0);
		netForeignCurrencyAmount 	= new BigDecimal(0);
		advForeignCurrencyAmount 	= new BigDecimal(0);
		batchDvId 		= new BigDecimal(0);
	}

	/**
	 * @param payeeRemarks the payeeRemarks to set
	 */
	public void setPayeeRemarks(String payeeRemarks) {
		this.payeeRemarks = payeeRemarks;
	}

	/**
	 * @return the payeeRemarks
	 */
	public String getPayeeRemarks() {
		return payeeRemarks;
	}

	/**
	 * @param adviceNo the adviceNo to set
	 */
	public void setAdviceNo(String adviceNo) {
		this.adviceNo = adviceNo;
	}

	/**
	 * @return the adviceNo
	 */
	public String getAdviceNo() {
		if(adviceNo==null){
			adviceNo = 	lineCode 	+ "-" +
						issueCode 	+ "-" + 
						adviceYear 	+ "-" + 
						StringFormatter.zeroPad(adviceSequenceNumber,7);
		}
		return adviceNo;
	}

	/**
	 * @param currencyDescription the currencyDescription to set
	 */
	public void setCurrencyDescription(String currencyDescription) {
		this.currencyDescription = currencyDescription;
	}

	/**
	 * @return the currencyDescription
	 */
	public String getCurrencyDescription() {
		return currencyDescription;
	}

	public void setClaimNo(String claimNo) {
		this.claimNo = claimNo;
	}

	public String getClaimNo() {
		return claimNo;
	}

	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}

	public String getPolicyNo() {
		return policyNo;
	}

	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}

	public Integer getAssdNo() {
		return assdNo;
	}

	public void setAssuredName(String assuredName) {
		this.assuredName = assuredName;
	}

	public String getAssuredName() {
		return assuredName;
	}

	public void setLossDate(Date lossDate) {
		this.lossDate = lossDate;
	}

	public Date getLossDate() {
		return lossDate;
	}
	
	public String getStrLossDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(lossDate != null){
			return sdf.format(lossDate).toString();
		} else {
			return null;
		}
	}

	/**
	 * @param payeeCd the payeeCd to set
	 */
	public void setPayeeCd(String payeeCd) {
		this.payeeCd = payeeCd;
	}

	/**
	 * @return the payeeCd
	 */
	public String getPayeeCd() {
		return payeeCd;
	}

	/**
	 * @param dspPaidAmt the dspPaidAmt to set
	 */
	public void setDspPaidAmt(BigDecimal dspPaidAmt) {
		this.dspPaidAmt = dspPaidAmt;
	}

	/**
	 * @return the dspPaidAmt
	 */
	public BigDecimal getDspPaidAmt() {
		return dspPaidAmt;
	}

	/**
	 * @param dspPaidFcurrAmt the dspPaidFcurrAmt to set
	 */
	public void setDspPaidFcurrAmt(BigDecimal dspPaidFcurrAmt) {
		this.dspPaidFcurrAmt = dspPaidFcurrAmt;
	}

	/**
	 * @return the dspPaidFcurrAmt
	 */
	public BigDecimal getDspPaidFcurrAmt() {
		return dspPaidFcurrAmt;
	}
	
	public String getSublineCode() {
		return sublineCode;
	}

	public void setSublineCode(String sublineCode) {
		this.sublineCode = sublineCode;
	}

	/**
	 * @param generateSw the generateSw to set
	 */
	public void setGenerateSw(String generateSw) {
		this.generateSw = generateSw;
	}

	/**
	 * @return the generateSw
	 */
	public String getGenerateSw() {
		return generateSw;
	}
	
}
