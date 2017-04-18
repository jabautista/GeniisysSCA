package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLMarineHullDtl extends BaseEntity{
	
	private Integer claimId;
	private String clmStatDesc;
	private String claimNo;
	private String policyNo;
	private String lineCd;
	private Date dspLossDate;
	private Date lossDate;
	private String assuredName;
	private String lossCtgry;
	private Integer renewNo;
	private Integer polSeqNo;
	private Integer issueYy;
	private String polIssCd;
	private String sublineCd;
	private Date expiryDate;
	private Date polEffDate;
	private String catastrophicCd;
	private Date clmFileDate;
	private Integer lossCatCd;
	private Integer itemNo;
	private Integer perilCd;
	private String closeFlag;
	private String itemTitle;
	private Integer groupedItemNo;
	private String groupedItemTitle;
	private Integer currencyCd;
	private String currencyDesc;
	private BigDecimal currencyRate;
	private String sectionOrHazardInfo;
	private String sectionOrHazardCd;
	private String itemDesc;
	private String itemDesc2;
	private String propertyNo;
	private String propertyNoType;
	private String location;
	private String conveyanceInfo;
	private String interestOnPremises;
	private Integer amountCoverage;
	private String limitOfLiability;
	private Integer capacityCd;
	private String position;
	private String positionDesc;
	private String personnelName;
	private String itm;
	private String giclItemPerilExist;
	private String giclMortgageeExist;
	private String giclItemPerilMsg;
	private Integer personnelNo;
	private String name;
	private BigDecimal amountCovered;
	private String positionCd;
	private String locationCd;
	private String sectionLineCd;
	private String sectionSublineCd;
	private String cpiBranchCd;
	private Integer cpiRecNo;
	private Date lastUpdate;
	private String userId;
	private String includeTag;
	private String remarks;
	private String vesselCd;
	private String geogLimit;
	private String deductText;
	private String dryPlace;
	private String vesselName;
	private String vestypeCd;
	private String vesselOldName;
	private String propelSw;
	private Integer hullTypeCd;
	private String regOwner;
	private String regPlace;
	private BigDecimal grossTon;
	private BigDecimal netTon;
	private Integer deadweight;
	private Integer yearBuilt;
	private Integer vessClassCd;
	private String crewNat;
	private Integer noCrew;
	private BigDecimal vesselLength;
	private BigDecimal vesselBreadth;
	private String vestypeDesc;
	private BigDecimal vesselDepth;
	private String hullDesc;
	private String vessClassDesc;
	private Date dryDate;
	
	// shan 04.15.2014
	private String lossDateChar;
	
	public Date getDryDate() {
		return dryDate;
	}
	public void setDryDate(Date dryDate) {
		this.dryDate = dryDate;
	}
	public String getVesselCd() {
		return vesselCd;
	}
	public void setVesselCd(String vesselCd) {
		this.vesselCd = vesselCd;
	}
	public String getGeogLimit() {
		return geogLimit;
	}
	public void setGeogLimit(String geogLimit) {
		this.geogLimit = geogLimit;
	}
	public String getDeductText() {
		return deductText;
	}
	public void setDeductText(String deductText) {
		this.deductText = deductText;
	}
	public String getDryPlace() {
		return dryPlace;
	}
	public void setDryPlace(String dryPlace) {
		this.dryPlace = dryPlace;
	}
	public String getVesselName() {
		return vesselName;
	}
	public void setVesselName(String vesselName) {
		this.vesselName = vesselName;
	}
	public String getVestypeCd() {
		return vestypeCd;
	}
	public void setVestypeCd(String vestypeCd) {
		this.vestypeCd = vestypeCd;
	}
	public String getVesselOldName() {
		return vesselOldName;
	}
	public void setVesselOldName(String vesselOldName) {
		this.vesselOldName = vesselOldName;
	}
	public String getPropelSw() {
		return propelSw;
	}
	public void setPropelSw(String propelSw) {
		this.propelSw = propelSw;
	}
	public Integer getHullTypeCd() {
		return hullTypeCd;
	}
	public void setHullTypeCd(Integer hullTypeCd) {
		this.hullTypeCd = hullTypeCd;
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
	public BigDecimal getGrossTon() {
		return grossTon;
	}
	public void setGrossTon(BigDecimal grossTon) {
		this.grossTon = grossTon;
	}
	public BigDecimal getNetTon() {
		return netTon;
	}
	public void setNetTon(BigDecimal netTon) {
		this.netTon = netTon;
	}
	public Integer getDeadweight() {
		return deadweight;
	}
	public void setDeadweight(Integer deadweight) {
		this.deadweight = deadweight;
	}
	public Integer getYearBuilt() {
		return yearBuilt;
	}
	public void setYearBuilt(Integer yearBuilt) {
		this.yearBuilt = yearBuilt;
	}
	public Integer getVessClassCd() {
		return vessClassCd;
	}
	public void setVessClassCd(Integer vessClassCd) {
		this.vessClassCd = vessClassCd;
	}
	public String getCrewNat() {
		return crewNat;
	}
	public void setCrewNat(String crewNat) {
		this.crewNat = crewNat;
	}
	public Integer getNoCrew() {
		return noCrew;
	}
	public void setNoCrew(Integer noCrew) {
		this.noCrew = noCrew;
	}
	public BigDecimal getVesselLength() {
		return vesselLength;
	}
	public void setVesselLength(BigDecimal vesselLength) {
		this.vesselLength = vesselLength;
	}
	public BigDecimal getVesselBreadth() {
		return vesselBreadth;
	}
	public void setVesselBreadth(BigDecimal vesselBreadth) {
		this.vesselBreadth = vesselBreadth;
	}
	public String getVestypeDesc() {
		return vestypeDesc;
	}
	public void setVestypeDesc(String vestypeDesc) {
		this.vestypeDesc = vestypeDesc;
	}
	public BigDecimal getVesselDepth() {
		return vesselDepth;
	}
	public void setVesselDepth(BigDecimal vesselDepth) {
		this.vesselDepth = vesselDepth;
	}
	public String getHullDesc() {
		return hullDesc;
	}
	public void setHullDesc(String hullDesc) {
		this.hullDesc = hullDesc;
	}
	public String getVessClassDesc() {
		return vessClassDesc;
	}
	public void setVessClassDesc(String vessClassDesc) {
		this.vessClassDesc = vessClassDesc;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getIncludeTag() {
		return includeTag;
	}
	public void setIncludeTag(String includeTag) {
		this.includeTag = includeTag;
	}
	public Date getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
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
	public String getSectionSublineCd() {
		return sectionSublineCd;
	}
	public void setSectionSublineCd(String sectionSublineCd) {
		this.sectionSublineCd = sectionSublineCd;
	}
	public String getSectionLineCd() {
		return sectionLineCd;
	}
	public void setSectionLineCd(String sectionLineCd) {
		this.sectionLineCd = sectionLineCd;
	}
	public String getLocationCd() {
		return locationCd;
	}
	public void setLocationCd(String locationCd) {
		this.locationCd = locationCd;
	}
	public BigDecimal getAmountCovered() {
		return amountCovered;
	}
	public void setAmountCovered(BigDecimal amountCovered) {
		this.amountCovered = amountCovered;
	}
	public String getPositionCd() {
		return positionCd;
	}
	public void setPositionCd(String positionCd) {
		this.positionCd = positionCd;
	}
	public Integer getPersonnelNo() {
		return personnelNo;
	}
	public void setPersonnelNo(Integer personnelNo) {
		this.personnelNo = personnelNo;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getGiclItemPerilExist() {
		return giclItemPerilExist;
	}
	public void setGiclItemPerilExist(String giclItemPerilExist) {
		this.giclItemPerilExist = giclItemPerilExist;
	}
	public String getGiclMortgageeExist() {
		return giclMortgageeExist;
	}
	public void setGiclMortgageeExist(String giclMortgageeExist) {
		this.giclMortgageeExist = giclMortgageeExist;
	}
	public String getGiclItemPerilMsg() {
		return giclItemPerilMsg;
	}
	public void setGiclItemPerilMsg(String giclItemPerilMsg) {
		this.giclItemPerilMsg = giclItemPerilMsg;
	}
	public String getItm() {
		return itm;
	}
	public void setItm(String itm) {
		this.itm = itm;
	}
	public String getPositionDesc() {
		return positionDesc;
	}
	public void setPositionDesc(String positionDesc) {
		this.positionDesc = positionDesc;
	}
	public String getPersonnelName() {
		return personnelName;
	}
	public void setPersonnelName(String personnelName) {
		this.personnelName = personnelName;
	}
	public String getPropertyNo() {
		return propertyNo;
	}
	public void setPropertyNo(String propertyNo) {
		this.propertyNo = propertyNo;
	}
	public String getPropertyNoType() {
		return propertyNoType;
	}
	public void setPropertyNoType(String propertyNoType) {
		this.propertyNoType = propertyNoType;
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
	public String getInterestOnPremises() {
		return interestOnPremises;
	}
	public void setInterestOnPremises(String interestOnPremises) {
		this.interestOnPremises = interestOnPremises;
	}
	public Integer getAmountCoverage() {
		return amountCoverage;
	}
	public void setAmountCoverage(Integer amountCoverage) {
		this.amountCoverage = amountCoverage;
	}
	public String getLimitOfLiability() {
		return limitOfLiability;
	}
	public void setLimitOfLiability(String limitOfLiability) {
		this.limitOfLiability = limitOfLiability;
	}
	public Integer getCapacityCd() {
		return capacityCd;
	}
	public void setCapacityCd(Integer capacityCd) {
		this.capacityCd = capacityCd;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
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
	public String getItemTitle() {
		return itemTitle;
	}
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}
	public Integer getGroupedItemNo() {
		return groupedItemNo;
	}
	public void setGroupedItemNo(Integer groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}
	public String getGroupedItemTitle() {
		return groupedItemTitle;
	}
	public void setGroupedItemTitle(String groupedItemTitle) {
		this.groupedItemTitle = groupedItemTitle;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public String getCurrencyDesc() {
		return currencyDesc;
	}
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}
	public BigDecimal getCurrencyRate() {
		return currencyRate;
	}
	public void setCurrencyRate(BigDecimal currencyRate) {
		this.currencyRate = currencyRate;
	}
	public String getSectionOrHazardInfo() {
		return sectionOrHazardInfo;
	}
	public void setSectionOrHazardInfo(String sectionOrHazardInfo) {
		this.sectionOrHazardInfo = sectionOrHazardInfo;
	}
	public String getSectionOrHazardCd() {
		return sectionOrHazardCd;
	}
	public void setSectionOrHazardCd(String sectionOrHazardCd) {
		this.sectionOrHazardCd = sectionOrHazardCd;
	}
	public String getCloseFlag() {
		return closeFlag;
	}
	public void setCloseFlag(String closeFlag) {
		this.closeFlag = closeFlag;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public Integer getPerilCd() {
		return perilCd;
	}
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public String getClmStatDesc() {
		return clmStatDesc;
	}
	public void setClmStatDesc(String clmStatDesc) {
		this.clmStatDesc = clmStatDesc;
	}
	public String getClaimNo() {
		return claimNo;
	}
	public void setClaimNo(String claimNo) {
		this.claimNo = claimNo;
	}
	public String getPolicyNo() {
		return policyNo;
	}
	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public Date getDspLossDate() {
		return dspLossDate;
	}
	public void setDspLossDate(Date dspLossDate) {
		this.dspLossDate = dspLossDate;
	}
	public Date getLossDate() {
		return lossDate;
	}
	public void setLossDate(Date lossDate) {
		this.lossDate = lossDate;
	}
	public String getAssuredName() {
		return assuredName;
	}
	public void setAssuredName(String assuredName) {
		this.assuredName = assuredName;
	}
	public String getLossCtgry() {
		return lossCtgry;
	}
	public void setLossCtgry(String lossCtgry) {
		this.lossCtgry = lossCtgry;
	}
	public Integer getRenewNo() {
		return renewNo;
	}
	public void setRenewNo(Integer renewNo) {
		this.renewNo = renewNo;
	}
	public Integer getPolSeqNo() {
		return polSeqNo;
	}
	public void setPolSeqNo(Integer polSeqNo) {
		this.polSeqNo = polSeqNo;
	}
	public Integer getIssueYy() {
		return issueYy;
	}
	public void setIssueYy(Integer issueYy) {
		this.issueYy = issueYy;
	}
	public String getPolIssCd() {
		return polIssCd;
	}
	public void setPolIssCd(String polIssCd) {
		this.polIssCd = polIssCd;
	}
	public String getSublineCd() {
		return sublineCd;
	}
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	public Date getExpiryDate() {
		return expiryDate;
	}
	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}
	public Date getPolEffDate() {
		return polEffDate;
	}
	public void setPolEffDate(Date polEffDate) {
		this.polEffDate = polEffDate;
	}
	public String getCatastrophicCd() {
		return catastrophicCd;
	}
	public void setCatastrophicCd(String catastrophicCd) {
		this.catastrophicCd = catastrophicCd;
	}
	public Date getClmFileDate() {
		return clmFileDate;
	}
	public void setClmFileDate(Date clmFileDate) {
		this.clmFileDate = clmFileDate;
	}
	public Integer getLossCatCd() {
		return lossCatCd;
	}
	public void setLossCatCd(Integer lossCatCd) {
		this.lossCatCd = lossCatCd;
	}
	public String getLossDateChar() {
		return lossDateChar;
	}
	public void setLossDateChar(String lossDateChar) {
		this.lossDateChar = lossDateChar;
	}	
}
