package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

public class GIPIFireItem {
	/** The par id. */
	private int policyId;
	
	/** The item no. */
	private int itemNo;
	
	/** The district no. */
	private String districtNo;
	
	/** The eq zone. */
	private String eqZone;
	
	/** The tarf cd. */
	private String tarfCd;
	
	/** The block no. */
	private String blockNo;
	
	/** The fr item type. */
	private String frItemType;
	
	/** The loc risk1. */
	private String locRisk1;
	
	/** The loc risk2. */
	private String locRisk2;
	
	/** The loc risk3. */
	private String locRisk3;
	
	/** The tariff zone. */
	private String tariffZone;
	
	/** The typhoon zone. */
	private String typhoonZone;
	
	/** The construction cd. */
	private String constructionCd;
	
	/** The construction remarks. */
	private String constructionRemarks;
	
	/** The front. */
	private String front;
	
	/** The right. */
	private String right;
	
	/** The left. */
	private String left;
	
	/** The rear. */
	private String rear;
	
	/** The occupancy cd. */
	private String occupancyCd;
	
	/** The occupancy remarks. */
	private String occupancyRemarks;
	
	/** The assignee. */
	private String assignee;
	
	/** The flood zone. */
	private String floodZone;
	
	/** The block id. */
	private String blockId;
	
	/** The risk cd. */
	private String riskCd;
	
	/** The city. */
	private String city;
	
	private String cityCd;
	
	/** The province cd. */
	private String provinceCd;
	
	/** The province desc. */
	private String provinceDesc;
	
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
	
	/** The currency desc. */
	private String currencyDesc;	
	
	/** The coverage desc. */
	private String coverageDesc;
	
	private String itmperlGroupedExists;
	
	private String districtDesc;
	
	private String occupancyDesc;
	
	private String riskDesc;
	
	private String typhoonZoneDesc;
	
	private String eqDesc;
	
	private String floodZoneDesc;
	
	
	private String constructionDesc;
	
	private String tariffZoneDesc;
	
	private String frItemDesc;
	
	private String tarfDesc;
	
	private String latitude;
	
	private String longitude;

	public GIPIFireItem(){
		
	}

	public GIPIFireItem(int policyId, int itemNo, String districtNo,
			String eqZone, String tarfCd, String blockNo, String frItemType,
			String locRisk1, String locRisk2, String locRisk3,
			String tariffZone, String typhoonZone, String constructionCd,
			String constructionRemarks, String front, String right,
			String left, String rear, String occupancyCd,
			String occupancyRemarks, String assignee, String floodZone,
			String blockId, String riskCd, String city, String cityCd,
			String provinceCd, String provinceDesc, String itemTitle,
			String itemGrp, String itemDesc, String itemDesc2,
			BigDecimal tsiAmt, BigDecimal premAmt, BigDecimal annPremAmt,
			BigDecimal annTsiAmt, String recFlag, int currencyCd,
			BigDecimal currencyRt, String groupCd, Date fromDate, Date toDate,
			String packLineCd, String packSublineCd, String discountSw,
			String coverageCd, String otherInfo, String surchargeSw,
			String regionCd, String changedTag, String prorateFlag,
			String compSw, BigDecimal shortRtPercent, String packBenCd,
			String paytTerms, String riskNo, String riskItemNo,
			String currencyDesc, String coverageDesc,
			String itmperlGroupedExists, String districtDesc,
			String occupancyDesc, String riskDesc, String typhoonZoneDesc,
			String eqDesc, String floodZoneDesc) {
		super();
		this.policyId = policyId;
		this.itemNo = itemNo;
		this.districtNo = districtNo;
		this.eqZone = eqZone;
		this.tarfCd = tarfCd;
		this.blockNo = blockNo;
		this.frItemType = frItemType;
		this.locRisk1 = locRisk1;
		this.locRisk2 = locRisk2;
		this.locRisk3 = locRisk3;
		this.tariffZone = tariffZone;
		this.typhoonZone = typhoonZone;
		this.constructionCd = constructionCd;
		this.constructionRemarks = constructionRemarks;
		this.front = front;
		this.right = right;
		this.left = left;
		this.rear = rear;
		this.occupancyCd = occupancyCd;
		this.occupancyRemarks = occupancyRemarks;
		this.assignee = assignee;
		this.floodZone = floodZone;
		this.blockId = blockId;
		this.riskCd = riskCd;
		this.city = city;
		this.cityCd = cityCd;
		this.provinceCd = provinceCd;
		this.provinceDesc = provinceDesc;
		this.itemTitle = itemTitle;
		this.itemGrp = itemGrp;
		this.itemDesc = itemDesc;
		this.itemDesc2 = itemDesc2;
		this.tsiAmt = tsiAmt;
		this.premAmt = premAmt;
		this.annPremAmt = annPremAmt;
		this.annTsiAmt = annTsiAmt;
		this.recFlag = recFlag;
		this.currencyCd = currencyCd;
		this.currencyRt = currencyRt;
		this.groupCd = groupCd;
		this.fromDate = fromDate;
		this.toDate = toDate;
		this.packLineCd = packLineCd;
		this.packSublineCd = packSublineCd;
		this.discountSw = discountSw;
		this.coverageCd = coverageCd;
		this.otherInfo = otherInfo;
		this.surchargeSw = surchargeSw;
		this.regionCd = regionCd;
		this.changedTag = changedTag;
		this.prorateFlag = prorateFlag;
		this.compSw = compSw;
		this.shortRtPercent = shortRtPercent;
		this.packBenCd = packBenCd;
		this.paytTerms = paytTerms;
		this.riskNo = riskNo;
		this.riskItemNo = riskItemNo;
		this.currencyDesc = currencyDesc;
		this.coverageDesc = coverageDesc;
		this.itmperlGroupedExists = itmperlGroupedExists;
		this.districtDesc = districtDesc;
		this.occupancyDesc = occupancyDesc;
		this.riskDesc = riskDesc;
		this.typhoonZoneDesc = typhoonZoneDesc;
		this.eqDesc = eqDesc;
		this.floodZoneDesc = floodZoneDesc;
	}

	public int getPolicyId() {
		return policyId;
	}

	public void setPolicyId(int policyId) {
		this.policyId = policyId;
	}

	public int getItemNo() {
		return itemNo;
	}

	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}

	public String getDistrictNo() {
		return districtNo;
	}

	public void setDistrictNo(String districtNo) {
		this.districtNo = districtNo;
	}

	public String getEqZone() {
		return eqZone;
	}

	public void setEqZone(String eqZone) {
		this.eqZone = eqZone;
	}

	public String getTarfCd() {
		return tarfCd;
	}

	public void setTarfCd(String tarfCd) {
		this.tarfCd = tarfCd;
	}

	public String getBlockNo() {
		return blockNo;
	}

	public void setBlockNo(String blockNo) {
		this.blockNo = blockNo;
	}

	public String getFrItemType() {
		return frItemType;
	}

	public void setFrItemType(String frItemType) {
		this.frItemType = frItemType;
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

	public String getTariffZone() {
		return tariffZone;
	}

	public void setTariffZone(String tariffZone) {
		this.tariffZone = tariffZone;
	}

	public String getTyphoonZone() {
		return typhoonZone;
	}

	public void setTyphoonZone(String typhoonZone) {
		this.typhoonZone = typhoonZone;
	}

	public String getConstructionCd() {
		return constructionCd;
	}

	public void setConstructionCd(String constructionCd) {
		this.constructionCd = constructionCd;
	}

	public String getConstructionRemarks() {
		return constructionRemarks;
	}

	public void setConstructionRemarks(String constructionRemarks) {
		this.constructionRemarks = constructionRemarks;
	}

	public String getFront() {
		return front;
	}

	public void setFront(String front) {
		this.front = front;
	}

	public String getRight() {
		return right;
	}

	public void setRight(String right) {
		this.right = right;
	}

	public String getLeft() {
		return left;
	}

	public void setLeft(String left) {
		this.left = left;
	}

	public String getRear() {
		return rear;
	}

	public void setRear(String rear) {
		this.rear = rear;
	}

	public String getOccupancyCd() {
		return occupancyCd;
	}

	public void setOccupancyCd(String occupancyCd) {
		this.occupancyCd = occupancyCd;
	}

	public String getOccupancyRemarks() {
		return occupancyRemarks;
	}

	public void setOccupancyRemarks(String occupancyRemarks) {
		this.occupancyRemarks = occupancyRemarks;
	}

	public String getAssignee() {
		return assignee;
	}

	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}

	public String getFloodZone() {
		return floodZone;
	}

	public void setFloodZone(String floodZone) {
		this.floodZone = floodZone;
	}

	public String getBlockId() {
		return blockId;
	}

	public void setBlockId(String blockId) {
		this.blockId = blockId;
	}

	public String getRiskCd() {
		return riskCd;
	}

	public void setRiskCd(String riskCd) {
		this.riskCd = riskCd;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getCityCd() {
		return cityCd;
	}

	public void setCityCd(String cityCd) {
		this.cityCd = cityCd;
	}

	public String getProvinceCd() {
		return provinceCd;
	}

	public void setProvinceCd(String provinceCd) {
		this.provinceCd = provinceCd;
	}

	public String getProvinceDesc() {
		return provinceDesc;
	}

	public void setProvinceDesc(String provinceDesc) {
		this.provinceDesc = provinceDesc;
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

	public String getItmperlGroupedExists() {
		return itmperlGroupedExists;
	}

	public void setItmperlGroupedExists(String itmperlGroupedExists) {
		this.itmperlGroupedExists = itmperlGroupedExists;
	}

	public String getDistrictDesc() {
		return districtDesc;
	}

	public void setDistrictDesc(String districtDesc) {
		this.districtDesc = districtDesc;
	}

	public String getOccupancyDesc() {
		return occupancyDesc;
	}

	public void setOccupancyDesc(String occupancyDesc) {
		this.occupancyDesc = occupancyDesc;
	}

	public String getRiskDesc() {
		return riskDesc;
	}

	public void setRiskDesc(String riskDesc) {
		this.riskDesc = riskDesc;
	}

	public String getTyphoonZoneDesc() {
		return typhoonZoneDesc;
	}

	public void setTyphoonZoneDesc(String typhoonZoneDesc) {
		this.typhoonZoneDesc = typhoonZoneDesc;
	}

	public String getEqDesc() {
		return eqDesc;
	}

	public void setEqDesc(String eqDesc) {
		this.eqDesc = eqDesc;
	}

	public String getFloodZoneDesc() {
		return floodZoneDesc;
	}

	public void setFloodZoneDesc(String floodZoneDesc) {
		this.floodZoneDesc = floodZoneDesc;
	}

	public String getConstructionDesc() {
		return constructionDesc;
	}

	public void setConstructionDesc(String constructionDesc) {
		this.constructionDesc = constructionDesc;
	}

	public String getTariffZoneDesc() {
		return tariffZoneDesc;
	}

	public void setTariffZoneDesc(String tariffZoneDesc) {
		this.tariffZoneDesc = tariffZoneDesc;
	}

	public String getFrItemDesc() {
		return frItemDesc;
	}

	public void setFrItemDesc(String frItemDesc) {
		this.frItemDesc = frItemDesc;
	}

	public String getTarfDesc() {
		return tarfDesc;
	}

	public void setTarfDesc(String tarfDesc) {
		this.tarfDesc = tarfDesc;
	}

	public String getLatitude() {
		return latitude;
	}

	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}

	public String getLongitude() {
		return longitude;
	}

	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
	
	
}
