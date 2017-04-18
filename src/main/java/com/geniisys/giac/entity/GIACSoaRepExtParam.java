package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACSoaRepExtParam extends BaseEntity{

	private String userId;
	private Date paramDate;
	private String reportDate;
	private Date fromDate1;
	private Date toDate1;
	private Date fromDate2;
	private Date toDate2;
	private String dateTag;
	private Date asOfDate;
	private String branchCd;
	private Integer intmNo;
	private String intmType;
	private Integer assdNo;
	private String incSpecialPol;
	private Date extractDate;
	private Integer extractAgingDays;
	private String branchParam;
	private BigDecimal outstandingBalance;
	
	// additional
	private String bookTag;
	private String incepTag;
	private String issueTag;
	private Date bookDateFr;
	private Date bookDateTo;
	private Date incepDateFr;
	private Date incepDateTo;
	private Date issueDateFr;
	private Date issueDateTo;
	private Date cutOffDate;
	
	//added by gab 10.14.2016 SR 4016
	private String dspAsOfDate;
	private String dspCutOffDate;
	private String dspBookDateFr;
	private String dspBookDateTo;
	private String dspIncepDateFr;
	private String dspIncepDateTo;
	private String dspIssueDateFr;
	private String dspIssueDateTo;
	
	private String includePDC;
	private String message;
	
	private String strBookDateFr;
	private String strBookDateTo;
	private String strIncepDateFr;
	private String strIncepDateTo;
	private String strIssueDateFr;
	private String strIssueDateTo;
	private String strCutOffDate;
	private String strAsOfDate;
	
	private String branchName;
	private String intmName;
	private String assdName;
	private String intmTypeDesc;
	
	private String paytDate;
	
	//added by gab 10.14.2016 SR 4016
	public String getDspBookDateFr() {
		return dspBookDateFr;
	}
	public void setDspBookDateFr(String dspBookDateFr) {
		this.dspBookDateFr = dspBookDateFr;
	}
	public String getDspBookDateTo() {
		return dspBookDateTo;
	}
	public void setDspBookDateTo(String dspBookDateTo) {
		this.dspBookDateTo = dspBookDateTo;
	}
	public String getDspIncepDateFr() {
		return dspIncepDateFr;
	}
	public void setDspIncepDateFr(String dspIncepDateFr) {
		this.dspIncepDateFr = dspIncepDateFr;
	}
	public String getDspIncepDateTo() {
		return dspIncepDateTo;
	}
	public void setDspIncepDateTo(String dspIncepDateTo) {
		this.dspIncepDateTo = dspIncepDateTo;
	}
	public String getDspIssueDateFr() {
		return dspIssueDateFr;
	}
	public void setDspIssueDateFr(String dspIssueDateFr) {
		this.dspIssueDateFr = dspIssueDateFr;
	}
	public String getDspIssueDateTo() {
		return dspIssueDateTo;
	}
	public void setDspIssueDateTo(String dspIssueDateTo) {
		this.dspIssueDateTo = dspIssueDateTo;
	}
	public String getDspAsOfDate() {
		return dspAsOfDate;
	}
	public void setDspAsOfDate(String dspAsOfDate) {
		this.dspAsOfDate = dspAsOfDate;
	}
	public String getDspCutOffDate() {
		return dspCutOffDate;
	}
	public void setDspCutOffDate(String dspCutOffDate) {
		this.dspCutOffDate = dspCutOffDate;
	}
	//end gab
	public String getIntmName() {
		return intmName;
	}
	public void setIntmName(String intmName) {
		this.intmName = intmName;
	}
	public String getAssdName() {
		return assdName;
	}
	public void setAssdName(String assdName) {
		this.assdName = assdName;
	}
	public String getIntmTypeDesc() {
		return intmTypeDesc;
	}
	public void setIntmTypeDesc(String intmTypeDesc) {
		this.intmTypeDesc = intmTypeDesc;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public Date getParamDate() {
		return paramDate;
	}
	public void setParamDate(Date paramDate) {
		this.paramDate = paramDate;
	}
	public String getReportDate() {
		return reportDate;
	}
	public void setReportDate(String reportDate) {
		this.reportDate = reportDate;
	}
	public Date getFromDate1() {
		return fromDate1;
	}
	public void setFromDate1(Date fromDate1) {
		this.fromDate1 = fromDate1;
	}
	public Date getToDate1() {
		return toDate1;
	}
	public void setToDate1(Date toDate1) {
		this.toDate1 = toDate1;
	}
	public Date getFromDate2() {
		return fromDate2;
	}
	public void setFromDate2(Date fromDate2) {
		this.fromDate2 = fromDate2;
	}
	public Date getToDate2() {
		return toDate2;
	}
	public void setToDate2(Date toDate2) {
		this.toDate2 = toDate2;
	}
	public String getDateTag() {
		return dateTag;
	}
	public void setDateTag(String dateTag) {
		this.dateTag = dateTag;
	}
	public Date getAsOfDate() {
		return asOfDate;
	}
	public void setAsOfDate(Date asOfDate) {
		this.asOfDate = asOfDate;
	}
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	public Integer getIntmNo() {
		return intmNo;
	}
	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}
	public String getIntmType() {
		return intmType;
	}
	public void setIntmType(String intmType) {
		this.intmType = intmType;
	}
	public Integer getAssdNo() {
		return assdNo;
	}
	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}
	public String getIncSpecialPol() {
		return incSpecialPol;
	}
	public void setIncSpecialPol(String incSpecialPol) {
		this.incSpecialPol = incSpecialPol;
	}
	public Date getExtractDate() {
		return extractDate;
	}
	public void setExtractDate(Date extractDate) {
		this.extractDate = extractDate;
	}
	public Integer getExtractAgingDays() {
		return extractAgingDays;
	}
	public void setExtractAgingDays(Integer extractAgingDays) {
		this.extractAgingDays = extractAgingDays;
	}
	public String getBranchParam() {
		return branchParam;
	}
	public void setBranchParam(String branchParam) {
		this.branchParam = branchParam;
	}
	public String getBookTag() {
		return bookTag;
	}
	public void setBookTag(String bookTag) {
		this.bookTag = bookTag;
	}
	public String getIncepTag() {
		return incepTag;
	}
	public void setIncepTag(String incepTag) {
		this.incepTag = incepTag;
	}
	public String getIssueTag() {
		return issueTag;
	}
	public void setIssueTag(String issueTag) {
		this.issueTag = issueTag;
	}
	public Date getBookDateFr() {
		return bookDateFr;
	}
	public void setBookDateFr(Date bookDateFr) {
		this.bookDateFr = bookDateFr;
	}
	public Date getBookDateTo() {
		return bookDateTo;
	}
	public void setBookDateTo(Date bookDateTo) {
		this.bookDateTo = bookDateTo;
	}
	public Date getIncepDateFr() {
		return incepDateFr;
	}
	public void setIncepDateFr(Date incepDateFr) {
		this.incepDateFr = incepDateFr;
	}
	public Date getIncepDateTo() {
		return incepDateTo;
	}
	public void setIncepDateTo(Date incepDateTo) {
		this.incepDateTo = incepDateTo;
	}
	public Date getIssueDateFr() {
		return issueDateFr;
	}
	public void setIssueDateFr(Date issueDateFr) {
		this.issueDateFr = issueDateFr;
	}
	public Date getIssueDateTo() {
		return issueDateTo;
	}
	public void setIssueDateTo(Date issueDateTo) {
		this.issueDateTo = issueDateTo;
	}
	public Date getCutOffDate() {
		return cutOffDate;
	}
	public void setCutOffDate(Date cutOffDate) {
		this.cutOffDate = cutOffDate;
	}
	public String getIncludePDC() {
		return includePDC;
	}
	public void setIncludePDC(String includePDC) {
		this.includePDC = includePDC;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getStrBookDateFr() {
		return strBookDateFr;
	}
	public void setStrBookDateFr(String strBookDateFr) {
		this.strBookDateFr = strBookDateFr;
	}
	public String getStrBookDateTo() {
		return strBookDateTo;
	}
	public void setStrBookDateTo(String strBookDateTo) {
		this.strBookDateTo = strBookDateTo;
	}
	public String getStrIncepDateFr() {
		return strIncepDateFr;
	}
	public void setStrIncepDateFr(String strIncepDateFr) {
		this.strIncepDateFr = strIncepDateFr;
	}
	public String getStrIncepDateTo() {
		return strIncepDateTo;
	}
	public void setStrIncepDateTo(String strIncepDateTo) {
		this.strIncepDateTo = strIncepDateTo;
	}
	public String getStrIssueDateFr() {
		return strIssueDateFr;
	}
	public void setStrIssueDateFr(String strIssueDateFr) {
		this.strIssueDateFr = strIssueDateFr;
	}
	public String getStrIssueDateTo() {
		return strIssueDateTo;
	}
	public void setStrIssueDateTo(String strIssueDateTo) {
		this.strIssueDateTo = strIssueDateTo;
	}
	public String getStrCutOffDate() {
		return strCutOffDate;
	}
	public void setStrCutOffDate(String strCutOffDate) {
		this.strCutOffDate = strCutOffDate;
	}
	public String getStrAsOfDate() {
		return strAsOfDate;
	}
	public void setStrAsOfDate(String strAsOfDate) {
		this.strAsOfDate = strAsOfDate;
	}
	public String getBranchName() {
		return branchName;
	}
	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}
	public BigDecimal getOutstandingBalance() {
		return outstandingBalance;
	}
	public void setOutstandingBalance(BigDecimal outstandingBalance) {
		this.outstandingBalance = outstandingBalance;
	}
	public String getPaytDate() {
		return paytDate;
	}
	public void setPaytDate(String paytDate) {
		this.paytDate = paytDate;
	}
	
	
}
