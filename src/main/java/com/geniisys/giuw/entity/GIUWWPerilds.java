package com.geniisys.giuw.entity;

import java.math.BigDecimal;
import java.util.List;

import com.geniisys.framework.util.BaseEntity;

public class GIUWWPerilds extends BaseEntity{
	
	private Integer distNo;
	private Integer distSeqNo;
	private Integer perilCd;
	private String perilName;
	private String lineCd;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private BigDecimal annTsiAmt;
	private String distFlag;
	private String arcExtData;
	private String currencyDesc;
	private List<GIUWWPerildsDtl> giuwWPerildsDtl; 
	
	private Integer itemGrp;
	private Integer currencyCd;
	private BigDecimal currencyRt;
	private String currencyShrtName;
	private String packLineCd;
	private String packSublineCd;
	private Integer origDistSeqNo;
	private String origPerilCd;
	private String perilType;
	private Integer bascPerlCd;

	private Integer maxDistSeqNo;
	private Integer cntPerDistGrp; // added by jhing 12.11.2014	

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
	public Integer getPerilCd() {
		return perilCd;
	}
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}	
	public String getPerilName() {
		return perilName;
	}
	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
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
	public String getDistFlag() {
		return distFlag;
	}
	public void setDistFlag(String distFlag) {
		this.distFlag = distFlag;
	}
	public String getArcExtData() {
		return arcExtData;
	}
	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}		
	public String getCurrencyDesc() {
		return currencyDesc;
	}
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}
	public List<GIUWWPerildsDtl> getGiuwWPerildsDtl() {
		return giuwWPerildsDtl;
	}
	public void setGiuwWPerildsDtl(List<GIUWWPerildsDtl> giuwWPerildsDtl) {
		this.giuwWPerildsDtl = giuwWPerildsDtl;
	}
	public Integer getItemGrp() {
		return itemGrp;
	}
	public void setItemGrp(Integer itemGrp) {
		this.itemGrp = itemGrp;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}
	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}
	public String getCurrencyShrtName() {
		return currencyShrtName;
	}
	public void setCurrencyShrtName(String currencyShrtName) {
		this.currencyShrtName = currencyShrtName;
	}
	public String getPackLineCd() {
		return packLineCd;
	}
	public void setPackLineCd(String packLineCd) {
		this.packLineCd = packLineCd;
	}
	public String getPackSublineCd() {
		return packSublineCd;
	}
	public void setPackSublineCd(String packSublineCd) {
		this.packSublineCd = packSublineCd;
	}
	public void setOrigDistSeqNo(Integer origDistSeqNo) {
		this.origDistSeqNo = origDistSeqNo;
	}
	public Integer getOrigDistSeqNo() {
		return origDistSeqNo;
	}
	public void setOrigPerilCd(String origPerilCd) {
		this.origPerilCd = origPerilCd;
	}
	public String getOrigPerilCd() {
		return origPerilCd;
	}
	public void setPerilType(String perilType) {
		this.perilType = perilType;
	}
	public String getPerilType() {
		return perilType;
	}	
	public Integer getBascPerlCd() {
		return bascPerlCd;
	}
	public void setBascPerlCd(Integer bascPerlCd) {
		this.bascPerlCd = bascPerlCd;
	}
	public void setMaxDistSeqNo(Integer maxDistSeqNo) {
		this.maxDistSeqNo = maxDistSeqNo;
	}
	public Integer getMaxDistSeqNo() {
		return maxDistSeqNo;
	}
	// added by jhing 12.11.2014
	public void setCntPerDistGrp(Integer maxDistSeqNo) {
		this.cntPerDistGrp = maxDistSeqNo;
	}
	public Integer getCntPerDistGrp() {
		return cntPerDistGrp;
	}		
}
