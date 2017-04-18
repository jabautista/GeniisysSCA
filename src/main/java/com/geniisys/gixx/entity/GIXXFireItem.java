package com.geniisys.gixx.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIXXFireItem extends BaseEntity{

	private Integer extractId;
	private Integer itemNo;
	private String frItemType;
	private Integer blockId;
	private String eqZone;
	private String typhoonZone;
	private String floodZone;
	private String tarfCd;
	private String constructionCd;
	private String tariffZone;
	private String occupancyCd;
	private String assignee;
	private String districtNo;
	private String blockNo;
	private String constructionRemarks;
	private String occupancyRemarks;
	private String locRisk1;
	private String locRisk2;
	private String locRisk3;
	private String front;
	private String right;
	private String left;
	private String rear;
	private String latitude;  //benjo 01.10.2017 SR-5749
	private String longitude; //benjo 01.10.2017 SR-5749
	private String frItemDesc;
	private String provinceDesc;
	private String city;
	private String eqDesc;
	private String typhoonZoneDesc;
	private String floodZoneDesc;
	private String tarfDesc;
	private String constructionDesc;
	private String tariffZoneDesc;
	private String occupancyDesc;
	private Date fromDate;
	private Date toDate;
	
	
	public Integer getExtractId() {
		return extractId;
	}
	public void setExtractId(Integer extractId) {
		this.extractId = extractId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public String getFrItemType() {
		return frItemType;
	}
	public void setFrItemType(String frItemType) {
		this.frItemType = frItemType;
	}
	public Integer getBlockId() {
		return blockId;
	}
	public void setBlockId(Integer blockId) {
		this.blockId = blockId;
	}
	public String getEqZone() {
		return eqZone;
	}
	public void setEqZone(String eqZone) {
		this.eqZone = eqZone;
	}
	public String getTyphoonZone() {
		return typhoonZone;
	}
	public void setTyphoonZone(String typhoonZone) {
		this.typhoonZone = typhoonZone;
	}
	public String getFloodZone() {
		return floodZone;
	}
	public void setFloodZone(String floodZone) {
		this.floodZone = floodZone;
	}
	public String getTarfCd() {
		return tarfCd;
	}
	public void setTarfCd(String tarfCd) {
		this.tarfCd = tarfCd;
	}
	public String getConstructionCd() {
		return constructionCd;
	}
	public void setConstructionCd(String constructionCd) {
		this.constructionCd = constructionCd;
	}
	public String getTariffZone() {
		return tariffZone;
	}
	public void setTariffZone(String tariffZone) {
		this.tariffZone = tariffZone;
	}
	public String getOccupancyCd() {
		return occupancyCd;
	}
	public void setOccupancyCd(String occupancyCd) {
		this.occupancyCd = occupancyCd;
	}
	public String getAssignee() {
		return assignee;
	}
	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}
	public String getDistrictNo() {
		return districtNo;
	}
	public void setDistrictNo(String districtNo) {
		this.districtNo = districtNo;
	}
	public String getBlockNo() {
		return blockNo;
	}
	public void setBlockNo(String blockNo) {
		this.blockNo = blockNo;
	}
	public String getConstructionRemarks() {
		return constructionRemarks;
	}
	public void setConstructionRemarks(String constructionRemarks) {
		this.constructionRemarks = constructionRemarks;
	}
	public String getOccupancyRemarks() {
		return occupancyRemarks;
	}
	public void setOccupancyRemarks(String occupancyRemarks) {
		this.occupancyRemarks = occupancyRemarks;
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
	public String getFrItemDesc() {
		return frItemDesc;
	}
	public void setFrItemDesc(String frItemDesc) {
		this.frItemDesc = frItemDesc;
	}
	public String getProvinceDesc() {
		return provinceDesc;
	}
	public void setProvinceDesc(String provinceDesc) {
		this.provinceDesc = provinceDesc;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getEqDesc() {
		return eqDesc;
	}
	public void setEqDesc(String eqDesc) {
		this.eqDesc = eqDesc;
	}
	public String getTyphoonZoneDesc() {
		return typhoonZoneDesc;
	}
	public void setTyphoonZoneDesc(String typhoonZoneDesc) {
		this.typhoonZoneDesc = typhoonZoneDesc;
	}
	public String getFloodZoneDesc() {
		return floodZoneDesc;
	}
	public void setFloodZoneDesc(String floodZoneDesc) {
		this.floodZoneDesc = floodZoneDesc;
	}
	public String getTarfDesc() {
		return tarfDesc;
	}
	public void setTarfDesc(String tarfDesc) {
		this.tarfDesc = tarfDesc;
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
	public String getOccupancyDesc() {
		return occupancyDesc;
	}
	public void setOccupancyDesc(String occupancyDesc) {
		this.occupancyDesc = occupancyDesc;
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
	/* benjo 01.10.2017 SR-5749 */
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
	/* end SR-5749 */
	
}
