/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIQuoteItemFI.
 * 
 * @author toni
 */
public class GIPIQuoteItemFI extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -857026519582057098L;

	/** The quote id. */
	private Integer quoteId;
	
	/** The item no. */
	private Integer itemNo;
	
	/** The district no. */
	private String districtNo;
	
	/** The eq zone. */
	private String eqZone;
	
	/** The tariff cd. */
	private String tariffCd;
	
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
	
	/** The flood zone. */
	private String floodZone;
	
	/** The assignee. */
	private String assignee;
	
	/** The block id. */
	private Integer blockId;
	
	/** The risk cd. */
	private String riskCd;
	
	/** The fr item tp ds. */
	private String frItemTpDs;
	
	/** The province desc. */
	private String provinceDesc;
	
	private String provinceCd;
	
	/** The block desc. */
	private String blockDesc;
	
	/** The risk desc. */
	private String riskDesc;
	
	/** The eq desc. */
	private String eqDesc;
	
	/** The typhoon zone desc. */
	private String typhoonZoneDesc;
	
	/** The flood zone desc. */
	private String floodZoneDesc;
	
	/** The tariff zone desc. */
	private String tariffZoneDesc;
	
	/** The construction desc. */
	private String constructionDesc;
	
	/** The occupancy desc. */
	private String occupancyDesc;
	
	/** The city cd. */
	private String cityCd;
	
	/** The city. */
	private String city;
    
    /** The date from. */
    private Date   dateFrom;
    
    /** The date to. */
    private Date   dateTo;
    
	/**
	 * Instantiates a new gIPI quote item fi.
	 */
	public GIPIQuoteItemFI() {

	}

	/**
	 * Instantiates a new gIPI quote item fi.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @param assignee the assignee
	 * @param frItemType the fr item type
	 * @param districtNo the district no
	 * @param blockNo the block no
	 * @param riskCd the risk cd
	 * @param eqZone the eq zone
	 * @param typhoonZone the typhoon zone
	 * @param floodZone the flood zone
	 * @param tariffCd the tariff cd
	 * @param tariffZone the tariff zone
	 * @param constructionCd the construction cd
	 * @param constructionRemarks the construction remarks
	 * @param userId the user id
	 * @param lastUpdate the last update
	 * @param front the front
	 * @param right the right
	 * @param left the left
	 * @param rear the rear
	 * @param locRisk1 the loc risk1
	 * @param locRisk2 the loc risk2
	 * @param locRisk3 the loc risk3
	 * @param occupancyCd the occupancy cd
	 * @param occupancyRemarks the occupancy remarks
	 */
	public GIPIQuoteItemFI(Integer quoteId, Integer itemNo, String assignee,
			String frItemType, String districtNo, String blockNo,
			String riskCd, String eqZone, String typhoonZone, String floodZone,
			String tariffCd, String tariffZone, String constructionCd,
			String constructionRemarks, String userId, Date lastUpdate,
			String front, String right, String left, String rear,
			String locRisk1, String locRisk2, String locRisk3,
			String occupancyCd, String occupancyRemarks) {
	}

	/**
	 * Gets the quote id.
	 * 
	 * @return the quote id
	 */
	public Integer getQuoteId() {
		return quoteId;
	}

	/**
	 * Sets the quote id.
	 * 
	 * @param quoteId the new quote id
	 */
	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}

	/**
	 * Gets the item no.
	 * 
	 * @return the item no
	 */
	public Integer getItemNo() {
		return itemNo;
	}

	/**
	 * Sets the item no.
	 * 
	 * @param itemNo the new item no
	 */
	public void setItemNo(Integer itemNo) {
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
	 * Gets the tariff cd.
	 * 
	 * @return the tariff cd
	 */
	public String getTariffCd() {
		return tariffCd;
	}

	/**
	 * Sets the tariff cd.
	 * 
	 * @param tariffCd the new tariff cd
	 */
	public void setTariffCd(String tariffCd) {
		this.tariffCd = tariffCd;
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
	 * Gets the block id.
	 * 
	 * @return the block id
	 */
	public Integer getBlockId() {
		return blockId;
	}

	/**
	 * Sets the block id.
	 * 
	 * @param blockId the new block id
	 */
	public void setBlockId(Integer blockId) {
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
	 * Gets the fr item tp ds.
	 * 
	 * @return the fr item tp ds
	 */
	public String getFrItemTpDs() {
		return frItemTpDs;
	}

	/**
	 * Sets the fr item tp ds.
	 * 
	 * @param frItemTpDs the new fr item tp ds
	 */
	public void setFrItemTpDs(String frItemTpDs) {
		this.frItemTpDs = frItemTpDs;
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
	 * Gets the block desc.
	 * 
	 * @return the block desc
	 */
	public String getBlockDesc() {
		return blockDesc;
	}

	/**
	 * Sets the block desc.
	 * 
	 * @param blockDesc the new block desc
	 */
	public void setBlockDesc(String blockDesc) {
		this.blockDesc = blockDesc;
	}

	/**
	 * Gets the risk desc.
	 * 
	 * @return the risk desc
	 */
	public String getRiskDesc() {
		return riskDesc;
	}

	/**
	 * Sets the risk desc.
	 * 
	 * @param riskDesc the new risk desc
	 */
	public void setRiskDesc(String riskDesc) {
		this.riskDesc = riskDesc;
	}

	/**
	 * Gets the eq desc.
	 * 
	 * @return the eq desc
	 */
	public String getEqDesc() {
		return eqDesc;
	}

	/**
	 * Sets the eq desc.
	 * 
	 * @param eqDesc the new eq desc
	 */
	public void setEqDesc(String eqDesc) {
		this.eqDesc = eqDesc;
	}

	/**
	 * Gets the typhoon zone desc.
	 * 
	 * @return the typhoon zone desc
	 */
	public String getTyphoonZoneDesc() {
		return typhoonZoneDesc;
	}

	/**
	 * Sets the typhoon zone desc.
	 * 
	 * @param typhoonZoneDesc the new typhoon zone desc
	 */
	public void setTyphoonZoneDesc(String typhoonZoneDesc) {
		this.typhoonZoneDesc = typhoonZoneDesc;
	}

	/**
	 * Gets the flood zone desc.
	 * 
	 * @return the flood zone desc
	 */
	public String getFloodZoneDesc() {
		return floodZoneDesc;
	}

	/**
	 * Sets the flood zone desc.
	 * 
	 * @param floodZoneDesc the new flood zone desc
	 */
	public void setFloodZoneDesc(String floodZoneDesc) {
		this.floodZoneDesc = floodZoneDesc;
	}

	/**
	 * Gets the tariff zone desc.
	 * 
	 * @return the tariff zone desc
	 */
	public String getTariffZoneDesc() {
		return tariffZoneDesc;
	}

	/**
	 * Sets the tariff zone desc.
	 * 
	 * @param tariffZoneDesc the new tariff zone desc
	 */
	public void setTariffZoneDesc(String tariffZoneDesc) {
		this.tariffZoneDesc = tariffZoneDesc;
	}

	/**
	 * Gets the construction desc.
	 * 
	 * @return the construction desc
	 */
	public String getConstructionDesc() {
		return constructionDesc;
	}

	/**
	 * Sets the construction desc.
	 * 
	 * @param constructionDesc the new construction desc
	 */
	public void setConstructionDesc(String constructionDesc) {
		this.constructionDesc = constructionDesc;
	}

	/**
	 * Gets the occupancy desc.
	 * 
	 * @return the occupancy desc
	 */
	public String getOccupancyDesc() {
		return occupancyDesc;
	}

	/**
	 * Sets the occupancy desc.
	 * 
	 * @param occupancyDesc the new occupancy desc
	 */
	public void setOccupancyDesc(String occupancyDesc) {
		this.occupancyDesc = occupancyDesc;
	}

	/**
	 * Gets the city cd.
	 * 
	 * @return the city cd
	 */
	public String getCityCd() {
		return cityCd;
	}

	/**
	 * Sets the city cd.
	 * 
	 * @param cityCd the new city cd
	 */
	public void setCityCd(String cityCd) {
		this.cityCd = cityCd;
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

	/**
	 * Sets the date from.
	 * 
	 * @param dateFrom the new date from
	 */
	public void setDateFrom(Date dateFrom) {
		this.dateFrom = dateFrom;
	}

	/**
	 * Gets the date from.
	 * 
	 * @return the date from
	 */
	public Date getDateFrom() {
		return dateFrom;
	}

	/**
	 * Sets the date to.
	 * 
	 * @param dateTo the new date to
	 */
	public void setDateTo(Date dateTo) {
		this.dateTo = dateTo;
	}

	/**
	 * Gets the date to.
	 * 
	 * @return the date to
	 */
	public Date getDateTo() {
		return dateTo;
	}

	/**
	 * @param provinceCd the provinceCd to set
	 */
	public void setProvinceCd(String provinceCd) {
		this.provinceCd = provinceCd;
	}

	/**
	 * @return the provinceCd
	 */
	public String getProvinceCd() {
		return provinceCd;
	}

	public void showAllValuesInConsole(){
		System.out.println("assignee : " + this.assignee);
		System.out.println("type	 : " + this.frItemType);
		System.out.println("province : " + this.provinceCd + " - " + this.provinceDesc);
		System.out.println("city	 : " + this.cityCd + " - " + this.city);
		System.out.println("district : " + this.districtNo);
		System.out.println("block	 : " + this.blockNo + " - " + this.blockId + " - " + this.blockDesc);
		System.out.println("risk	 : " + this.riskCd + " - " + this.riskDesc);
		System.out.println("occupancy: " + this.occupancyCd + " - " + this.occupancyDesc + " - " + this.occupancyRemarks);
		System.out.println("eqZone	 : " + this.eqZone);
		System.out.println("typhoonZn: " + this.typhoonZone + " - " + this.typhoonZoneDesc);
		System.out.println("floodZn  : " + this.floodZone + " - " + this.floodZoneDesc);
		System.out.println("tariffZn : " + this.tariffZone + " - " + this.tariffZoneDesc);
//		System.out.println("city	 : " + this.assignee);
	}
	
}
