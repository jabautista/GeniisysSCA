/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	GICLS024
 * Created By	:	rencela
 * Create Date	:	Oct 15, 2010
 ***************************************************/
package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;

import com.geniisys.framework.util.BaseEntity;

public class GICLClaims extends BaseEntity{
	private Integer 	accountOfCode;
	private String	 	assuredName;
	private String 		assuredName2;
	private Integer 	assuredNo;
	private Integer 	blockId;
	private Integer 	catastrophicCode;
	private String 		cityCode;
	private Integer 	claimId;
	private BigDecimal 	claimAmount;
	private String 		claimControl;
	private String 		claimCoop;
	private String 		claimDistTag;
	private Date 		claimFileDate;
	private String 		strClaimFileDate;
	private Integer 	claimSequenceNo;
	private Date 		claimSettlementDate;
	private String 		claimStatusCd;
	private Integer 	claimYy;
	private Date 		closeDate;
	private String 		contactNumber;
	private String 		cpiBranchCd;
	private Integer 	cpiRecNo;
	private String 		creditBranch;
	private Integer 	csrNo;
	private String 		defProcessor;
	private String 		districtNumber;
	private String 		districtNo;
	private Date 		dspLossDate;
	private String 		emailAddress;
	private Date 		entryDate;
	private Date 		expiryDate;
	private BigDecimal 	expPaidAmount;
	private BigDecimal 	expenseResAmount;
	private Integer 	intermediaryNo;
	private String 		inHouseAdjustment;
	private Integer 	issueYy;
	private String 		issueCode;
	private String 		issCd;
	private Date 		userLastUpdate;
	private String 		lineCode;
	private String		lineName;
	private Integer 	locationCode;
	private String 		lossCatCd;
	private Date		lossDate;
	private String 		lossDetails;
	private String 		lossLocation1;
	private String 		lossLocation2;
	private String 		lossLocation3;
	private BigDecimal 	lossPaidAmount;
	private BigDecimal 	lossResAmount;
	private Integer 	maxEndorsementSequenceNumber;
	private String 		motorNumber;
	private BigDecimal 	netPaidExpense;
	private BigDecimal 	netPaidLoss;
	private Integer 	obligeeNo;
	private String 		oldStatCd;
	private Integer		packPolicyId;
	private String 		plateNumber;
	private Date 		policyEffectivityDate;
	private String 		policyIssueCode;
	private Integer 	policySequenceNo;
	private String 		provinceCode;
	private String 		reasonCode;
	private String 		recoverySw;
	private String 		refreshSw;
	private String 		remarks;
	private Integer 	renewNo;
	private String 		reportedBy;
	private Integer	 	riCd;
	private String 		serialNumber;
	private Integer		settlingAgentCode;
	private String 		specialInstructions;
	private String 		sublineCd;
	private Integer	 	surveyAgentCode;
	private String 		totalTag;
	private Integer 	transactionNo;
	private String		userId;
	private String 		zipCode;
	private Date		polEffDate;
	private Integer 	catastrophicCd;
	private Integer		perilCd;
	private String 		lineCd;
	
	// properties not present in gicl_claims table
	private BigDecimal 	paidAmount;
	private String 		claimNumber;
	private String 		claimStatDesc;
	private String		packPolicy;
	private String		nbtClmStatCd;
	
	private String		clmStatDesc;
	private String		dspRiName;
	private String		dspCityDesc;
	private String		dspProvinceDesc;
	private String 		dspCatDesc;
	private String 		dspLossCatDesc;
	private Date 		dspLossTime;
	private String 		dspInHouAdjName;
	private String 		dspCredBrDesc;
	private String 		packPolFlag;
	private String 	    blockNo;
	private String		packPolNo;
	private Date		issueDate;
	private String		redistSw;
	private Date		inceptDate;
	private String 		opNumber;
	private String 		itemNo;
	
	private String 		policyNo;
	private Integer     polRenewNo;
	private String 		lossCtgry;
	private String 		giclMortgageeExist;
	private String 		giclItemPerilExist;
	private String		giclClmItemExist;
	private String		giclClmReserveExist;
	private String		dspSettlingName;
	private String 		dspSurveyName;
	
	private String		billAddress;
	private String		lossCatDes;
	private String 		mortgName;
	private String 		intmName;
	private String		prelimIssueDate;
	private String		prelimInceptDate;
	private String		prelimExpiryDate;
	private String 		prelimLossDate;
	private String		prelimClmFileDate;
	private String		riName;
	private BigDecimal	shrRiTsiPct;
	private BigDecimal	shrRiTsiAmt;
	private BigDecimal	shrRiTsiAmt2;
	private BigDecimal	shrRiPct;
	private BigDecimal	riResAmt;
	private BigDecimal	riResAmt2;
	private Integer		groupedItemNo;
	private Integer		reserveItemNo;
	private Integer		grpSeqNo;
	
	private Integer		adviceId;
	private String		adviceNo;
	private String		claimNo;
	private String 		itemLimit;
	
	private String		dspAcctOf;
	private String		strPolEffDate;
	private Integer		policyId;
	private String		dspLocationDesc;
	
	private String		polFlag;
	private String 		clmSetld;
	private String 		adviceExist;
	private String 		paytSw;
	private String 		chkPayment;
	private String 		withRecovery;
	private String		assignee;
	private String      dspAcctOfCdName;
	private String 		dspCatastrophicDesc;
	private String		basicIntmSw;
	
	//added by Kenneth L.
	private String 		assdName;
	private String		claimStatus;
	private String 		plateNo;
	private String 		inHouAdj;
	
	private String 		reasonDesc; //Kenneth SR 5147 11.05.2015
	
	private String lossDateStr;
	
	public GICLClaims(){
	}
	
	/**
	 * For Testing...
	 */
	public void displayDetailsInConsole(){
		System.out.println("claimId     - " + claimId);
		System.out.println("claimSeqNo  - " + claimSequenceNo);
		System.out.println("claimYy     - " + claimYy);
		System.out.println("claimControl- " + claimControl);
		System.out.println("claimCoop   - " + claimCoop);
		System.out.println("claimFilDate- " + claimFileDate);
		System.out.println("claimSettDat- " + claimSettlementDate);
		System.out.println("claimStatus - " + claimStatusCd);
		System.out.println("claimStatDe - " + clmStatDesc);
		System.out.println("lineCode    - " + lineCode);
		System.out.println("issueCode   - " + issueCode);
		System.out.println("sublineCode - " + sublineCd);
		System.out.println("issueYy     - " + issueYy);
		System.out.println("policySeqNo - " + policySequenceNo);
		System.out.println("policyIssCd - " + policyIssueCode);
		System.out.println("policyEffDat- " + policyEffectivityDate);
		System.out.println("dspLossDate - " + dspLossDate);
		System.out.println("lossDate    - " + lossDate);
		System.out.println("lossDetails - " + lossDetails);
		System.out.println("lossPaidAmt - " + lossPaidAmount);
		System.out.println("lossResAmt  - " + lossResAmount);
		System.out.println("lossLoc1    - " + lossLocation1);
		System.out.println("lossLoc2    - " + lossLocation2);
		System.out.println("lossLoc3    - " + lossLocation3);
		System.out.println("renewNo     - " + renewNo);
	}
	
	public String getDspAcctOf() {
		return dspAcctOf;
	}

	public void setDspAcctOf(String dspAcctOf) {
		this.dspAcctOf = dspAcctOf;
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
	
	public String getLineName() {
		return lineName;
	}

	public void setLineName(String lineName) {
		this.lineName = lineName;
	}

	public String getDspLocationDesc() {
		return dspLocationDesc;
	}

	public void setDspLocationDesc(String dspLocationDesc) {
		this.dspLocationDesc = dspLocationDesc;
	}
	public String getSublineCd() {
		return sublineCd;
	}

	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	public Integer getIssueYy() {
		return issueYy;
	}

	public void setIssueYy(Integer issueYy) {
		this.issueYy = issueYy;
	}

	public Integer getPolicySequenceNo() {
		return policySequenceNo;
	}

	public void setPolicySequenceNo(Integer policySequenceNo) {
		this.policySequenceNo = policySequenceNo;
	}

	public Integer getRenewNo() {
		return renewNo;
	}

	public void setRenewNo(Integer renewNo) {
		this.renewNo = renewNo;
	}

	public String getPolicyIssueCode() {
		return policyIssueCode;
	}

	public void setPolicyIssueCode(String policyIssueCode) {
		this.policyIssueCode = policyIssueCode;
	}

	public Integer getClaimYy() {
		return claimYy;
	}

	public void setClaimYy(Integer claimYy) {
		this.claimYy = claimYy;
	}

	public Integer getClaimSequenceNo() {
		return claimSequenceNo;
	}

	public void setClaimSequenceNo(Integer claimSequenceNo) {
		this.claimSequenceNo = claimSequenceNo;
	}

	public String getClaimControl() {
		return claimControl;
	}

	public void setClaimControl(String claimControl) {
		this.claimControl = claimControl;
	}

	public String getClaimCoop() {
		return claimCoop;
	}

	public void setClaimCoop(String claimCoop) {
		this.claimCoop = claimCoop;
	}

	public Integer getAssuredNo() {
		return assuredNo;
	}

	public void setAssuredNo(Integer assuredNo) {
		this.assuredNo = assuredNo;
	}

	public String getRecoverySw() {
		return recoverySw;
	}

	public void setRecoverySw(String recoverySw) {
		this.recoverySw = recoverySw;
	}

	/**
	 * Get String formatted clmFileDate
	 * @return
	 */
	public Object getStrClaimFileDate() { 
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (claimFileDate != null) {
			return df.format(claimFileDate);			
		} else {
			return null;
		}
	}
	
	public Object getStrClaimFileDate2() { 
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (claimFileDate != null) {
			return df.format(claimFileDate);			
		} else {
			return null;
		}
	}
	
	public Date getClaimFileDate(){ 
		return claimFileDate;
	}

	public void setClaimFileDate(Date claimFileDate) {
		this.claimFileDate = claimFileDate;
	}
	
	
	public Object getStrLossDate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (lossDate != null) {
			return df.format(lossDate);
		} else {
			return null;
		}
	}
	
	public Object getStrLossDate2() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (lossDate != null) {
			return df.format(lossDate);			
		} else {
			return null;
		}
	}
	
	public Date getLossDate() {
		return lossDate;
	}
	
	public void setLossDate(Date lossDate) {
		this.lossDate = lossDate;
	}

	public Object getStrEntryDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (entryDate != null) {
			return df.format(entryDate);			
		} else {
			return null;
		}
	}
	
	public Date getEntryDate() {
		return entryDate;
	}

	public void setEntryDate(Date entryDate) {
		this.entryDate = entryDate;
	}

	public Object getStrDspLossDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (dspLossDate != null) {
			return df.format(dspLossDate);			
		} else {
			return null;
		}
	}
	
	public Object getStrDspLossDate2() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (dspLossDate != null) {
			return df.format(dspLossDate);			
		} else {
			return null;
		}
	}
	
	public Date getDspLossDate() {
		return dspLossDate;
	}

	public void setDspLossDate(Date dspLossDate) {
		this.dspLossDate = dspLossDate;
	}

	public String getClaimStatusCd() {
		return claimStatusCd;
	}

	public void setClaimStatusCd(String claimStatusCd) {
		this.claimStatusCd = claimStatusCd;
	}

	public Object getStrClaimSettlementDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (claimSettlementDate != null) {
			return df.format(claimSettlementDate);			
		} else {
			return null;
		}
	}
	
	public Date getClaimSettlementDate() {
		return claimSettlementDate;
	}

	public void setClaimSettlementDate(Date claimSettlementDate) {
		this.claimSettlementDate = claimSettlementDate;
	}

	public BigDecimal getLossPaidAmount() {
		return lossPaidAmount;
	}

	public void setLossPaidAmount(BigDecimal lossPaidAmount) {
		this.lossPaidAmount = lossPaidAmount;
	}

	public BigDecimal getLossResAmount() {
		return lossResAmount;
	}

	public void setLossResAmount(BigDecimal lossResAmount) {
		this.lossResAmount = lossResAmount;
	}

	public BigDecimal getExpPaidAmount() {
		return expPaidAmount;
	}

	public void setExpPaidAmount(BigDecimal expPaidAmount) {
		this.expPaidAmount = expPaidAmount;
	}

	public String getLossLocation1() {
		return lossLocation1;
	}

	public void setLossLocation1(String lossLocation1) {
		this.lossLocation1 = lossLocation1;
	}

	public String getLossLocation2() {
		return lossLocation2;
	}

	public void setLossLocation2(String lossLocation2) {
		this.lossLocation2 = lossLocation2;
	}

	public String getLossLocation3() {
		return lossLocation3;
	}

	public void setLossLocation3(String lossLocation3) {
		this.lossLocation3 = lossLocation3;
	}

	public String getInHouseAdjustment() {
		return inHouseAdjustment;
	}

	public void setInHouseAdjustment(String inHouseAdjustment) {
		this.inHouseAdjustment = inHouseAdjustment;
	}

	public Object getStrPolicyEffectivityDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (policyEffectivityDate != null) {
			return df.format(policyEffectivityDate);			
		} else {
			return null;
		}
	}
	
	public Object getStrPolicyEffectivityDate2() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (policyEffectivityDate != null) {
			return df.format(policyEffectivityDate);			
		} else {
			return null;
		}
	}
	
	public Date getPolicyEffectivityDate() {
		return policyEffectivityDate;
	}

	public void setPolicyEffectivityDate(Date policyEffectivityDate) {
		this.policyEffectivityDate = policyEffectivityDate;
	}

	public Integer getCsrNo() {
		return csrNo;
	}

	public void setCsrNo(Integer csrNo) {
		this.csrNo = csrNo;
	}

	public String getLossCatCd() {
		return lossCatCd;
	}

	public void setLossCatCd(String lossCatCd) {
		this.lossCatCd = lossCatCd;
	}

	public Integer getIntermediaryNo() {
		return intermediaryNo;
	}

	public void setIntermediaryNo(Integer intermediaryNo) {
		this.intermediaryNo = intermediaryNo;
	}

	public BigDecimal getClaimAmount() {
		return claimAmount;
	}

	public void setClaimAmount(BigDecimal claimAmount) {
		this.claimAmount = claimAmount;
	}

	public String getLossDetails() {
		return lossDetails;
	}

	public void setLossDetails(String lossDetails) {
		this.lossDetails = lossDetails;
	}

	public Integer getObligeeNo() {
		return obligeeNo;
	}

	public void setObligeeNo(Integer obligeeNo) {
		this.obligeeNo = obligeeNo;
	}

	public BigDecimal getExpenseResAmount() {
		return expenseResAmount;
	}

	public void setExpenseResAmount(BigDecimal expenseResAmount) {
		this.expenseResAmount = expenseResAmount;
	}

	public String getAssuredName() {
		return assuredName;
	}

	public void setAssuredName(String assuredName) {
		this.assuredName = assuredName;
	}

	public Integer getRiCd() {
		return riCd;
	}

	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}

	public String getPlateNumber() {
		return plateNumber;
	}

	public void setPlateNumber(String plateNumber) {
		this.plateNumber = plateNumber;
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

	public String getClaimDistTag() {
		return claimDistTag;
	}

	public void setClaimDistTag(String claimDistTag) {
		this.claimDistTag = claimDistTag;
	}

	public String getAssuredName2() {
		return assuredName2;
	}

	public void setAssuredName2(String assuredName2) {
		this.assuredName2 = assuredName2;
	}

	public String getOldStatCd() {
		return oldStatCd;
	}

	public void setOldStatCd(String oldStatCd) {
		this.oldStatCd = oldStatCd;
	}

	public Date getCloseDate() {
		return closeDate;
	}

	public void setCloseDate(Date closeDate) {
		this.closeDate = closeDate;
	}
	
	public Object getStrCloseDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (closeDate != null) {
			return df.format(closeDate);			
		} else {
			return null;
		}
	}

	public Object getStrExpiryDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (expiryDate != null) {
			return df.format(expiryDate);			
		} else {
			return null;
		}
	}
	
	public Object getStrExpiryDate2() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (expiryDate != null) {
			return df.format(expiryDate);			
		} else {
			return null;
		}
	}
	
	public Date getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}

	public Integer getAccountOfCode() {
		return accountOfCode;
	}

	public void setAccountOfCode(Integer accountOfCode) {
		this.accountOfCode = accountOfCode;
	}

	public Integer getMaxEndorsementSequenceNumber() {
		return maxEndorsementSequenceNumber;
	}

	public void setMaxEndorsementSequenceNumber(
			Integer maxEndorsementSequenceNumber) {
		this.maxEndorsementSequenceNumber = maxEndorsementSequenceNumber;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public Integer getCatastrophicCode() {
		return catastrophicCode;
	}

	public void setCatastrophicCode(Integer catastrophicCode) {
		this.catastrophicCode = catastrophicCode;
	}

	public String getCreditBranch() {
		return creditBranch;
	}

	public void setCreditBranch(String creditBranch) {
		this.creditBranch = creditBranch;
	}

	public BigDecimal getNetPaidLoss() {
		return netPaidLoss;
	}

	public void setNetPaidLoss(BigDecimal netPaidLoss) {
		this.netPaidLoss = netPaidLoss;
	}

	public BigDecimal getNetPaidExpense() {
		return netPaidExpense;
	}

	public void setNetPaidExpense(BigDecimal netPaidExpense) {
		this.netPaidExpense = netPaidExpense;
	}

	public String getRefreshSw() {
		return refreshSw;
	}

	public void setRefreshSw(String refreshSw) {
		this.refreshSw = refreshSw;
	}

	public String getTotalTag() {
		return totalTag;
	}

	public void setTotalTag(String totalTag) {
		this.totalTag = totalTag;
	}

	public Integer getTransactionNo() {
		return transactionNo;
	}

	public void setTransactionNo(Integer transactionNo) {
		this.transactionNo = transactionNo;
	}

	public String getContactNumber() {
		return contactNumber;
	}

	public void setContactNumber(String contactNumber) {
		this.contactNumber = contactNumber;
	}

	public String getEmailAddress() {
		return emailAddress;
	}

	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
	}

	public String getSpecialInstructions() {
		return specialInstructions;
	}

	public void setSpecialInstructions(String specialInstructions) {
		this.specialInstructions = specialInstructions;
	}

	public String getReasonCode() {
		return reasonCode;
	}

	public void setReasonCode(String reasonCode) {
		this.reasonCode = reasonCode;
	}

	public String getDefProcessor() {
		return defProcessor;
	}

	public void setDefProcessor(String defProcessor) {
		this.defProcessor = defProcessor;
	}

	public Integer getPackPolicyId() {
		return packPolicyId;
	}

	public void setPackPolicyId(Integer packPolicyId) {
		this.packPolicyId = packPolicyId;
	}

	public String getProvinceCode() {
		return provinceCode;
	}

	public void setProvinceCode(String provinceCode) {
		this.provinceCode = provinceCode;
	}

	public String getCityCode() {
		return cityCode;
	}

	public void setCityCode(String cityCode) {
		this.cityCode = cityCode;
	}

	public String getZipCode() {
		return zipCode;
	}

	public void setZipCode(String zipCode) {
		this.zipCode = zipCode;
	}

	public Integer getSettlingAgentCode() {
		return settlingAgentCode;
	}

	public void setSettlingAgentCode(Integer settlingAgentCode) {
		this.settlingAgentCode = settlingAgentCode;
	}

	public Integer getSurveyAgentCode() {
		return surveyAgentCode;
	}

	public void setSurveyAgentCode(Integer surveyAgentCode) {
		this.surveyAgentCode = surveyAgentCode;
	}

	public String getMotorNumber() {
		return motorNumber;
	}

	public void setMotorNumber(String motorNumber) {
		this.motorNumber = motorNumber;
	}

	public String getSerialNumber() {
		return serialNumber;
	}

	public void setSerialNumber(String serialNumber) {
		this.serialNumber = serialNumber;
	}

	public Integer getLocationCode() {
		return locationCode;
	}

	public void setLocationCode(Integer locationCode) {
		this.locationCode = locationCode;
	}

	public Integer getBlockId() {
		return blockId;
	}

	public void setBlockId(Integer blockId) {
		this.blockId = blockId;
	}

	public String getDistrictNumber() {
		return districtNumber;
	}

	public void setDistrictNumber(String districtNumber) {
		this.districtNumber = districtNumber;
	}

	public String getReportedBy() {
		return reportedBy;
	}
	public void setReportedBy(String reportedBy) {
		this.reportedBy = reportedBy;
	}
	public String getIssueCode() {
		return issueCode;
	}
	/**
	 * Sets the value for BOTH issueCode property AND issCd property
	 * issueCode and issCd are synonyms
	 * - this is a way to fix the inconsistent naming used for this property, without the need to re-code all the affected xml files
	 * @param issueCode
	 */
	public void setIssueCode(String issueCode) {
		this.issCd = issueCode;
		this.issueCode = issueCode;
	}
	
	public String getIssCd() {
		return issCd;
	}
	
	/**
	 * Sets the value for BOTH issueCode property AND issCd property
	 * issueCode and issCd are synonyms
	 * - this is a way to fix the inconsistent naming used for this property, without the need to re-code all the affected xml files
	 * @param issCd
	 */
	public void setIssCd(String issCd) {
		this.issueCode = issCd;
		this.issCd = issCd;
	}
	
	public BigDecimal getPaidAmount() {
		return paidAmount;
	}
	public void setPaidAmount(BigDecimal paidAmount) {
		this.paidAmount = paidAmount;
	}

	public String getClaimNumber() {
		return claimNumber;
	}

	public void setClaimNumber(String claimNumber) {
		this.claimNumber = claimNumber;
	}

	public String getClaimStatDesc() {
		return claimStatDesc;
	}

	/**
	 * Set Claim Stat Desc
	 * @param claimStatDesc
	 */
	public void setClaimStatDesc(String claimStatDesc) {
		this.claimStatDesc = claimStatDesc;
		this.clmStatDesc = claimStatDesc;
	}

	/**
	 * Set claim Stat Desc - synonym method for setClaimStatDesc
	 * @param claimStatDesc
	 */
	public void setClmStatDesc(String claimStatDesc) {
		this.claimStatDesc = claimStatDesc;
		this.clmStatDesc = claimStatDesc;
	}
	
	/**
	 * @return the packPolicy
	 */
	public String getPackPolicy() {
		return packPolicy;
	}

	/**
	 * @param packPolicy the packPolicy to set
	 */
	public void setPackPolicy(String packPolicy) {
		this.packPolicy = packPolicy;
	}

	/**
	 * @return the userId
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * @param userId the userId to set
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}

	/**
	 * @return the lastUpdate
	 */
	public Object getStrUserLastUpdate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (userLastUpdate != null) {
			return df.format(userLastUpdate);			
		} else {
			return null;
		}
	}
	
	public Date getUserLastUpdate() {
		return userLastUpdate;
	}

	/**
	 * @param lastUpdate the lastUpdate to set
	 */
	public void setUserLastUpdate(Date userLastUpdate) {
		this.userLastUpdate = userLastUpdate;
	}

	/**
	 * @return the dspLossTime
	 */
	public Object getStrDspLossTime() {
		DateFormat df = new SimpleDateFormat("hh:mm:ss aa");
		if (dspLossTime != null) {
			return df.format(dspLossTime);			
		} else {
			return null;
		}
	}
	
	public void setPolIssCd(String polIssCd){
		this.policyIssueCode = polIssCd; 
	}
	
	public String getPolIssCd(){
		return this.policyIssueCode;
	}
	
	public Date getDspLossTime() {
		return dspLossTime;
	}

	/**
	 * @param dspLossTime the dspLossTime to set
	 */
	public void setDspLossTime(Date dspLossTime) {
		this.dspLossTime = dspLossTime;
	}

	/**
	 * @return the clmStatDesc
	 */
	public String getClmStatDesc() {
		return clmStatDesc;
	}

	/**
	 * @return the dspRiName
	 */
	public String getDspRiName() {
		return dspRiName;
	}

	/**
	 * @param dspRiName the dspRiName to set
	 */
	public void setDspRiName(String dspRiName) {
		this.dspRiName = dspRiName;
	}

	/**
	 * @return the dspCityDesc
	 */
	public String getDspCityDesc() {
		return dspCityDesc;
	}

	/**
	 * @param dspCityDesc the dspCityDesc to set
	 */
	public void setDspCityDesc(String dspCityDesc) {
		this.dspCityDesc = dspCityDesc;
	}

	/**
	 * @return the dspProvinceDesc
	 */
	public String getDspProvinceDesc() {
		return dspProvinceDesc;
	}

	/**
	 * @param dspProvinceDesc the dspProvinceDesc to set
	 */
	public void setDspProvinceDesc(String dspProvinceDesc) {
		this.dspProvinceDesc = dspProvinceDesc;
	}

	/**
	 * @return the dspCatDesc
	 */
	public String getDspCatDesc() {
		return dspCatDesc;
	}

	/**
	 * @param dspCatDesc the dspCatDesc to set
	 */
	public void setDspCatDesc(String dspCatDesc) {
		this.dspCatDesc = dspCatDesc;
	}

	/**
	 * @return the dspLossCatDesc
	 */
	public String getDspLossCatDesc() {
		return dspLossCatDesc;
	}

	/**
	 * @param dspLossCatDesc the dspLossCatDesc to set
	 */
	public void setDspLossCatDesc(String dspLossCatDesc) {
		this.dspLossCatDesc = dspLossCatDesc;
	}

	/**
	 * @return the dspInHouAdjName
	 */
	public String getDspInHouAdjName() {
		return dspInHouAdjName;
	}

	/**
	 * @param dspInHouAdjName the dspInHouAdjName to set
	 */
	public void setDspInHouAdjName(String dspInHouAdjName) {
		this.dspInHouAdjName = dspInHouAdjName;
	}

	/**
	 * @return the dspCredBrDesc
	 */
	public String getDspCredBrDesc() {
		return dspCredBrDesc;
	}

	/**
	 * @param dspCredBrDesc the dspCredBrDesc to set
	 */
	public void setDspCredBrDesc(String dspCredBrDesc) {
		this.dspCredBrDesc = dspCredBrDesc;
	}

	/**
	 * @return the packPolFlag
	 */
	public String getPackPolFlag() {
		return packPolFlag;
	}

	/**
	 * @param packPolFlag the packPolFlag to set
	 */
	public void setPackPolFlag(String packPolFlag) {
		this.packPolFlag = packPolFlag;
	}

	/**
	 * @return the blockNo
	 */
	public String getBlockNo() {
		return blockNo;
	}

	/**
	 * @param blockNo the blockNo to set
	 */
	public void setBlockNo(String blockNo) {
		this.blockNo = blockNo;
	}

	/**
	 * @return the packPolNo
	 */
	public String getPackPolNo() {
		return packPolNo;
	}

	/**
	 * @param packPolNo the packPolNo to set
	 */
	public void setPackPolNo(String packPolNo) {
		this.packPolNo = packPolNo;
	}

	/**
	 * @return the issueDate
	 */
	public Object getStrIssueDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (issueDate != null) {
			return df.format(issueDate);			
		} else {
			return null;
		}
	}
	
	public Date getIssueDate() {
		return issueDate;
	}	

	/**
	 * @param issueDate the issueDate to set
	 */
	public void setIssueDate(Date issueDate) {
		this.issueDate = issueDate;
	}

	/**
	 * @return the redistSw
	 */
	public String getRedistSw() {
		return redistSw;
	}

	/**
	 * @param redistSw the redistSw to set
	 */
	public void setRedistSw(String redistSw) {
		this.redistSw = redistSw;
	}

	/**
	 * @return the giclMortgageeExist
	 */
	public String getGiclMortgageeExist() {
		return giclMortgageeExist;
	}

	/**
	 * @param giclMortgageeExist the giclMortgageeExist to set
	 */
	public void setGiclMortgageeExist(String giclMortgageeExist) {
		this.giclMortgageeExist = giclMortgageeExist;
	}

	public Date getPolEffDate() {
		return polEffDate;
	}

	public void setPolEffDate(Date polEffDate) {
		this.polEffDate = polEffDate;
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
		
		if(polEffDate != null){
			this.setStrPolEffDate(sdf.format(polEffDate));	
		}else{
			this.setStrPolEffDate(null);	
		}
			
	
	}

	public Integer getCatastrophicCd() {
		return catastrophicCd;
	}

	public void setCatastrophicCd(Integer catastrophicCd) {
		this.catastrophicCd = catastrophicCd;
	}

	public Integer getPerilCd() {
		return perilCd;
	}

	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}

	public Date getInceptDate() {
		return inceptDate;
	}

	public Object getStrInceptDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (inceptDate != null) {
			return df.format(inceptDate);			
		} else {
			return null;
		}
	}
	
	public void setInceptDate(Date inceptDate) {
		this.inceptDate = inceptDate;
	}

	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}

	public String getPolicyNo() {
		return policyNo;
	}

	public void setPolRenewNo(Integer polRenewNo) {
		this.polRenewNo = polRenewNo;
	}

	public Integer getPolRenewNo() {
		return polRenewNo;
	}

	public void setLossCtgry(String lossCtgry) {
		this.lossCtgry = lossCtgry;
	}

	public String getLossCtgry() {
		return lossCtgry;
	}

	public String getOpNumber() {
		return opNumber;
	}

	public void setOpNumber(String opNumber) {
		this.opNumber = opNumber;
	}

	public String getItemNo() {
		return itemNo;
	}

	public void setItemNo(String itemNo) {
		this.itemNo = itemNo;
	}

	public String getGiclItemPerilExist() {
		return giclItemPerilExist;
	}

	public void setGiclItemPerilExist(String giclItemPerilExist) {
		this.giclItemPerilExist = giclItemPerilExist;
	}

	public String getGiclClmItemExist() {
		return giclClmItemExist;
	}

	public void setGiclClmItemExist(String giclClmItemExist) {
		this.giclClmItemExist = giclClmItemExist;
	}

	public String getGiclClmReserveExist() {
		return giclClmReserveExist;
	}

	public void setGiclClmReserveExist(String giclClmReserveExist) {
		this.giclClmReserveExist = giclClmReserveExist;
	}

	public String getNbtClmStatCd() {
		return nbtClmStatCd;
	}

	public void setNbtClmStatCd(String nbtClmStatCd) {
		this.nbtClmStatCd = nbtClmStatCd;
	}

	public String getDspSettlingName() {
		return dspSettlingName;
	}

	public void setDspSettlingName(String dspSettlingName) {
		this.dspSettlingName = dspSettlingName;
	}

	public String getDspSurveyName() {
		return dspSurveyName;
	}

	public void setDspSurveyName(String dspSurveyName) {
		this.dspSurveyName = dspSurveyName;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getLineCd() {
		return lineCd;
	}

	public String getBillAddress() {
		return billAddress;
	}

	public void setBillAddress(String billAddress) {
		this.billAddress = billAddress;
	}

	public String getLossCatDes() {
		return lossCatDes;
	}

	public void setLossCatDes(String lossCatDes) {
		this.lossCatDes = lossCatDes;
	}

	public String getMortgName() {
		return mortgName;
	}

	public void setMortgName(String mortgName) {
		this.mortgName = mortgName;
	}

	public String getIntmName() {
		return intmName;
	}

	public void setIntmName(String intmName) {
		this.intmName = intmName;
	}

	public String getPrelimIssueDate() {
		return prelimIssueDate;
	}

	public void setPrelimIssueDate(String prelimIssueDate) {
		this.prelimIssueDate = prelimIssueDate;
	}

	public String getPrelimInceptDate() {
		return prelimInceptDate;
	}

	public void setPrelimInceptDate(String prelimInceptDate) {
		this.prelimInceptDate = prelimInceptDate;
	}

	public String getPrelimExpiryDate() {
		return prelimExpiryDate;
	}

	public void setPrelimExpiryDate(String prelimExpiryDate) {
		this.prelimExpiryDate = prelimExpiryDate;
	}

	public String getPrelimLossDate() {
		return prelimLossDate;
	}

	public void setPrelimLossDate(String prelimLossDate) {
		this.prelimLossDate = prelimLossDate;
	}

	public String getPrelimClmFileDate() {
		return prelimClmFileDate;
	}

	public void setPrelimClmFileDate(String prelimClmFileDate) {
		this.prelimClmFileDate = prelimClmFileDate;
	}

	public String getRiName() {
		return riName;
	}

	public void setRiName(String riName) {
		this.riName = riName;
	}

	public BigDecimal getShrRiTsiPct() {
		return shrRiTsiPct;
	}

	public void setShrRiTsiPct(BigDecimal shrRiTsiPct) {
		this.shrRiTsiPct = shrRiTsiPct;
	}

	public BigDecimal getShrRiTsiAmt() {
		return shrRiTsiAmt;
	}

	public void setShrRiTsiAmt(BigDecimal shrRiTsiAmt) {
		this.shrRiTsiAmt = shrRiTsiAmt;
	}

	public BigDecimal getShrRiTsiAmt2() {
		return shrRiTsiAmt2;
	}

	public void setShrRiTsiAmt2(BigDecimal shrRiTsiAmt2) {
		this.shrRiTsiAmt2 = shrRiTsiAmt2;
	}

	public BigDecimal getShrRiPct() {
		return shrRiPct;
	}

	public void setShrRiPct(BigDecimal shrRiPct) {
		this.shrRiPct = shrRiPct;
	}

	public BigDecimal getRiResAmt() {
		return riResAmt;
	}

	public void setRiResAmt(BigDecimal riResAmt) {
		this.riResAmt = riResAmt;
	}

	public BigDecimal getRiResAmt2() {
		return riResAmt2;
	}

	public void setRiResAmt2(BigDecimal riResAmt2) {
		this.riResAmt2 = riResAmt2;
	}

	public Integer getGroupedItemNo() {
		return groupedItemNo;
	}

	public void setGroupedItemNo(Integer groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}

	public Integer getReserveItemNo() {
		return reserveItemNo;
	}

	public void setReserveItemNo(Integer reserveItemNo) {
		this.reserveItemNo = reserveItemNo;
	}

	public Integer getGrpSeqNo() {
		return grpSeqNo;
	}

	public void setGrpSeqNo(Integer grpSeqNo) {
		this.grpSeqNo = grpSeqNo;
	}

	public void setAdviceNo(String adviceNo) {
		this.adviceNo = adviceNo;
	}

	public String getAdviceNo() {
		return adviceNo;
	}

	public Integer getAdviceId() {
		return adviceId;
	}

	public void setAdviceId(Integer adviceId) {
		this.adviceId = adviceId;
	}

	public String getClaimNo() {
		return claimNo;
	}

	public void setClaimNo(String claimNo) {
		this.claimNo = claimNo;
	}

	public String getDistrictNo() {
		return districtNo;
	}

	public void setDistrictNo(String districtNo) {
		this.districtNo = districtNo;
	}

	public String getItemLimit() {
		return itemLimit;
	}

	public void setItemLimit(String itemLimit) {
		this.itemLimit = itemLimit;
	}

	public Integer getPolSeqNo(){
		return this.policySequenceNo;
	}
	
	public void setPolSeqNo(Integer polSeqNo){
		this.policySequenceNo = polSeqNo;
	}
	
	public static GICLClaims makeClaim(Map<String, Object> claimsMap){
		GICLClaims clm = new GICLClaims();
		Iterator<String> keys = claimsMap.keySet().iterator();
		String key = "";
		while(keys.hasNext()){
			key = keys.next();
			try{
				if(key.equals("claimId")){				clm.setClaimId(Integer.parseInt(claimsMap.get(key).toString()));
				}else if(key.equals("claimNumber")){	clm.setClaimNo(claimsMap.get(key).toString());
				}else if(key.equals("policyNumber")){	clm.setPolicyNo(claimsMap.get("policyNumber").toString());
				}else if(key.equals("lineCd")){			clm.setLineCd(claimsMap.get("lineCd").toString());	
				}else if(key.equals("dspLossDate")){	clm.setDspLossDate((Date)claimsMap.get("dspLossDate")); // knoe the format of oracle
				}else if(key.equals("lossDate")){		clm.setLossDate((Date)claimsMap.get("lossDate"));
				}else if(key.equals("assuredName")){	clm.setAssuredName(claimsMap.get("assuredName").toString());
				}else if(key.equals("lossCategory")){	clm.setLossCatCd(claimsMap.get("lossCategory").toString());
				}else if(key.equals("sublineCd")){		clm.setSublineCd(claimsMap.get("sublineCd").toString());
				}else if(key.equals("polIssCd")){		clm.setPolicyIssueCode(claimsMap.get("polIssCd").toString());
				}else if(key.equals("issueYy")){		clm.setIssueYy(Integer.parseInt(claimsMap.get("issueYy").toString()));
				}else if(key.equals("polSeqNo")){		clm.setPolSeqNo((Integer.parseInt(claimsMap.get("polSeqNo").toString())));
				}else if(key.equals("renewNo")){		clm.setRenewNo(Integer.parseInt(claimsMap.get("renewNo").toString()));
				}else if(key.equals("issCd")){			clm.setIssCd(claimsMap.get("issCd").toString());
				}else if(key.equals("polEffDate")){		clm.setPolEffDate((Date)claimsMap.get("polEffDate"));
				}else if(key.equals("expiryDate")){		clm.setExpiryDate((Date) claimsMap.get("expiryDate"));//	System.out.println("expiryDate:  " + claimsMap.get("expiryDate").toString());	
				}else if(key.equals("clmFileDate")){	clm.setClaimFileDate((Date)claimsMap.get("clmFileDate"));// System.out.println("clmFileDate: " + claimsMap.get("clmFileDate").toString());
				}else if(key.equals("clmStatDesc")){	clm.setClmStatDesc((String) claimsMap.get("clmStatDesc"));
				}else if(key.equals("catastrophicCd")){	clm.setCatastrophicCd(Integer.parseInt(claimsMap.get("catastrophicCd").toString()));
				}else if(key.equals("claimYy")){		clm.setClaimYy(Integer.parseInt(claimsMap.get("claimYy").toString()));
				}/*else if(key.equals("exists")){
				}*/
			}catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
		return clm;
	}

	public void setStrPolEffDate(String strPolEffDate) {
		this.strPolEffDate = strPolEffDate;
	}

	public String getStrPolEffDate() {
		return strPolEffDate;
	}

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	/**
	 * @return the polFlag
	 */
	public String getPolFlag() {
		return polFlag;
	}

	/**
	 * @param polFlag the polFlag to set
	 */
	public void setPolFlag(String polFlag) {
		this.polFlag = polFlag;
	}

	/**
	 * @return the clmSetld
	 */
	public String getClmSetld() {
		return clmSetld;
	}

	/**
	 * @param clmSetld the clmSetld to set
	 */
	public void setClmSetld(String clmSetld) {
		this.clmSetld = clmSetld;
	}

	/**
	 * @return the adviceExist
	 */
	public String getAdviceExist() {
		return adviceExist;
	}

	/**
	 * @param adviceExist the adviceExist to set
	 */
	public void setAdviceExist(String adviceExist) {
		this.adviceExist = adviceExist;
	}

	/**
	 * @return the paytSw
	 */
	public String getPaytSw() {
		return paytSw;
	}

	/**
	 * @param paytSw the paytSw to set
	 */
	public void setPaytSw(String paytSw) {
		this.paytSw = paytSw;
	}

	/**
	 * @return the chkPayment
	 */
	public String getChkPayment() {
		return chkPayment;
	}

	/**
	 * @param chkPayment the chkPayment to set
	 */
	public void setChkPayment(String chkPayment) {
		this.chkPayment = chkPayment;
	}

	/**
	 * @return the withRecovery
	 */
	public String getWithRecovery() {
		return withRecovery;
	}

	/**
	 * @param withRecovery the withRecovery to set
	 */
	public void setWithRecovery(String withRecovery) {
		this.withRecovery = withRecovery;
	}

	public String getAssignee() {
		return assignee;
	}

	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}

	public String getDspAcctOfCdName() {
		return dspAcctOfCdName;
	}

	public void setDspAcctOfCdName(String dspAcctOfCdName) {
		this.dspAcctOfCdName = dspAcctOfCdName;
	}

	public String getDspCatastrophicDesc() {
		return dspCatastrophicDesc;
	}

	public void setDspCatastrophicDesc(String dspCatastrophicDesc) {
		this.dspCatastrophicDesc = dspCatastrophicDesc;
	}

	public String getBasicIntmSw() {
		return basicIntmSw;
	}

	public void setBasicIntmSw(String basicIntmSw) {
		this.basicIntmSw = basicIntmSw;
	}
	
	public String getAssdName() {
		return assdName;
	}

	public void setAssdName(String assdName) {
		this.assdName = assdName;
	}

	public void setClaimStatus(String claimStatus) {
		this.claimStatus = claimStatus;
	}

	public String getClaimStatus() {
		return claimStatus;
	}
	
	public String getPlateNo() {
		return plateNo;
	}

	public void setPlateNo(String plateNo) {
		this.plateNo = plateNo;
	}

	public void setInHouAdj(String inHouAdj) {
		this.inHouAdj = inHouAdj;
	}

	public String getInHouAdj() {
		return inHouAdj;
	}

	public String getLossDateStr() {
		return lossDateStr;
	}

	public void setLossDateStr(String lossDateStr) {
		this.lossDateStr = lossDateStr;
	}

	public void setStrClaimFileDate(String strClaimFileDate) {
		this.strClaimFileDate = strClaimFileDate;
	}

	//start kenneth SR 5147 11.05.2015
	public String getReasonDesc() {
		return reasonDesc;
	}

	public void setReasonDesc(String reasonDesc) {
		this.reasonDesc = reasonDesc;
	}
	//end kenneth SR 5147 11.05.2015
}