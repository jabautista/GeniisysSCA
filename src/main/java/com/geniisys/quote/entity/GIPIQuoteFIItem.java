package com.geniisys.quote.entity;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIQuoteFIItem extends BaseEntity{
	
	private Integer quoteId;
	private Integer itemNo;
	private String districtNo;
	private String eqZone;
	private String tarfCd;
	private String blockNo;
	private String frItemType;
	private String locRisk1;
	private String locRisk2;
	private String locRisk3;
	private String tariffZone;
	private String typhoonZone;
	private String constructionCd;
	private String constructionRemarks;
	private String front;
	private String right;
	private String left;
	private String rear;
	private String occupancyCd;
	private String occupancyRemarks;
	private String floodZone;
	private String assignee;
	private Integer blockId;
	private String userId;
	private Date lastUpdate;
	private String riskCd;
	private Date dateFrom;
	private Date dateTo;
	
	private String dspProvince;
	private String dspCity;
	private String dspBlockNo;
	private String dspDistrictDesc;
	private String dspFrItemType;
	private String dspConstructionCd;
	private String dspOccupancyCd;
	private String dspRisk;
	private Date nbtFromDt;
	private Date nbtToDt;
	private String dspTariffZone;
	private String dspEqZone;
	private String dspTyphoonZone;
	private String dspFloodZone;
	/*Added by MarkS 02/09/2017 SR5918*/
	private String latitude; 
	private String longitude;
	 
	
	public GIPIQuoteFIItem() {
		super();
	}

	public Integer getQuoteId() {
		return quoteId;
	}

	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
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

	public String getFloodZone() {
		return floodZone;
	}

	public void setFloodZone(String floodZone) {
		this.floodZone = floodZone;
	}

	public String getAssignee() {
		return assignee;
	}

	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}

	public Integer getBlockId() {
		return blockId;
	}

	public void setBlockId(Integer blockId) {
		this.blockId = blockId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Date getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	
	public Object getStrLastUpdate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (lastUpdate != null) {
			return df.format(lastUpdate);
		} else {
			return null;
		}
	}

	public String getRiskCd() {
		return riskCd;
	}

	public void setRiskCd(String riskCd) {
		this.riskCd = riskCd;
	}

	public Date getDateFrom() {
		return dateFrom;
	}

	public void setDateFrom(Date dateFrom) {
		this.dateFrom = dateFrom;
	}
	
	public Object getStrDateFrom(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (dateFrom != null) {
			return df.format(dateFrom);
		} else {
			return null;
		}
	}

	public Date getDateTo() {
		return dateTo;
	}

	public void setDateTo(Date dateTo) {
		this.dateTo = dateTo;
	}
	
	public Object getStrDateTo(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (dateTo != null) {
			return df.format(dateTo);
		} else {
			return null;
		}
	}

	public String getDspProvince() {
		return dspProvince;
	}

	public void setDspProvince(String dspProvince) {
		this.dspProvince = dspProvince;
	}

	public String getDspCity() {
		return dspCity;
	}

	public void setDspCity(String dspCity) {
		this.dspCity = dspCity;
	}

	public String getDspBlockNo() {
		return dspBlockNo;
	}

	public void setDspBlockNo(String dspBlockNo) {
		this.dspBlockNo = dspBlockNo;
	}

	public String getDspDistrictDesc() {
		return dspDistrictDesc;
	}

	public void setDspDistrictDesc(String dspDistrictDesc) {
		this.dspDistrictDesc = dspDistrictDesc;
	}

	public String getDspFrItemType() {
		return dspFrItemType;
	}

	public void setDspFrItemType(String dspFrItemType) {
		this.dspFrItemType = dspFrItemType;
	}

	public String getDspConstructionCd() {
		return dspConstructionCd;
	}

	public void setDspConstructionCd(String dspConstructionCd) {
		this.dspConstructionCd = dspConstructionCd;
	}

	public String getDspOccupancyCd() {
		return dspOccupancyCd;
	}

	public void setDspOccupancyCd(String dspOccupancyCd) {
		this.dspOccupancyCd = dspOccupancyCd;
	}

	public String getDspRisk() {
		return dspRisk;
	}

	public void setDspRisk(String dspRisk) {
		this.dspRisk = dspRisk;
	}

	public Date getNbtFromDt() {
		return nbtFromDt;
	}

	public void setNbtFromDt(Date nbtFromDt) {
		this.nbtFromDt = nbtFromDt;
	}
	
	public Object getStrNbtFromDt(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (nbtFromDt != null) {
			return df.format(nbtFromDt);
		} else {
			return null;
		}
	}

	public Date getNbtToDt() {
		return nbtToDt;
	}

	public void setNbtToDt(Date nbtToDt) {
		this.nbtToDt = nbtToDt;
	}
	
	public Object getStrNbtToDt(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (nbtToDt != null) {
			return df.format(nbtToDt);
		} else {
			return null;
		}
	}

	public String getDspTariffZone() {
		return dspTariffZone;
	}

	public void setDspTariffZone(String dspTariffZone) {
		this.dspTariffZone = dspTariffZone;
	}

	public String getDspEqZone() {
		return dspEqZone;
	}

	public void setDspEqZone(String dspEqZone) {
		this.dspEqZone = dspEqZone;
	}

	public String getDspTyphoonZone() {
		return dspTyphoonZone;
	}

	public void setDspTyphoonZone(String dspTyphoonZone) {
		this.dspTyphoonZone = dspTyphoonZone;
	}

	public String getDspFloodZone() {
		return dspFloodZone;
	}

	public void setDspFloodZone(String dspFloodZone) {
		this.dspFloodZone = dspFloodZone;
	}
	/*Added by MarkS 02/09/2017 SR5918*/
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
	/*END SR5918*/

}
