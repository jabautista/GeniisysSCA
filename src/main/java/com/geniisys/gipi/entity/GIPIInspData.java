package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIInspData extends BaseEntity{

	private int inspNo;
	private String inspName;
	private int itemNo;
	private String itemDesc;
	private String blockId;
	private String assdNo;
	private String assdName;
	private String locRisk1;
	private String locRisk2;
	private String locRisk3;
	private String occupancyCd;
	private String occupancyRemarks;
	private String constructionCd;
	private String constructionRemarks;
	private String front;
	private String left;
	private String right;
	private String rear;
	private String wcCd;
	private String tarfCd;
	private String tariffZone;
	private String eqZone;
	private String floodZone;
	private String typhoonZone;
	private BigDecimal premRate;
	private BigDecimal tsiAmt;
	private int intmNo;
	private String intmName;
	private int inspCd;
	private Date dateInsp;
	private String approvedBy;
	private Date dateApproved;
	private String parId;
	private String quoteId;
	private String itemTitle;
	private String status;
	private String itemGrp;
	private String remarks;
	private String arcExtData;
	private String blockNo;
	private String districtNo;
	private String city;
	private String province;
	private String provinceCd;
	private String cityCd;
	private String riskGrade;
	private String perilOption1;
	private BigDecimal perilOption1BldgRate;
	private BigDecimal perilOption1ContRate;
	private String perilOption2;
	private BigDecimal perilOption2BldgRate;
	private BigDecimal perilOption2ContRate;
	private String districtDesc;
	private String blockDesc;
	/*Added by MarkS 02/09/2017 SR5919 */
	private String latitude;
	private String longitude;
	/* end SR5919*/
	
	
	public GIPIInspData() {
		
	}
	
	public GIPIInspData(int inspNo, String inspName, int itemNo,
			String itemDesc, String blockId, String assdNo, String assdName,
			String locRisk1, String locRisk2, String locRisk3,
			String occupancyCd, String occupancyRemarks, String constructionCd,
			String constructionRemarks, String front, String left,
			String right, String rear, String wcCd, String tarfCd,
			String tariffZone, String eqZone, String floodZone,
			String typhoonZone, BigDecimal premRate, BigDecimal tsiAmt,
			int intmNo, String intmName, int inspCd, Date dateInsp,
			String approvedBy, Date dateApproved, String parId, String quoteId,
			String itemTitle, String status, String itemGrp, String remarks,
			String arcExtData, String blockNo, String districtNo, String city,
			String province, String provinceCd, String cityCd, String riskGrade,
			String perilOption1, BigDecimal perilOption1BldgRate,
			BigDecimal perilOption1ContRate, String perilOption2,
			BigDecimal perilOption2BldgRate, BigDecimal perilOption2ContRate) {
		this.inspNo = inspNo;
		this.inspName = inspName;
		this.itemNo = itemNo;
		this.itemDesc = itemDesc;
		this.blockId = blockId;
		this.assdNo = assdNo;
		this.assdName = assdName;
		this.locRisk1 = locRisk1;
		this.locRisk2 = locRisk2;
		this.locRisk3 = locRisk3;
		this.occupancyCd = occupancyCd;
		this.occupancyRemarks = occupancyRemarks;
		this.constructionCd = constructionCd;
		this.constructionRemarks = constructionRemarks;
		this.front = front;
		this.left = left;
		this.right = right;
		this.rear = rear;
		this.wcCd = wcCd;
		this.tarfCd = tarfCd;
		this.tariffZone = tariffZone;
		this.eqZone = eqZone;
		this.floodZone = floodZone;
		this.typhoonZone = typhoonZone;
		this.premRate = premRate;
		this.tsiAmt = tsiAmt;
		this.intmNo = intmNo;
		this.intmName = intmName;
		this.inspCd = inspCd;
		this.dateInsp = dateInsp;
		this.approvedBy = approvedBy;
		this.dateApproved = dateApproved;
		this.parId = parId;
		this.quoteId = quoteId;
		this.itemTitle = itemTitle;
		this.status = status;
		this.itemGrp = itemGrp;
		this.remarks = remarks;
		this.arcExtData = arcExtData;
		this.blockNo = blockNo;
		this.districtNo = districtNo;
		this.city = city;
		this.province = province;
		this.provinceCd = provinceCd;
		this.cityCd = cityCd;
		this.riskGrade = riskGrade;
		this.perilOption1 = perilOption1;
		this.perilOption1BldgRate = perilOption1BldgRate;
		this.perilOption1ContRate = perilOption1ContRate;
		this.perilOption2 = perilOption2;
		this.perilOption2BldgRate = perilOption2BldgRate;
		this.perilOption2ContRate = perilOption2ContRate;
	}

	public String getDistrictDesc() {
		return districtDesc;
	}

	public void setDistrictDesc(String districtDesc) {
		this.districtDesc = districtDesc;
	}

	public String getBlockDesc() {
		return blockDesc;
	}

	public void setBlockDesc(String blockDesc) {
		this.blockDesc = blockDesc;
	}

	public int getInspNo() {
		return inspNo;
	}

	public void setInspNo(int inspNo) {
		this.inspNo = inspNo;
	}
	
	public String getInspName() {
		return inspName;
	}

	public void setInspName(String inspName) {
		this.inspName = inspName;
	}

	public String getIntmName() {
		return intmName;
	}

	public void setIntmName(String intmName) {
		this.intmName = intmName;
	}

	public Object getStrDateInsp() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (dateInsp != null) {
			return df.format(dateInsp);			
		} else {
			return null;
		}
	}
	
	public Date getDateInsp() {
		return dateInsp;
	}

	public void setDateInsp(Date dateInsp) {
		this.dateInsp = dateInsp;
	}

	public int getItemNo() {
		return itemNo;
	}

	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}

	public String getItemDesc() {
		return itemDesc;
	}

	public void setItemDesc(String itemDesc) {
		this.itemDesc = itemDesc;
	}

	public String getBlockId() {
		return blockId;
	}

	public void setBlockId(String blockId) {
		this.blockId = blockId;
	}

	public String getAssdNo() {
		return assdNo;
	}

	public void setAssdNo(String assdNo) {
		this.assdNo = assdNo;
	}

	public String getAssdName() {
		return assdName;
	}

	public void setAssdName(String assdName) {
		this.assdName = assdName;
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

	public String getLeft() {
		return left;
	}

	public void setLeft(String left) {
		this.left = left;
	}

	public String getRight() {
		return right;
	}

	public void setRight(String right) {
		this.right = right;
	}

	public String getRear() {
		return rear;
	}

	public void setRear(String rear) {
		this.rear = rear;
	}

	public String getWcCd() {
		return wcCd;
	}

	public void setWcCd(String wcCd) {
		this.wcCd = wcCd;
	}

	public String getTarfCd() {
		return tarfCd;
	}

	public void setTarfCd(String tarfCd) {
		this.tarfCd = tarfCd;
	}

	public String getTariffZone() {
		return tariffZone;
	}

	public void setTariffZone(String tariffZone) {
		this.tariffZone = tariffZone;
	}

	public String getEqZone() {
		return eqZone;
	}

	public void setEqZone(String eqZone) {
		this.eqZone = eqZone;
	}

	public String getFloodZone() {
		return floodZone;
	}

	public void setFloodZone(String floodZone) {
		this.floodZone = floodZone;
	}

	public String getTyphoonZone() {
		return typhoonZone;
	}

	public void setTyphoonZone(String typhoonZone) {
		this.typhoonZone = typhoonZone;
	}

	public BigDecimal getPremRate() {
		return premRate;
	}

	public void setPremRate(BigDecimal premRate) {
		this.premRate = premRate;
	}

	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}

	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}

	public int getIntmNo() {
		return intmNo;
	}

	public void setIntmNo(int intmNo) {
		this.intmNo = intmNo;
	}

	public int getInspCd() {
		return inspCd;
	}

	public void setInspCd(int inspCd) {
		this.inspCd = inspCd;
	}

	public String getApprovedBy() {
		return approvedBy;
	}

	public void setApprovedBy(String approvedBy) {
		this.approvedBy = approvedBy;
	}

	public Object getStrDateApproved() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (dateApproved != null) {
			return df.format(dateApproved);			
		} else {
			return null;
		}
	}
	
	public Date getDateApproved() {
		return dateApproved;
	}

	public void setDateApproved(Date dateApproved) {
		this.dateApproved = dateApproved;
	}

	public String getParId() {
		return parId;
	}

	public void setParId(String parId) {
		this.parId = parId;
	}

	public String getQuoteId() {
		return quoteId;
	}

	public void setQuoteId(String quoteId) {
		this.quoteId = quoteId;
	}

	public String getItemTitle() {
		return itemTitle;
	}

	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getItemGrp() {
		return itemGrp;
	}

	public void setItemGrp(String itemGrp) {
		this.itemGrp = itemGrp;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getArcExtData() {
		return arcExtData;
	}

	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}

	public String getBlockNo() {
		return blockNo;
	}

	public void setBlockNo(String blockNo) {
		this.blockNo = blockNo;
	}

	public String getDistrictNo() {
		return districtNo;
	}

	public void setDistrictNo(String districtNo) {
		this.districtNo = districtNo;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getProvince() {
		return province;
	}

	public void setProvince(String province) {
		this.province = province;
	}

	public String getProvinceCd() {
		return provinceCd;
	}

	public void setProvinceCd(String provinceCd) {
		this.provinceCd = provinceCd;
	}

	public String getCityCd() {
		return cityCd;
	}

	public void setCityCd(String cityCd) {
		this.cityCd = cityCd;
	}

	public String getRiskGrade() {
		return riskGrade;
	}

	public void setRiskGrade(String riskGrade) {
		this.riskGrade = riskGrade;
	}

	public String getPerilOption1() {
		return perilOption1;
	}

	public void setPerilOption1(String perilOption1) {
		this.perilOption1 = perilOption1;
	}

	public BigDecimal getPerilOption1BldgRate() {
		return perilOption1BldgRate;
	}

	public void setPerilOption1BldgRate(BigDecimal perilOption1BldgRate) {
		this.perilOption1BldgRate = perilOption1BldgRate;
	}

	public BigDecimal getPerilOption1ContRate() {
		return perilOption1ContRate;
	}

	public void setPerilOption1ContRate(BigDecimal perilOption1ContRate) {
		this.perilOption1ContRate = perilOption1ContRate;
	}

	public String getPerilOption2() {
		return perilOption2;
	}

	public void setPerilOption2(String perilOption2) {
		this.perilOption2 = perilOption2;
	}

	public BigDecimal getPerilOption2BldgRate() {
		return perilOption2BldgRate;
	}

	public void setPerilOption2BldgRate(BigDecimal perilOption2BldgRate) {
		this.perilOption2BldgRate = perilOption2BldgRate;
	}

	public BigDecimal getPerilOption2ContRate() {
		return perilOption2ContRate;
	}

	public void setPerilOption2ContRate(BigDecimal perilOption2ContRate) {
		this.perilOption2ContRate = perilOption2ContRate;
	}
/*Added by MarkS 02/09/2017 SR5919*/
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
 /* end SR5919*/
	
	
}
