package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLCasualtyDtl extends BaseEntity{
	
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
	private BigDecimal amountCoverage;
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
	private Integer groupNo;
	
	// shan 04.15.2014
	private String lossDateChar;
		
	public Integer getGroupNo() {
		return groupNo;
	}
	public void setGroupNo(Integer groupNo) {
		this.groupNo = groupNo;
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
	
	public Object getStrLastUpdate(){
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(lastUpdate != null){
			return sdf.format(lastUpdate).toString();
		} else {
			return null;
		}
		
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
	public BigDecimal getAmountCoverage() {
		return amountCoverage;
	}
	public void setAmountCoverage(BigDecimal amountCoverage) {
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
