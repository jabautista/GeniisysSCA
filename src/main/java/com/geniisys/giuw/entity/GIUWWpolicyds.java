package com.geniisys.giuw.entity;

import java.math.BigDecimal;
import java.util.List;

import com.geniisys.framework.util.BaseEntity;

public class GIUWWpolicyds extends BaseEntity{

	private Integer distNo;
	private Integer distSeqNo;
	private String distFlag;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private Integer itemGrp;
	private BigDecimal annTsiAmt;
	private String arcExtData;
	private String currencyCd;
	private String currencyDesc;
	private String nbtLineCd;
	private List<GIUWWpolicydsDtl> giuwWpolicydsDtl;
	
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
	public String getDistFlag() {
		return distFlag;
	}
	public void setDistFlag(String distFlag) {
		this.distFlag = distFlag;
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
	public Integer getItemGrp() {
		return itemGrp;
	}
	public void setItemGrp(Integer itemGrp) {
		this.itemGrp = itemGrp;
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
	public String getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(String currencyCd) {
		this.currencyCd = currencyCd;
	}
	public String getCurrencyDesc() {
		return currencyDesc;
	}
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}
	public String getNbtLineCd() {
		return nbtLineCd;
	}
	public void setNbtLineCd(String nbtLineCd) {
		this.nbtLineCd = nbtLineCd;
	}
	public List<GIUWWpolicydsDtl> getGiuwWpolicydsDtl() {
		return giuwWpolicydsDtl;
	}
	public void setGiuwWpolicydsDtl(List<GIUWWpolicydsDtl> giuwWpolicydsDtl) {
		this.giuwWpolicydsDtl = giuwWpolicydsDtl;
	}
	
}
