package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIItmPerilGrouped extends BaseEntity{
	private Integer policyId;
	private Integer itemNo;
	private Integer groupedItemNo;
	private String lineCd;
	private Integer perilCd;
	private String recFlag;
	private BigDecimal premRt;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private BigDecimal annTsiAmt;
	private BigDecimal annPremAmt;
	private String aggregateSw;
	private BigDecimal baseAmt;
	private BigDecimal riCommRate;
	private BigDecimal riCommAmt;
	private Integer noOfDays;
	private String arcExtData;
	private String perilName;
	private String groupedItemTitle;
	
	private String perilType;
	private BigDecimal sumTsiAmt;
	private BigDecimal sumPremAmt;
	
	public GIPIItmPerilGrouped(){
		
	}
	
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public Integer getGroupedItemNo() {
		return groupedItemNo;
	}
	public void setGroupedItemNo(Integer groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public Integer getPerilCd() {
		return perilCd;
	}
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	public String getRecFlag() {
		return recFlag;
	}
	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}
	public BigDecimal getPremRt() {
		return premRt;
	}
	public void setPremRt(BigDecimal premRt) {
		this.premRt = premRt;
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
	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}
	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}
	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}
	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}
	public String getAggregateSw() {
		return aggregateSw;
	}
	public void setAggregateSw(String aggregateSw) {
		this.aggregateSw = aggregateSw;
	}
	public BigDecimal getBaseAmt() {
		return baseAmt;
	}
	public void setBaseAmt(BigDecimal baseAmt) {
		this.baseAmt = baseAmt;
	}
	public BigDecimal getRiCommRate() {
		return riCommRate;
	}
	public void setRiCommRate(BigDecimal riCommRate) {
		this.riCommRate = riCommRate;
	}
	public BigDecimal getRiCommAmt() {
		return riCommAmt;
	}
	public void setRiCommAmt(BigDecimal riCommAmt) {
		this.riCommAmt = riCommAmt;
	}
	public Integer getNoOfDays() {
		return noOfDays;
	}
	public void setNoOfDays(Integer noOfDays) {
		this.noOfDays = noOfDays;
	}
	public String getArcExtData() {
		return arcExtData;
	}
	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}

	public String getPerilName() {
		return perilName;
	}

	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}

	public String getGroupedItemTitle() {
		return groupedItemTitle;
	}

	public void setGroupedItemTitle(String groupedItemTitle) {
		this.groupedItemTitle = groupedItemTitle;
	}

	public String getPerilType() {
		return perilType;
	}

	public void setPerilType(String perilType) {
		this.perilType = perilType;
	}

	public BigDecimal getSumTsiAmt() {
		return sumTsiAmt;
	}

	public void setSumTsiAmt(BigDecimal sumTsiAmt) {
		this.sumTsiAmt = sumTsiAmt;
	}

	public BigDecimal getSumPremAmt() {
		return sumPremAmt;
	}

	public void setSumPremAmt(BigDecimal sumPremAmt) {
		this.sumPremAmt = sumPremAmt;
	}	
	
}
