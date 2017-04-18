package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWCasualtyItem extends BaseEntity{
	
	/** The par id. */
	private String parId;
	
	/** The item no. */
	private String itemNo;
	
	/** The item title. */
	private String itemTitle;
	
	/** The item grp. */
	private String itemGrp;
	
	/** The item desc. */
	private String itemDesc;
	
	/** The item desc2. */
	private String itemDesc2;
	
	/** The tsi amt. */
	private BigDecimal tsiAmt;
	
	/** The prem amt. */
	private BigDecimal premAmt;
	
	/** The ann prem amt. */
	private BigDecimal annPremAmt;
	
	/** The ann tsi amt. */
	private BigDecimal annTsiAmt;
	
	/** The rec flag. */
	private String recFlag;
	
	/** The currency cd. */
	private int currencyCd;
	
	/** The currency rt. */
	private BigDecimal currencyRt;
	
	/** The group cd. */
	private String groupCd;
	
	/** The from date. */
	private Date fromDate;
	
	/** The to date. */
	private Date toDate;
	
	/** The pack line cd. */
	private String packLineCd;
	
	/** The pack subline cd. */
	private String packSublineCd;
	
	/** The discount sw. */
	private String discountSw;
	
	/** The coverage cd. */
	private String coverageCd;
	
	/** The other info. */
	private String otherInfo;
	
	/** The surcharge sw. */
	private String surchargeSw;
	
	/** The region cd. */
	private String regionCd;
	
	/** The changed tag. */
	private String changedTag;
	
	/** The prorate flag. */
	private String prorateFlag;
	
	/** The comp sw. */
	private String compSw;
	
	/** The short rt percent. */
	private BigDecimal shortRtPercent;
	
	/** The pack ben cd. */
	private String packBenCd;
	
	/** The payt terms. */
	private String paytTerms;
	
	/** The risk no. */
	private String riskNo;
	
	/** The risk item no. */
	private String riskItemNo;

	private String sectionLineCd;
	private String sectionSublineCd;
	private String sectionOrHazardCd;
	private String propertyNoType;
	private String capacityCd;
	private String propertyNo;
	private String location;
	private String conveyanceInfo;
	private String limitOfLiability;
	private String interestOnPremises;
	private String sectionOrHazardInfo;
	private String locationCd;
	
	private String currencyDesc;
	private String coverageDesc;
	
	private String itmperlGroupedExists;
	
	private String remarks;
	
	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	/**
	 * @param itmperlGroupedExists the itmperlGroupedExists to set
	 */
	public void setItmperlGroupedExists(String itmperlGroupedExists) {
		this.itmperlGroupedExists = itmperlGroupedExists;
	}

	/**
	 * @return the itmperlGroupedExists
	 */
	public String getItmperlGroupedExists() {
		return itmperlGroupedExists;
	}
	
	public GIPIWCasualtyItem(){
		
	}
	
	public GIPIWCasualtyItem(final String parId, final String itemNo,
			final String sectionLineCd, final String sectionSublineCd, final String sectionOrHazardCd,
			final String propertyNoType, final String capacityCd, final String propertyNo,
			final String location, final String conveyanceInfo, final String limitOfLiability,
			final String interestOnPremises, final String sectionOrHazardInfo, final String locationCd
			){
		this.parId = parId;
		this.itemNo = itemNo;
		this.sectionLineCd = sectionLineCd;
		this.sectionSublineCd = sectionSublineCd;
		this.sectionOrHazardCd = sectionOrHazardCd;
		this.propertyNoType = propertyNoType;
		this.capacityCd = capacityCd;
		this.propertyNo = propertyNo;
		this.location = location;
		this.conveyanceInfo = conveyanceInfo;
		this.limitOfLiability = limitOfLiability;
		this.interestOnPremises = interestOnPremises;
		this.sectionOrHazardInfo = sectionOrHazardInfo;
		this.locationCd = locationCd;
	}
	
	public String getParId() {
		return parId;
	}
	public void setParId(String parId) {
		this.parId = parId;
	}
	public String getItemNo() {
		return itemNo;
	}
	public void setItemNo(String itemNo) {
		this.itemNo = itemNo;
	}
	public String getItemTitle() {
		return itemTitle;
	}
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}
	public String getItemGrp() {
		return itemGrp;
	}
	public void setItemGrp(String itemGrp) {
		this.itemGrp = itemGrp;
	}
	public String getItemDesc() {
		return itemDesc;
	}
	public void setItemDesc(String itemDesc) {
		this.itemDesc = itemDesc;
	}
	public String getItemDesc2() {
		return itemDesc2;
	}
	public void setItemDesc2(String itemDesc2) {
		this.itemDesc2 = itemDesc2;
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
	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}
	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}
	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}
	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}
	public String getRecFlag() {
		return recFlag;
	}
	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}
	public int getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(int currencyCd) {
		this.currencyCd = currencyCd;
	}
	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}
	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}
	public String getGroupCd() {
		return groupCd;
	}
	public void setGroupCd(String groupCd) {
		this.groupCd = groupCd;
	}
	public Date getFromDate() {
		return fromDate;
	}
	public void setFromDate(Date fromDate) {
		this.fromDate = fromDate;
	}
	public Date getToDate() {
		return toDate;
	}
	public void setToDate(Date toDate) {
		this.toDate = toDate;
	}
	public String getPackLineCd() {
		return packLineCd;
	}
	public void setPackLineCd(String packLineCd) {
		this.packLineCd = packLineCd;
	}
	public String getPackSublineCd() {
		return packSublineCd;
	}
	public void setPackSublineCd(String packSublineCd) {
		this.packSublineCd = packSublineCd;
	}
	public String getDiscountSw() {
		return discountSw;
	}
	public void setDiscountSw(String discountSw) {
		this.discountSw = discountSw;
	}
	public String getCoverageCd() {
		return coverageCd;
	}
	public void setCoverageCd(String coverageCd) {
		this.coverageCd = coverageCd;
	}
	public String getOtherInfo() {
		return otherInfo;
	}
	public void setOtherInfo(String otherInfo) {
		this.otherInfo = otherInfo;
	}
	public String getSurchargeSw() {
		return surchargeSw;
	}
	public void setSurchargeSw(String surchargeSw) {
		this.surchargeSw = surchargeSw;
	}
	public String getRegionCd() {
		return regionCd;
	}
	public void setRegionCd(String regionCd) {
		this.regionCd = regionCd;
	}
	public String getChangedTag() {
		return changedTag;
	}
	public void setChangedTag(String changedTag) {
		this.changedTag = changedTag;
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
	public String getPackBenCd() {
		return packBenCd;
	}
	public void setPackBenCd(String packBenCd) {
		this.packBenCd = packBenCd;
	}
	public String getPaytTerms() {
		return paytTerms;
	}
	public void setPaytTerms(String paytTerms) {
		this.paytTerms = paytTerms;
	}
	public String getRiskNo() {
		return riskNo;
	}
	public void setRiskNo(String riskNo) {
		this.riskNo = riskNo;
	}
	public String getRiskItemNo() {
		return riskItemNo;
	}
	public void setRiskItemNo(String riskItemNo) {
		this.riskItemNo = riskItemNo;
	}
	public String getSectionLineCd() {
		return sectionLineCd;
	}
	public void setSectionLineCd(String sectionLineCd) {
		this.sectionLineCd = sectionLineCd;
	}
	public String getSectionSublineCd() {
		return sectionSublineCd;
	}
	public void setSectionSublineCd(String sectionSublineCd) {
		this.sectionSublineCd = sectionSublineCd;
	}
	public String getSectionOrHazardCd() {
		return sectionOrHazardCd;
	}
	public void setSectionOrHazardCd(String sectionOrHazardCd) {
		this.sectionOrHazardCd = sectionOrHazardCd;
	}
	public String getPropertyNoType() {
		return propertyNoType;
	}
	public void setPropertyNoType(String propertyNoType) {
		this.propertyNoType = propertyNoType;
	}
	public String getCapacityCd() {
		return capacityCd;
	}
	public void setCapacityCd(String capacityCd) {
		this.capacityCd = capacityCd;
	}
	public String getPropertyNo() {
		return propertyNo;
	}
	public void setPropertyNo(String propertyNo) {
		this.propertyNo = propertyNo;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getConveyanceInfo() {
		return conveyanceInfo;
	}
	public void setConveyanceInfo(String conveyanceInfo) {
		this.conveyanceInfo = conveyanceInfo;
	}
	public String getLimitOfLiability() {
		return limitOfLiability;
	}
	public void setLimitOfLiability(String limitOfLiability) {
		this.limitOfLiability = limitOfLiability;
	}
	public String getInterestOnPremises() {
		return interestOnPremises;
	}
	public void setInterestOnPremises(String interestOnPremises) {
		this.interestOnPremises = interestOnPremises;
	}
	public String getSectionOrHazardInfo() {
		return sectionOrHazardInfo;
	}
	public void setSectionOrHazardInfo(String sectionOrHazardInfo) {
		this.sectionOrHazardInfo = sectionOrHazardInfo;
	}
	public String getLocationCd() {
		return locationCd;
	}
	public void setLocationCd(String locationCd) {
		this.locationCd = locationCd;
	}
	public String getCurrencyDesc() {
		return currencyDesc;
	}
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}
	public String getCoverageDesc() {
		return coverageDesc;
	}
	public void setCoverageDesc(String coverageDesc) {
		this.coverageDesc = coverageDesc;
	}
}
