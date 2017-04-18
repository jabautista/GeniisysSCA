package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWItemVes extends BaseEntity{
	
	private Integer parId;
	private Integer itemNo;
	private String itemTitle;
	private String itemDesc;
	private String itemDesc2;
	private String vesselCd;
	private String vesselFlag;
	private String vesselName;
	private String vesselOldName;
	private String vesTypeDesc;
	private String propelSw;
	private String vessClassDesc;
	private String hullDesc;
	private String regOwner;
	private String regPlace;
	private Integer grossTon;
	private Integer yearBuilt;
	private Integer netTon;
	private Integer noCrew;
	private Integer deadWeight;
	private String crewNat;
	private Integer vesselLength;
	private Integer vesselDepth;
	private Integer vesselBreadth;
	private String dryPlace;
	private String dryDate;
	private String recFlag;
	private String deductText;
	private String geogLimit;
	private Integer itemGrp;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private BigDecimal annPremAmt;
	private BigDecimal annTsiAmt;
	private int currencyCd;
	private BigDecimal currencyRt;
	private String groupCd;
	private Date fromDate;
	private Date toDate;
	private String packLineCd;
	private String packSublineCd;
	private String discountSw;
	private String coverageCd;
	private String otherInfo;
	private String surchargeSw;
	private String regionCd;
	private String changedTag;
	private String prorateFlag;
	private String compSw;
	private BigDecimal shortRtPercent;
	private String packBenCd;
	private String paytTerms;
	private String riskNo;
	private String riskItemNo;
	
	private Integer noOfItemperils;
	
	private String currencyDesc;
	private String coverageDesc;
	
	private String itmperlGroupedExists;
	private String restrictedCondition;
	
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
	
	public GIPIWItemVes(){
		
	}
	
	public GIPIWItemVes(final String parId, final String itemNo, final String vesselCd, final String recFlag,
						final String deductText, final String geogLimit, final String dryDate, final String dryPlace){
		this.parId = Integer.parseInt(parId);
		this.itemNo = Integer.parseInt(itemNo);
		this.vesselCd = vesselCd;
		this.recFlag = recFlag;
		this.deductText = deductText;
		this.geogLimit = geogLimit;
		this.dryDate = dryDate;
		this.dryPlace = dryPlace;
		
	}
	
	public GIPIWItemVes(final Integer parId, final Integer itemNo, final String vesselCd, final String recFlag,
			final String deductText, final String geogLimit, final String dryDate, final String dryPlace){
		this.parId = parId;
		this.itemNo = itemNo;
		this.vesselCd = vesselCd;
		this.recFlag = recFlag;
		this.deductText = deductText;
		this.geogLimit = geogLimit;
		this.dryDate = dryDate;
		this.dryPlace = dryPlace;

}
	
	public Integer getParId() {
		return parId;
	}
	public void setParId(Integer parId) {
		this.parId = parId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public String getItemTitle() {
		return itemTitle;
	}
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
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
	public String getVesselCd() {
		return vesselCd;
	}
	public void setVesselCd(String vesselCd) {
		this.vesselCd = vesselCd;
	}
	public String getVesselFlag() {
		return vesselFlag;
	}
	public void setVesselFlag(String vesselFlag) {
		this.vesselFlag = vesselFlag;
	}
	public String getVesselName() {
		return vesselName;
	}
	public void setVesselName(String vesselName) {
		this.vesselName = vesselName;
	}
	public String getVesselOldName() {
		return vesselOldName;
	}
	public void setVesselOldName(String vesselOldName) {
		this.vesselOldName = vesselOldName;
	}
	public String getVesTypeDesc() {
		return vesTypeDesc;
	}
	public void setVesTypeDesc(String vesTypeDesc) {
		this.vesTypeDesc = vesTypeDesc;
	}
	public String getPropelSw() {
		return propelSw;
	}
	public void setPropelSw(String propelSw) {
		this.propelSw = propelSw;
	}
	public String getVessClassDesc() {
		return vessClassDesc;
	}
	public void setVessClassDesc(String vessClassDesc) {
		this.vessClassDesc = vessClassDesc;
	}
	public String getHullDesc() {
		return hullDesc;
	}
	public void setHullDesc(String hullDesc) {
		this.hullDesc = hullDesc;
	}
	public String getRegOwner() {
		return regOwner;
	}
	public void setRegOwner(String regOwner) {
		this.regOwner = regOwner;
	}
	public String getRegPlace() {
		return regPlace;
	}
	public void setRegPlace(String regPlace) {
		this.regPlace = regPlace;
	}
	public Integer getGrossTon() {
		return grossTon;
	}
	public void setGrossTon(Integer grossTon) {
		this.grossTon = grossTon;
	}
	public Integer getYearBuilt() {
		return yearBuilt;
	}
	public void setYearBuilt(Integer yearBuilt) {
		this.yearBuilt = yearBuilt;
	}
	public Integer getNetTon() {
		return netTon;
	}
	public void setNetTon(Integer netTon) {
		this.netTon = netTon;
	}
	public Integer getNoCrew() {
		return noCrew;
	}
	public void setNoCrew(Integer noCrew) {
		this.noCrew = noCrew;
	}
	public Integer getDeadWeight() {
		return deadWeight;
	}
	public void setDeadWeight(Integer deadWeight) {
		this.deadWeight = deadWeight;
	}
	public String getCrewNat() {
		return crewNat;
	}
	public void setCrewNat(String crewNat) {
		this.crewNat = crewNat;
	}
	public Integer getVesselLength() {
		return vesselLength;
	}
	public void setVesselLength(Integer vesselLength) {
		this.vesselLength = vesselLength;
	}
	public Integer getVesselDepth() {
		return vesselDepth;
	}
	public void setVesselDepth(Integer vesselDepth) {
		this.vesselDepth = vesselDepth;
	}
	public Integer getVesselBreadth() {
		return vesselBreadth;
	}
	public void setVesselBreadth(Integer vesselBreadth) {
		this.vesselBreadth = vesselBreadth;
	}
	public String getDryPlace() {
		return dryPlace;
	}
	public void setDryPlace(String dryPlace) {
		this.dryPlace = dryPlace;
	}
	public String getDryDate() {
		return dryDate;
	}
	public void setDryDate(String dryDate) {
		this.dryDate = dryDate;
	}
	public String getRecFlag() {
		return recFlag;
	}
	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}
	public String getDeductText() {
		return deductText;
	}
	public void setDeductText(String deductText) {
		this.deductText = deductText;
	}
	public String getGeogLimit() {
		return geogLimit;
	}
	public void setGeogLimit(String geogLimit) {
		this.geogLimit = geogLimit;
	}
	public Integer getItemGrp() {
		return itemGrp;
	}
	public void setItemGrp(Integer itemGrp) {
		this.itemGrp = itemGrp;
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
	public String getCurrencyDesc() {
		return currencyDesc;
	}
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}
	public void setCoverageDesc(String coverageDesc) {
		this.coverageDesc = coverageDesc;
	}
	public String getCoverageDesc() {
		return coverageDesc;
	}

	/**
	 * @param restrictedCondition the restrictedCondition to set
	 */
	public void setRestrictedCondition(String restrictedCondition) {
		this.restrictedCondition = restrictedCondition;
	}

	/**
	 * @return the restrictedCondition
	 */
	public String getRestrictedCondition() {
		return restrictedCondition;
	}

	/**
	 * @param noOfItemperils the noOfItemperils to set
	 */
	public void setNoOfItemperils(Integer noOfItemperils) {
		this.noOfItemperils = noOfItemperils;
	}

	/**
	 * @return the noOfItemperils
	 */
	public Integer getNoOfItemperils() {
		return noOfItemperils;
	}
	
	
	
	
	

}
