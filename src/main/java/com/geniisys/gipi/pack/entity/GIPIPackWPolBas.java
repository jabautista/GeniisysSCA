/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.pack.entity;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.geniisys.framework.util.BaseEntity;

/**
 * The Class GIPIPackWPolBas
 */
public class GIPIPackWPolBas extends BaseEntity {

	/** The pack par id */
	private Integer packParId;
	
	/** The label tag */
	private String labelTag;
	
	/** The assd no**/
	private Integer assdNo;
	
	/** The assd name */
	private String dspAssdName;
	
	/** The account of name */
	private String acctOfName;
	
	/** The line cd */
	private String lineCd;
	
	/**The subline cd */
	private String sublineCd;
	
	/** The surcharge sw */
	private String surchargeSw;
	
	/** The manual renew no */
	private String manualRenewNo;
	
	/** The discount sw */
	private String discountSw;
	
	/** The pol flag */
	private String polFlag;
	
	/** The type cd */
	private String typeCd;
	
	/** The address1 */
	private String address1;
	
	/** The address2 */
	private String address2;
	
	/** The address3 */
	private String address3;
	
	/** The booking year */
	private Integer bookingYear;
	
	/** The booking month */
	private String bookingMth;
	
	/** The incept date */
	private Date inceptDate;
	
	/** The expiry date */
	private Date expiryDate;
	
	/** The issue date */
	private Date issueDate;
	
	/** The place cd */
	private String placeCd;
	
	/** The place desc */
	private String placeDesc;
	
	/** The incept tag */
	private String inceptTag;
	
	/** The expiry tag */
	private String expiryTag;
	
	/** The risk tag */
	private String riskTag;
	
	/** The ref pol no */
	private String refPolNo;
	
	/** The industry cd */
	private String industryCd;
	
	/** The industry desc */
	private String industryDesc;
	
	/** The region cd */
	private String regionCd;
	
	/** The region desc */
	private String regionDesc;
	
	/** The crediting branch */
	private String credBranch;
	
	/** The cred branch desc (iss name) */
	private String credBranchDesc;
	
	/** The iss cd */
	private String issCd;
	
	/** The quotation printed sw */
	private String quotationPrintedSw;
	
	/** The covernote printed sw */
	private String covernotePrintedSw;
	
	/** The pack pol flag */
	private String packPolFlag;
	
	/** The auto renew flag */
	private String autoRenewFlag;
	
	/** The foreign acc sw */
	private String foreignAccSw;
	
	/** The reg policy sw*/
	private String regPolicySw;
	
	/** The fleet print tag */
	private String fleetPrintTag;
	
	/** The with_tariff tag */
	private String withTariffSw;
	
	/** The co_insurance sw */
	private String coInsuranceSw;
	
	/** The prorate flag */
	private String prorateFlag;
	
	/** The comp sw */
	private String compSw;
	
	/** The short rate percent */
	private BigDecimal shortRtPercent;
	
	/** The prov prem tag */
	private String provPremTag;
	
	/** The prov prem pct */
	private BigDecimal provPremPct;
	
	/** The designation */
	private String designation;
	
	/** The acct of cd */
	private String acctOfCd;
	
	/** The invoice sw */
	private String invoiceSw;
	
	/** The renew no */
	private Integer renewNo;
	
	/** The issue year */
	private Integer issueYy;
	
	/** The ref open pol no. */
	private String refOpenPolNo;
	
	/** The same pol no sw */
	private String samePolnoSw;
	
	/** The endt Year */
	private Integer endtYy;
	
	/** The endt seq no */
	private String endtSeqNo;
	
	/** The mortgagee Name */
	private String mortgName;
	
	/** The validate tag */
	private String validateTag;
	
	/** The pol seq no */
	private Integer polSeqNo;
	
	/** The back stat */
	private String backStat;
	
	/** The effectivity date */
	private Date effDate;
	
	/** The endt expiry date */
	private Date endtExpiryDate;
	
	/** The endt expiry tag */
	private String endtExpiryTag;
	
	/** The endt iss cd */
	private String endtIssCd;
	
	/** The account of cd sw */
	private String acctOfCdSw;
	
	/** The old assd No */
	private Integer oldAssdNo;
	
	/** The old address1 */
	private String oldAddress1;
	
	/** The old address2 */
	private String oldAddress2;
	
	/** The old address3 */
	private String oldAddress3;
	
	/** The ann tsi amt */
	private BigDecimal annTsiAmt;
	
	/** The prem amt */
	private BigDecimal premAmt;
	
	/** The tsi amt */
	private BigDecimal tsiAmt;
	
	/** The annual premium amount */
	private BigDecimal annPremAmt;
	
	/** The bank ref no */
	private String bankRefNo;
	
	/** The user id */
	private String userId;
	
	/** The banc assurance switch */
	private String bancassuranceSw;
	
	/** The banc type cd */
	private String bancTypeCd;
	
	/** The banc type desc */
	
	private String bancTypeDesc;
	
	/** The area cd */
	private String areaCd;
	
	/** The area desc */
	private String areaDesc;
	
	/** The branch cd */
	private String branchCd;
	
	/** The branch desc */
	private String branchDesc;
	
	/** The manager cd */
	private String managerCd;
	
	/** The company cd */
	private Integer companyCd;
	
	/** The employee cd */
	private String employeeCd;
	
	/** The plan sw */
	private String planSw;
	
	/** The plan cd */
	private Integer planCd;
	
	/** The plan ch tag */
	private String planChTag;
	
	// (temporary) 
	// emman 11.18.2010 - don't delete the following variables anymore for they will still be used by other modules
	// other variables
	
	private String cancelType;
	
	private String takeupTerm;
	
	private String premWarrTag;
	
	private String premWarrDays;
	
	private String surveyAgentCd;
	
	private String settlingAgentCd;
	
	private String dspAreaCd;
	
	private Integer parId;
	
	private Integer prorateDays;
	
	private String updateIssueDate;
	
	// andrew - 03.11.2011
	private List<GIPIWPackLineSubline> gipiwPackLineSubline;	

	public Integer getPackParId() {
		return packParId;
	}

	public void setPackParId(Integer packParId) {
		this.packParId = packParId;
	}

	public String getLabelTag() {
		return labelTag;
	}

	public void setLabelTag(String labelTag) {
		this.labelTag = labelTag;
	}

	public Integer getAssdNo() {
		return assdNo;
	}

	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}

	public String getDspAssdName() {
		return dspAssdName;
	}

	public void setDspAssdName(String dspAssdName) {
		this.dspAssdName = dspAssdName;
	}

	public String getAcctOfName() {
		return acctOfName;
	}

	public void setAcctOfName(String acctOfName) {
		this.acctOfName = acctOfName;
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

	public String getSurchargeSw() {
		return surchargeSw;
	}

	public void setSurchargeSw(String surchargeSw) {
		this.surchargeSw = surchargeSw;
	}

	public String getManualRenewNo() {
		return manualRenewNo;
	}

	public void setManualRenewNo(String manualRenewNo) {
		this.manualRenewNo = manualRenewNo;
	}

	public String getDiscountSw() {
		return discountSw;
	}

	public void setDiscountSw(String discountSw) {
		this.discountSw = discountSw;
	}

	public String getPolFlag() {
		return polFlag;
	}

	public void setPolFlag(String polFlag) {
		this.polFlag = polFlag;
	}

	public String getTypeCd() {
		return typeCd;
	}

	public void setTypeCd(String typeCd) {
		this.typeCd = typeCd;
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

	public Integer getBookingYear() {
		return bookingYear;
	}

	public void setBookingYear(Integer bookingYear) {
		this.bookingYear = bookingYear;
	}

	public String getBookingMth() {
		return bookingMth;
	}

	public void setBookingMth(String bookingMth) {
		this.bookingMth = bookingMth;
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

	public String getPlaceCd() {
		return placeCd;
	}

	public void setPlaceCd(String placeCd) {
		this.placeCd = placeCd;
	}

	public String getInceptTag() {
		return inceptTag;
	}

	public void setInceptTag(String inceptTag) {
		this.inceptTag = inceptTag;
	}

	public String getExpiryTag() {
		return expiryTag;
	}

	public void setExpiryTag(String expiryTag) {
		this.expiryTag = expiryTag;
	}

	public String getRiskTag() {
		return riskTag;
	}

	public void setRiskTag(String riskTag) {
		this.riskTag = riskTag;
	}

	public String getRefPolNo() {
		return refPolNo;
	}

	public void setRefPolNo(String refPolNo) {
		this.refPolNo = refPolNo;
	}

	public String getIndustryCd() {
		return industryCd;
	}

	public void setIndustryCd(String industryCd) {
		this.industryCd = industryCd;
	}

	public String getRegionCd() {
		return regionCd;
	}

	public void setRegionCd(String regionCd) {
		this.regionCd = regionCd;
	}

	public String getCredBranch() {
		return credBranch;
	}

	public void setCredBranch(String credBranch) {
		this.credBranch = credBranch;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public String getQuotationPrintedSw() {
		return quotationPrintedSw;
	}

	public void setQuotationPrintedSw(String quotationPrintedSw) {
		this.quotationPrintedSw = quotationPrintedSw;
	}

	public String getCovernotePrintedSw() {
		return covernotePrintedSw;
	}

	public void setCovernotePrintedSw(String covernotePrintedSw) {
		this.covernotePrintedSw = covernotePrintedSw;
	}

	public String getPackPolFlag() {
		return packPolFlag;
	}

	public void setPackPolFlag(String packPolFlag) {
		this.packPolFlag = packPolFlag;
	}

	public String getAutoRenewFlag() {
		return autoRenewFlag;
	}

	public void setAutoRenewFlag(String autoRenewFlag) {
		this.autoRenewFlag = autoRenewFlag;
	}

	public String getForeignAccSw() {
		return foreignAccSw;
	}

	public void setForeignAccSw(String foreignAccSw) {
		this.foreignAccSw = foreignAccSw;
	}

	public String getRegPolicySw() {
		return regPolicySw;
	}

	public void setRegPolicySw(String regPolicySw) {
		this.regPolicySw = regPolicySw;
	}

	public String getFleetPrintTag() {
		return fleetPrintTag;
	}

	public void setFleetPrintTag(String fleetPrintTag) {
		this.fleetPrintTag = fleetPrintTag;
	}

	public String getWithTariffSw() {
		return withTariffSw;
	}

	public void setWithTariffSw(String withTariffSw) {
		this.withTariffSw = withTariffSw;
	}

	public String getCoInsuranceSw() {
		return coInsuranceSw;
	}

	public void setCoInsuranceSw(String coInsuranceSw) {
		this.coInsuranceSw = coInsuranceSw;
	}

	public String getProrateFlag() {
		return prorateFlag;
	}

	public void setProrateFlag(String prorateFlag) {
		this.prorateFlag = prorateFlag;
	}

	public String getCompSw() {
		return compSw;
	}

	public void setCompSw(String compSw) {
		this.compSw = compSw;
	}

	public BigDecimal getShortRtPercent() {
		return shortRtPercent;
	}

	public void setShortRtPercent(BigDecimal shortRtPercent) {
		this.shortRtPercent = shortRtPercent;
	}

	public String getProvPremTag() {
		return provPremTag;
	}

	public void setProvPremTag(String provPremTag) {
		this.provPremTag = provPremTag;
	}

	public BigDecimal getProvPremPct() {
		return provPremPct;
	}

	public void setProvPremPct(BigDecimal provPremPct) {
		this.provPremPct = provPremPct;
	}

	public String getDesignation() {
		return designation;
	}

	public void setDesignation(String designation) {
		this.designation = designation;
	}

	public String getAcctOfCd() {
		return acctOfCd;
	}

	public void setAcctOfCd(String acctOfCd) {
		this.acctOfCd = acctOfCd;
	}

	public String getInvoiceSw() {
		return invoiceSw;
	}

	public void setInvoiceSw(String invoiceSw) {
		this.invoiceSw = invoiceSw;
	}

	public Integer getRenewNo() {
		return renewNo;
	}

	public void setRenewNo(Integer renewNo) {
		this.renewNo = renewNo;
	}

	public Integer getIssueYy() {
		return issueYy;
	}

	public void setIssueYy(Integer issueYy) {
		this.issueYy = issueYy;
	}

	public String getRefOpenPolNo() {
		return refOpenPolNo;
	}

	public void setRefOpenPolNo(String refOpenPolNo) {
		this.refOpenPolNo = refOpenPolNo;
	}

	public String getSamePolnoSw() {
		return samePolnoSw;
	}

	public void setSamePolnoSw(String samePolnoSw) {
		this.samePolnoSw = samePolnoSw;
	}

	public Integer getEndtYy() {
		return endtYy;
	}

	public void setEndtYy(Integer endtYy) {
		this.endtYy = endtYy;
	}

	public String getEndtSeqNo() {
		return endtSeqNo;
	}

	public void setEndtSeqNo(String endtSeqNo) {
		this.endtSeqNo = endtSeqNo;
	}

	public String getMortgName() {
		return mortgName;
	}

	public void setMortgName(String mortgName) {
		this.mortgName = mortgName;
	}

	public String getValidateTag() {
		return validateTag;
	}

	public void setValidateTag(String validateTag) {
		this.validateTag = validateTag;
	}

	public Integer getPolSeqNo() {
		return polSeqNo;
	}

	public void setPolSeqNo(Integer polSeqNo) {
		this.polSeqNo = polSeqNo;
	}

	public String getBackStat() {
		return backStat;
	}

	public void setBackStat(String backStat) {
		this.backStat = backStat;
	}

	public Date getEffDate() {
		return effDate;
	}

	public Object getStrEffDate(){
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(effDate != null){
			return sdf.format(effDate).toString();
		} else {
			return null;
		}
	}	
	
	public void setEffDate(Date effDate) {
		this.effDate = effDate;
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

	public String getAcctOfCdSw() {
		return acctOfCdSw;
	}

	public void setAcctOfCdSw(String acctOfCdSw) {
		this.acctOfCdSw = acctOfCdSw;
	}

	public Integer getOldAssdNo() {
		return oldAssdNo;
	}

	public void setOldAssdNo(Integer oldAssdNo) {
		this.oldAssdNo = oldAssdNo;
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

	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}

	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}

	public BigDecimal getPremAmt() {
		return premAmt;
	}

	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}

	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}

	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}

	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}

	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}

	public void setPremWarrDays(String premWarrDays) {
		this.premWarrDays = premWarrDays;
	}

	public String getPremWarrDays() {
		return premWarrDays;
	}

	public void setPremWarrTag(String premWarrTag) {
		this.premWarrTag = premWarrTag;
	}

	public String getPremWarrTag() {
		return premWarrTag;
	}

	public void setTakeupTerm(String takeupTerm) {
		this.takeupTerm = takeupTerm;
	}

	public String getTakeupTerm() {
		return takeupTerm;
	}

	public void setCancelType(String cancelType) {
		this.cancelType = cancelType;
	}

	public String getCancelType() {
		return cancelType;
	}
	
	public String getSurveyAgentCd() {
		return surveyAgentCd;
	}

	public void setSurveyAgentCd(String surveyAgentCd) {
		this.surveyAgentCd = surveyAgentCd;
	}

	public String getSettlingAgentCd() {
		return settlingAgentCd;
	}

	public void setSettlingAgentCd(String settlingAgentCd) {
		this.settlingAgentCd = settlingAgentCd;
	}

	public String getPlaceDesc() {
		return placeDesc;
	}

	public void setPlaceDesc(String placeDesc) {
		this.placeDesc = placeDesc;
	}

	public String getIndustryDesc() {
		return industryDesc;
	}

	public void setIndustryDesc(String industryDesc) {
		this.industryDesc = industryDesc;
	}

	public String getRegionDesc() {
		return regionDesc;
	}

	public void setRegionDesc(String regionDesc) {
		this.regionDesc = regionDesc;
	}

	public String getCredBranchDesc() {
		return credBranchDesc;
	}

	public void setCredBranchDesc(String credBranchDesc) {
		this.credBranchDesc = credBranchDesc;
	}

	public String getBankRefNo() {
		return bankRefNo;
	}

	public void setBankRefNo(String bankRefNo) {
		this.bankRefNo = bankRefNo;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getBancassuranceSw() {
		return bancassuranceSw;
	}

	public void setBancassuranceSw(String bancassuranceSw) {
		this.bancassuranceSw = bancassuranceSw;
	}

	public String getBancTypeCd() {
		return bancTypeCd;
	}

	public void setBancTypeCd(String bancTypeCd) {
		this.bancTypeCd = bancTypeCd;
	}

	public String getBancTypeDesc() {
		return bancTypeDesc;
	}

	public void setBancTypeDesc(String bancTypeDesc) {
		this.bancTypeDesc = bancTypeDesc;
	}

	public String getAreaCd() {
		return areaCd;
	}

	public void setAreaCd(String areaCd) {
		this.areaCd = areaCd;
	}

	public String getAreaDesc() {
		return areaDesc;
	}

	public void setAreaDesc(String areaDesc) {
		this.areaDesc = areaDesc;
	}

	public String getBranchCd() {
		return branchCd;
	}

	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}

	public String getBranchDesc() {
		return branchDesc;
	}

	public void setBranchDesc(String branchDesc) {
		this.branchDesc = branchDesc;
	}

	public String getManagerCd() {
		return managerCd;
	}

	public void setManagerCd(String managerCd) {
		this.managerCd = managerCd;
	}

	public String getDspAreaCd() {
		return dspAreaCd;
	}

	public void setDspAreaCd(String dspAreaCd) {
		this.dspAreaCd = dspAreaCd;
	}
	
	public Integer getParId() {
		return this.parId;
	}

	public void setParId(Integer parId) {
		this.parId = parId;
	}
	
	public Integer getCompanyCd() {
		return this.companyCd;
	}
	
	public void setCompanyCd(Integer companyCd) {
		this.companyCd = companyCd;
	}

	public void setProrateDays(Integer prorateDays) {
		this.prorateDays = prorateDays;
	}

	public Integer getProrateDays() {
		return prorateDays;
	}

	public void setEmployeeCd(String employeeCd) {
		this.employeeCd = employeeCd;
	}

	public String getEmployeeCd() {
		return employeeCd;
	}

	public void setPlanSw(String planSw) {
		this.planSw = planSw;
	}

	public String getPlanSw() {
		return planSw;
	}

	public void setPlanCd(Integer planCd) {
		this.planCd = planCd;
	}

	public Integer getPlanCd() {
		return planCd;
	}

	public void setPlanChTag(String planChTag) {
		this.planChTag = planChTag;
	}

	public String getPlanChTag() {
		return planChTag;
	}

	public void setUpdateIssueDate(String updateIssueDate) {
		this.updateIssueDate = updateIssueDate;
	}

	public String getUpdateIssueDate() {
		return updateIssueDate;
	}

	public void setGipiwPackLineSubline(List<GIPIWPackLineSubline> gipiwPackLineSubline) {
		this.gipiwPackLineSubline = gipiwPackLineSubline;
	}

	public List<GIPIWPackLineSubline> getGipiwPackLineSubline() {
		return gipiwPackLineSubline;
	}
	
} 