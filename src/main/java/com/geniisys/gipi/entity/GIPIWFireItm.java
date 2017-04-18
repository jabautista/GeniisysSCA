/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIWFireItm.
 */
public class GIPIWFireItm extends BaseEntity{
	
	/** The par id. */
	private int parId;
	
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
	
	private String latitude; //Added by Jerome 11.10.2016 SR 5749
	
	private String longitude; //Added by Jerome 11.10.2016 SR 5749

	public String getLongitude() {
		return longitude;
	}

	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}

	public String getRiskDesc() {
		return riskDesc;
	}

	public void setRiskDesc(String riskDesc) {
		this.riskDesc = riskDesc;
	}

	public String getOccupancyDesc() {
		return occupancyDesc;
	}

	public void setOccupancyDesc(String occupancyDesc) {
		this.occupancyDesc = occupancyDesc;
	}

	public String getDistrictDesc() {
		return districtDesc;
	}

	public void setDistrictDesc(String districtDesc) {
		this.districtDesc = districtDesc;
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
	
	/**
	 * Instantiates a new gIPIW fire itm.
	 */
	public GIPIWFireItm(){
		
	}
	
	/**
	 * Instantiates a new gIPIW fire itm.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @param districtNo the district no
	 * @param eqZone the eq zone
	 * @param tarfCd the tarf cd
	 * @param blockNo the block no
	 * @param frItemType the fr item type
	 * @param locRisk1 the loc risk1
	 * @param locRisk2 the loc risk2
	 * @param locRisk3 the loc risk3
	 * @param tariffZone the tariff zone
	 * @param typhoonZone the typhoon zone
	 * @param constructionCd the construction cd
	 * @param constructionRemarks the construction remarks
	 * @param front the front
	 * @param right the right
	 * @param left the left
	 * @param rear the rear
	 * @param occupancyCd the occupancy cd
	 * @param occupancyRemarks the occupancy remarks
	 * @param assignee the assignee
	 * @param floodZone the flood zone
	 * @param blockId the block id
	 * @param riskCd the risk cd
	 */
	public GIPIWFireItm(final int parId, final int itemNo, final String districtNo, final String eqZone,
			final String tarfCd, final String blockNo, final String frItemType, final String locRisk1,
			final String locRisk2, final String locRisk3, final String tariffZone, final String typhoonZone,
			final String constructionCd, final String constructionRemarks, final String front, final String right, 
			final String left, final String rear, final String occupancyCd, final String occupancyRemarks, 
			final String assignee, final String floodZone, final String blockId, final String riskCd){
		this.parId = parId;
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
	}
	
	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public int getParId() {
		return parId;
	}
	
	/**
	 * Sets the par id.
	 * 
	 * @param parId the new par id
	 */
	public void setParId(int parId) {
		this.parId = parId;
	}
	
	/**
	 * Gets the item no.
	 * 
	 * @return the item no
	 */
	public int getItemNo() {
		return itemNo;
	}
	
	/**
	 * Sets the item no.
	 * 
	 * @param itemNo the new item no
	 */
	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}
	
	/**
	 * Gets the district no.
	 * 
	 * @return the district no
	 */
	public String getDistrictNo() {
		return districtNo;
	}
	
	/**
	 * Sets the district no.
	 * 
	 * @param districtNo the new district no
	 */
	public void setDistrictNo(String districtNo) {
		this.districtNo = districtNo;
	}
	
	/**
	 * Gets the eq zone.
	 * 
	 * @return the eq zone
	 */
	public String getEqZone() {
		return eqZone;
	}
	
	/**
	 * Sets the eq zone.
	 * 
	 * @param eqZone the new eq zone
	 */
	public void setEqZone(String eqZone) {
		this.eqZone = eqZone;
	}
	
	/**
	 * Gets the tarf cd.
	 * 
	 * @return the tarf cd
	 */
	public String getTarfCd() {
		return tarfCd;
	}
	
	/**
	 * Sets the tarf cd.
	 * 
	 * @param tarfCd the new tarf cd
	 */
	public void setTarfCd(String tarfCd) {
		this.tarfCd = tarfCd;
	}
	
	/**
	 * Gets the block no.
	 * 
	 * @return the block no
	 */
	public String getBlockNo() {
		return blockNo;
	}
	
	/**
	 * Sets the block no.
	 * 
	 * @param blockNo the new block no
	 */
	public void setBlockNo(String blockNo) {
		this.blockNo = blockNo;
	}
	
	/**
	 * Gets the fr item type.
	 * 
	 * @return the fr item type
	 */
	public String getFrItemType() {
		return frItemType;
	}
	
	/**
	 * Sets the fr item type.
	 * 
	 * @param frItemType the new fr item type
	 */
	public void setFrItemType(String frItemType) {
		this.frItemType = frItemType;
	}
	
	/**
	 * Gets the loc risk1.
	 * 
	 * @return the loc risk1
	 */
	public String getLocRisk1() {
		return locRisk1;
	}
	
	/**
	 * Sets the loc risk1.
	 * 
	 * @param locRisk1 the new loc risk1
	 */
	public void setLocRisk1(String locRisk1) {
		this.locRisk1 = locRisk1;
	}
	
	/**
	 * Gets the loc risk2.
	 * 
	 * @return the loc risk2
	 */
	public String getLocRisk2() {
		return locRisk2;
	}
	
	/**
	 * Sets the loc risk2.
	 * 
	 * @param locRisk2 the new loc risk2
	 */
	public void setLocRisk2(String locRisk2) {
		this.locRisk2 = locRisk2;
	}
	
	/**
	 * Gets the loc risk3.
	 * 
	 * @return the loc risk3
	 */
	public String getLocRisk3() {
		return locRisk3;
	}
	
	/**
	 * Sets the loc risk3.
	 * 
	 * @param locRisk3 the new loc risk3
	 */
	public void setLocRisk3(String locRisk3) {
		this.locRisk3 = locRisk3;
	}
	
	/**
	 * Gets the tariff zone.
	 * 
	 * @return the tariff zone
	 */
	public String getTariffZone() {
		return tariffZone;
	}
	
	/**
	 * Sets the tariff zone.
	 * 
	 * @param tariffZone the new tariff zone
	 */
	public void setTariffZone(String tariffZone) {
		this.tariffZone = tariffZone;
	}	
	
	/**
	 * Gets the typhoon zone.
	 * 
	 * @return the typhoon zone
	 */
	public String getTyphoonZone() {
		return typhoonZone;
	}

	/**
	 * Sets the typhoon zone.
	 * 
	 * @param typhoonZone the new typhoon zone
	 */
	public void setTyphoonZone(String typhoonZone) {
		this.typhoonZone = typhoonZone;
	}

	/**
	 * Gets the construction cd.
	 * 
	 * @return the construction cd
	 */
	public String getConstructionCd() {
		return constructionCd;
	}
	
	/**
	 * Sets the construction cd.
	 * 
	 * @param constructionCd the new construction cd
	 */
	public void setConstructionCd(String constructionCd) {
		this.constructionCd = constructionCd;
	}
	
	/**
	 * Gets the construction remarks.
	 * 
	 * @return the construction remarks
	 */
	public String getConstructionRemarks() {
		return constructionRemarks;
	}
	
	/**
	 * Sets the construction remarks.
	 * 
	 * @param constructionRemarks the new construction remarks
	 */
	public void setConstructionRemarks(String constructionRemarks) {
		this.constructionRemarks = constructionRemarks;
	}
	
	/**
	 * Gets the front.
	 * 
	 * @return the front
	 */
	public String getFront() {
		return front;
	}
	
	/**
	 * Sets the front.
	 * 
	 * @param front the new front
	 */
	public void setFront(String front) {
		this.front = front;
	}
	
	/**
	 * Gets the right.
	 * 
	 * @return the right
	 */
	public String getRight() {
		return right;
	}
	
	/**
	 * Sets the right.
	 * 
	 * @param right the new right
	 */
	public void setRight(String right) {
		this.right = right;
	}
	
	/**
	 * Gets the left.
	 * 
	 * @return the left
	 */
	public String getLeft() {
		return left;
	}
	
	/**
	 * Sets the left.
	 * 
	 * @param left the new left
	 */
	public void setLeft(String left) {
		this.left = left;
	}
	
	/**
	 * Gets the rear.
	 * 
	 * @return the rear
	 */
	public String getRear() {
		return rear;
	}
	
	/**
	 * Sets the rear.
	 * 
	 * @param rear the new rear
	 */
	public void setRear(String rear) {
		this.rear = rear;
	}
	
	/**
	 * Gets the occupancy cd.
	 * 
	 * @return the occupancy cd
	 */
	public String getOccupancyCd() {
		return occupancyCd;
	}
	
	/**
	 * Sets the occupancy cd.
	 * 
	 * @param occupancyCd the new occupancy cd
	 */
	public void setOccupancyCd(String occupancyCd) {
		this.occupancyCd = occupancyCd;
	}
	
	/**
	 * Gets the occupancy remarks.
	 * 
	 * @return the occupancy remarks
	 */
	public String getOccupancyRemarks() {
		return occupancyRemarks;
	}
	
	/**
	 * Sets the occupancy remarks.
	 * 
	 * @param occupancyRemarks the new occupancy remarks
	 */
	public void setOccupancyRemarks(String occupancyRemarks) {
		this.occupancyRemarks = occupancyRemarks;
	}
	
	/**
	 * Gets the assignee.
	 * 
	 * @return the assignee
	 */
	public String getAssignee() {
		return assignee;
	}
	
	/**
	 * Sets the assignee.
	 * 
	 * @param assignee the new assignee
	 */
	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}
	
	/**
	 * Gets the flood zone.
	 * 
	 * @return the flood zone
	 */
	public String getFloodZone() {
		return floodZone;
	}
	
	/**
	 * Sets the flood zone.
	 * 
	 * @param floodZone the new flood zone
	 */
	public void setFloodZone(String floodZone) {
		this.floodZone = floodZone;
	}
	
	/**
	 * Gets the block id.
	 * 
	 * @return the block id
	 */
	public String getBlockId() {
		return blockId;
	}
	
	/**
	 * Sets the block id.
	 * 
	 * @param blockId the new block id
	 */
	public void setBlockId(String blockId) {
		this.blockId = blockId;
	}
	
	/**
	 * Gets the risk cd.
	 * 
	 * @return the risk cd
	 */
	public String getRiskCd() {
		return riskCd;
	}
	
	/**
	 * Sets the risk cd.
	 * 
	 * @param riskCd the new risk cd
	 */
	public void setRiskCd(String riskCd) {
		this.riskCd = riskCd;
	}

	/**
	 * Gets the city.
	 * 
	 * @return the city
	 */
	public String getCity() {
		return city;
	}	

	/**
	 * Sets the city.
	 * 
	 * @param city the new city
	 */
	public void setCity(String city) {
		this.city = city;
	}
	
	public String getCityCd() {
		return cityCd;
	}

	public void setCityCd(String cityCd) {
		this.cityCd = cityCd;
	}

	/**
	 * Gets the province cd.
	 * 
	 * @return the province cd
	 */
	public String getProvinceCd() {
		return provinceCd;
	}

	/**
	 * Sets the province cd.
	 * 
	 * @param provinceCd the new province cd
	 */
	public void setProvinceCd(String provinceCd) {
		this.provinceCd = provinceCd;
	}	

	/**
	 * Gets the province desc.
	 * 
	 * @return the province desc
	 */
	public String getProvinceDesc() {
		return provinceDesc;
	}

	/**
	 * Sets the province desc.
	 * 
	 * @param provinceDesc the new province desc
	 */
	public void setProvinceDesc(String provinceDesc) {
		this.provinceDesc = provinceDesc;
	}

	/**
	 * Gets the item title.
	 * 
	 * @return the item title
	 */
	public String getItemTitle() {
		return itemTitle;
	}

	/**
	 * Sets the item title.
	 * 
	 * @param itemTitle the new item title
	 */
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}

	/**
	 * Gets the item grp.
	 * 
	 * @return the item grp
	 */
	public String getItemGrp() {
		return itemGrp;
	}

	/**
	 * Sets the item grp.
	 * 
	 * @param itemGrp the new item grp
	 */
	public void setItemGrp(String itemGrp) {
		this.itemGrp = itemGrp;
	}

	/**
	 * Gets the item desc.
	 * 
	 * @return the item desc
	 */
	public String getItemDesc() {
		return itemDesc;
	}

	/**
	 * Sets the item desc.
	 * 
	 * @param itemDesc the new item desc
	 */
	public void setItemDesc(String itemDesc) {
		this.itemDesc = itemDesc;
	}

	/**
	 * Gets the item desc2.
	 * 
	 * @return the item desc2
	 */
	public String getItemDesc2() {
		return itemDesc2;
	}

	/**
	 * Sets the item desc2.
	 * 
	 * @param itemDesc2 the new item desc2
	 */
	public void setItemDesc2(String itemDesc2) {
		this.itemDesc2 = itemDesc2;
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
	 * Gets the prem amt.
	 * 
	 * @return the prem amt
	 */
	public BigDecimal getPremAmt() {
		return premAmt;
	}

	/**
	 * Sets the prem amt.
	 * 
	 * @param premAmt the new prem amt
	 */
	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
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
	 * Gets the rec flag.
	 * 
	 * @return the rec flag
	 */
	public String getRecFlag() {
		return recFlag;
	}

	/**
	 * Sets the rec flag.
	 * 
	 * @param recFlag the new rec flag
	 */
	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}

	/**
	 * Gets the currency cd.
	 * 
	 * @return the currency cd
	 */
	public int getCurrencyCd() {
		return currencyCd;
	}

	/**
	 * Sets the currency cd.
	 * 
	 * @param currencyCd the new currency cd
	 */
	public void setCurrencyCd(int currencyCd) {
		this.currencyCd = currencyCd;
	}

	/**
	 * Gets the currency rt.
	 * 
	 * @return the currency rt
	 */
	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}

	/**
	 * Sets the currency rt.
	 * 
	 * @param currencyRt the new currency rt
	 */
	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}

	/**
	 * Gets the group cd.
	 * 
	 * @return the group cd
	 */
	public String getGroupCd() {
		return groupCd;
	}

	/**
	 * Sets the group cd.
	 * 
	 * @param groupCd the new group cd
	 */
	public void setGroupCd(String groupCd) {
		this.groupCd = groupCd;
	}

	/**
	 * Gets the from date.
	 * 
	 * @return the from date
	 */
	public Date getFromDate() {
		return fromDate;
	}

	/**
	 * Sets the from date.
	 * 
	 * @param fromDate the new from date
	 */
	public void setFromDate(Date fromDate) {
		this.fromDate = fromDate;
	}

	/**
	 * Gets the to date.
	 * 
	 * @return the to date
	 */
	public Date getToDate() {
		return toDate;
	}

	/**
	 * Sets the to date.
	 * 
	 * @param toDate the new to date
	 */
	public void setToDate(Date toDate) {
		this.toDate = toDate;
	}

	/**
	 * Gets the pack line cd.
	 * 
	 * @return the pack line cd
	 */
	public String getPackLineCd() {
		return packLineCd;
	}

	/**
	 * Sets the pack line cd.
	 * 
	 * @param packLineCd the new pack line cd
	 */
	public void setPackLineCd(String packLineCd) {
		this.packLineCd = packLineCd;
	}

	/**
	 * Gets the pack subline cd.
	 * 
	 * @return the pack subline cd
	 */
	public String getPackSublineCd() {
		return packSublineCd;
	}

	/**
	 * Sets the pack subline cd.
	 * 
	 * @param packSublineCd the new pack subline cd
	 */
	public void setPackSublineCd(String packSublineCd) {
		this.packSublineCd = packSublineCd;
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
	 * Gets the coverage cd.
	 * 
	 * @return the coverage cd
	 */
	public String getCoverageCd() {
		return coverageCd;
	}

	/**
	 * Sets the coverage cd.
	 * 
	 * @param coverageCd the new coverage cd
	 */
	public void setCoverageCd(String coverageCd) {
		this.coverageCd = coverageCd;
	}

	/**
	 * Gets the other info.
	 * 
	 * @return the other info
	 */
	public String getOtherInfo() {
		return otherInfo;
	}

	/**
	 * Sets the other info.
	 * 
	 * @param otherInfo the new other info
	 */
	public void setOtherInfo(String otherInfo) {
		this.otherInfo = otherInfo;
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
	 * Gets the changed tag.
	 * 
	 * @return the changed tag
	 */
	public String getChangedTag() {
		return changedTag;
	}

	/**
	 * Sets the changed tag.
	 * 
	 * @param changedTag the new changed tag
	 */
	public void setChangedTag(String changedTag) {
		this.changedTag = changedTag;
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
	 * Gets the pack ben cd.
	 * 
	 * @return the pack ben cd
	 */
	public String getPackBenCd() {
		return packBenCd;
	}

	/**
	 * Sets the pack ben cd.
	 * 
	 * @param packBenCd the new pack ben cd
	 */
	public void setPackBenCd(String packBenCd) {
		this.packBenCd = packBenCd;
	}

	/**
	 * Gets the payt terms.
	 * 
	 * @return the payt terms
	 */
	public String getPaytTerms() {
		return paytTerms;
	}

	/**
	 * Sets the payt terms.
	 * 
	 * @param paytTerms the new payt terms
	 */
	public void setPaytTerms(String paytTerms) {
		this.paytTerms = paytTerms;
	}

	/**
	 * Gets the risk no.
	 * 
	 * @return the risk no
	 */
	public String getRiskNo() {
		return riskNo;
	}

	/**
	 * Sets the risk no.
	 * 
	 * @param riskNo the new risk no
	 */
	public void setRiskNo(String riskNo) {
		this.riskNo = riskNo;
	}

	/**
	 * Gets the risk item no.
	 * 
	 * @return the risk item no
	 */
	public String getRiskItemNo() {
		return riskItemNo;
	}

	/**
	 * Sets the risk item no.
	 * 
	 * @param riskItemNo the new risk item no
	 */
	public void setRiskItemNo(String riskItemNo) {
		this.riskItemNo = riskItemNo;
	}

	/**
	 * Gets the currency desc.
	 * 
	 * @return the currency desc
	 */
	public String getCurrencyDesc() {
		return currencyDesc;
	}

	/**
	 * Sets the currency desc.
	 * 
	 * @param currencyDesc the new currency desc
	 */
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}

	/**
	 * Gets the coverage desc.
	 * 
	 * @return the coverage desc
	 */
	public String getCoverageDesc() {
		return coverageDesc;
	}

	/**
	 * Sets the coverage desc.
	 * 
	 * @param coverageDesc the new coverage desc
	 */
	public void setCoverageDesc(String coverageDesc) {
		this.coverageDesc = coverageDesc;
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
	
	public String getLatitude() { //Added by Jerome 11.10.2016 SR 5749
		return latitude;
	}

	public void setLatitude(String latitude) { //Added by Jerome 11.10.2016 SR 5749
		this.latitude = latitude;
	}
}
