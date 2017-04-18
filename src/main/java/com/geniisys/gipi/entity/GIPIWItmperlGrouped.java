package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWItmperlGrouped extends BaseEntity{

	private Integer parId;
	private Integer itemNo;
	private Integer groupedItemNo;
	private String lineCd;
	private String perilCd;
	private String recFlag;
	private String noOfDays;
	private String premRt;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private BigDecimal annTsiAmt;
	private BigDecimal annPremAmt;
	private BigDecimal origAnnPremAmt; //benjo 12.16.2015 UCPBGEN-SR-20835
	private String aggregateSw;
	private BigDecimal baseAmt;
	private BigDecimal riCommRate;
	private BigDecimal riCommAmt;
	private String perilName;
	private String groupedItemTitle;
	private String wcSw;
	private String perilType;
	private Integer bascPerlCd;
	
	public GIPIWItmperlGrouped(){
		
	}
	
	public GIPIWItmperlGrouped(final Integer parId, final Integer itemNo,
			final Integer groupedItemNo, final String lineCd, final String perilCd,
			final String recFlag, final String noOfDays, final String premRt,
			final BigDecimal tsiAmt, final BigDecimal premAmt, final BigDecimal annTsiAmt,
			final BigDecimal annPremAmt, final String aggregateSw, final BigDecimal baseAmt,
			final BigDecimal riCommRate, final BigDecimal riCommAmt,
			final String wcSw){
		this.parId = parId;
		this.itemNo = itemNo;
		this.groupedItemNo = groupedItemNo;
		this.lineCd = lineCd;
		this.perilCd = perilCd;
		this.recFlag = recFlag;
		this.noOfDays = noOfDays;
		this.premRt = premRt;
		this.tsiAmt = tsiAmt;
		this.premAmt = premAmt;
		this.annTsiAmt = annTsiAmt;
		this.annPremAmt = annPremAmt;
		this.aggregateSw = aggregateSw;
		this.baseAmt = baseAmt;
		this.riCommRate = riCommRate;
		this.riCommAmt = riCommAmt;
		this.wcSw = wcSw;
	}

	public Integer getParId() {
		return parId;
	}

	public void setParId(Integer parId) {
		this.parId = parId;
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

	public String getPerilCd() {
		return perilCd;
	}

	public void setPerilCd(String perilCd) {
		this.perilCd = perilCd;
	}

	public String getRecFlag() {
		return recFlag;
	}

	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}

	public String getNoOfDays() {
		return noOfDays;
	}

	public void setNoOfDays(String noOfDays) {
		this.noOfDays = noOfDays;
	}

	public String getPremRt() {
		return premRt;
	}

	public void setPremRt(String premRt) {
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

	public String getWcSw() {
		return wcSw;
	}

	public void setWcSw(String wcSw) {
		this.wcSw = wcSw;
	}

	public String getPerilType() {
		return perilType;
	}

	public void setPerilType(String perilType) {
		this.perilType = perilType;
	}

	public Integer getBascPerlCd() {
		return bascPerlCd;
	}

	public void setBascPerlCd(Integer bascPerlCd) {
		this.bascPerlCd = bascPerlCd;
	}

	/*benjo 12.16.2015 UCPBGEN-SR-20835*/
	public BigDecimal getOrigAnnPremAmt() {
		return origAnnPremAmt;
	}

	public void setOrigAnnPremAmt(BigDecimal origAnnPremAmt) {
		this.origAnnPremAmt = origAnnPremAmt;
	}
	/*benjo end*/
}
