package com.geniisys.giex.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIEXItmperilGrouped extends BaseEntity{
	
	private Integer policyId;
	private Integer itemNo;
	private Integer groupedItemNo;
	private String lineCd;
	private Integer perilCd;
	private String recFlag;
	private BigDecimal premRt;
	private BigDecimal premAmt;
	private BigDecimal tsiAmt;
	private BigDecimal annTsiAmt;
	private BigDecimal annPremAmt;
	private String aggregateSw;
	private BigDecimal baseAmt;
	private BigDecimal riCommRate;
	private BigDecimal riCommAmt;
	private Integer noOfDays;
	
	private BigDecimal nbtPremAmt;
	private BigDecimal nbtTsiAmt;
	private String nbtItemTitle;
	private String nbtGroupedItemTitle;
	private String dspPerilName;
	private String dspPerilType;
	private Integer dspBascPerlCd; 
	
	public GIEXItmperilGrouped() {
		super();
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

	public BigDecimal getPremAmt() {
		return premAmt;
	}

	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}

	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}

	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
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

	public BigDecimal getNbtPremAmt() {
		return nbtPremAmt;
	}

	public void setNbtPremAmt(BigDecimal nbtPremAmt) {
		this.nbtPremAmt = nbtPremAmt;
	}

	public BigDecimal getNbtTsiAmt() {
		return nbtTsiAmt;
	}

	public void setNbtTsiAmt(BigDecimal nbtTsiAmt) {
		this.nbtTsiAmt = nbtTsiAmt;
	}

	public String getNbtItemTitle() {
		return nbtItemTitle;
	}

	public void setNbtItemTitle(String nbtItemTitle) {
		this.nbtItemTitle = nbtItemTitle;
	}

	public String getNbtGroupedItemTitle() {
		return nbtGroupedItemTitle;
	}

	public void setNbtGroupedItemTitle(String nbtGroupedItemTitle) {
		this.nbtGroupedItemTitle = nbtGroupedItemTitle;
	}

	public String getDspPerilName() {
		return dspPerilName;
	}

	public void setDspPerilName(String dspPerilName) {
		this.dspPerilName = dspPerilName;
	}

	public String getDspPerilType() {
		return dspPerilType;
	}

	public void setDspPerilType(String dspPerilType) {
		this.dspPerilType = dspPerilType;
	}

	public Integer getDspBascPerlCd() {
		return dspBascPerlCd;
	}

	public void setDspBascPerlCd(Integer dspBascPerlCd) {
		this.dspBascPerlCd = dspBascPerlCd;
	}
	
}
