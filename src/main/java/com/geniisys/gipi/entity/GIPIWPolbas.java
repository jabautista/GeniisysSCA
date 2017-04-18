/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIWPolbas.
 */
public class GIPIWPolbas extends BaseEntity {

	/** The par id. */
	private Integer parId;
	
	/** The line cd. */
	private String lineCd;
	// GIPI_WPOLBAS B540 Basic Information
	/** The invoice sw. */
	private String invoiceSw;
	
	/** The subline cd. */
	private String sublineCd;
	
	/** The pol flag. */
	private String polFlag;
	
	/** The manual renew no. */
	private String manualRenewNo;
	
	/** The type cd. */
	private String typeCd;
	
	/** The address1. */
	private String address1;
	
	/** The address2. */
	private String address2;
	
	/** The address3. */
	private String address3;
	
	/** The cred branch. */
	private String credBranch;
	
	/** The iss cd. */
	private String issCd;

	/** The assd no. */
	private String assdNo;
	
	/** The acct of cd. */
	private String acctOfCd;
	
	/** The issue date. */
	private Date issueDate;
	
	/** The place cd. */
	private String placeCd;
	
	/** The risk tag. */
	private String riskTag;
	
	/** The ref pol no. */
	private String refPolNo;
	
	/** The industry cd. */
	private String industryCd;
	
	/** The region cd. */
	private String regionCd;

	/** The quotation printed sw. */
	private String quotationPrintedSw;
	
	/** The covernote printed sw. */
	private String covernotePrintedSw;
	
	/** The pack pol flag. */
	private String packPolFlag;
	
	/** The auto renew flag. */
	private String autoRenewFlag;
	
	/** The foreign acc sw. */
	private String foreignAccSw;
	
	/** The reg policy sw. */
	private String regPolicySw;
	
	/** The prem warr tag. */
	private String premWarrTag;
	
	/** The prem warr days. */
	private String premWarrDays;
	
	/** The fleet print tag. */
	private String fleetPrintTag;
	
	/** The with tariff sw. */
	private String withTariffSw;
	
	/** The prov prem tag. */
	private String provPremTag;
	
	/** The prov prem pct. */
	private String provPremPct;

	// Period of Insurance
	/** The incept date. */
	private Date inceptDate;
	
	/** The incept tag. */
	private String inceptTag;
	
	/** The expiry date. */
	private Date expiryDate;
	
	/** The expiry tag. */
	private String expiryTag;
	
	/** The prorate flag. */
	private String prorateFlag; // condition
	
	/** The comp sw. */
	private String compSw; // +1 -1 ordinary
	
	/** The short rt percent. */
	private String shortRtPercent; // for short rate
	
	/** The booking year. */
	private String bookingYear;
	
	/** The booking mth. */
	private String bookingMth;
	
	/** The co insurance sw. */
	private String coInsuranceSw;
	
	/** The takeup term. */
	private String takeupTerm;

	// for non base table
	/** The dsp assd name. */
	private String dspAssdName;
	
	/** The acct of name. */
	private String acctOfName;

	// for misc
	/** The designation. */
	private String designation;
	
	/** The user id. */
	private String userId;
	
	/** The msg alert. */
	private String msgAlert;
	
	/** The renew no. */
	private String renewNo;
	
	/** The ref open pol no. */
	private String refOpenPolNo;
	
	/** The same polno sw. */
	private String samePolnoSw;
	
	/** The endt yy. */
	private String endtYy;
	
	/** The endt seq no. */
	private String endtSeqNo;
	
	/** The update issue date. */
	private String updateIssueDate;
	
	//inadd ko lang ito para sa parameter sa insert sa ngaun
	/** The label tag. */
	private String labelTag;
	
	/** The surcharge sw. */
	private String surchargeSw;
	
	/** The discount sw. */
	private String discountSw;
	
	/** The survey agent cd. */
	private String surveyAgentCd;
	
	/** The settling agent cd. */
	private String settlingAgentCd;
	
	/** The issue yy. */
	private Integer issueYy;
	
	/** The pol seq no. */
	private Integer polSeqNo;
	
	/** The pack par id. */
	private Integer packParId;
	private String mortgName;
	private String validateTag;
	private String backStat;
	private Date effDate;
	private Date endtExpiryDate;
	private String cancelType;
	
	private String endtExpiryTag;
	private Integer oldAssdNo;
	private String endtIssCd;
	private String acctOfCdSw;
	private String oldAddress1;
	private String oldAddress2;
	private String oldAddress3;
	private BigDecimal annTsiAmt;
	private BigDecimal premAmt;
	private BigDecimal tsiAmt;
	private BigDecimal annPremAmt;	
	private Integer planCd;
	private String planChTag;
	private String planSw;
	private String companyCd;
	private String employeeCd;
	private String bankRefNo;
	private String bancTypeCd;
	private String bancassuranceSw;
	private String areaCd;
	private String branchCd;
	private String managerCd;
	
	private String bancTypeDesc;
	private String areaDesc;
	private String branchDesc;
	private String payeeName;
	private String surveyAgentName;
	private String settlingAgentName;
	
	private Integer bondSeqNo; // Udel 05292012 added for IC bond sequence
	private Integer cancelledEndtId; //robert 
	private String bondAutoPrem; //added by robert GENQA 4828 08.27.15
	
	private Integer policyId;
	private String riCd;
	


	public GIPIWPolbas(){
		
	}
	
	private static Logger log = Logger.getLogger(GIPIWPolbas.class);
	
	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	public String getRiCd() {
		return riCd;
	}

	public void setRiCd(String riCd) {
		this.riCd = riCd;
	}
	
	public String getEndtExpiryTag() {
		return endtExpiryTag;
	}

	public void setEndtExpiryTag(String endtExpiryTag) {
		this.endtExpiryTag = endtExpiryTag;
	}

	public Integer getOldAssdNo() {
		return oldAssdNo;
	}

	public void setOldAssdNo(Integer oldAssdNo) {
		this.oldAssdNo = oldAssdNo;
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

	public String getCancelType() {
		return cancelType;
	}

	public void setCancelType(String cancelType) {
		this.cancelType = cancelType;
	}

	public Date getEffDate() {
		return effDate;
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

	public String getBackStat() {
		return backStat;
	}

	public void setBackStat(String backStat) {
		this.backStat = backStat;
	}

	public String getValidateTag() {
		return validateTag;
	}

	public void setValidateTag(String validateTag) {
		this.validateTag = validateTag;
	}

	public String getMortgName() {
		return mortgName;
	}

	public void setMortgName(String mortgName) {
		this.mortgName = mortgName;
	}

	/**
	 * Gets the update issue date.
	 * 
	 * @return the update issue date
	 */
	public String getUpdateIssueDate() {
		return updateIssueDate;
	}
	
	/**
	 * Sets the update issue date.
	 * 
	 * @param updateIssueDate the new update issue date
	 */
	public void setUpdateIssueDate(String updateIssueDate) {
		this.updateIssueDate = updateIssueDate;
	}
	
	/**
	 * Gets the endt yy.
	 * 
	 * @return the endt yy
	 */
	public String getEndtYy() {
		return endtYy;
	}
	
	/**
	 * Sets the endt yy.
	 * 
	 * @param endtYy the new endt yy
	 */
	public void setEndtYy(String endtYy) {
		this.endtYy = endtYy;
	}
	
	/**
	 * Gets the endt seq no.
	 * 
	 * @return the endt seq no
	 */
	public String getEndtSeqNo() {
		return endtSeqNo;
	}
	
	/**
	 * Sets the endt seq no.
	 * 
	 * @param endtSeqNo the new endt seq no
	 */
	public void setEndtSeqNo(String endtSeqNo) {
		this.endtSeqNo = endtSeqNo;
	}
	
	/**
	 * Gets the same polno sw.
	 * 
	 * @return the same polno sw
	 */
	public String getSamePolnoSw() {
		return samePolnoSw;
	}
	
	/**
	 * Sets the same polno sw.
	 * 
	 * @param samePolnoSw the new same polno sw
	 */
	public void setSamePolnoSw(String samePolnoSw) {
		this.samePolnoSw = samePolnoSw;
	}
	
	/**
	 * Gets the ref open pol no.
	 * 
	 * @return the ref open pol no
	 */
	public String getRefOpenPolNo() {
		return refOpenPolNo;
	}
	
	/**
	 * Sets the ref open pol no.
	 * 
	 * @param refOpenPolNo the new ref open pol no
	 */
	public void setRefOpenPolNo(String refOpenPolNo) {
		this.refOpenPolNo = refOpenPolNo;
	}
	
	/**
	 * Gets the pack par id.
	 * 
	 * @return the pack par id
	 */
	public Integer getPackParId() {
		return packParId;
	}
	
	/**
	 * Sets the pack par id.
	 * 
	 * @param packParId the new pack par id
	 */
	public void setPackParId(Integer packParId) {
		this.packParId = packParId;
	}
	
	/**
	 * Gets the pol seq no.
	 * 
	 * @return the pol seq no
	 */
	public Integer getPolSeqNo() {
		return polSeqNo;
	}
	
	/**
	 * Sets the pol seq no.
	 * 
	 * @param polSeqNo the new pol seq no
	 */
	public void setPolSeqNo(Integer polSeqNo) {
		this.polSeqNo = polSeqNo;
	}
	
	/**
	 * Gets the issue yy.
	 * 
	 * @return the issue yy
	 */
	public Integer getIssueYy() {
		return issueYy;
	}
	
	/**
	 * Sets the issue yy.
	 * 
	 * @param issueYy the new issue yy
	 */
	public void setIssueYy(Integer issueYy) {
		this.issueYy = issueYy;
	}
	
	/**
	 * Gets the renew no.
	 * 
	 * @return the renew no
	 */
	public String getRenewNo() {
		return renewNo;
	}
	
	/**
	 * Sets the renew no.
	 * 
	 * @param renewNo the new renew no
	 */
	public void setRenewNo(String renewNo) {
		this.renewNo = renewNo;
	}
	
	/**
	 * Gets the label tag.
	 * 
	 * @return the label tag
	 */
	public String getLabelTag() {
		return labelTag;
	}
	
	/**
	 * Sets the label tag.
	 * 
	 * @param labelTag the new label tag
	 */
	public void setLabelTag(String labelTag) {
		this.labelTag = labelTag;
	}
	
	/**
	 * Gets the surcharge sw.
	 * 
	 * @return the surcharge sw
	 */
	public String getSurchargeSw() {
		return surchargeSw;
	}
	
	/**
	 * Sets the surcharge sw.
	 * 
	 * @param surchargeSw the new surcharge sw
	 */
	public void setSurchargeSw(String surchargeSw) {
		this.surchargeSw = surchargeSw;
	}
	
	/**
	 * Gets the discount sw.
	 * 
	 * @return the discount sw
	 */
	public String getDiscountSw() {
		return discountSw;
	}
	
	/**
	 * Sets the discount sw.
	 * 
	 * @param discountSw the new discount sw
	 */
	public void setDiscountSw(String discountSw) {
		this.discountSw = discountSw;
	}
	
	/**
	 * Gets the survey agent cd.
	 * 
	 * @return the survey agent cd
	 */
	public String getSurveyAgentCd() {
		return surveyAgentCd;
	}
	
	/**
	 * Sets the survey agent cd.
	 * 
	 * @param surveyAgentCd the new survey agent cd
	 */
	public void setSurveyAgentCd(String surveyAgentCd) {
		this.surveyAgentCd = surveyAgentCd;
	}
	
	/**
	 * Gets the settling agent cd.
	 * 
	 * @return the settling agent cd
	 */
	public String getSettlingAgentCd() {
		return settlingAgentCd;
	}
	
	/**
	 * Sets the settling agent cd.
	 * 
	 * @param settlingAgentCd the new settling agent cd
	 */
	public void setSettlingAgentCd(String settlingAgentCd) {
		this.settlingAgentCd = settlingAgentCd;
	}
	
	/**
	 * Gets the line cd.
	 * 
	 * @return the line cd
	 */
	public String getLineCd() {
		return lineCd;
	}
	
	/**
	 * Sets the line cd.
	 * 
	 * @param lineCd the new line cd
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	
	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public Integer getParId() {
		return parId;
	}
	
	/**
	 * Sets the par id.
	 * 
	 * @param parId the new par id
	 */
	public void setParId(Integer parId) {
		this.parId = parId;
	}
	
	/**
	 * Gets the invoice sw.
	 * 
	 * @return the invoice sw
	 */
	public String getInvoiceSw() {
		return invoiceSw;
	}
	
	/**
	 * Sets the invoice sw.
	 * 
	 * @param invoiceSw the new invoice sw
	 */
	public void setInvoiceSw(String invoiceSw) {
		this.invoiceSw = invoiceSw;
	}
	
	/**
	 * Gets the subline cd.
	 * 
	 * @return the subline cd
	 */
	public String getSublineCd() {
		return sublineCd;
	}
	
	/**
	 * Sets the subline cd.
	 * 
	 * @param sublineCd the new subline cd
	 */
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	
	/**
	 * Gets the pol flag.
	 * 
	 * @return the pol flag
	 */
	public String getPolFlag() {
		return polFlag;
	}
	
	/**
	 * Sets the pol flag.
	 * 
	 * @param polFlag the new pol flag
	 */
	public void setPolFlag(String polFlag) {
		this.polFlag = polFlag;
	}
	
	/**
	 * Gets the manual renew no.
	 * 
	 * @return the manual renew no
	 */
	public String getManualRenewNo() {
		return manualRenewNo;
	}
	
	/**
	 * Sets the manual renew no.
	 * 
	 * @param manualRenewNo the new manual renew no
	 */
	public void setManualRenewNo(String manualRenewNo) {
		this.manualRenewNo = manualRenewNo;
	}
	
	/**
	 * Gets the type cd.
	 * 
	 * @return the type cd
	 */
	public String getTypeCd() {
		return typeCd;
	}
	
	/**
	 * Sets the type cd.
	 * 
	 * @param typeCd the new type cd
	 */
	public void setTypeCd(String typeCd) {
		this.typeCd = typeCd;
	}
	
	/**
	 * Gets the address1.
	 * 
	 * @return the address1
	 */
	public String getAddress1() {
		return address1;
	}
	
	/**
	 * Sets the address1.
	 * 
	 * @param address1 the new address1
	 */
	public void setAddress1(String address1) {
		this.address1 = address1;
	}
	
	/**
	 * Gets the address2.
	 * 
	 * @return the address2
	 */
	public String getAddress2() {
		return address2;
	}
	
	/**
	 * Sets the address2.
	 * 
	 * @param address2 the new address2
	 */
	public void setAddress2(String address2) {
		this.address2 = address2;
	}
	
	/**
	 * Gets the address3.
	 * 
	 * @return the address3
	 */
	public String getAddress3() {
		return address3;
	}
	
	/**
	 * Sets the address3.
	 * 
	 * @param address3 the new address3
	 */
	public void setAddress3(String address3) {
		this.address3 = address3;
	}
	
	/**
	 * Gets the cred branch.
	 * 
	 * @return the cred branch
	 */
	public String getCredBranch() {
		return credBranch;
	}
	
	/**
	 * Sets the cred branch.
	 * 
	 * @param credBranch the new cred branch
	 */
	public void setCredBranch(String credBranch) {
		this.credBranch = credBranch;
	}
	
	/**
	 * Gets the iss cd.
	 * 
	 * @return the iss cd
	 */
	public String getIssCd() {
		return issCd;
	}
	
	/**
	 * Sets the iss cd.
	 * 
	 * @param issCd the new iss cd
	 */
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	
	/**
	 * Gets the assd no.
	 * 
	 * @return the assd no
	 */
	public String getAssdNo() {
		return assdNo;
	}
	
	/**
	 * Sets the assd no.
	 * 
	 * @param assdNo the new assd no
	 */
	public void setAssdNo(String assdNo) {
		this.assdNo = assdNo;
	}
	
	/**
	 * Gets the acct of cd.
	 * 
	 * @return the acct of cd
	 */
	public String getAcctOfCd() {
		return acctOfCd;
	}
	
	/**
	 * Sets the acct of cd.
	 * 
	 * @param acctOfCd the new acct of cd
	 */
	public void setAcctOfCd(String acctOfCd) {
		this.acctOfCd = acctOfCd;
	}
	
	/**
	 * Gets the issue date.
	 * 
	 * @return the issue date
	 */
	public Date getIssueDate() {
		return issueDate;
	}
	
	/**
	 * Sets the issue date.
	 * 
	 * @param issueDate the new issue date
	 */
	public void setIssueDate(Date issueDate) {
		this.issueDate = issueDate;
	}
	
	/**
	 * Gets the place cd.
	 * 
	 * @return the place cd
	 */
	public String getPlaceCd() {
		return placeCd;
	}
	
	/**
	 * Sets the place cd.
	 * 
	 * @param placeCd the new place cd
	 */
	public void setPlaceCd(String placeCd) {
		this.placeCd = placeCd;
	}
	
	/**
	 * Gets the risk tag.
	 * 
	 * @return the risk tag
	 */
	public String getRiskTag() {
		return riskTag;
	}
	
	/**
	 * Sets the risk tag.
	 * 
	 * @param riskTag the new risk tag
	 */
	public void setRiskTag(String riskTag) {
		this.riskTag = riskTag;
	}
	
	/**
	 * Gets the ref pol no.
	 * 
	 * @return the ref pol no
	 */
	public String getRefPolNo() {
		return refPolNo;
	}
	
	/**
	 * Sets the ref pol no.
	 * 
	 * @param refPolNo the new ref pol no
	 */
	public void setRefPolNo(String refPolNo) {
		this.refPolNo = refPolNo;
	}
	
	/**
	 * Gets the industry cd.
	 * 
	 * @return the industry cd
	 */
	public String getIndustryCd() {
		return industryCd;
	}
	
	/**
	 * Sets the industry cd.
	 * 
	 * @param industryCd the new industry cd
	 */
	public void setIndustryCd(String industryCd) {
		this.industryCd = industryCd;
	}
	
	/**
	 * Gets the region cd.
	 * 
	 * @return the region cd
	 */
	public String getRegionCd() {
		return regionCd;
	}
	
	/**
	 * Sets the region cd.
	 * 
	 * @param regionCd the new region cd
	 */
	public void setRegionCd(String regionCd) {
		this.regionCd = regionCd;
	}
	
	/**
	 * Gets the quotation printed sw.
	 * 
	 * @return the quotation printed sw
	 */
	public String getQuotationPrintedSw() {
		return quotationPrintedSw;
	}
	
	/**
	 * Sets the quotation printed sw.
	 * 
	 * @param quotationPrintedSw the new quotation printed sw
	 */
	public void setQuotationPrintedSw(String quotationPrintedSw) {
		this.quotationPrintedSw = quotationPrintedSw;
	}
	
	/**
	 * Gets the covernote printed sw.
	 * 
	 * @return the covernote printed sw
	 */
	public String getCovernotePrintedSw() {
		return covernotePrintedSw;
	}
	
	/**
	 * Sets the covernote printed sw.
	 * 
	 * @param covernotePrintedSw the new covernote printed sw
	 */
	public void setCovernotePrintedSw(String covernotePrintedSw) {
		this.covernotePrintedSw = covernotePrintedSw;
	}
	
	/**
	 * Gets the pack pol flag.
	 * 
	 * @return the pack pol flag
	 */
	public String getPackPolFlag() {
		return packPolFlag;
	}
	
	/**
	 * Sets the pack pol flag.
	 * 
	 * @param packPolFlag the new pack pol flag
	 */
	public void setPackPolFlag(String packPolFlag) {
		this.packPolFlag = packPolFlag;
	}
	
	/**
	 * Gets the auto renew flag.
	 * 
	 * @return the auto renew flag
	 */
	public String getAutoRenewFlag() {
		return autoRenewFlag;
	}
	
	/**
	 * Sets the auto renew flag.
	 * 
	 * @param autoRenewFlag the new auto renew flag
	 */
	public void setAutoRenewFlag(String autoRenewFlag) {
		this.autoRenewFlag = autoRenewFlag;
	}
	
	/**
	 * Gets the foreign acc sw.
	 * 
	 * @return the foreign acc sw
	 */
	public String getForeignAccSw() {
		return foreignAccSw;
	}
	
	/**
	 * Sets the foreign acc sw.
	 * 
	 * @param foreignAccSw the new foreign acc sw
	 */
	public void setForeignAccSw(String foreignAccSw) {
		this.foreignAccSw = foreignAccSw;
	}
	
	/**
	 * Gets the reg policy sw.
	 * 
	 * @return the reg policy sw
	 */
	public String getRegPolicySw() {
		return regPolicySw;
	}
	
	/**
	 * Sets the reg policy sw.
	 * 
	 * @param regPolicySw the new reg policy sw
	 */
	public void setRegPolicySw(String regPolicySw) {
		this.regPolicySw = regPolicySw;
	}
	
	/**
	 * Gets the prem warr tag.
	 * 
	 * @return the prem warr tag
	 */
	public String getPremWarrTag() {
		return premWarrTag;
	}
	
	/**
	 * Sets the prem warr tag.
	 * 
	 * @param premWarrTag the new prem warr tag
	 */
	public void setPremWarrTag(String premWarrTag) {
		this.premWarrTag = premWarrTag;
	}
	
	/**
	 * Gets the prem warr days.
	 * 
	 * @return the prem warr days
	 */
	public String getPremWarrDays() {
		return premWarrDays;
	}
	
	/**
	 * Sets the prem warr days.
	 * 
	 * @param premWarrDays the new prem warr days
	 */
	public void setPremWarrDays(String premWarrDays) {
		this.premWarrDays = premWarrDays;
	}
	
	/**
	 * Gets the fleet print tag.
	 * 
	 * @return the fleet print tag
	 */
	public String getFleetPrintTag() {
		return fleetPrintTag;
	}
	
	/**
	 * Sets the fleet print tag.
	 * 
	 * @param fleetPrintTag the new fleet print tag
	 */
	public void setFleetPrintTag(String fleetPrintTag) {
		this.fleetPrintTag = fleetPrintTag;
	}
	
	/**
	 * Gets the with tariff sw.
	 * 
	 * @return the with tariff sw
	 */
	public String getWithTariffSw() {
		return withTariffSw;
	}
	
	/**
	 * Sets the with tariff sw.
	 * 
	 * @param withTariffSw the new with tariff sw
	 */
	public void setWithTariffSw(String withTariffSw) {
		this.withTariffSw = withTariffSw;
	}
	
	/**
	 * Gets the prov prem tag.
	 * 
	 * @return the prov prem tag
	 */
	public String getProvPremTag() {
		return provPremTag;
	}
	
	/**
	 * Sets the prov prem tag.
	 * 
	 * @param provPremTag the new prov prem tag
	 */
	public void setProvPremTag(String provPremTag) {
		this.provPremTag = provPremTag;
	}
	
	/**
	 * Gets the prov prem pct.
	 * 
	 * @return the prov prem pct
	 */
	public String getProvPremPct() {
		return provPremPct;
	}
	
	/**
	 * Sets the prov prem pct.
	 * 
	 * @param provPremPct the new prov prem pct
	 */
	public void setProvPremPct(String provPremPct) {
		this.provPremPct = provPremPct;
	}
	
	/**
	 * Gets the incept date.
	 * 
	 * @return the incept date
	 */
	public Date getInceptDate() {
		return inceptDate;
	}
	
	/**
	 * Sets the incept date.
	 * 
	 * @param inceptDate the new incept date
	 */
	public void setInceptDate(Date inceptDate) {
		this.inceptDate = inceptDate;
	}
	
	/**
	 * Gets the incept tag.
	 * 
	 * @return the incept tag
	 */
	public String getInceptTag() {
		return inceptTag;
	}
	
	/**
	 * Sets the incept tag.
	 * 
	 * @param inceptTag the new incept tag
	 */
	public void setInceptTag(String inceptTag) {
		this.inceptTag = inceptTag;
	}
	
	/**
	 * Gets the expiry date.
	 * 
	 * @return the expiry date
	 */
	public Date getExpiryDate() {
		return expiryDate;
	}
	
	/**
	 * Sets the expiry date.
	 * 
	 * @param expiryDate the new expiry date
	 */
	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}
	
	/**
	 * Gets the expiry tag.
	 * 
	 * @return the expiry tag
	 */
	public String getExpiryTag() {
		return expiryTag;
	}
	
	/**
	 * Sets the expiry tag.
	 * 
	 * @param expiryTag the new expiry tag
	 */
	public void setExpiryTag(String expiryTag) {
		this.expiryTag = expiryTag;
	}
	
	/**
	 * Gets the prorate flag.
	 * 
	 * @return the prorate flag
	 */
	public String getProrateFlag() {
		return prorateFlag;
	}
	
	/**
	 * Sets the prorate flag.
	 * 
	 * @param prorateFlag the new prorate flag
	 */
	public void setProrateFlag(String prorateFlag) {
		this.prorateFlag = prorateFlag;
	}
	
	/**
	 * Gets the comp sw.
	 * 
	 * @return the comp sw
	 */
	public String getCompSw() {
		return compSw;
	}
	
	/**
	 * Sets the comp sw.
	 * 
	 * @param compSw the new comp sw
	 */
	public void setCompSw(String compSw) {
		this.compSw = compSw;
	}
	
	/**
	 * Gets the short rt percent.
	 * 
	 * @return the short rt percent
	 */
	public String getShortRtPercent() {
		return shortRtPercent;
	}
	
	/**
	 * Sets the short rt percent.
	 * 
	 * @param shortRtPercent the new short rt percent
	 */
	public void setShortRtPercent(String shortRtPercent) {
		this.shortRtPercent = shortRtPercent;
	}
	
	/**
	 * Gets the booking year.
	 * 
	 * @return the booking year
	 */
	public String getBookingYear() {
		return bookingYear;
	}
	
	/**
	 * Sets the booking year.
	 * 
	 * @param bookingYear the new booking year
	 */
	public void setBookingYear(String bookingYear) {
		this.bookingYear = bookingYear;
	}
	
	/**
	 * Gets the booking mth.
	 * 
	 * @return the booking mth
	 */
	public String getBookingMth() {
		return bookingMth;
	}
	
	/**
	 * Sets the booking mth.
	 * 
	 * @param bookingMth the new booking mth
	 */
	public void setBookingMth(String bookingMth) {
		this.bookingMth = bookingMth;
	}
	
	/**
	 * Gets the co insurance sw.
	 * 
	 * @return the co insurance sw
	 */
	public String getCoInsuranceSw() {
		return coInsuranceSw;
	}
	
	/**
	 * Sets the co insurance sw.
	 * 
	 * @param coInsuranceSw the new co insurance sw
	 */
	public void setCoInsuranceSw(String coInsuranceSw) {
		this.coInsuranceSw = coInsuranceSw;
	}
	
	/**
	 * Gets the takeup term.
	 * 
	 * @return the takeup term
	 */
	public String getTakeupTerm() {
		return takeupTerm;
	}
	
	/**
	 * Sets the takeup term.
	 * 
	 * @param takeupTerm the new takeup term
	 */
	public void setTakeupTerm(String takeupTerm) {
		this.takeupTerm = takeupTerm;
	}
	
	/**
	 * Gets the dsp assd name.
	 * 
	 * @return the dsp assd name
	 */
	public String getDspAssdName() {
		return dspAssdName;
	}
	
	/**
	 * Sets the dsp assd name.
	 * 
	 * @param dspAssdName the new dsp assd name
	 */
	public void setDspAssdName(String dspAssdName) {
		this.dspAssdName = dspAssdName;
	}
	
	/**
	 * Gets the acct of name.
	 * 
	 * @return the acct of name
	 */
	public String getAcctOfName() {
		return acctOfName;
	}
	
	/**
	 * Sets the acct of name.
	 * 
	 * @param acctOfName the new acct of name
	 */
	public void setAcctOfName(String acctOfName) {
		this.acctOfName = acctOfName;
	}
	
	/**
	 * Gets the designation.
	 * 
	 * @return the designation
	 */
	public String getDesignation() {
		return designation;
	}
	
	/**
	 * Sets the designation.
	 * 
	 * @param designation the new designation
	 */
	public void setDesignation(String designation) {
		this.designation = designation;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseEntity#getUserId()
	 */
	@Override
	public String getUserId() {
		return userId;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseEntity#setUserId(java.lang.String)
	 */
	@Override
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	/**
	 * Gets the msg alert.
	 * 
	 * @return the msg alert
	 */
	public String getMsgAlert() {
		return msgAlert;
	}
	
	/**
	 * Sets the msg alert.
	 * 
	 * @param msgAlert the new msg alert
	 */
	public void setMsgAlert(String msgAlert) {
		this.msgAlert = msgAlert;
	}

	/**
	 * @param planCd the planCd to set
	 */
	public void setPlanCd(Integer planCd) {
		this.planCd = planCd;
	}

	/**
	 * @return the planCd
	 */
	public Integer getPlanCd() {
		return planCd;
	}

	/**
	 * @param planChTag the planChTag to set
	 */
	public void setPlanChTag(String planChTag) {
		this.planChTag = planChTag;
	}

	/**
	 * @return the planChTag
	 */
	public String getPlanChTag() {
		return planChTag;
	}

	/**
	 * @param planSw the planSw to set
	 */
	public void setPlanSw(String planSw) {
		this.planSw = planSw;
	}

	/**
	 * @return the planSw
	 */
	public String getPlanSw() {
		return planSw;
	}

	public String getCompanyCd() {
		return companyCd;
	}
	public void setCompanyCd(String companyCd) {
		this.companyCd = companyCd;
	}
	public String getEmployeeCd() {
		return employeeCd;
	}
	public void setEmployeeCd(String employeeCd) {
		this.employeeCd = employeeCd;
	}
	public String getBankRefNo() {
		return bankRefNo;
	}
	public void setBankRefNo(String bankRefNo) {
		this.bankRefNo = bankRefNo;
	}
	public String getBancTypeCd() {
		return bancTypeCd;
	}
	public void setBancTypeCd(String bancTypeCd) {
		this.bancTypeCd = bancTypeCd;
	}
	public String getBancassuranceSw() {
		return bancassuranceSw;
	}
	public void setBancassuranceSw(String bancassuranceSw) {
		this.bancassuranceSw = bancassuranceSw;
	}
	public String getAreaCd() {
		return areaCd;
	}
	public void setAreaCd(String areaCd) {
		this.areaCd = areaCd;
	}
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	public String getManagerCd() {
		return managerCd;
	}
	public void setManagerCd(String managerCd) {
		this.managerCd = managerCd;
	}
	
	public GIPIWPolbas(JSONObject obj){
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		
		try {			
			this.parId 				= obj.isNull("parId") ? null : obj.getInt("parId");
			this.lineCd 			= obj.isNull("lineCd") ? null : obj.getString("lineCd");
			this.issCd				= obj.isNull("issCd") ? null : obj.getString("issCd");
			this.foreignAccSw		= obj.isNull("foreignAccSw") ? null : obj.getString("foreignAccSw");
			this.invoiceSw			= obj.isNull("invoiceSw") ? null : obj.getString("invoiceSw");
			this.quotationPrintedSw	= obj.isNull("quotationPrintedSw") ? null : obj.getString("quotationPrintedSw");
			this.covernotePrintedSw	= obj.isNull("covernotePrintedSw") ? null : obj.getString("covernotePrintedSw");
			this.autoRenewFlag		= obj.isNull("autoRenewFlag") ? null : obj.getString("autoRenewFlag");
			this.provPremTag		= obj.isNull("provPremTag") ? null : obj.getString("provPremTag");
			this.samePolnoSw		= obj.isNull("samePolnoSw") ? null : obj.getString("samePolnoSw");
			this.packPolFlag		= obj.isNull("packPolFlag") ? null : obj.getString("packPolFlag");
			this.regPolicySw		= obj.isNull("regPolicySw") ? null : obj.getString("regPolicySw");
			this.coInsuranceSw		= obj.isNull("coInsuranceSw") ? null : obj.getString("coInsuranceSw");
			this.manualRenewNo		= obj.isNull("manualRenewNo") ? null : obj.getString("manualRenewNo");
			this.sublineCd			= obj.isNull("sublineCd") ? null : obj.getString("sublineCd");
			this.issueYy			= obj.isNull("issueYy") ? null : obj.getInt("issueYy");
			this.polSeqNo			= obj.isNull("polSeqNo") ? null : obj.getInt("polSeqNo");
			this.endtIssCd			= obj.isNull("endtIssCd") ? null : obj.getString("endtIssCd");
			this.endtYy				= obj.isNull("endtYy") ? null : obj.getString("endtYy");
			this.endtSeqNo			= obj.isNull("endtSeqNo") ? null : obj.getString("endtSeqNo");
			this.renewNo			= obj.isNull("renewNo") ? null : obj.getString("renewNo");
			this.inceptDate			= obj.isNull("inceptDate") ? null : sdf.parse(obj.getString("inceptDate"));
			this.expiryDate			= obj.isNull("expiryDate") ? null : sdf.parse(obj.getString("expiryDate"));
			this.expiryTag			= obj.isNull("expiryTag") ? null : obj.getString("expiryTag");
			this.effDate			= obj.isNull("effDate") ? null : sdf.parse(obj.getString("effDate"));
			this.issueDate			= obj.isNull("issueDate") ? null : sdf.parse(obj.getString("issueDate"));
			this.polFlag			= obj.isNull("polFlag") ? null : obj.getString("polFlag");
			this.assdNo				= obj.isNull("assdNo") ? null : obj.getString("assdNo");
			this.designation		= obj.isNull("designation") ? null : obj.getString("designation");
			this.address1			= obj.isNull("address1") ? null : obj.getString("address1");
			this.address2			= obj.isNull("address2") ? null : obj.getString("address2");
			this.address3			= obj.isNull("address3") ? null : obj.getString("address3");
			this.mortgName			= obj.isNull("mortgName") ? null : obj.getString("mortgName");
			this.tsiAmt				= obj.isNull("tsiAmt") ? null : new BigDecimal(obj.getString("tsiAmt"));
			this.premAmt			= obj.isNull("premAmt") ? null : new BigDecimal(obj.getString("premAmt"));
			this.annTsiAmt			= obj.isNull("annTsiAmt") ? null : new BigDecimal(obj.getString("annTsiAmt"));
			this.annPremAmt			= obj.isNull("annPremAmt") ? null : new BigDecimal(obj.getString("annPremAmt"));
			this.userId				= obj.isNull("userId") ? null : obj.getString("userId");
			this.endtExpiryDate		= obj.isNull("endtExpiryDate") ? null : sdf.parse(obj.getString("endtExpiryDate"));
			this.prorateFlag		= obj.isNull("prorateFlag") ? null : obj.getString("prorateFlag");
			this.shortRtPercent		= obj.isNull("shortRtPercent") ? null : obj.getString("shortRtPercent");
			this.typeCd				= obj.isNull("typeCd") ? null : obj.getString("typeCd");
			this.acctOfCd			= obj.isNull("acctOfCd") ? null : obj.getString("acctOfCd");
			this.provPremPct		= obj.isNull("provPremPct") ? null : obj.getString("provPremPct");
			this.discountSw			= obj.isNull("discountSw") ? null : obj.getString("discountSw");
			this.premWarrTag		= obj.isNull("premWarrTag") ? null : obj.getString("premWarrTag");
			this.refPolNo			= obj.isNull("refPolNo") ? null : obj.getString("refPolNo");
			this.refOpenPolNo		= obj.isNull("refOpenPolNo") ? null : obj.getString("refOpenPolNo");
			this.inceptTag			= obj.isNull("inceptTag") ? null : obj.getString("inceptTag");
			this.fleetPrintTag		= obj.isNull("fleetPrintTag") ? null : obj.getString("fleetPrintTag");
			this.compSw				= obj.isNull("compSw") ? null : obj.getString("compSw");
			this.bookingMth			= obj.isNull("bookingMth") ? null : obj.getString("bookingMth");
			this.bookingYear		= obj.isNull("bookingYear") ? null : obj.getString("bookingYear");
			this.withTariffSw		= obj.isNull("withTariffSw") ? null : obj.getString("withTariffSw");
			this.endtExpiryTag		= obj.isNull("endtExpiryTag") ? null : obj.getString("endtExpiryTag");
			this.placeCd			= obj.isNull("placeCd") ? null : obj.getString("placeCd");
			this.backStat			= obj.isNull("backStat") ? null : obj.getString("backStat");
			this.validateTag		= obj.isNull("validateTag") ? null : obj.getString("validateTag");
			this.industryCd			= obj.isNull("industryCd") ? null : obj.getString("industryCd");
			this.regionCd			= obj.isNull("regionCd") ? null : obj.getString("regionCd");
			this.acctOfCdSw			= obj.isNull("acctOfCdSw") ? null : obj.getString("acctOfCdSw");
			this.surchargeSw		= obj.isNull("surchargeSw") ? null : obj.getString("surchargeSw");
			this.credBranch			= obj.isNull("credBranch") ? null : obj.getString("credBranch");
			this.oldAssdNo			= obj.isNull("oldAssdNo") ? null : obj.getInt("oldAssdNo");
			this.labelTag			= obj.isNull("labelTag") ? null : obj.getString("labelTag");
			this.oldAddress1		= obj.isNull("oldAddress1") ? null : obj.getString("oldAddress1");
			this.oldAddress2		= obj.isNull("oldAddress2") ? null : obj.getString("oldAddress2");
			this.oldAddress3		= obj.isNull("oldAddress3") ? null : obj.getString("oldAddress3");
			this.riskTag			= obj.isNull("riskTag") ? null : obj.getString("riskTag");
			this.packParId			= obj.isNull("packParId") ? null : obj.getInt("packParId");
			this.surveyAgentCd		= obj.isNull("surveyAgentCd") ? null : obj.getString("surveyAgentCd");
			this.settlingAgentCd	= obj.isNull("settlingAgentCd") ? null : obj.getString("settlingAgentCd");
			this.premWarrDays		= obj.isNull("premWarrDays") ? null : obj.getString("premWarrDays");
			this.takeupTerm			= obj.isNull("takeupTerm") ? null : obj.getString("takeupTerm");
			this.cancelType			= obj.isNull("cancelType") ? null : obj.getString("cancelType");
			this.companyCd			= obj.isNull("companyCd") ? null : obj.getString("companyCd");
			this.employeeCd			= obj.isNull("employeeCd") ? null : obj.getString("employeeCd");
			this.bancassuranceSw	= obj.isNull("bancassuranceSw") ? null : obj.getString("bancassuranceSw");
			this.areaCd				= obj.isNull("areaCd") ? null : obj.getString("areaCd");
			this.branchCd			= obj.isNull("branchCd") ? null : obj.getString("branchCd");
			this.managerCd			= obj.isNull("managerCd") ? null : obj.getString("managerCd");
			this.bancTypeCd			= obj.isNull("bancTypeCd") ? null : obj.getString("bancTypeCd");
			this.bankRefNo			= obj.isNull("bankRefNo") ? null : obj.getString("bankRefNo");
			this.planCd				= obj.isNull("planCd") ? null : obj.getInt("planCd");
			this.planChTag			= obj.isNull("planChTag") ? null : obj.getString("planChTag");
			this.planSw				= obj.isNull("planSw") ? null : obj.getString("planSw");
			this.bondSeqNo			= obj.isNull("bondSeqNo") ? null : obj.getInt("bondSeqNo"); // Udel 05292012 added for IC bond sequence
			this.cancelledEndtId	= obj.isNull("cancelledEndtId") ? null : obj.getInt("cancelledEndtId"); //robert 9.21.2012
		} catch (JSONException e) {			
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (ParseException e) {			
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}		
	}

	public String getBancTypeDesc() {
		return bancTypeDesc;
	}

	public void setBancTypeDesc(String bancTypeDesc) {
		this.bancTypeDesc = bancTypeDesc;
	}

	public String getAreaDesc() {
		return areaDesc;
	}

	public void setAreaDesc(String areaDesc) {
		this.areaDesc = areaDesc;
	}

	public String getBranchDesc() {
		return branchDesc;
	}

	public void setBranchDesc(String branchDesc) {
		this.branchDesc = branchDesc;
	}

	public String getPayeeName() {
		return payeeName;
	}

	public void setPayeeName(String payeeName) {
		this.payeeName = payeeName;
	}

	public void setSurveyAgentName(String surveyAgentName) {
		this.surveyAgentName = surveyAgentName;
	}

	public String getSurveyAgentName() {
		return surveyAgentName;
	}

	public void setSettlingAgentName(String settlingAgentName) {
		this.settlingAgentName = settlingAgentName;
	}

	public String getSettlingAgentName() {
		return settlingAgentName;
	}
	
	public String getFormattedInceptDate(){
		SimpleDateFormat formatter = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if(this.inceptDate != null){
			return formatter.format(this.inceptDate);
		} else {
			return null;
		}
	}
	
	public String getFormattedExpiryDate(){
		SimpleDateFormat formatter = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if(this.expiryDate != null){
			return formatter.format(this.expiryDate);
		} else {
			return null;
		}
	}

	// Added by Jomar Diago 01072012
	public String getFormattedEndtExpDate(){
		SimpleDateFormat formatter = new SimpleDateFormat("MM-dd-yyyy");
		if(this.endtExpiryDate != null){
			return formatter.format(this.endtExpiryDate);
		} else {
			return null;
		}
	}

//gzelle 1.30.2013 SR11980 RSIC	
	public String getFormattedEffDate(){
		SimpleDateFormat formatter = new SimpleDateFormat("MM-dd-yyyy");
		if(this.effDate != null){
			return formatter.format(this.effDate);
		} else {
			return null;
		}
	}
	
	public String getFormattedEndtExpiryDate(){
		SimpleDateFormat formatter = new SimpleDateFormat("MM-dd-yyyy");
		if(this.endtExpiryDate != null){
			return formatter.format(this.endtExpiryDate);
		} else {
			return null;
		}
	}
//gzelle ---END---
	
	/**
	 * @return the bondSeqNo
	 */
	public Integer getBondSeqNo() {
		return bondSeqNo;
	}

	/**
	 * @param bondSeqNo the bondSeqNo to set
	 */
	public void setBondSeqNo(Integer bondSeqNo) {
		this.bondSeqNo = bondSeqNo;
	}

	public Integer getCancelledEndtId() {
		return cancelledEndtId;
	}

	public void setCancelledEndtId(Integer cancelledEndtId) {
		this.cancelledEndtId = cancelledEndtId;
	}
	//added by robert GENQA 4828 08.27.15
	public String getBondAutoPrem() {
		return bondAutoPrem;
	}

	public void setBondAutoPrem(String bondAutoPrem) {
		this.bondAutoPrem = bondAutoPrem;
	}
	//end robert GENQA 4828 08.27.15
}
