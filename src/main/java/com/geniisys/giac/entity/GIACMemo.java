package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACMemo extends BaseEntity{

	private Integer gaccTranId;
	private String fundCd;
	private String branchCd;
	private String memoType;
	private Date memoDate;
	private Integer memoYear;
	private Integer memoSeqNo;
	private String recipient;
	private String particulars;
	private String memoStatus;
	private Integer currencyCd;
	//private Float currencyRt;
	private Double currencyRt;
	private String userId;
	private String lastUpdateStr;
	private Date lastUpdate;
	private String dvNo; //Added by Jerome Bautista 12.14.2015 SR 3467
	private BigDecimal riCommAmt; // bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002
	private BigDecimal riCommVat; // bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002
	
	private String memoNumber;
	private String meanMemoType;
	private String meanMemoStatus;
	private BigDecimal foreignAmount;
	private String foreignCurrSname;
	private BigDecimal localAmount;
	private String localCurrSname;
	private Float localCurrRt;
	private Integer localCurrCd;
	private String branchName;
	private String fundDesc;
	private String graccRacCd;
	private Date dspMemoDate;
	private String cancelFlag;
	private Integer checkAppliedCMTag;
	private Integer checkUserPerIssCdAcctgTag;
	
	private String closedTag;
	private String tranFlag;
	private String allowTranForClosedMonthTag;
	private String allowPrintForOpenCMDMTag;
	private String allowCancelTranForClosedMonthTag;
	
	public Integer getGaccTranId() {
		return gaccTranId;
	}
	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}
	public String getFundCd() {
		return fundCd;
	}
	public void setFundCd(String fundCd) {
		this.fundCd = fundCd;
	}
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	public String getMemoType() {
		return memoType;
	}
	public void setMemoType(String memoType) {
		this.memoType = memoType;
	}
	public Date getMemoDate() {
		return memoDate;
	}
	public void setMemoDate(Date memoDate) {
		this.memoDate = memoDate;
	}
	public Integer getMemoYear() {
		return memoYear;
	}
	public void setMemoYear(Integer memoYear) {
		this.memoYear = memoYear;
	}
	public Integer getMemoSeqNo() {
		return memoSeqNo;
	}
	public void setMemoSeqNo(Integer memoSeqNo) {
		this.memoSeqNo = memoSeqNo;
	}
	public String getRecipient() {
		return recipient;
	}
	public void setRecipient(String recipient) {
		this.recipient = recipient;
	}
	public String getParticulars() {
		return particulars;
	}
	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}
	public String getMemoStatus() {
		return memoStatus;
	}
	public void setMemoStatus(String memoStatus) {
		this.memoStatus = memoStatus;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public Double getCurrencyRt() {
		return currencyRt;
	}
	public void setCurrencyRt(Double currencyRt) {
		this.currencyRt = currencyRt;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getLastUpdateStr() {
		return lastUpdateStr;
	}
	public void setLastUpdateStr(String lastUpdateStr) {
		this.lastUpdateStr = lastUpdateStr;
	}
	public Date getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	public String getDvNo() { //Added by Jerome Bautista 12.14.2015 SR 3467
		return dvNo;
	}
	public void setDvNo(String dvNo) { //Added by Jerome Bautista 12.14.2015 SR 3467
		this.dvNo = dvNo;
	}
	public String getMemoNumber() {
		return memoNumber;
	}
	public void setMemoNumber(String memoNumber) {
		this.memoNumber = memoNumber;
	}
	public String getMeanMemoType() {
		return meanMemoType;
	}
	public void setMeanMemoType(String meanMemoType) {
		this.meanMemoType = meanMemoType;
	}
	public String getMeanMemoStatus() {
		return meanMemoStatus;
	}
	public void setMeanMemoStatus(String meanMemoStatus) {
		this.meanMemoStatus = meanMemoStatus;
	}
	public BigDecimal getForeignAmount() {
		return foreignAmount;
	}
	public void setForeignAmount(BigDecimal foreignAmount) {
		this.foreignAmount = foreignAmount;
	}
	public String getForeignCurrSname() {
		return foreignCurrSname;
	}
	public void setForeignCurrSname(String foreignCurrSname) {
		this.foreignCurrSname = foreignCurrSname;
	}
	public BigDecimal getLocalAmount() {
		return localAmount;
	}
	public void setLocalAmount(BigDecimal localAmount) {
		this.localAmount = localAmount;
	}
	public String getLocalCurrSname() {
		return localCurrSname;
	}
	public void setLocalCurrSname(String localCurrSname) {
		this.localCurrSname = localCurrSname;
	}
	public Float getLocalCurrRt() {
		return localCurrRt;
	}
	public void setLocalCurrRt(Float localCurrRt) {
		this.localCurrRt = localCurrRt;
	}
	public Integer getLocalCurrCd() {
		return localCurrCd;
	}
	public void setLocalCurrCd(Integer localCurrCd) {
		this.localCurrCd = localCurrCd;
	}
	public String getBranchName() {
		return branchName;
	}
	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}
	public String getFundDesc() {
		return fundDesc;
	}
	public void setFundDesc(String fundDesc) {
		this.fundDesc = fundDesc;
	}
	public String getGraccRacCd() {
		return graccRacCd;
	}
	public void setGraccRacCd(String graccRacCd) {
		this.graccRacCd = graccRacCd;
	}
	public Date getDspMemoDate() {
		return dspMemoDate;
	}
	public void setDspMemoDate(Date dspMemoDate) {
		this.dspMemoDate = dspMemoDate;
	}
	public String getTranFlag() {
		return tranFlag;
	}
	public void setTranFlag(String tranFlag) {
		this.tranFlag = tranFlag;
	}
	public String getCancelFlag() {
		return cancelFlag;
	}
	public void setCancelFlag(String cancelFlag) {
		this.cancelFlag = cancelFlag;
	}
	
	public Integer getCheckAppliedCMTag() {
		return checkAppliedCMTag;
	}
	public void setCheckAppliedCMTag(Integer checkAppliedCMTag) {
		this.checkAppliedCMTag = checkAppliedCMTag;
	}
	public Integer getCheckUserPerIssCdAcctgTag() {
		return checkUserPerIssCdAcctgTag;
	}
	public void setCheckUserPerIssCdAcctgTag(Integer checkUserPerIssCdAcctgTag) {
		this.checkUserPerIssCdAcctgTag = checkUserPerIssCdAcctgTag;
	}
	public String getClosedTag() {
		return closedTag;
	}
	public void setClosedTag(String closedTag) {
		this.closedTag = closedTag;
	}
	public String getAllowTranForClosedMonthTag() {
		return allowTranForClosedMonthTag;
	}
	public void setAllowTranForClosedMonthTag(String allowTranForClosedMonthTag) {
		this.allowTranForClosedMonthTag = allowTranForClosedMonthTag;
	}
	public String getAllowPrintForOpenCMDMTag() {
		return allowPrintForOpenCMDMTag;
	}
	public void setAllowPrintForOpenCMDMTag(String allowPrintForOpenCMDMTag) {
		this.allowPrintForOpenCMDMTag = allowPrintForOpenCMDMTag;
	}
	public String getAllowCancelTranForClosedMonthTag() {
		return allowCancelTranForClosedMonthTag;
	}
	public void setAllowCancelTranForClosedMonthTag(
			String allowCancelTranForClosedMonthTag) {
		this.allowCancelTranForClosedMonthTag = allowCancelTranForClosedMonthTag;
	}
	
	// bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002 START
	public BigDecimal getRiCommAmt() {
		return riCommAmt;
	}
	public void setRiCommAmt(BigDecimal riCommAmt) {
		this.riCommAmt = riCommAmt;
	}
	public BigDecimal getRiCommVat() {
		return riCommVat;
	}
	public void setRiCommVat(BigDecimal riCommVat) {
		this.riCommVat = riCommVat;
	}
	// bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002 END
	
}
