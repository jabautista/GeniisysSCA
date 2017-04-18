/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.geniisys.common.entity.GIISReports;
import com.seer.framework.util.Entity;


/**
 * The Class GIPIPolbasic.
 */
@SuppressWarnings("rawtypes")
public class GIPIPolbasic extends Entity {
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The policy id. */
	private Integer policyId;
	 
 	/** The line cd. */
 	private String lineCd;
 	
 	/** The menu line cd*/
 	private String menulineCd;
	 
 	/** The subline cd. */
 	private String sublineCd;
	 
 	/** The iss cd. */
 	private String issCd; 
	 
 	/** The issue yy. */
 	private Integer issueYy; 
	 
 	/** The pol seq no. */
 	private Integer polSeqNo;                                          
	 
 	/** The endt iss cd. */
 	private String endtIssCd;                                           
	 
 	/** The endt yy. */
 	private Integer endtYy;                                                
	 
 	/** The endt seq no. */
 	private Integer endtSeqNo;                                     
	 
 	/** The renew no. */
 	private Integer renewNo;                                       
	 
 	/** The par id. */
 	private Integer parId;                           
	 
 	/** The eff date. */
 	private Date effDate;                                       
	 
 	/** The pol flag. */
 	private String polFlag;                          
	 
 	/** The invoice sw. */
 	private String invoiceSw;                                  
	 
 	/** The auto renew flag. */
 	private String autoRenewFlag;                       
	 
 	/** The prov prem tag. */
 	private String provPremTag;                      
	 
 	/** The pack pol flag. */
 	private String packPolFlag;                           
	 
 	/** The reg policy sw. */
 	private String regPolicySw;                     
	 
 	/** The co insurance sw. */
 	private String coInsuranceSw;          
	 
 	/** The manual renew no. */
 	private Integer manualRenewNo;                                        
	 
 	/** The old pol flag. */
 	private String oldPolFlag;                                    
	 
 	/** The endt type. */
 	private String endtType;                                     
	 
 	/** The incept date. */
 	private Date inceptDate;                                  
	 
 	/** The expiry date. */
 	private Date expiryDate;                                  
	 
 	/** The expiry tag. */
 	private String expiryTag;                              
	 
 	/** The issue date. */
 	private Date issueDate;                            
	 
 	/** The assd no. */
 	private Integer assdNo;                    
	 
 	/** The designation. */
 	private String designation;                      
	 
 	/** The address1. */
 	private String address1;                 
	 
 	/** The address2. */
 	private String address2;                   
	 
 	/** The address3. */
 	private String address3;                    
	 
 	/** The mortg name. */
 	private String mortgName;                     
	 
 	/** The tsi amt. */
 	private BigDecimal tsiAmt;                     
	 
 	/** The prem a mt. */
 	private BigDecimal premAMt;                     
	 
 	/** The ann tsi amt. */
 	private BigDecimal annTsiAmt;                 
	 
 	/** The ann prem amt. */
 	private BigDecimal annPremAmt;                   
	 
 	/** The pool pol no. */
 	private String poolPolNo;                     
	 
 	/** The foreign acct sw. */
 	private String foreignAcctSw;                 
	 
 	/** The discount sw. */
 	private String discountSw;                     
	 
 	/** The back stat. */
 	private Integer backStat;                    
	 
 	/** The acct ent date. */
 	private Date acctEntDate;                               
	 
 	/** The spld acct ent date. */
 	private Date spldAcctEntDate;                            
	 
 	/** The spld approval. */
 	private String spldApproval;                           
	 
 	/** The spld date. */
 	private Date spldDate;                            
	 
 	/** The spld user id. */
 	private String spldUserId;                  
	 
 	/** The spld flag. */
 	private String spldFlag;                      
	 
 	/** The dist flag. */
 	private String distFlag;                        
	 
 	/** The orig policy id. */
 	private Integer origPolicyId;                       
	 
 	/** The endt expiry date. */
 	private Date endtExpiryDate;                        
	 
 	/** The no of items. */
 	private Integer noOfItems;                       
	 
 	/** The subline type cd. */
 	private String sublineTypeCd;                  
	 
 	/** The prorate flag. */
 	private String prorateFlag;                         
	 
 	/** The short rt percent. */
 	private BigDecimal shortRtPercent;                
	 
 	/** The type cd. */
 	private String typeCd;                              
	 
 	/** The acct of cd. */
 	private Integer acctOfCd;                            
	 
 	/** The prov prem pct. */
 	private Integer provPremPct;                     
	 
 	/** The renew flag. */
 	private String renewFlag;                 
	 
 	/** The prem warr tag. */
 	private String premWarrTag;               
	 
 	/** The ref pol no. */
 	private String refPolNo;                 
	 
 	/** The ref open pol no. */
 	private String refOpenPolNo;                              
	 
 	/** The incept tag. */
 	private String inceptTag;                                       
	 
 	/** The comp sw. */
 	private String compSw;                                       
	 
 	/** The booking mth. */
 	private String bookingMth;                                 
	 
 	/** The booking year. */
 	private Integer bookingYear;                                    
	 
 	/** The endt expiry tag. */
 	private String endtExpiryTag;                         
	 
 	/** The fleet print tag. */
 	private String fleetPrintTag;                               
	 
 	/** The with tariff sw. */
 	private String withTariffSw;                        
	 
 	/** The polendt printed date. */
 	private Date polendtPrintedDate;                          
	 
 	/** The user id. */
 	private String userId;                             
	 
 	/** The last upd date. */
 	private Date lastUpdDate;                            
	 
 	/** The cpi rec no. */
 	private Integer cpiRecNo;                          
	 
 	/** The cpi branch cd. */
 	private String cpiBranchCd;                                     
	 
 	/** The polendt printed cnt. */
 	private Integer polendtPrintedCnt;                      
	 
 	/** The place cd. */
 	private String placeCd;                              
	 
 	/** The eis flag. */
 	private String eisFlag;                       
	 
 	/** The ren notice cnt. */
 	private Integer renNoticeCnt;                      
	 
 	/** The ren notice date. */
 	private Date renNoticeDate;                        
	 
 	/** The qd flag. */
 	private String qdFlag;                    
	 
 	/** The actual renew no. */
 	private Integer actualRenewNo;                    
	 
 	/** The validate tag. */
 	private String validateTag;                   
	 
 	/** The industry cd. */
 	private Integer industryCd;                    
	 
 	/** The region cd. */
 	private Integer regionCd;                     
	 
 	/** The acct of cd sw. */
 	private String acctOfCdSw;                
	 
 	/** The surcharge sw. */
 	private String surchargeSw;                   
	 
 	/** The cred branch. */
 	private String credBranch;                
	 
 	/** The old assd no. */
 	private Integer oldAssdNo;               
	 
 	/** The cancel date. */
 	private Date cancelDate;                           
	 
 	/** The label tag. */
 	private String labelTag;                                               
	 
 	/** The old address1. */
 	private String oldAddress1;                                              
	 
 	/** The old address2. */
 	private String oldAddress2;                                            
	 
 	/** The old address3. */
 	private String oldAddress3;                                           
	 
 	/** The reinstatement date. */
 	private Date reinstatementDate;                                     
	 
 	/** The risk tag. */
 	private String riskTag;                                     
	 
 	/** The renew extract tag. */
 	private String renewExtractTag;                                    
	 
 	/** The claims extract tag. */
 	private String claimsExtractTag;                             
	 
 	/** The survey agent cd. */
 	private Integer surveyAgentCd;                                
	 
 	/** The settling agent cd. */
 	private Integer settlingAgentCd;                         
	 
 	/** The pack policy id. */
 	private Integer packPolicyId;                       
	 
 	/** The prem warr days. */
 	private Integer premWarrDays;                         
	 
 	/** The spoil cd. */
 	private String spoilCd;                               
	 
 	/** The takeup term. */
 	private String takeupTerm;                          
	 
 	/** The reinstate tag. */
 	private String reinstateTag;                       
	 
 	/** The arc ext data. */
 	private String arcExtData;                       
	 
 	/** The cancelled endt id. */
 	private Integer cancelledEndtId;
 	
 	private Integer packPol;
 	
 	private String assdName;
 	
 	private String policyNo;
 	
 	private String parNo;
 	
 	private String billNotPrinted;
 	
 	private String endtNo;
 	
 	private String policyDsDtlExist;
 	
 	private String endtTax;
 	
 	private Integer itmperilCount;
 	
 	private String compulsoryDeath;
 	
 	private String cocType;
 	
 	private Integer premSeqNo;
 	
 	private String meanPolFlag;
 	
	private List<GIISReports> lineReports;
	
	private List<GIISReports> packageReports;
	
	private List<GIPIItem> gipiItems;
	
	private Integer companyCd;
	
	private String companyName;
	
	private String employeeCd;
	
	private String employeeName;
	
	private String bankRefNo;
	
	private String bancTypeCd;
	
	private String bancTypeDesc;
	
	private Integer areaCd;
	
	private String areaDesc;
	
	private Integer branchCd;
	
	private String branchDesc;
	
	private Integer managerCd;
		
	private String payeeName;
	
	private String planCd;
	
	private String planDesc;
	
	private String planChTag;
	
	private String acctOf;
	
	private String defaultCurrency;
	
	private String endorsement;
	
	private String printSw;
	
	private String endtCd;
	
	private String endtTitle;
	
	private Integer distNo;
	
	/**
	 * @author rey
	 * @date 07-29-2011
	 */
	private BigDecimal amountDue;
	
	/**
	 * @author rey
	 * @date 07-29-2011
	 */
	private String billNo;
	
	private Integer itemGrp;

	private String insured;
	
	private String property;
	
	private String paytTerms;
	
	private Date dueDate;
	
	private BigDecimal currencyRt;
	
	private String policyCurrency;

	private String remarks;
	
	private BigDecimal refInvNo;
	
	private BigDecimal otherCharges;
	
	private BigDecimal riCommVat;
	
	private BigDecimal riCommAmt;
	
	private Integer multiBookingYy;
	
	private String multiBookingMm;
	
	private String multiBookingDt;
	
	private BigDecimal taxSum;
	
	private BigDecimal sumPremAmt;
	
	private String currencyDesc;
	
	private String taxCd;
	
	private Integer taxId;
	
	private String taxDesc;
	
	private BigDecimal taxAmt;
	
	private Integer perilCd;
	
	private String perilName;
	
	private BigDecimal premAmt;
	
	private BigDecimal totalShr;
	
	private BigDecimal totalPrem;
	
	private BigDecimal totalTax;
	
	private BigDecimal totalTaxDue;
	
	private Integer instNo;
	
	private BigDecimal sharePct;
	
	private BigDecimal totalDue;
	
	private BigDecimal premiumAmt;
	
	private BigDecimal wholdingTax;
	
	private BigDecimal commissionRt;
	
	private BigDecimal commissionAmt;
	
	private BigDecimal netComAmt;
	
	private Integer intmNo;
	
	private String intmName;
	
	private Integer parentIntmNo;
	
	private String refIntmCd;
	
	private BigDecimal totalCommission;
	
	private BigDecimal totalTaxWholding;
	
	private String intmCdName;
	
	private BigDecimal sharePercentage;
	
	private BigDecimal prntDetailRt;
	
	private BigDecimal prntDetailAmt;
	
	private BigDecimal childCommRt;
	
	private BigDecimal childCommAmt;
	
	private Integer sequence;
	
	private BigDecimal discAmt;
	
	private BigDecimal discRt;
	
	private BigDecimal surchargeAmt;
	
	private BigDecimal surchargeRt;
	
	private BigDecimal netPremAmt;
	
	private String netGrossTag;
	
	private Integer itemNo;
	
	private BigDecimal sharePrem;
	
	private String assdName2;
	
	private String obligeeName;
	
	private String prinSignor;
	
	private String npName;
	
	private String clauseDesc;
	
	private String genInfo;
	
	private String bondDtl;
	
	private String indemnityText;
	
	private String collFlag;
	
	private Integer waiverLimit;
	
	private Date contractDate;
	
	private String contractDtl;
	
	private String cosignName;
	
	private String bondsFlag;
	
	private String indemFlag;
	
	private String strConDate;
	
	private BigDecimal bondTsiAmt;
	
	private BigDecimal bondRate;
	
	private BigDecimal notarialFee;
	
	private BigDecimal totalAmtDue;
	
	private BigDecimal riCommRate;
	
	private Integer bondSeqNo;
	
	private String itemTitle;
	
	private Integer indGrpCd;
	
	private BigDecimal lossAmt;
	
	private BigDecimal totalLossAmt;
	
	private Integer claimId;
	
	private String claimNo;
	
	private String strDueDate; //added to parse the due date
	
	private Integer riCd; // jmm SR22834 for validation
	
	public Integer getRiCd() {
		return riCd;
	}

	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}

	public BigDecimal getRiCommRate() {
		return riCommRate;
	}

	public void setRiCommRate(BigDecimal riCommRate) {
		this.riCommRate = riCommRate;
	}

	public BigDecimal getTotalAmtDue() {
		return totalAmtDue;
	}

	public void setTotalAmtDue(BigDecimal totalAmtDue) {
		this.totalAmtDue = totalAmtDue;
	}

	public BigDecimal getNotarialFee() {
		return notarialFee;
	}

	public void setNotarialFee(BigDecimal notarialFee) {
		this.notarialFee = notarialFee;
	}

	public BigDecimal getBondRate() {
		return bondRate;
	}

	public void setBondRate(BigDecimal bondRate) {
		this.bondRate = bondRate;
	}

	public BigDecimal getBondTsiAmt() {
		return bondTsiAmt;
	}

	public void setBondTsiAmt(BigDecimal bondTsiAmt) {
		this.bondTsiAmt = bondTsiAmt;
	}

	public String getStrConDate() {
		return strConDate;
	}

	public void setStrConDate(String strConDate) {
		this.strConDate = strConDate;
	}

	public String getIndemFlag() {
		return indemFlag;
	}

	public void setIndemFlag(String indemFlag) {
		this.indemFlag = indemFlag;
	}

	public String getBondsFlag() {
		return bondsFlag;
	}

	public void setBondsFlag(String bondsFlag) {
		this.bondsFlag = bondsFlag;
	}

	public String getCosignName() {
		return cosignName;
	}

	public void setCosignName(String cosignName) {
		this.cosignName = cosignName;
	}

	public String getNpName() {
		return npName;
	}

	public void setNpName(String npName) {
		this.npName = npName;
	}

	public String getClauseDesc() {
		return clauseDesc;
	}

	public void setClauseDesc(String clauseDesc) {
		this.clauseDesc = clauseDesc;
	}

	public String getGenInfo() {
		return genInfo;
	}

	public void setGenInfo(String genInfo) {
		this.genInfo = genInfo;
	}

	public String getBondDtl() {
		return bondDtl;
	}

	public void setBondDtl(String bondDtl) {
		this.bondDtl = bondDtl;
	}

	public String getIndemnityText() {
		return indemnityText;
	}

	public void setIndemnityText(String indemnityText) {
		this.indemnityText = indemnityText;
	}

	public String getCollFlag() {
		return collFlag;
	}

	public void setCollFlag(String collFlag) {
		this.collFlag = collFlag;
	}

	public Integer getWaiverLimit() {
		return waiverLimit;
	}

	public void setWaiverLimit(Integer waiverLimit) {
		this.waiverLimit = waiverLimit;
	}

	public Date getContractDate() {
		return contractDate;
	}

	public void setContractDate(Date contractDate) {
		this.contractDate = contractDate;
	}

	public String getContractDtl() {
		return contractDtl;
	}

	public void setContractDtl(String contractDtl) {
		this.contractDtl = contractDtl;
	}

	public String getPrinSignor() {
		return prinSignor;
	}

	public void setPrinSignor(String prinSignor) {
		this.prinSignor = prinSignor;
	}

	public String getObligeeName() {
		return obligeeName;
	}

	public void setObligeeName(String obligeeName) {
		this.obligeeName = obligeeName;
	}

	public String getAssdName2() {
		return assdName2;
	}

	public void setAssdName2(String assdName2) {
		this.assdName2 = assdName2;
	}

	public BigDecimal getSharePrem() {
		return sharePrem;
	}

	public void setSharePrem(BigDecimal sharePrem) {
		this.sharePrem = sharePrem;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	public BigDecimal getSurchargeAmt() {
		return surchargeAmt;
	}

	public void setSurchargeAmt(BigDecimal surchargeAmt) {
		this.surchargeAmt = surchargeAmt;
	}

	public BigDecimal getSurchargeRt() {
		return surchargeRt;
	}

	public void setSurchargeRt(BigDecimal surchargeRt) {
		this.surchargeRt = surchargeRt;
	}

	public BigDecimal getNetPremAmt() {
		return netPremAmt;
	}

	public void setNetPremAmt(BigDecimal netPremAmt) {
		this.netPremAmt = netPremAmt;
	}

	public String getNetGrossTag() {
		return netGrossTag;
	}

	public void setNetGrossTag(String netGrossTag) {
		this.netGrossTag = netGrossTag;
	}

	public BigDecimal getDiscRt() {
		return discRt;
	}

	public void setDiscRt(BigDecimal discRt) {
		this.discRt = discRt;
	}

	public BigDecimal getDiscAmt() {
		return discAmt;
	}

	public void setDiscAmt(BigDecimal discAmt) {
		this.discAmt = discAmt;
	}

	public Integer getSequence() {
		return sequence;
	}

	public void setSequence(Integer sequence) {
		this.sequence = sequence;
	}

	public BigDecimal getChildCommAmt() {
		return childCommAmt;
	}

	public void setChildCommAmt(BigDecimal childCommAmt) {
		this.childCommAmt = childCommAmt;
	}

	public BigDecimal getChildCommRt() {
		return childCommRt;
	}

	public void setChildCommRt(BigDecimal childCommRt) {
		this.childCommRt = childCommRt;
	}

	public BigDecimal getPrntDetailAmt() {
		return prntDetailAmt;
	}

	public void setPrntDetailAmt(BigDecimal prntDetailAmt) {
		this.prntDetailAmt = prntDetailAmt;
	}

	public BigDecimal getPrntDetailRt() {
		return prntDetailRt;
	}

	public void setPrntDetailRt(BigDecimal prntDetailRt) {
		this.prntDetailRt = prntDetailRt;
	}

	public BigDecimal getSharePercentage() {
		return sharePercentage;
	}

	public void setSharePercentage(BigDecimal sharePercentage) {
		this.sharePercentage = sharePercentage;
	}

	public String getIntmCdName() {
		return intmCdName;
	}

	public void setIntmCdName(String intmCdName) {
		this.intmCdName = intmCdName;
	}

	public BigDecimal getTotalCommission() {
		return totalCommission;
	}

	public void setTotalCommission(BigDecimal totalCommission) {
		this.totalCommission = totalCommission;
	}

	public BigDecimal getTotalTaxWholding() {
		return totalTaxWholding;
	}

	public void setTotalTaxWholding(BigDecimal totalTaxWholding) {
		this.totalTaxWholding = totalTaxWholding;
	}

	public String getRefIntmCd() {
		return refIntmCd;
	}

	public void setRefIntmCd(String refIntmCd) {
		this.refIntmCd = refIntmCd;
	}

	public Integer getParentIntmNo() {
		return parentIntmNo;
	}

	public void setParentIntmNo(Integer parentIntmNo) {
		this.parentIntmNo = parentIntmNo;
	}

	public String getIntmName() {
		return intmName;
	}

	public void setIntmName(String intmName) {
		this.intmName = intmName;
	}

	public Integer getIntmNo() {
		return intmNo;
	}

	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}

	public BigDecimal getNetComAmt() {
		return netComAmt;
	}

	public void setNetComAmt(BigDecimal netComAmt) {
		this.netComAmt = netComAmt;
	}

	public BigDecimal getCommissionAmt() {
		return commissionAmt;
	}

	public void setCommissionAmt(BigDecimal commissionAmt) {
		this.commissionAmt = commissionAmt;
	}

	public BigDecimal getCommissionRt() {
		return commissionRt;
	}

	public void setCommissionRt(BigDecimal commissionRt) {
		this.commissionRt = commissionRt;
	}

	public BigDecimal getWholdingTax() {
		return wholdingTax;
	}

	public void setWholdingTax(BigDecimal wholdingTax) {
		this.wholdingTax = wholdingTax;
	}

	public BigDecimal getPremiumAmt() {
		return premiumAmt;
	}

	public void setPremiumAmt(BigDecimal premiumAmt) {
		this.premiumAmt = premiumAmt;
	}

	public BigDecimal getTotalDue() {
		return totalDue;
	}

	public void setTotalDue(BigDecimal totalDue) {
		this.totalDue = totalDue;
	}

	public BigDecimal getSharePct() {
		return sharePct;
	}

	public void setSharePct(BigDecimal sharePct) {
		this.sharePct = sharePct;
	}

	public Integer getInstNo() {
		return instNo;
	}

	public void setInstNo(Integer instNo) {
		this.instNo = instNo;
	}

	public BigDecimal getTotalTaxDue() {
		return totalTaxDue;
	}

	public void setTotalTaxDue(BigDecimal totalTaxDue) {
		this.totalTaxDue = totalTaxDue;
	}

	public BigDecimal getTotalTax() {
		return totalTax;
	}

	public void setTotalTax(BigDecimal totalTax) {
		this.totalTax = totalTax;
	}

	public BigDecimal getTotalPrem() {
		return totalPrem;
	}

	public void setTotalPrem(BigDecimal totalPrem) {
		this.totalPrem = totalPrem;
	}

	public BigDecimal getTotalShr() {
		return totalShr;
	}

	public void setTotalShr(BigDecimal totalShr) {
		this.totalShr = totalShr;
	}

	public BigDecimal getPremAmt() {
		return premAmt;
	}

	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}

	public String getPerilName() {
		return perilName;
	}

	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}

	public Integer getPerilCd() {
		return perilCd;
	}

	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}

	public BigDecimal getTaxAmt() {
		return taxAmt;
	}

	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}

	public String getTaxDesc() {
		return taxDesc;
	}

	public void setTaxDesc(String taxDesc) {
		this.taxDesc = taxDesc;
	}

	public Integer getTaxId() {
		return taxId;
	}

	public void setTaxId(Integer taxId) {
		this.taxId = taxId;
	}

	public String getTaxCd() {
		return taxCd;
	}

	public void setTaxCd(String taxCd) {
		this.taxCd = taxCd;
	}

	public String getCurrencyDesc() {
		return currencyDesc;
	}

	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}

	public BigDecimal getTaxSum() {
		return taxSum;
	}

	public void setTaxSum(BigDecimal taxSum) {
		this.taxSum = taxSum;
	}

	public BigDecimal getSumPremAmt() {
		return sumPremAmt;
	}

	public void setSumPremAmt(BigDecimal sumPremAmt) {
		this.sumPremAmt = sumPremAmt;
	}

	public String getMultiBookingDt() {
		return multiBookingDt;
	}

	public void setMultiBookingDt(String multiBookingDt) {
		this.multiBookingDt = multiBookingDt;
	}

	public Integer getMultiBookingYy() {
		return multiBookingYy;
	}

	public void setMultiBookingYy(Integer multiBookingYy) {
		this.multiBookingYy = multiBookingYy;
	}

	public String getMultiBookingMm() {
		return multiBookingMm;
	}

	public void setMultiBookingMm(String multiBookingMm) {
		this.multiBookingMm = multiBookingMm;
	}

	public BigDecimal getRiCommVat() {
		return riCommVat;
	}

	public void setRiCommVat(BigDecimal riCommVat) {
		this.riCommVat = riCommVat;
	}

	public BigDecimal getRiCommAmt() {
		return riCommAmt;
	}

	public void setRiCommAmt(BigDecimal riCommAmt) {
		this.riCommAmt = riCommAmt;
	}

	public BigDecimal getOtherCharges() {
		return otherCharges;
	}

	public void setOtherCharges(BigDecimal otherCharges) {
		this.otherCharges = otherCharges;
	}

	public BigDecimal getRefInvNo() {
		return refInvNo;
	}

	public void setRefInvNo(BigDecimal refInvNo) {
		this.refInvNo = refInvNo;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getPolicyCurrency() {
		return policyCurrency;
	}

	public void setPolicyCurrency(String policyCurrency) {
		this.policyCurrency = policyCurrency;
	}

	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}

	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}

	public Date getDueDate() {
		return dueDate;
	}

	public void setDueDate(Date dueDate) {
		this.dueDate = dueDate;
	}

	public String getPaytTerms() {
		return paytTerms;
	}

	public void setPaytTerms(String paytTerms) {
		this.paytTerms = paytTerms;
	}

	public String getProperty() {
		return property;
	}

	public void setProperty(String property) {
		this.property = property;
	}

	public String getInsured() {
		return insured;
	}

	public void setInsured(String insured) {
		this.insured = insured;
	}

	public Integer getItemGrp() {
		return itemGrp;
	}

	public void setItemGrp(Integer itemGrp) {
		this.itemGrp = itemGrp;
	}

	public BigDecimal getAmountDue() {
		return amountDue;
	}

	public void setAmountDue(BigDecimal amountDue) {
		this.amountDue = amountDue;
	}

	public String getBillNo() {
		return billNo;
	}

	public void setBillNo(String billNo) {
		this.billNo = billNo;
	}

	public String getEndtCd() {
		return endtCd;
	}

	public void setEndtCd(String endtCd) {
		this.endtCd = endtCd;
	}

	public String getEndtTitle() {
		return endtTitle;
	}

	public void setEndtTitle(String endtTitle) {
		this.endtTitle = endtTitle;
	}

	/**
	 * Gets the policy id.
	 * 
	 * @return the policy id
	 */
	public Integer getPolicyId() {
		return policyId;
	}
	
	/**
	 * Sets the policy id.
	 * 
	 * @param policyId the new policy id
	 */
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
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
	 * Gets the menu line cd.
	 * 
	 * @return the menu line cd
	 */
	public void setMenulineCd(String menulineCd) {
		this.menulineCd = menulineCd;
	}
	
	/**
	 * Sets the menu line cd.
	 * 
	 * @param menulineCd the new menu line cd
	 */
	public String getMenulineCd() {
		return menulineCd;
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
	 * Gets the endt iss cd.
	 * 
	 * @return the endt iss cd
	 */
	public String getEndtIssCd() {
		return endtIssCd;
	}
	
	/**
	 * Sets the endt iss cd.
	 * 
	 * @param endtIssCd the new endt iss cd
	 */
	public void setEndtIssCd(String endtIssCd) {
		this.endtIssCd = endtIssCd;
	}
	
	/**
	 * Gets the endt yy.
	 * 
	 * @return the endt yy
	 */
	public Integer getEndtYy() {
		return endtYy;
	}
	
	/**
	 * Sets the endt yy.
	 * 
	 * @param endtYy the new endt yy
	 */
	public void setEndtYy(Integer endtYy) {
		this.endtYy = endtYy;
	}
	
	/**
	 * Gets the endt seq no.
	 * 
	 * @return the endt seq no
	 */
	public Integer getEndtSeqNo() {
		return endtSeqNo;
	}
	
	/**
	 * Sets the endt seq no.
	 * 
	 * @param endtSeqNo the new endt seq no
	 */
	public void setEndtSeqNo(Integer endtSeqNo) {
		this.endtSeqNo = endtSeqNo;
	}
	
	/**
	 * Gets the renew no.
	 * 
	 * @return the renew no
	 */
	public Integer getRenewNo() {
		return renewNo;
	}
	
	/**
	 * Sets the renew no.
	 * 
	 * @param renewNo the new renew no
	 */
	public void setRenewNo(Integer renewNo) {
		this.renewNo = renewNo;
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
	 * Gets the eff date.
	 * 
	 * @return the eff date
	 */
	public Date getEffDate() {
		return effDate;
	}
	
	/**
	 * Sets the eff date.
	 * 
	 * @param effDate the new eff date
	 */
	public void setEffDate(Date effDate) {
		this.effDate = effDate;
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
	 * Gets the manual renew no.
	 * 
	 * @return the manual renew no
	 */
	public Integer getManualRenewNo() {
		return manualRenewNo;
	}
	
	/**
	 * Sets the manual renew no.
	 * 
	 * @param manualRenewNo the new manual renew no
	 */
	public void setManualRenewNo(Integer manualRenewNo) {
		this.manualRenewNo = manualRenewNo;
	}
	
	/**
	 * Gets the old pol flag.
	 * 
	 * @return the old pol flag
	 */
	public String getOldPolFlag() {
		return oldPolFlag;
	}
	
	/**
	 * Sets the old pol flag.
	 * 
	 * @param oldPolFlag the new old pol flag
	 */
	public void setOldPolFlag(String oldPolFlag) {
		this.oldPolFlag = oldPolFlag;
	}
	
	/**
	 * Gets the endt type.
	 * 
	 * @return the endt type
	 */
	public String getEndtType() {
		return endtType;
	}
	
	/**
	 * Sets the endt type.
	 * 
	 * @param endtType the new endt type
	 */
	public void setEndtType(String endtType) {
		this.endtType = endtType;
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
	 * Gets the assd no.
	 * 
	 * @return the assd no
	 */
	public Integer getAssdNo() {
		return assdNo;
	}
	
	/**
	 * Sets the assd no.
	 * 
	 * @param assdNo the new assd no
	 */
	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
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
	 * Gets the mortg name.
	 * 
	 * @return the mortg name
	 */
	public String getMortgName() {
		return mortgName;
	}
	
	/**
	 * Sets the mortg name.
	 * 
	 * @param mortgName the new mortg name
	 */
	public void setMortgName(String mortgName) {
		this.mortgName = mortgName;
	}
	
	/**
	 * Gets the tsi amt.
	 * 
	 * @return the tsi amt
	 */
	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}
	
	/**
	 * Sets the tsi amt.
	 * 
	 * @param tsiAmt the new tsi amt
	 */
	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}
	
	/**
	 * Gets the prem a mt.
	 * 
	 * @return the prem a mt
	 */
	public BigDecimal getPremAMt() {
		return premAMt;
	}
	
	/**
	 * Sets the prem a mt.
	 * 
	 * @param premAMt the new prem a mt
	 */
	public void setPremAMt(BigDecimal premAMt) {
		this.premAMt = premAMt;
	}
	
	/**
	 * Gets the ann tsi amt.
	 * 
	 * @return the ann tsi amt
	 */
	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}
	
	/**
	 * Sets the ann tsi amt.
	 * 
	 * @param annTsiAmt the new ann tsi amt
	 */
	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}
	
	/**
	 * Gets the ann prem amt.
	 * 
	 * @return the ann prem amt
	 */
	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}
	
	/**
	 * Sets the ann prem amt.
	 * 
	 * @param annPremAmt the new ann prem amt
	 */
	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}
	
	/**
	 * Gets the pool pol no.
	 * 
	 * @return the pool pol no
	 */
	public String getPoolPolNo() {
		return poolPolNo;
	}
	
	/**
	 * Sets the pool pol no.
	 * 
	 * @param poolPolNo the new pool pol no
	 */
	public void setPoolPolNo(String poolPolNo) {
		this.poolPolNo = poolPolNo;
	}
	
	/**
	 * Gets the foreign acct sw.
	 * 
	 * @return the foreign acct sw
	 */
	public String getForeignAcctSw() {
		return foreignAcctSw;
	}
	
	/**
	 * Sets the foreign acct sw.
	 * 
	 * @param foreignAcctSw the new foreign acct sw
	 */
	public void setForeignAcctSw(String foreignAcctSw) {
		this.foreignAcctSw = foreignAcctSw;
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
	 * Gets the back stat.
	 * 
	 * @return the back stat
	 */
	public Integer getBackStat() {
		return backStat;
	}
	
	/**
	 * Sets the back stat.
	 * 
	 * @param backStat the new back stat
	 */
	public void setBackStat(Integer backStat) {
		this.backStat = backStat;
	}
	
	/**
	 * Gets the acct ent date.
	 * 
	 * @return the acct ent date
	 */
	public Date getAcctEntDate() {
		return acctEntDate;
	}
	
	/**
	 * Sets the acct ent date.
	 * 
	 * @param acctEntDate the new acct ent date
	 */
	public void setAcctEntDate(Date acctEntDate) {
		this.acctEntDate = acctEntDate;
	}
	
	/**
	 * Gets the spld acct ent date.
	 * 
	 * @return the spld acct ent date
	 */
	public Date getSpldAcctEntDate() {
		return spldAcctEntDate;
	}
	
	/**
	 * Sets the spld acct ent date.
	 * 
	 * @param spldAcctEntDate the new spld acct ent date
	 */
	public void setSpldAcctEntDate(Date spldAcctEntDate) {
		this.spldAcctEntDate = spldAcctEntDate;
	}
	
	/**
	 * Gets the spld approval.
	 * 
	 * @return the spld approval
	 */
	public String getSpldApproval() {
		return spldApproval;
	}
	
	/**
	 * Sets the spld approval.
	 * 
	 * @param spldApproval the new spld approval
	 */
	public void setSpldApproval(String spldApproval) {
		this.spldApproval = spldApproval;
	}
	
	/**
	 * Gets the spld date.
	 * 
	 * @return the spld date
	 */
	public Date getSpldDate() {
		return spldDate;
	}
	
	/**
	 * Sets the spld date.
	 * 
	 * @param spldDate the new spld date
	 */
	public void setSpldDate(Date spldDate) {
		this.spldDate = spldDate;
	}
	
	/**
	 * Gets the spld user id.
	 * 
	 * @return the spld user id
	 */
	public String getSpldUserId() {
		return spldUserId;
	}
	
	/**
	 * Sets the spld user id.
	 * 
	 * @param spldUserId the new spld user id
	 */
	public void setSpldUserId(String spldUserId) {
		this.spldUserId = spldUserId;
	}
	
	/**
	 * Gets the spld flag.
	 * 
	 * @return the spld flag
	 */
	public String getSpldFlag() {
		return spldFlag;
	}
	
	/**
	 * Sets the spld flag.
	 * 
	 * @param spldFlag the new spld flag
	 */
	public void setSpldFlag(String spldFlag) {
		this.spldFlag = spldFlag;
	}
	
	/**
	 * Gets the dist flag.
	 * 
	 * @return the dist flag
	 */
	public String getDistFlag() {
		return distFlag;
	}
	
	/**
	 * Sets the dist flag.
	 * 
	 * @param distFlag the new dist flag
	 */
	public void setDistFlag(String distFlag) {
		this.distFlag = distFlag;
	}
	
	/**
	 * Gets the orig policy id.
	 * 
	 * @return the orig policy id
	 */
	public Integer getOrigPolicyId() {
		return origPolicyId;
	}
	
	/**
	 * Sets the orig policy id.
	 * 
	 * @param origPolicyId the new orig policy id
	 */
	public void setOrigPolicyId(Integer origPolicyId) {
		this.origPolicyId = origPolicyId;
	}
	
	/**
	 * Gets the endt expiry date.
	 * 
	 * @return the endt expiry date
	 */
	public Date getEndtExpiryDate() {
		return endtExpiryDate;
	}
	
	/**
	 * Sets the endt expiry date.
	 * 
	 * @param endtExpiryDate the new endt expiry date
	 */
	public void setEndtExpiryDate(Date endtExpiryDate) {
		this.endtExpiryDate = endtExpiryDate;
	}
	
	/**
	 * Gets the no of items.
	 * 
	 * @return the no of items
	 */
	public Integer getNoOfItems() {
		return noOfItems;
	}
	
	/**
	 * Sets the no of items.
	 * 
	 * @param noOfItems the new no of items
	 */
	public void setNoOfItems(Integer noOfItems) {
		this.noOfItems = noOfItems;
	}
	
	/**
	 * Gets the subline type cd.
	 * 
	 * @return the subline type cd
	 */
	public String getSublineTypeCd() {
		return sublineTypeCd;
	}
	
	/**
	 * Sets the subline type cd.
	 * 
	 * @param sublineTypeCd the new subline type cd
	 */
	public void setSublineTypeCd(String sublineTypeCd) {
		this.sublineTypeCd = sublineTypeCd;
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
	 * Gets the short rt percent.
	 * 
	 * @return the short rt percent
	 */
	public BigDecimal getShortRtPercent() {
		return shortRtPercent;
	}
	
	/**
	 * Sets the short rt percent.
	 * 
	 * @param shortRtPercent the new short rt percent
	 */
	public void setShortRtPercent(BigDecimal shortRtPercent) {
		this.shortRtPercent = shortRtPercent;
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
	 * Gets the acct of cd.
	 * 
	 * @return the acct of cd
	 */
	public Integer getAcctOfCd() {
		return acctOfCd;
	}
	
	/**
	 * Sets the acct of cd.
	 * 
	 * @param acctOfCd the new acct of cd
	 */
	public void setAcctOfCd(Integer acctOfCd) {
		this.acctOfCd = acctOfCd;
	}
	
	/**
	 * Gets the prov prem pct.
	 * 
	 * @return the prov prem pct
	 */
	public Integer getProvPremPct() {
		return provPremPct;
	}
	
	/**
	 * Sets the prov prem pct.
	 * 
	 * @param provPremPct the new prov prem pct
	 */
	public void setProvPremPct(Integer provPremPct) {
		this.provPremPct = provPremPct;
	}
	
	/**
	 * Gets the renew flag.
	 * 
	 * @return the renew flag
	 */
	public String getRenewFlag() {
		return renewFlag;
	}
	
	/**
	 * Sets the renew flag.
	 * 
	 * @param renewFlag the new renew flag
	 */
	public void setRenewFlag(String renewFlag) {
		this.renewFlag = renewFlag;
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
	 * Gets the booking year.
	 * 
	 * @return the booking year
	 */
	public Integer getBookingYear() {
		return bookingYear;
	}
	
	/**
	 * Sets the booking year.
	 * 
	 * @param bookingYear the new booking year
	 */
	public void setBookingYear(Integer bookingYear) {
		this.bookingYear = bookingYear;
	}
	
	/**
	 * Gets the endt expiry tag.
	 * 
	 * @return the endt expiry tag
	 */
	public String getEndtExpiryTag() {
		return endtExpiryTag;
	}
	
	/**
	 * Sets the endt expiry tag.
	 * 
	 * @param endtExpiryTag the new endt expiry tag
	 */
	public void setEndtExpiryTag(String endtExpiryTag) {
		this.endtExpiryTag = endtExpiryTag;
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
	 * Gets the polendt printed date.
	 * 
	 * @return the polendt printed date
	 */
	public Date getPolendtPrintedDate() {
		return polendtPrintedDate;
	}
	
	/**
	 * Sets the polendt printed date.
	 * 
	 * @param polendtPrintedDate the new polendt printed date
	 */
	public void setPolendtPrintedDate(Date polendtPrintedDate) {
		this.polendtPrintedDate = polendtPrintedDate;
	}
	
	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#getUserId()
	 */
	@Override
	public String getUserId() {
		return userId;
	}
	
	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#setUserId(java.lang.String)
	 */
	@Override
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	/**
	 * Gets the last upd date.
	 * 
	 * @return the last upd date
	 */
	public Date getLastUpdDate() {
		return lastUpdDate;
	}
	
	/**
	 * Sets the last upd date.
	 * 
	 * @param lastUpdDate the new last upd date
	 */
	public void setLastUpdDate(Date lastUpdDate) {
		this.lastUpdDate = lastUpdDate;
	}
	
	/**
	 * Gets the cpi rec no.
	 * 
	 * @return the cpi rec no
	 */
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	
	/**
	 * Sets the cpi rec no.
	 * 
	 * @param cpiRecNo the new cpi rec no
	 */
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	
	/**
	 * Gets the cpi branch cd.
	 * 
	 * @return the cpi branch cd
	 */
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	
	/**
	 * Sets the cpi branch cd.
	 * 
	 * @param cpiBranchCd the new cpi branch cd
	 */
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	
	/**
	 * Gets the polendt printed cnt.
	 * 
	 * @return the polendt printed cnt
	 */
	public Integer getPolendtPrintedCnt() {
		return polendtPrintedCnt;
	}
	
	/**
	 * Sets the polendt printed cnt.
	 * 
	 * @param polendtPrintedCnt the new polendt printed cnt
	 */
	public void setPolendtPrintedCnt(Integer polendtPrintedCnt) {
		this.polendtPrintedCnt = polendtPrintedCnt;
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
	 * Gets the eis flag.
	 * 
	 * @return the eis flag
	 */
	public String getEisFlag() {
		return eisFlag;
	}
	
	/**
	 * Sets the eis flag.
	 * 
	 * @param eisFlag the new eis flag
	 */
	public void setEisFlag(String eisFlag) {
		this.eisFlag = eisFlag;
	}
	
	/**
	 * Gets the ren notice cnt.
	 * 
	 * @return the ren notice cnt
	 */
	public Integer getRenNoticeCnt() {
		return renNoticeCnt;
	}
	
	/**
	 * Sets the ren notice cnt.
	 * 
	 * @param renNoticeCnt the new ren notice cnt
	 */
	public void setRenNoticeCnt(Integer renNoticeCnt) {
		this.renNoticeCnt = renNoticeCnt;
	}
	
	/**
	 * Gets the ren notice date.
	 * 
	 * @return the ren notice date
	 */
	public Date getRenNoticeDate() {
		return renNoticeDate;
	}
	
	/**
	 * Sets the ren notice date.
	 * 
	 * @param renNoticeDate the new ren notice date
	 */
	public void setRenNoticeDate(Date renNoticeDate) {
		this.renNoticeDate = renNoticeDate;
	}
	
	/**
	 * Gets the qd flag.
	 * 
	 * @return the qd flag
	 */
	public String getQdFlag() {
		return qdFlag;
	}
	
	/**
	 * Sets the qd flag.
	 * 
	 * @param qdFlag the new qd flag
	 */
	public void setQdFlag(String qdFlag) {
		this.qdFlag = qdFlag;
	}
	
	/**
	 * Gets the actual renew no.
	 * 
	 * @return the actual renew no
	 */
	public Integer getActualRenewNo() {
		return actualRenewNo;
	}
	
	/**
	 * Sets the actual renew no.
	 * 
	 * @param actualRenewNo the new actual renew no
	 */
	public void setActualRenewNo(Integer actualRenewNo) {
		this.actualRenewNo = actualRenewNo;
	}
	
	/**
	 * Gets the validate tag.
	 * 
	 * @return the validate tag
	 */
	public String getValidateTag() {
		return validateTag;
	}
	
	/**
	 * Sets the validate tag.
	 * 
	 * @param validateTag the new validate tag
	 */
	public void setValidateTag(String validateTag) {
		this.validateTag = validateTag;
	}
	
	/**
	 * Gets the industry cd.
	 * 
	 * @return the industry cd
	 */
	public Integer getIndustryCd() {
		return industryCd;
	}
	
	/**
	 * Sets the industry cd.
	 * 
	 * @param industryCd the new industry cd
	 */
	public void setIndustryCd(Integer industryCd) {
		this.industryCd = industryCd;
	}
	
	/**
	 * Gets the region cd.
	 * 
	 * @return the region cd
	 */
	public Integer getRegionCd() {
		return regionCd;
	}
	
	/**
	 * Sets the region cd.
	 * 
	 * @param regionCd the new region cd
	 */
	public void setRegionCd(Integer regionCd) {
		this.regionCd = regionCd;
	}
	
	/**
	 * Gets the acct of cd sw.
	 * 
	 * @return the acct of cd sw
	 */
	public String getAcctOfCdSw() {
		return acctOfCdSw;
	}
	
	/**
	 * Sets the acct of cd sw.
	 * 
	 * @param acctOfCdSw the new acct of cd sw
	 */
	public void setAcctOfCdSw(String acctOfCdSw) {
		this.acctOfCdSw = acctOfCdSw;
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
	 * Gets the old assd no.
	 * 
	 * @return the old assd no
	 */
	public Integer getOldAssdNo() {
		return oldAssdNo;
	}
	
	/**
	 * Sets the old assd no.
	 * 
	 * @param oldAssdNo the new old assd no
	 */
	public void setOldAssdNo(Integer oldAssdNo) {
		this.oldAssdNo = oldAssdNo;
	}
	
	/**
	 * Gets the cancel date.
	 * 
	 * @return the cancel date
	 */
	public Date getCancelDate() {
		return cancelDate;
	}
	
	/**
	 * Sets the cancel date.
	 * 
	 * @param cancelDate the new cancel date
	 */
	public void setCancelDate(Date cancelDate) {
		this.cancelDate = cancelDate;
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
	 * Gets the old address1.
	 * 
	 * @return the old address1
	 */
	public String getOldAddress1() {
		return oldAddress1;
	}
	
	/**
	 * Sets the old address1.
	 * 
	 * @param oldAddress1 the new old address1
	 */
	public void setOldAddress1(String oldAddress1) {
		this.oldAddress1 = oldAddress1;
	}
	
	/**
	 * Gets the old address2.
	 * 
	 * @return the old address2
	 */
	public String getOldAddress2() {
		return oldAddress2;
	}
	
	/**
	 * Sets the old address2.
	 * 
	 * @param oldAddress2 the new old address2
	 */
	public void setOldAddress2(String oldAddress2) {
		this.oldAddress2 = oldAddress2;
	}
	
	/**
	 * Gets the old address3.
	 * 
	 * @return the old address3
	 */
	public String getOldAddress3() {
		return oldAddress3;
	}
	
	/**
	 * Sets the old address3.
	 * 
	 * @param oldAddress3 the new old address3
	 */
	public void setOldAddress3(String oldAddress3) {
		this.oldAddress3 = oldAddress3;
	}
	
	/**
	 * Gets the reinstatement date.
	 * 
	 * @return the reinstatement date
	 */
	public Date getReinstatementDate() {
		return reinstatementDate;
	}
	
	/**
	 * Sets the reinstatement date.
	 * 
	 * @param reinstatementDate the new reinstatement date
	 */
	public void setReinstatementDate(Date reinstatementDate) {
		this.reinstatementDate = reinstatementDate;
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
	 * Gets the renew extract tag.
	 * 
	 * @return the renew extract tag
	 */
	public String getRenewExtractTag() {
		return renewExtractTag;
	}
	
	/**
	 * Sets the renew extract tag.
	 * 
	 * @param renewExtractTag the new renew extract tag
	 */
	public void setRenewExtractTag(String renewExtractTag) {
		this.renewExtractTag = renewExtractTag;
	}
	
	/**
	 * Gets the claims extract tag.
	 * 
	 * @return the claims extract tag
	 */
	public String getClaimsExtractTag() {
		return claimsExtractTag;
	}
	
	/**
	 * Sets the claims extract tag.
	 * 
	 * @param claimsExtractTag the new claims extract tag
	 */
	public void setClaimsExtractTag(String claimsExtractTag) {
		this.claimsExtractTag = claimsExtractTag;
	}
	
	/**
	 * Gets the survey agent cd.
	 * 
	 * @return the survey agent cd
	 */
	public Integer getSurveyAgentCd() {
		return surveyAgentCd;
	}
	
	/**
	 * Sets the survey agent cd.
	 * 
	 * @param surveyAgentCd the new survey agent cd
	 */
	public void setSurveyAgentCd(Integer surveyAgentCd) {
		this.surveyAgentCd = surveyAgentCd;
	}
	
	/**
	 * Gets the settling agent cd.
	 * 
	 * @return the settling agent cd
	 */
	public Integer getSettlingAgentCd() {
		return settlingAgentCd;
	}
	
	/**
	 * Sets the settling agent cd.
	 * 
	 * @param settlingAgentCd the new settling agent cd
	 */
	public void setSettlingAgentCd(Integer settlingAgentCd) {
		this.settlingAgentCd = settlingAgentCd;
	}
	
	/**
	 * Gets the pack policy id.
	 * 
	 * @return the pack policy id
	 */
	public Integer getPackPolicyId() {
		return packPolicyId;
	}
	
	/**
	 * Sets the pack policy id.
	 * 
	 * @param packPolicyId the new pack policy id
	 */
	public void setPackPolicyId(Integer packPolicyId) {
		this.packPolicyId = packPolicyId;
	}
	
	/**
	 * Gets the prem warr days.
	 * 
	 * @return the prem warr days
	 */
	public Integer getPremWarrDays() {
		return premWarrDays;
	}
	
	/**
	 * Sets the prem warr days.
	 * 
	 * @param premWarrDays the new prem warr days
	 */
	public void setPremWarrDays(Integer premWarrDays) {
		this.premWarrDays = premWarrDays;
	}
	
	/**
	 * Gets the spoil cd.
	 * 
	 * @return the spoil cd
	 */
	public String getSpoilCd() {
		return spoilCd;
	}
	
	/**
	 * Sets the spoil cd.
	 * 
	 * @param spoilCd the new spoil cd
	 */
	public void setSpoilCd(String spoilCd) {
		this.spoilCd = spoilCd;
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
	 * Gets the reinstate tag.
	 * 
	 * @return the reinstate tag
	 */
	public String getReinstateTag() {
		return reinstateTag;
	}
	
	/**
	 * Sets the reinstate tag.
	 * 
	 * @param reinstateTag the new reinstate tag
	 */
	public void setReinstateTag(String reinstateTag) {
		this.reinstateTag = reinstateTag;
	}
	
	/**
	 * Gets the arc ext data.
	 * 
	 * @return the arc ext data
	 */
	public String getArcExtData() {
		return arcExtData;
	}
	
	/**
	 * Sets the arc ext data.
	 * 
	 * @param arcExtData the new arc ext data
	 */
	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}
	
	/**
	 * Gets the cancelled endt id.
	 * 
	 * @return the cancelled endt id
	 */
	public Integer getCancelledEndtId() {
		return cancelledEndtId;
	}
	
	/**
	 * Sets the cancelled endt id.
	 * 
	 * @param cancelledEndtId the new cancelled endt id
	 */
	public void setCancelledEndtId(Integer cancelledEndtId) {
		this.cancelledEndtId = cancelledEndtId;
	}
	
	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#getId()
	 */
	@Override
	public Object getId() {
		// TODO Auto-generated method stub
		return null;
	}
	
	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#setId(java.lang.Object)
	 */
	@Override
	public void setId(Object id) {
		// TODO Auto-generated method stub
		
	}

	/**
	 * @param packPol the packPol to set
	 */
	public void setPackPol(Integer packPol) {
		this.packPol = packPol;
	}

	/**
	 * @return the packPol
	 */
	public Integer getPackPol() {
		return packPol;
	}

	/**
	 * @param assdName the assdName to set
	 */
	public void setAssdName(String assdName) {
		this.assdName = assdName;
	}

	/**
	 * @return the assdName
	 */
	public String getAssdName() {
		return assdName;
	}

	/**
	 * @param policyNo the policyNo to set
	 */
	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}

	/**
	 * @return the policyNo
	 */
	public String getPolicyNo() {
		return policyNo;
	}

	/**
	 * @param parNo the parNo to set
	 */
	public void setParNo(String parNo) {
		this.parNo = parNo;
	}

	/**
	 * @return the parNo
	 */
	public String getParNo() {
		return parNo;
	}

	/**
	 * @param billNotPrinted the billNotPrinted to set
	 */
	public void setBillNotPrinted(String billNotPrinted) {
		this.billNotPrinted = billNotPrinted;
	}

	/**
	 * @return the billNotPrinted
	 */
	public String getBillNotPrinted() {
		return billNotPrinted;
	}


	/**
	 * @param endtNo the endtNo to set
	 */
	public void setEndtNo(String endtNo) {
		this.endtNo = endtNo;
	}

	/**
	 * @return the endtNo
	 */
	public String getEndtNo() {
		return endtNo;
	}


	/**
	 * @param policyDsDtlExist the policyDsDtlExist to set
	 */
	public void setPolicyDsDtlExist(String policyDsDtlExist) {
		this.policyDsDtlExist = policyDsDtlExist;
	}

	/**
	 * @return the policyDsDtlExist
	 */
	public String getPolicyDsDtlExist() {
		return policyDsDtlExist;
	}

	/**
	 * @param endtTax the endtTax to set
	 */
	public void setEndtTax(String endtTax) {
		this.endtTax = endtTax;
	}

	/**
	 * @return the endtTax
	 */
	public String getEndtTax() {
		return endtTax;
	}

	/**
	 * @param itmperilCount the itmperilCount to set
	 */
	public void setItmperilCount(Integer itmperilCount) {
		this.itmperilCount = itmperilCount;
	}

	/**
	 * @return the itmperilCount
	 */
	public Integer getItmperilCount() {
		return itmperilCount;
	}

	/**
	 * @param compulsoryDeath the compulsoryDeath to set
	 */
	public void setCompulsoryDeath(String compulsoryDeath) {
		this.compulsoryDeath = compulsoryDeath;
	}

	/**
	 * @return the compulsoryDeath
	 */
	public String getCompulsoryDeath() {
		return compulsoryDeath;
	}

	/**
	 * @param cocType the cocType to set
	 */
	public void setCocType(String cocType) {
		this.cocType = cocType;
	}

	/**
	 * @return the cocType
	 */
	public String getCocType() {
		return cocType;
	}

	/**
	 * @param lineReports the lineReports to set
	 */
	public void setLineReports(List<GIISReports> lineReports) {
		this.lineReports = lineReports;
	}

	/**
	 * @return the lineReports
	 */
	public List<GIISReports> getLineReports() {
		return lineReports;
	}

	/**
	 * @param packageReports the packageReports to set
	 */
	public void setPackageReports(List<GIISReports> packageReports) {
		this.packageReports = packageReports;
	}

	/**
	 * @return the packageReports
	 */
	public List<GIISReports> getPackageReports() {
		return packageReports;
	}

	public void setGipiItems(List<GIPIItem> gipiItems) {
		this.gipiItems = gipiItems;
	}


	public List<GIPIItem> getGipiItems() {
		//return (List<GIPIItem>) StringFormatter.escapeHTMLInList4(gipiItems);	//Gzelle 02122015
		return (List<GIPIItem>) gipiItems; // andrew - 19595, 19567, 19638 - 07102015
	}

	/**
	 * @param premSeqNo the premSeqNo to set
	 */
	public void setPremSeqNo(Integer premSeqNo) {
		this.premSeqNo = premSeqNo;
	}

	/**
	 * @return the premSeqNo
	 */
	public Integer getPremSeqNo() {
		return premSeqNo;
	}

	public String getMeanPolFlag() {
		return meanPolFlag;
	}

	public void setMeanPolFlag(String meanPolFlag) {
		this.meanPolFlag = meanPolFlag;
	}
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

	public String getEmployeeName() {
		return employeeName;
	}

	public void setEmployeeName(String employeeName) {
		this.employeeName = employeeName;
	}

	public Integer getCompanyCd() {
		return companyCd;
	}

	public void setCompanyCd(Integer companyCd) {
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

	public String getBancTypeDesc() {
		return bancTypeDesc;
	}

	public void setBancTypeDesc(String bancTypeDesc) {
		this.bancTypeDesc = bancTypeDesc;
	}

	public Integer getAreaCd() {
		return areaCd;
	}

	public void setAreaCd(Integer areaCd) {
		this.areaCd = areaCd;
	}

	public String getAreaDesc() {
		return areaDesc;
	}

	public void setAreaDesc(String areaDesc) {
		this.areaDesc = areaDesc;
	}

	public Integer getBranchCd() {
		return branchCd;
	}

	public void setBranchCd(Integer branchCd) {
		this.branchCd = branchCd;
	}

	public String getBranchDesc() {
		return branchDesc;
	}

	public void setBranchDesc(String branchDesc) {
		this.branchDesc = branchDesc;
	}

	public Integer getManagerCd() {
		return managerCd;
	}

	public void setManagerCd(Integer managerCd) {
		this.managerCd = managerCd;
	}

	public String getPayeeName() {
		return payeeName;
	}

	public void setPayeeName(String payeeName) {
		this.payeeName = payeeName;
	}

	public String getPlanCd() {
		return planCd;
	}

	public void setPlanCd(String planCd) {
		this.planCd = planCd;
	}

	public String getPlanDesc() {
		return planDesc;
	}

	public void setPlanDesc(String planDesc) {
		this.planDesc = planDesc;
	}

	public String getPlanChTag() {
		return planChTag;
	}

	public void setPlanChTag(String planChTag) {
		this.planChTag = planChTag;
	}

	public String getAcctOf() {
		return acctOf;
	}

	public void setAcctOf(String acctOf) {
		this.acctOf = acctOf;
	}

	public String getDefaultCurrency() {
		return defaultCurrency;
	}

	public void setDefaultCurrency(String defaultCurrency) {
		this.defaultCurrency = defaultCurrency;
	}

	public String getEndorsement() {
		return endorsement;
	}

	public void setEndorsement(String endorsement) {
		this.endorsement = endorsement;
	}

	public String getPrintSw() {
		return printSw;
	}

	public void setPrintSw(String printSw) {
		this.printSw = printSw;
	}

	public void setDistNo(Integer distNo) {
		this.distNo = distNo;
	}

	public Integer getDistNo() {
		return distNo;
	}

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

	public String getItemTitle() {
		return itemTitle;
	}

	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}
	
//	Gzelle 06.27.2013
	public String getStrAcctEntDt() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(acctEntDate != null){
			return sdf.format(acctEntDate).toString();
		} else {
			return null;
		}
	}	
	
	public String getStrInceptDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(inceptDate != null){
			return sdf.format(inceptDate).toString();
		} else {
			return null;
		}
	}
	
	public String getStrExpiryDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(expiryDate != null){
			return sdf.format(expiryDate).toString();
		} else {
			return null;
		}
	}
	//added by steven 08.08.2014
	public String getStrEffDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(effDate != null){
			return sdf.format(effDate).toString();
		} else {
			return null;
		}
	}

	public String getStrIssueDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(this.issueDate != null){
			return sdf.format(this.issueDate).toString();
		} else {
			return null;
		}
	}
	
	public Integer getIndGrpCd() {
		return indGrpCd;
	}

	public void setIndGrpCd(Integer indGrpCd) {
		this.indGrpCd = indGrpCd;
	}

	public BigDecimal getLossAmt() {
		return lossAmt;
	}

	public void setLossAmt(BigDecimal lossAmt) {
		this.lossAmt = lossAmt;
	}

	public BigDecimal getTotalLossAmt() {
		return totalLossAmt;
	}

	public void setTotalLossAmt(BigDecimal totalLossAmt) {
		this.totalLossAmt = totalLossAmt;
	}

	public Integer getClaimId() {
		return claimId;
	}

	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}

	public String getClaimNo() {
		return claimNo;
	}

	public void setClaimNo(String claimNo) {
		this.claimNo = claimNo;
	}

	public String getStrDueDate() {
		return strDueDate;
	}

	public void setStrDueDate(String strDueDate) {
		this.strDueDate = strDueDate;
	}

}
