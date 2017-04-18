package com.geniisys.gixx.entity;

import java.math.BigDecimal;
import java.util.Date;

public class GIXXPolbasic {
	
	private Integer extractId;
	private String lineCd;
	private String sublineCd;
	private String issCd;
	private Integer issueYy;
	private Integer polSeqNo;
	private Integer renewNo;
	private String polFlag;
	private Date effDate;
	private Date inceptDate;
	private Date expiryDate;
	private Date issueDate;
	private Integer assdNo;
	private String designation;
	private String typeCd;
	private Integer acctOfCd;
	private String mortgName;
	private String address1;
	private String address2;
	private String address3;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private String poolPolNo;
	private Integer noOfItems;
	private String sublineTypeCd;
	private Float shortRtPercent;
	private Integer provPremPct;
	private String autoRenewFlag;
	private String prorateFlag;
	private String renewFlag;
	private String packPolFlag;
	private String provPremTag;
	private String expiryTag;
	private String foreignAccSw;
	private String invoiceSw;
	private String discountSw;
	private String refPolNo;
	private String premWarrTag;
	private String coInsuranceSw;
	private String regPolicySw;
	private String refOpenPolNo;
	private Integer manualRenewNo;
	private String inceptTag;
	private String withTariffSw;
	private String surchargeSw;
	private Integer industryCd;
	private Integer regionCd;
	private String credBranch;
	private BigDecimal annTsiAmt;
	private String distFlag;
	private Date acctEntDate;
	private String acctOfCdSw;
	private Integer actualRenewNo;
	private BigDecimal annPremAmt;
	private String backStat;
	private String bookingMth;
	private Integer bookingYear;
	private Date cancelDate;
	private String compSw;
	private String eisFlag;
	private Date endtExpiryDate;
	private String endtExpiryTag;
	private String endtIssCd;
	private Integer endtSeqNo;
	private String endtType;
	private Integer endtYy;
	private String fleetPrintTag;
	private String labelTag;
	private String oldAddress1;
	private String oldAddress2;
	private String oldAddress3;
	private Integer oldAssdNo;
	private String oldPolFlag;
	private Integer origPolicyId;
	private Integer parId;
	private String placeCd;
	private Integer polEndtPrintedCnt;
	private Date polEndtPrintedDate;
	private Integer policyId;
	private String qdFlag;
	private Date reinstatementDate;
	private Integer renNoticeCnt;
	private Date renNoticeDate;
	private String samePolNoSw;
	private Date spldAcctEntDate;
	private String spldApproval;
	private Date spldDate;
	private String spldFlag;
	private String spldUserId;
	private String userId;
	private Date lastUpdateDate;
	private String validateTag;
	private String riskTag;
	private String renewExtractTag;
	private String claimsExtractTag;
	private Integer settlingAgentCd;
	private Integer surveyAgentCd;
	private String polFlagDesc;
	// additional attributes for GIPIS101
	private String polNo;
	private String dspIndustryNm;
	private String dspTypeDesc;
	private String dspCredBranch;
	private String regionDesc;
	private String assdName;
	private String typeDesc;
	private String nbtRiskTag;
	private String drvAcctOf;
	private String dspLabelTag;
	private String settlingAgent;
	private String surveyAgent;
	
	private String policyIdType;
	private String lineType;
	private String bankBtnLabel;
	private String defaultCurrency;
	private String isForeignCurrency;
	private String dspRate;
	private String varSublineOpen;
	private String varSublineMop;
	private String valPeriod;
	private String valPeriodUnit;
	
	
	private String contractProjBussTitle;
	private String siteLocation;
	private Date constructStartDate;
	private Date constructEndDate;
	private Date maintainStartDate;
	private Date maintainEndDate;
	private String mbiPolicyNo;
	private Integer weeksTest;
	private Integer timeExcess;
	private String promptTitle;
	private String promptLocation;
	
	private String sublineCdParam; //added by robert SR 20307 10.27.15

	public String getPolFlagDesc() {
		return polFlagDesc;
	}
	public void setPolFlagDesc(String polFlagDesc) {
		this.polFlagDesc = polFlagDesc;
	}
	public Integer getExtractId() {
		return extractId;
	}
	public void setExtractId(Integer extractId) {
		this.extractId = extractId;
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
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
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
	public String getPolFlag() {
		return polFlag;
	}
	public void setPolFlag(String polFlag) {
		this.polFlag = polFlag;
	}
	public Date getEffDate() {
		return effDate;
	}
	public void setEffDate(Date effDate) {
		this.effDate = effDate;
	}
	public Date getInceptDate() {
		return inceptDate;
	}
	public void setInceptDate(Date inceptDate) {
		this.inceptDate = inceptDate;
	}
	public Date getExpiryDate() {
		return expiryDate;
	}
	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}
	public Date getIssueDate() {
		return issueDate;
	}
	public void setIssueDate(Date issueDate) {
		this.issueDate = issueDate;
	}
	public Integer getAssdNo() {
		return assdNo;
	}
	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}
	public String getDesignation() {
		return designation;
	}
	public void setDesignation(String designation) {
		this.designation = designation;
	}
	public String getTypeCd() {
		return typeCd;
	}
	public void setTypeCd(String typeCd) {
		this.typeCd = typeCd;
	}
	public Integer getAcctOfCd() {
		return acctOfCd;
	}
	public void setAcctOfCd(Integer acctOfCd) {
		this.acctOfCd = acctOfCd;
	}
	public String getMortgName() {
		return mortgName;
	}
	public void setMortgName(String mortgName) {
		this.mortgName = mortgName;
	}
	public String getAddress1() {
		return address1;
	}
	public void setAddress1(String address1) {
		this.address1 = address1;
	}
	public String getAddress2() {
		return address2;
	}
	public void setAddress2(String address2) {
		this.address2 = address2;
	}
	public String getAddress3() {
		return address3;
	}
	public void setAddress3(String address3) {
		this.address3 = address3;
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
	public String getPoolPolNo() {
		return poolPolNo;
	}
	public void setPoolPolNo(String poolPolNo) {
		this.poolPolNo = poolPolNo;
	}
	public Integer getNoOfItems() {
		return noOfItems;
	}
	public void setNoOfItems(Integer noOfItems) {
		this.noOfItems = noOfItems;
	}
	public String getSublineTypeCd() {
		return sublineTypeCd;
	}
	public void setSublineTypeCd(String sublineTypeCd) {
		this.sublineTypeCd = sublineTypeCd;
	}
	public Float getShortRtPercent() {
		return shortRtPercent;
	}
	public void setShortRtPercent(Float shortRtPercent) {
		this.shortRtPercent = shortRtPercent;
	}
	public Integer getProvPremPct() {
		return provPremPct;
	}
	public void setProvPremPct(Integer provPremPct) {
		this.provPremPct = provPremPct;
	}
	public String getAutoRenewFlag() {
		return autoRenewFlag;
	}
	public void setAutoRenewFlag(String autoRenewFlag) {
		this.autoRenewFlag = autoRenewFlag;
	}
	public String getProrateFlag() {
		return prorateFlag;
	}
	public void setProrateFlag(String prorateFlag) {
		this.prorateFlag = prorateFlag;
	}
	public String getRenewFlag() {
		return renewFlag;
	}
	public void setRenewFlag(String renewFlag) {
		this.renewFlag = renewFlag;
	}
	public String getPackPolFlag() {
		return packPolFlag;
	}
	public void setPackPolFlag(String packPolFlag) {
		this.packPolFlag = packPolFlag;
	}
	public String getProvPremTag() {
		return provPremTag;
	}
	public void setProvPremTag(String provPremTag) {
		this.provPremTag = provPremTag;
	}
	public String getExpiryTag() {
		return expiryTag;
	}
	public void setExpiryTag(String expiryTag) {
		this.expiryTag = expiryTag;
	}
	public String getForeignAccSw() {
		return foreignAccSw;
	}
	public void setForeignAccSw(String foreignAccSw) {
		this.foreignAccSw = foreignAccSw;
	}
	public String getInvoiceSw() {
		return invoiceSw;
	}
	public void setInvoiceSw(String invoiceSw) {
		this.invoiceSw = invoiceSw;
	}
	public String getDiscountSw() {
		return discountSw;
	}
	public void setDiscountSw(String discountSw) {
		this.discountSw = discountSw;
	}
	public String getRefPolNo() {
		return refPolNo;
	}
	public void setRefPolNo(String refPolNo) {
		this.refPolNo = refPolNo;
	}
	public String getPremWarrTag() {
		return premWarrTag;
	}
	public void setPremWarrTag(String premWarrTag) {
		this.premWarrTag = premWarrTag;
	}
	public String getCoInsuranceSw() {
		return coInsuranceSw;
	}
	public void setCoInsuranceSw(String coInsuranceSw) {
		this.coInsuranceSw = coInsuranceSw;
	}
	public String getRegPolicySw() {
		return regPolicySw;
	}
	public void setRegPolicySw(String regPolicySw) {
		this.regPolicySw = regPolicySw;
	}
	public String getRefOpenPolNo() {
		return refOpenPolNo;
	}
	public void setRefOpenPolNo(String refOpenPolNo) {
		this.refOpenPolNo = refOpenPolNo;
	}
	public Integer getManualRenewNo() {
		return manualRenewNo;
	}
	public void setManualRenewNo(Integer manualRenewNo) {
		this.manualRenewNo = manualRenewNo;
	}
	public String getInceptTag() {
		return inceptTag;
	}
	public void setInceptTag(String inceptTag) {
		this.inceptTag = inceptTag;
	}
	public String getWithTariffSw() {
		return withTariffSw;
	}
	public void setWithTariffSw(String withTariffSw) {
		this.withTariffSw = withTariffSw;
	}
	public String getSurchargeSw() {
		return surchargeSw;
	}
	public void setSurchargeSw(String surchargeSw) {
		this.surchargeSw = surchargeSw;
	}
	public Integer getIndustryCd() {
		return industryCd;
	}
	public void setIndustryCd(Integer industryCd) {
		this.industryCd = industryCd;
	}
	public Integer getRegionCd() {
		return regionCd;
	}
	public void setRegionCd(Integer regionCd) {
		this.regionCd = regionCd;
	}
	public String getCredBranch() {
		return credBranch;
	}
	public void setCredBranch(String credBranch) {
		this.credBranch = credBranch;
	}
	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}
	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}
	public String getDistFlag() {
		return distFlag;
	}
	public void setDistFlag(String distFlag) {
		this.distFlag = distFlag;
	}
	public Date getAcctEntDate() {
		return acctEntDate;
	}
	public void setAcctEntDate(Date acctEntDate) {
		this.acctEntDate = acctEntDate;
	}
	public String getAcctOfCdSw() {
		return acctOfCdSw;
	}
	public void setAcctOfCdSw(String acctOfCdSw) {
		this.acctOfCdSw = acctOfCdSw;
	}
	public Integer getActualRenewNo() {
		return actualRenewNo;
	}
	public void setActualRenewNo(Integer actualRenewNo) {
		this.actualRenewNo = actualRenewNo;
	}
	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}
	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}
	public String getBackStat() {
		return backStat;
	}
	public void setBackStat(String backStat) {
		this.backStat = backStat;
	}
	public String getBookingMth() {
		return bookingMth;
	}
	public void setBookingMth(String bookingMth) {
		this.bookingMth = bookingMth;
	}
	public Integer getBookingYear() {
		return bookingYear;
	}
	public void setBookingYear(Integer bookingYear) {
		this.bookingYear = bookingYear;
	}
	public Date getCancelDate() {
		return cancelDate;
	}
	public void setCancelDate(Date cancelDate) {
		this.cancelDate = cancelDate;
	}
	public String getCompSw() {
		return compSw;
	}
	public void setCompSw(String compSw) {
		this.compSw = compSw;
	}
	public String getEisFlag() {
		return eisFlag;
	}
	public void setEisFlag(String eisFlag) {
		this.eisFlag = eisFlag;
	}
	public Date getEndtExpiryDate() {
		return endtExpiryDate;
	}
	public void setEndtExpiryDate(Date endtExpiryDate) {
		this.endtExpiryDate = endtExpiryDate;
	}
	public String getEndtExpiryTag() {
		return endtExpiryTag;
	}
	public void setEndtExpiryTag(String endtExpiryTag) {
		this.endtExpiryTag = endtExpiryTag;
	}
	public String getEndtIssCd() {
		return endtIssCd;
	}
	public void setEndtIssCd(String endtIssCd) {
		this.endtIssCd = endtIssCd;
	}
	public Integer getEndtSeqNo() {
		return endtSeqNo;
	}
	public void setEndtSeqNo(Integer endtSeqNo) {
		this.endtSeqNo = endtSeqNo;
	}
	public String getEndtType() {
		return endtType;
	}
	public void setEndtType(String endtType) {
		this.endtType = endtType;
	}
	public Integer getEndtYy() {
		return endtYy;
	}
	public void setEndtYy(Integer endtYy) {
		this.endtYy = endtYy;
	}
	public String getFleetPrintTag() {
		return fleetPrintTag;
	}
	public void setFleetPrintTag(String fleetPrintTag) {
		this.fleetPrintTag = fleetPrintTag;
	}
	public String getLabelTag() {
		return labelTag;
	}
	public void setLabelTag(String labelTag) {
		this.labelTag = labelTag;
	}
	public String getOldAddress1() {
		return oldAddress1;
	}
	public void setOldAddress1(String oldAddress1) {
		this.oldAddress1 = oldAddress1;
	}
	public String getOldAddress2() {
		return oldAddress2;
	}
	public void setOldAddress2(String oldAddress2) {
		this.oldAddress2 = oldAddress2;
	}
	public String getOldAddress3() {
		return oldAddress3;
	}
	public void setOldAddress3(String oldAddress3) {
		this.oldAddress3 = oldAddress3;
	}
	public Integer getOldAssdNo() {
		return oldAssdNo;
	}
	public void setOldAssdNo(Integer oldAssdNo) {
		this.oldAssdNo = oldAssdNo;
	}
	public String getOldPolFlag() {
		return oldPolFlag;
	}
	public void setOldPolFlag(String oldPolFlag) {
		this.oldPolFlag = oldPolFlag;
	}
	public Integer getOrigPolicyId() {
		return origPolicyId;
	}
	public void setOrigPolicyId(Integer origPolicyId) {
		this.origPolicyId = origPolicyId;
	}
	public Integer getParId() {
		return parId;
	}
	public void setParId(Integer parId) {
		this.parId = parId;
	}
	public String getPlaceCd() {
		return placeCd;
	}
	public void setPlaceCd(String placeCd) {
		this.placeCd = placeCd;
	}
	public Integer getPolEndtPrintedCnt() {
		return polEndtPrintedCnt;
	}
	public void setPolEndtPrintedCnt(Integer polEndtPrintedCnt) {
		this.polEndtPrintedCnt = polEndtPrintedCnt;
	}
	public Date getPolEndtPrintedDate() {
		return polEndtPrintedDate;
	}
	public void setPolEndtPrintedDate(Date polEndtPrintedDate) {
		this.polEndtPrintedDate = polEndtPrintedDate;
	}
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public String getQdFlag() {
		return qdFlag;
	}
	public void setQdFlag(String qdFlag) {
		this.qdFlag = qdFlag;
	}
	public Date getReinstatementDate() {
		return reinstatementDate;
	}
	public void setReinstatementDate(Date reinstatementDate) {
		this.reinstatementDate = reinstatementDate;
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
	public String getSamePolNoSw() {
		return samePolNoSw;
	}
	public void setSamePolNoSw(String samePolNoSw) {
		this.samePolNoSw = samePolNoSw;
	}
	public Date getSpldAcctEntDate() {
		return spldAcctEntDate;
	}
	public void setSpldAcctEntDate(Date spldAcctEntDate) {
		this.spldAcctEntDate = spldAcctEntDate;
	}
	public String getSpldApproval() {
		return spldApproval;
	}
	public void setSpldApproval(String spldApproval) {
		this.spldApproval = spldApproval;
	}
	public Date getSpldDate() {
		return spldDate;
	}
	public void setSpldDate(Date spldDate) {
		this.spldDate = spldDate;
	}
	public String getSpldFlag() {
		return spldFlag;
	}
	public void setSpldFlag(String spldFlag) {
		this.spldFlag = spldFlag;
	}
	public String getSpldUserId() {
		return spldUserId;
	}
	public void setSpldUserId(String spldUserId) {
		this.spldUserId = spldUserId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public Date getLastUpdateDate() {
		return lastUpdateDate;
	}
	public void setLastUpdateDate(Date lastUpdateDate) {
		this.lastUpdateDate = lastUpdateDate;
	}
	public String getValidateTag() {
		return validateTag;
	}
	public void setValidateTag(String validateTag) {
		this.validateTag = validateTag;
	}
	public String getRiskTag() {
		return riskTag;
	}
	public void setRiskTag(String riskTag) {
		this.riskTag = riskTag;
	}
	public String getRenewExtractTag() {
		return renewExtractTag;
	}
	public void setRenewExtractTag(String renewExtractTag) {
		this.renewExtractTag = renewExtractTag;
	}
	public String getClaimsExtractTag() {
		return claimsExtractTag;
	}
	public void setClaimsExtractTag(String claimsExtractTag) {
		this.claimsExtractTag = claimsExtractTag;
	}
	public Integer getSettlingAgentCd() {
		return settlingAgentCd;
	}
	public void setSettlingAgentCd(Integer settlingAgentCd) {
		this.settlingAgentCd = settlingAgentCd;
	}
	public Integer getSurveyAgentCd() {
		return surveyAgentCd;
	}
	public void setSurveyAgentCd(Integer surveyAgentCd) {
		this.surveyAgentCd = surveyAgentCd;
	}
	public String getPolNo() {
		return polNo;
	}
	public void setPolNo(String policyNo) {
		this.polNo = policyNo;
	}
	public String getDspIndustryNm() {
		return dspIndustryNm;
	}
	public void setDspIndustryNm(String dspindustryNm) {
		this.dspIndustryNm = dspindustryNm;
	}
	public String getDspTypeDesc() {
		return dspTypeDesc;
	}
	public void setDspTypeDesc(String dspTypeDesc) {
		this.dspTypeDesc = dspTypeDesc;
	}
	public String getDspCredBranch() {
		return dspCredBranch;
	}
	public void setDspCredBranch(String dspCredBranch) {
		this.dspCredBranch = dspCredBranch;
	}
	public String getRegionDesc() {
		return regionDesc;
	}
	public void setRegionDesc(String regionDesc) {
		this.regionDesc = regionDesc;
	}
	public String getAssdName() {
		return assdName;
	}
	public void setAssdName(String assdName) {
		this.assdName = assdName;
	}
	public String getTypeDesc() {
		return typeDesc;
	}
	public void setTypeDesc(String typeDesc) {
		this.typeDesc = typeDesc;
	}
	public String getNbtRiskTag() {
		return nbtRiskTag;
	}
	public void setNbtRiskTag(String nbtRiskTag) {
		this.nbtRiskTag = nbtRiskTag;
	}
	public String getDrvAcctOf() {
		return drvAcctOf;
	}
	public void setDrvAcctOf(String drvAcctOf) {
		this.drvAcctOf = drvAcctOf;
	}
	public String getDspLabelTag() {
		return dspLabelTag;
	}
	public void setDspLabelTag(String dspLabelTag) {
		this.dspLabelTag = dspLabelTag;
	}
	public String getSettlingAgent() {
		return settlingAgent;
	}
	public void setSettlingAgent(String settlingAgent) {
		this.settlingAgent = settlingAgent;
	}
	public String getSurveyAgent() {
		return surveyAgent;
	}
	public void setSurveyAgent(String surveyAgent) {
		this.surveyAgent = surveyAgent;
	}
	public String getPolicyIdType() {
		return policyIdType;
	}
	public void setPolicyIdType(String policyIdType) {
		this.policyIdType = policyIdType;
	}
	public String getLineType() {
		return lineType;
	}
	public void setLineType(String lineType) {
		this.lineType = lineType;
	}
	public String getBankBtnLabel() {
		return bankBtnLabel;
	}
	public void setBankBtnLabel(String bankBtnLabel) {
		this.bankBtnLabel = bankBtnLabel;
	}
	public String getDefaultCurrency() {
		return defaultCurrency;
	}
	public void setDefaultCurrency(String defaultCurrency) {
		this.defaultCurrency = defaultCurrency;
	}
	public String getIsForeignCurrency() {
		return isForeignCurrency;
	}
	public void setIsForeignCurrency(String isForeignCurrency) {
		this.isForeignCurrency = isForeignCurrency;
	}
	public String getDspRate() {
		return dspRate;
	}
	public void setDspRate(String dspRate) {
		this.dspRate = dspRate;
	}
	public String getVarSublineOpen() {
		return varSublineOpen;
	}
	public void setVarSublineOpen(String varSublineOpen) {
		this.varSublineOpen = varSublineOpen;
	}
	public String getVarSublineMop() {
		return varSublineMop;
	}
	public void setVarSublineMop(String varSublineMop) {
		this.varSublineMop = varSublineMop;
	}
	public String getValPeriod() {
		return valPeriod;
	}
	public void setValPeriod(String valPeriod) {
		this.valPeriod = valPeriod;
	}
	public String getValPeriodUnit() {
		return valPeriodUnit;
	}
	public void setValPeriodUnit(String valPeriodUnit) {
		this.valPeriodUnit = valPeriodUnit;
	}
	public String getContractProjBussTitle() {
		return contractProjBussTitle;
	}
	public void setContractProjBussTitle(String contractProjBussTitle) {
		this.contractProjBussTitle = contractProjBussTitle;
	}
	public String getSiteLocation() {
		return siteLocation;
	}
	public void setSiteLocation(String siteLocation) {
		this.siteLocation = siteLocation;
	}
	public Date getConstructStartDate() {
		return constructStartDate;
	}
	public void setConstructStartDate(Date constructStartDate) {
		this.constructStartDate = constructStartDate;
	}
	public Date getConstructEndDate() {
		return constructEndDate;
	}
	public void setConstructEndDate(Date constructEndDate) {
		this.constructEndDate = constructEndDate;
	}
	public Date getMaintainStartDate() {
		return maintainStartDate;
	}
	public void setMaintainStartDate(Date maintainStartDate) {
		this.maintainStartDate = maintainStartDate;
	}
	public Date getMaintainEndDate() {
		return maintainEndDate;
	}
	public void setMaintainEndDate(Date maintainEndDate) {
		this.maintainEndDate = maintainEndDate;
	}
	public String getMbiPolicyNo() {
		return mbiPolicyNo;
	}
	public void setMbiPolicyNo(String mbiPolicyNo) {
		this.mbiPolicyNo = mbiPolicyNo;
	}
	public Integer getWeeksTest() {
		return weeksTest;
	}
	public void setWeeksTest(Integer weeksTest) {
		this.weeksTest = weeksTest;
	}
	public Integer getTimeExcess() {
		return timeExcess;
	}
	public void setTimeExcess(Integer timeExcess) {
		this.timeExcess = timeExcess;
	}
	public String getPromptTitle() {
		return promptTitle;
	}
	public void setPromptTitle(String promptTitle) {
		this.promptTitle = promptTitle;
	}
	public String getPromptLocation() {
		return promptLocation;
	}
	public void setPromptLocation(String promptLocation) {
		this.promptLocation = promptLocation;
	}
	//added by robert SR 20307 10.27.15
	public String getSublineCdParam() {
		return sublineCdParam;
	}
	public void setSublineCdParam(String sublineCdParam) {
		this.sublineCdParam = sublineCdParam;
	}
	//end robert SR 20307 10.27.15
	
}
