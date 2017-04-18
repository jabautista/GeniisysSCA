package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLFireDtl extends BaseEntity{

	private Integer claimId;
	private Integer itemNo;
	private Integer currencyCd;
	private String itemTitle;
	private String districtNo;
	private String eqZone;
	private String tarfCd;
	private String blockNo;
	private Integer blockId;
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
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private Date lossDate;
	private BigDecimal currencyRate;
	private String riskCd;
	
	private String riskDesc;
	private String itemDesc;
	private String itemDesc2;
	private String dspItemType;
	private String dspEqZone;
	private String dspTariffZone;
	private String dspTyphoon;
	private String dspConstruction;
	private String dspOccupancy;
	private String dspFloodZone;
	private String dspCurrencyDesc;
	private String giclItemPerilExist;
	private String giclMortgageeExist;
	private String giclItemPerilMsg;
	private String msgAlert;
	private String locRisk;
	private BigDecimal annTsiAmt;
	
	// shan 04.15.2014
	private String lossDateChar;
	
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public String getItemTitle() {
		return itemTitle;
	}
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
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
	public Integer getBlockId() {
		return blockId;
	}
	public void setBlockId(Integer blockId) {
		this.blockId = blockId;
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
	public Date getLossDate() {
		return lossDate;
	}
	public void setLossDate(Date lossDate) {
		this.lossDate = lossDate;
	}
	public BigDecimal getCurrencyRate() {
		return currencyRate;
	}
	public void setCurrencyRate(BigDecimal currencyRate) {
		this.currencyRate = currencyRate;
	}
	public String getRiskCd() {
		return riskCd;
	}
	public void setRiskCd(String riskCd) {
		this.riskCd = riskCd;
	}
	public String getRiskDesc() {
		return riskDesc;
	}
	public void setRiskDesc(String riskDesc) {
		this.riskDesc = riskDesc;
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
	public String getDspItemType() {
		return dspItemType;
	}
	public void setDspItemType(String dspItemType) {
		this.dspItemType = dspItemType;
	}
	public String getDspEqZone() {
		return dspEqZone;
	}
	public void setDspEqZone(String dspEqZone) {
		this.dspEqZone = dspEqZone;
	}
	public String getDspTariffZone() {
		return dspTariffZone;
	}
	public void setDspTariffZone(String dspTariffZone) {
		this.dspTariffZone = dspTariffZone;
	}
	public String getDspTyphoon() {
		return dspTyphoon;
	}
	public void setDspTyphoon(String dspTyphoon) {
		this.dspTyphoon = dspTyphoon;
	}
	public String getDspConstruction() {
		return dspConstruction;
	}
	public void setDspConstruction(String dspConstruction) {
		this.dspConstruction = dspConstruction;
	}
	public String getDspOccupancy() {
		return dspOccupancy;
	}
	public void setDspOccupancy(String dspOccupancy) {
		this.dspOccupancy = dspOccupancy;
	}
	public String getDspFloodZone() {
		return dspFloodZone;
	}
	public void setDspFloodZone(String dspFloodZone) {
		this.dspFloodZone = dspFloodZone;
	}
	public String getDspCurrencyDesc() {
		return dspCurrencyDesc;
	}
	public void setDspCurrencyDesc(String dspCurrencyDesc) {
		this.dspCurrencyDesc = dspCurrencyDesc;
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
	public String getLocRisk() {
		return locRisk;
	}
	public void setLocRisk(String locRisk) {
		this.locRisk = locRisk;
	}
	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}
	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}
	public String getMsgAlert() {
		return msgAlert;
	}
	public void setMsgAlert(String msgAlert) {
		this.msgAlert = msgAlert;
	}
	public String getLossDateChar() {
		return lossDateChar;
	}
	public void setLossDateChar(String lossDateChar) {
		this.lossDateChar = lossDateChar;
	}
}
