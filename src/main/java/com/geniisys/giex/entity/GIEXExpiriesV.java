package com.geniisys.giex.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIEXExpiriesV extends BaseEntity{
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
	private BigDecimal renTsiAmt;
	private BigDecimal renPremAmt;
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
	private String carCompany;
	private Integer intmNo;
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
	private Integer cocSerialNo;
	private String nonRenReasonCd;
	private Integer packPolicyId;
	private String isPackage;
	
	private String policyNo;
	private BigDecimal dspPrem;
	private BigDecimal dspTsi;
	private BigDecimal dspOrigPrem;
	private BigDecimal dspOrigTsi;
	private String distSw;
	private String parNo;
	
	private String expiryFlag;
	private String dspAssured;
	private String nbtReassignmentSw;
	private String expiryDateString;
	private String extractDateString;
	
	public GIEXExpiriesV() {
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

	public Date getDatePrinted() {
		return datePrinted;
	}

	public void setDatePrinted(Date datePrinted) {
		this.datePrinted = datePrinted;
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

	public String getCarCompany() {
		return carCompany;
	}

	public void setCarCompany(String carCompany) {
		this.carCompany = carCompany;
	}

	public Integer getIntmNo() {
		return intmNo;
	}

	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
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

	public Integer getCocSerialNo() {
		return cocSerialNo;
	}

	public void setCocSerialNo(Integer cocSerialNo) {
		this.cocSerialNo = cocSerialNo;
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

	public String getIsPackage() {
		return isPackage;
	}

	public void setIsPackage(String isPackage) {
		this.isPackage = isPackage;
	}

	public String getPolicyNo() {
		return policyNo;
	}

	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}

	public BigDecimal getDspPrem() {
		return dspPrem;
	}

	public void setDspPrem(BigDecimal dspPrem) {
		this.dspPrem = dspPrem;
	}

	public BigDecimal getDspTsi() {
		return dspTsi;
	}

	public void setDspTsi(BigDecimal dspTsi) {
		this.dspTsi = dspTsi;
	}

	public BigDecimal getDspOrigPrem() {
		return dspOrigPrem;
	}

	public void setDspOrigPrem(BigDecimal dspOrigPrem) {
		this.dspOrigPrem = dspOrigPrem;
	}

	public BigDecimal getDspOrigTsi() {
		return dspOrigTsi;
	}

	public void setDspOrigTsi(BigDecimal dspOrigTsi) {
		this.dspOrigTsi = dspOrigTsi;
	}

	public void setDistSw(String distSw) {
		this.distSw = distSw;
	}

	public String getDistSw() {
		return distSw;
	}

	public void setParNo(String parNo) {
		this.parNo = parNo;
	}

	public String getParNo() {
		return parNo;
	}

	public void setExpiryFlag(String expiryFlag) {
		this.expiryFlag = expiryFlag;
	}

	public String getExpiryFlag() {
		return expiryFlag;
	}

	public void setDspAssured(String dspAssured) {
		this.dspAssured = dspAssured;
	}

	public String getDspAssured() {
		return dspAssured;
	}

	public void setNbtReassignmentSw(String nbtReassignmentSw) {
		this.nbtReassignmentSw = nbtReassignmentSw;
	}

	public String getNbtReassignmentSw() {
		return nbtReassignmentSw;
	}

	public void setExpiryDateString(String expiryDateString) {
		this.expiryDateString = expiryDateString;
	}

	public String getExpiryDateString() {
		return expiryDateString;
	}

	public void setExtractDateString(String extractDateString) {
		this.extractDateString = extractDateString;
	}

	public String getExtractDateString() {
		return extractDateString;
	}
	
}
