package com.geniisys.giuw.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIUWWitemds extends BaseEntity{
	
	private Integer distNo;
	private Integer	distSeqNo;
	private Integer itemNo;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private BigDecimal annTsiAmt;
	private String arcExtData;
	private String nbtItemTitle;
	private String nbtItemDesc;
	private String dspPackLineCd;
	private String dspPackSublineCd;
	private String itemGrp;
	private String nbtCurrencyCd;
	private BigDecimal dspCurrencyRt;
	private String dspShortName;
	private String origDistSeqNo;
	
	private Integer maxDistSeqNo; // added by jhing 12.05.2014 
	private Integer cntPerDistGrp; // added by jhing 12.05.2014
	
	public Integer getDistNo() {
		return distNo;
	}
	public void setDistNo(Integer distNo) {
		this.distNo = distNo;
	}
	public Integer getDistSeqNo() {
		return distSeqNo;
	}
	public void setDistSeqNo(Integer distSeqNo) {
		this.distSeqNo = distSeqNo;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
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
	public String getArcExtData() {
		return arcExtData;
	}
	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}
	public String getNbtItemTitle() {
		return nbtItemTitle;
	}
	public void setNbtItemTitle(String nbtItemTitle) {
		this.nbtItemTitle = nbtItemTitle;
	}
	public String getNbtItemDesc() {
		return nbtItemDesc;
	}
	public void setNbtItemDesc(String nbtItemDesc) {
		this.nbtItemDesc = nbtItemDesc;
	}
	public String getDspPackLineCd() {
		return dspPackLineCd;
	}
	public void setDspPackLineCd(String dspPackLineCd) {
		this.dspPackLineCd = dspPackLineCd;
	}
	public String getDspPackSublineCd() {
		return dspPackSublineCd;
	}
	public void setDspPackSublineCd(String dspPackSublineCd) {
		this.dspPackSublineCd = dspPackSublineCd;
	}
	public String getItemGrp() {
		return itemGrp;
	}
	public void setItemGrp(String itemGrp) {
		this.itemGrp = itemGrp;
	}
	public String getNbtCurrencyCd() {
		return nbtCurrencyCd;
	}
	public void setNbtCurrencyCd(String nbtCurrencyCd) {
		this.nbtCurrencyCd = nbtCurrencyCd;
	}
	public BigDecimal getDspCurrencyRt() {
		return dspCurrencyRt;
	}
	public void setDspCurrencyRt(BigDecimal dspCurrencyRt) {
		this.dspCurrencyRt = dspCurrencyRt;
	}
	public String getDspShortName() {
		return dspShortName;
	}
	public void setDspShortName(String dspShortName) {
		this.dspShortName = dspShortName;
	}
	public String getOrigDistSeqNo() {
		return origDistSeqNo;
	}
	public void setOrigDistSeqNo(String origDistSeqNo) {
		this.origDistSeqNo = origDistSeqNo;
	}
	
	// added by jhing 12.05.2014
	public void setMaxDistSeqNo(Integer maxDistSeqNo) {
		this.maxDistSeqNo = maxDistSeqNo;
	}
	public Integer getMaxDistSeqNo() {
		return maxDistSeqNo;
	}	
	public void setCntPerDistGrp(Integer maxDistSeqNo) {
		this.cntPerDistGrp = maxDistSeqNo;
	}
	public Integer getCntPerDistGrp() {
		return cntPerDistGrp;
	}	
}
