package com.geniisys.giuw.entity;

import java.math.BigDecimal;
import java.util.List;

import com.geniisys.framework.util.BaseEntity;

public class GIUWPerilds extends BaseEntity {

	private Integer distNo;
	private Integer distSeqNo;
	private Integer perilCd;
	private String perilName;
	private String lineCd;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private BigDecimal annTsiAmt;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String arcExtData;
	private String currencyDesc;  //added by Halley 09.27.2013
	private List<GIUWPerildsDtl> giuwPerildsDtl;
	
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
	public String getArcExtData() {
		return arcExtData;
	}
	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}
	public List<GIUWPerildsDtl> getGiuwPerildsDtl() {
		return giuwPerildsDtl;
	}
	public void setGiuwPerildsDtl(List<GIUWPerildsDtl> giuwPerildsDtl) {
		this.giuwPerildsDtl = giuwPerildsDtl;
	}
	public String getCurrencyDesc() {
		return currencyDesc;
	}
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}
}
