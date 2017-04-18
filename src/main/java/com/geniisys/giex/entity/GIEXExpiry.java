package com.geniisys.giex.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIEXExpiry extends BaseEntity{

	private Integer policyId;
	private Date expiryDate;
	private String renewFlag;
	private String lineCd;
	private String sublineCd;
	private String samePolnoSw;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String issCd;
	private String postFlag;
	private String balanceFlag;
	private String claimFlag;
	private String extractUser;
	private Date extractDate;
	private String userId;
	private Date lastUpdate;
	private Date datePrinted;
	private Integer noOfCopies;
	private String autoRenewFlag;
	private String updateFlag;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private String summarySw;
	private Date inceptDate;
	private Integer assdNo;
	private String autoSw;
	private BigDecimal taxAmt;
	private BigDecimal policyTaxAmt;
	private Integer issueYy;
	private Integer polSeqNo;
	private Integer renewNo;
	private String color;
	private String motorNo;
	private String modelYear;
	private String make;
	private String serialNo;
	private String plateNo;
	private Integer renNoticeCnt;
	private Date renNoticeDate;
	private String itemTitle;
	private String locRisk1;
	private String locRisk2;
	private String locRisk3;
	private Integer intmNo;
	private String carCompany;
	private String remarks;
	private BigDecimal origTsiAmt;
	private String smsFlag;
	private String renewalId;
	private String regPolicySw;
	private String assdSms;
	private String intmSms;
	private String emailDoc;
	private String emailSw;
	private String emailStat;
	private String assdEmail;
	private String intmEmail;
	private String nonRenReason;
	private String nonRenReasonCd;
	private Integer packPolicyId;
	private Integer riskNo;
	private Integer riskItemNo;
	private String motorCoverage;
	private BigDecimal renTsiAmt;
	private BigDecimal renPremAmt;
	private BigDecimal currencyPremAmt;
	private String policyCurrency;
	private Integer cocSerialNo;
	private String approveTag;
	private Date approveDate;
	private String printTag;
	private Date printDate;
	private Date smsDate;
	private String bankRefNo;
	
	private String policyNo;
	private String issName;
	private String lineName;
	private String sublineName;
	private String assdName;
	private BigDecimal premRenewAmt;
	private String refPolNo;
	private String expDate;
	private String fmPremAmt;
	private String fmPremRenewAmt;
	private String premTotal;
	private String premRenewTotal;
	private BigDecimal renewalCount;
	private String intmNum;
	private String dspPackLineCd;
	private String dspPackSublineCd;
	private String dspPackIssCd;
	private Integer dspPackIssueYy;
	private Integer dspPackPolSeqNo;
	private Integer dspPackRenewNo;
	private String packPolFlag;
	private Integer nbtIssueYy;
	private Integer nbtPolSeqNo;
	private Integer nbtRenewNo;
	private String nbtProrateFlag;
	private Date endtExpiryDate;
	private Date effDate;
	private BigDecimal shortRtPercent;
	private Integer provPremPct;
	private String provPremTag;
	private String dspAssdName;
	private String compSw;
	private String  isPack;
	private String buttonSw;
	private String isGpa;

	public GIEXExpiry() {
		super();
	}

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	public Date getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}
	
	public Object getStrExpiryDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (expiryDate != null) {
			return df.format(expiryDate);			
		} else {
			return null;
		}
	}

	public String getRenewFlag() {
		return renewFlag;
	}

	public void setRenewFlag(String renewFlag) {
		this.renewFlag = renewFlag;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getSublineCd() {
		return sublineCd;
	}

	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	public String getSamePolnoSw() {
		return samePolnoSw;
	}

	public void setSamePolnoSw(String samePolnoSw) {
		this.samePolnoSw = samePolnoSw;
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

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public String getPostFlag() {
		return postFlag;
	}

	public void setPostFlag(String postFlag) {
		this.postFlag = postFlag;
	}

	public String getBalanceFlag() {
		return balanceFlag;
	}

	public void setBalanceFlag(String balanceFlag) {
		this.balanceFlag = balanceFlag;
	}

	public String getClaimFlag() {
		return claimFlag;
	}

	public void setClaimFlag(String claimFlag) {
		this.claimFlag = claimFlag;
	}

	public String getExtractUser() {
		return extractUser;
	}

	public void setExtractUser(String extractUser) {
		this.extractUser = extractUser;
	}

	public Date getExtractDate() {
		return extractDate;
	}

	public void setExtractDate(Date extractDate) {
		this.extractDate = extractDate;
	}
	
	public Object getStrExtractDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (extractDate != null) {
			return df.format(extractDate);			
		} else {
			return null;
		}
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
	
	public Object getStrLastDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (lastUpdate != null) {
			return df.format(lastUpdate);			
		} else {
			return null;
		}
	}

	public Date getDatePrinted() {
		return datePrinted;
	}

	public void setDatePrinted(Date datePrinted) {
		this.datePrinted = datePrinted;
	}
	
	public Object getStrDatePrinted() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (datePrinted != null) {
			return df.format(datePrinted);			
		} else {
			return null;
		}
	}

	public Integer getNoOfCopies() {
		return noOfCopies;
	}

	public void setNoOfCopies(Integer noOfCopies) {
		this.noOfCopies = noOfCopies;
	}

	public String getAutoRenewFlag() {
		return autoRenewFlag;
	}

	public void setAutoRenewFlag(String autoRenewFlag) {
		this.autoRenewFlag = autoRenewFlag;
	}

	public String getUpdateFlag() {
		return updateFlag;
	}

	public void setUpdateFlag(String updateFlag) {
		this.updateFlag = updateFlag;
	}

	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}

	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}

	public BigDecimal getPremAmt() {
		return premAmt;
	}

	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}

	public String getSummarySw() {
		return summarySw;
	}

	public void setSummarySw(String summarySw) {
		this.summarySw = summarySw;
	}

	public Date getInceptDate() {
		return inceptDate;
	}

	public void setInceptDate(Date inceptDate) {
		this.inceptDate = inceptDate;
	}
	
	public Object getStrInceptDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (inceptDate != null) {
			return df.format(inceptDate);			
		} else {
			return null;
		}
	}

	public Integer getAssdNo() {
		return assdNo;
	}

	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}

	public String getAutoSw() {
		return autoSw;
	}

	public void setAutoSw(String autoSw) {
		this.autoSw = autoSw;
	}

	public BigDecimal getTaxAmt() {
		return taxAmt;
	}

	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}

	public BigDecimal getPolicyTaxAmt() {
		return policyTaxAmt;
	}

	public void setPolicyTaxAmt(BigDecimal policyTaxAmt) {
		this.policyTaxAmt = policyTaxAmt;
	}

	public Integer getIssueYy() {
		return issueYy;
	}

	public void setIssueYy(Integer issueYy) {
		this.issueYy = issueYy;
	}

	public Integer getPolSeqNo() {
		return polSeqNo;
	}

	public void setPolSeqNo(Integer polSeqNo) {
		this.polSeqNo = polSeqNo;
	}

	public Integer getRenewNo() {
		return renewNo;
	}

	public void setRenewNo(Integer renewNo) {
		this.renewNo = renewNo;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public String getMotorNo() {
		return motorNo;
	}

	public void setMotorNo(String motorNo) {
		this.motorNo = motorNo;
	}

	public String getModelYear() {
		return modelYear;
	}

	public void setModelYear(String modelYear) {
		this.modelYear = modelYear;
	}

	public String getMake() {
		return make;
	}

	public void setMake(String make) {
		this.make = make;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getPlateNo() {
		return plateNo;
	}

	public void setPlateNo(String plateNo) {
		this.plateNo = plateNo;
	}

	public Integer getRenNoticeCnt() {
		return renNoticeCnt;
	}

	public void setRenNoticeCnt(Integer renNoticeCnt) {
		this.renNoticeCnt = renNoticeCnt;
	}

	public Date getRenNoticeDate() {
		return renNoticeDate;
	}

	public void setRenNoticeDate(Date renNoticeDate) {
		this.renNoticeDate = renNoticeDate;
	}
	
	public Object getStrRenNoticeDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (renNoticeDate != null) {
			return df.format(renNoticeDate);			
		} else {
			return null;
		}
	}

	public String getItemTitle() {
		return itemTitle;
	}

	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}

	public String getLocRisk1() {
		return locRisk1;
	}

	public void setLocRisk1(String locRisk1) {
		this.locRisk1 = locRisk1;
	}

	public String getLocRisk2() {
		return locRisk2;
	}

	public void setLocRisk2(String locRisk2) {
		this.locRisk2 = locRisk2;
	}

	public String getLocRisk3() {
		return locRisk3;
	}

	public void setLocRisk3(String locRisk3) {
		this.locRisk3 = locRisk3;
	}

	public Integer getIntmNo() {
		return intmNo;
	}

	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}

	public String getCarCompany() {
		return carCompany;
	}

	public void setCarCompany(String carCompany) {
		this.carCompany = carCompany;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public BigDecimal getOrigTsiAmt() {
		return origTsiAmt;
	}

	public void setOrigTsiAmt(BigDecimal origTsiAmt) {
		this.origTsiAmt = origTsiAmt;
	}

	public String getSmsFlag() {
		return smsFlag;
	}

	public void setSmsFlag(String smsFlag) {
		this.smsFlag = smsFlag;
	}

	public String getRenewalId() {
		return renewalId;
	}

	public void setRenewalId(String renewalId) {
		this.renewalId = renewalId;
	}

	public String getRegPolicySw() {
		return regPolicySw;
	}

	public void setRegPolicySw(String regPolicySw) {
		this.regPolicySw = regPolicySw;
	}

	public String getAssdSms() {
		return assdSms;
	}

	public void setAssdSms(String assdSms) {
		this.assdSms = assdSms;
	}

	public String getIntmSms() {
		return intmSms;
	}

	public void setIntmSms(String intmSms) {
		this.intmSms = intmSms;
	}

	public String getEmailDoc() {
		return emailDoc;
	}

	public void setEmailDoc(String emailDoc) {
		this.emailDoc = emailDoc;
	}

	public String getEmailSw() {
		return emailSw;
	}

	public void setEmailSw(String emailSw) {
		this.emailSw = emailSw;
	}

	public String getEmailStat() {
		return emailStat;
	}

	public void setEmailStat(String emailStat) {
		this.emailStat = emailStat;
	}

	public String getAssdEmail() {
		return assdEmail;
	}

	public void setAssdEmail(String assdEmail) {
		this.assdEmail = assdEmail;
	}

	public String getIntmEmail() {
		return intmEmail;
	}

	public void setIntmEmail(String intmEmail) {
		this.intmEmail = intmEmail;
	}

	public String getNonRenReason() {
		return nonRenReason;
	}

	public void setNonRenReason(String nonRenReason) {
		this.nonRenReason = nonRenReason;
	}

	public String getNonRenReasonCd() {
		return nonRenReasonCd;
	}

	public void setNonRenReasonCd(String nonRenReasonCd) {
		this.nonRenReasonCd = nonRenReasonCd;
	}

	public Integer getPackPolicyId() {
		return packPolicyId;
	}

	public void setPackPolicyId(Integer packPolicyId) {
		this.packPolicyId = packPolicyId;
	}

	public Integer getRiskNo() {
		return riskNo;
	}

	public void setRiskNo(Integer riskNo) {
		this.riskNo = riskNo;
	}

	public Integer getRiskItemNo() {
		return riskItemNo;
	}

	public void setRiskItemNo(Integer riskItemNo) {
		this.riskItemNo = riskItemNo;
	}

	public String getMotorCoverage() {
		return motorCoverage;
	}

	public void setMotorCoverage(String motorCoverage) {
		this.motorCoverage = motorCoverage;
	}

	public BigDecimal getRenTsiAmt() {
		return renTsiAmt;
	}

	public void setRenTsiAmt(BigDecimal renTsiAmt) {
		this.renTsiAmt = renTsiAmt;
	}

	public BigDecimal getRenPremAmt() {
		return renPremAmt;
	}

	public void setRenPremAmt(BigDecimal renPremAmt) {
		this.renPremAmt = renPremAmt;
	}

	public BigDecimal getCurrencyPremAmt() {
		return currencyPremAmt;
	}

	public void setCurrencyPremAmt(BigDecimal currencyPremAmt) {
		this.currencyPremAmt = currencyPremAmt;
	}

	public String getPolicyCurrency() {
		return policyCurrency;
	}

	public void setPolicyCurrency(String policyCurrency) {
		this.policyCurrency = policyCurrency;
	}

	public Integer getCocSerialNo() {
		return cocSerialNo;
	}

	public void setCocSerialNo(Integer cocSerialNo) {
		this.cocSerialNo = cocSerialNo;
	}

	public String getApproveTag() {
		return approveTag;
	}

	public void setApproveTag(String approveTag) {
		this.approveTag = approveTag;
	}

	public Date getApproveDate() {
		return approveDate;
	}

	public void setApproveDate(Date approveDate) {
		this.approveDate = approveDate;
	}
	
	public Object getStrApproveDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (approveDate != null) {
			return df.format(approveDate);			
		} else {
			return null;
		}
	}

	public String getPrintTag() {
		return printTag;
	}

	public void setPrintTag(String printTag) {
		this.printTag = printTag;
	}

	public Date getPrintDate() {
		return printDate;
	}

	public void setPrintDate(Date printDate) {
		this.printDate = printDate;
	}
	
	public Object getStrPrintDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (printDate != null) {
			return df.format(printDate);			
		} else {
			return null;
		}
	}

	public Date getSmsDate() {
		return smsDate;
	}

	public void setSmsDate(Date smsDate) {
		this.smsDate = smsDate;
	}
	
	public Object getStrSmsDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (smsDate != null) {
			return df.format(smsDate);			
		} else {
			return null;
		}
	}

	public String getBankRefNo() {
		return bankRefNo;
	}

	public void setBankRefNo(String bankRefNo) {
		this.bankRefNo = bankRefNo;
	}

	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}

	public String getPolicyNo() {
		return policyNo;
	}

	public void setIssName(String issName) {
		this.issName = issName;
	}

	public String getIssName() {
		return issName;
	}

	public void setLineName(String lineName) {
		this.lineName = lineName;
	}

	public String getLineName() {
		return lineName;
	}

	public void setSublineName(String sublineName) {
		this.sublineName = sublineName;
	}

	public String getSublineName() {
		return sublineName;
	}

	public void setAssdName(String assdName) {
		this.assdName = assdName;
	}

	public String getAssdName() {
		return assdName;
	}

	public void setPremRenewAmt(BigDecimal premRenewAmt) {
		this.premRenewAmt = premRenewAmt;
	}

	public BigDecimal getPremRenewAmt() {
		return premRenewAmt;
	}

	public void setRefPolNo(String refPolNo) {
		this.refPolNo = refPolNo;
	}

	public String getRefPolNo() {
		return refPolNo;
	}

	public void setExpDate(String expDate) {
		this.expDate = expDate;
	}

	public String getExpDate() {
		return expDate;
	}
	
	public String getFmPremAmt() {
		return fmPremAmt;
	}

	public void setFmPremAmt(String fmPremAmt) {
		this.fmPremAmt = fmPremAmt;
	}

	public String getFmPremRenewAmt() {
		return fmPremRenewAmt;
	}

	public void setFmPremRenewAmt(String fmPremRenewAmt) {
		this.fmPremRenewAmt = fmPremRenewAmt;
	}

	public String getPremTotal() {
		return premTotal;
	}

	public void setPremTotal(String premTotal) {
		this.premTotal = premTotal;
	}

	public String getPremRenewTotal() {
		return premRenewTotal;
	}

	public void setPremRenewTotal(String premRenewTotal) {
		this.premRenewTotal = premRenewTotal;
	}

	public BigDecimal getRenewalCount() {
		return renewalCount;
	}

	public void setRenewalCount(BigDecimal renewalCount) {
		this.renewalCount = renewalCount;
	}

	public String getIntmNum() {
		return intmNum;
	}

	public void setIntmNum(String intmNum) {
		this.intmNum = intmNum;
	}

	public String getDspPackLineCd() {
		return dspPackLineCd;
	}

	public void setDspPackLineCd(String dspPackLineCd) {
		this.dspPackLineCd = dspPackLineCd;
	}

	public String getDspPackSublineCd() {
		return dspPackSublineCd;
	}

	public void setDspPackSublineCd(String dspPackSublineCd) {
		this.dspPackSublineCd = dspPackSublineCd;
	}

	public String getDspPackIssCd() {
		return dspPackIssCd;
	}

	public void setDspPackIssCd(String dspPackIssCd) {
		this.dspPackIssCd = dspPackIssCd;
	}

	public Integer getDspPackIssueYy() {
		return dspPackIssueYy;
	}

	public void setDspPackIssueYy(Integer dspPackIssueYy) {
		this.dspPackIssueYy = dspPackIssueYy;
	}

	public Integer getDspPackPolSeqNo() {
		return dspPackPolSeqNo;
	}

	public void setDspPackPolSeqNo(Integer dspPackPolSeqNo) {
		this.dspPackPolSeqNo = dspPackPolSeqNo;
	}

	public Integer getDspPackRenewNo() {
		return dspPackRenewNo;
	}

	public void setDspPackRenewNo(Integer dspPackRenewNo) {
		this.dspPackRenewNo = dspPackRenewNo;
	}

	public String getPackPolFlag() {
		return packPolFlag;
	}

	public void setPackPolFlag(String packPolFlag) {
		this.packPolFlag = packPolFlag;
	}

	public Integer getNbtIssueYy() {
		return nbtIssueYy;
	}

	public void setNbtIssueYy(Integer nbtIssueYy) {
		this.nbtIssueYy = nbtIssueYy;
	}

	public Integer getNbtPolSeqNo() {
		return nbtPolSeqNo;
	}

	public void setNbtPolSeqNo(Integer nbtPolSeqNo) {
		this.nbtPolSeqNo = nbtPolSeqNo;
	}

	public Integer getNbtRenewNo() {
		return nbtRenewNo;
	}

	public void setNbtRenewNo(Integer nbtRenewNo) {
		this.nbtRenewNo = nbtRenewNo;
	}

	public String getNbtProrateFlag() {
		return nbtProrateFlag;
	}

	public void setNbtProrateFlag(String nbtProrateFlag) {
		this.nbtProrateFlag = nbtProrateFlag;
	}

	public Date getEndtExpiryDate() {
		return endtExpiryDate;
	}

	public void setEndtExpiryDate(Date endtExpiryDate) {
		this.endtExpiryDate = endtExpiryDate;
	}
	
	public Object getStrEndtExpiryDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (endtExpiryDate != null) {
			return df.format(endtExpiryDate);			
		} else {
			return null;
		}
	}

	public Date getEffDate() {
		return effDate;
	}

	public void setEffDate(Date effDate) {
		this.effDate = effDate;
	}
	
	public Object getStrEffDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (effDate != null) {
			return df.format(effDate);			
		} else {
			return null;
		}
	}

	public BigDecimal getShortRtPercent() {
		return shortRtPercent;
	}

	public void setShortRtPercent(BigDecimal shortRtPercent) {
		this.shortRtPercent = shortRtPercent;
	}

	public Integer getProvPremPct() {
		return provPremPct;
	}

	public void setProvPremPct(Integer provPremPct) {
		this.provPremPct = provPremPct;
	}

	public String getProvPremTag() {
		return provPremTag;
	}

	public void setProvPremTag(String provPremTag) {
		this.provPremTag = provPremTag;
	}

	public String getDspAssdName() {
		return dspAssdName;
	}

	public void setDspAssdName(String dspAssdName) {
		this.dspAssdName = dspAssdName;
	}

	public String getCompSw() {
		return compSw;
	}

	public void setCompSw(String compSw) {
		this.compSw = compSw;
	}

	public String getIsPack() {
		return isPack;
	}

	public void setIsPack(String isPack) {
		this.isPack = isPack;
	}

	public String getButtonSw() {
		return buttonSw;
	}

	public void setButtonSw(String buttonSw) {
		this.buttonSw = buttonSw;
	}

	public String getIsGpa() {
		return isGpa;
	}

	public void setIsGpa(String isGpa) {
		this.isGpa = isGpa;
	}
	
}
