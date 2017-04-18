package com.geniisys.gixx.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIXXOrigItmPeril extends BaseEntity{

	private Integer extractId;
	private Integer itemNo;
	private BigDecimal annTsiAmt;
	private BigDecimal annPremAmt;
	private String compRem;
	private BigDecimal riCommAmt;
	private Float riCommRate;
	private String lineCd;
	private String recFlag;
	
	private Integer yourPerilCode;
	private BigDecimal yourTsiAmt;
	private BigDecimal yourPremAmt;
	private Float yourPremRt;
	private String yourDiscountSw;
	
	private Integer fullPerilCode;
	private BigDecimal fullTsiAmt;
	private BigDecimal fullPremAmt;
	private Float fullPremRt;
	private String fullDiscountSw;
	
	private BigDecimal dspFullPremAmt;
	private BigDecimal dspFullTsiAmt;
	private String perilDesc;
	
	
	public Integer getExtractId() {
		return extractId;
	}
	public void setExtractId(Integer extractId) {
		this.extractId = extractId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
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
	public String getCompRem() {
		return compRem;
	}
	public void setCompRem(String compRem) {
		this.compRem = compRem;
	}
	public BigDecimal getRiCommAmt() {
		return riCommAmt;
	}
	public void setRiCommAmt(BigDecimal riCommAmt) {
		this.riCommAmt = riCommAmt;
	}
	public Float getRiCommRate() {
		return riCommRate;
	}
	public void setRiCommRate(Float riCommRate) {
		this.riCommRate = riCommRate;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getRecFlag() {
		return recFlag;
	}
	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}
	public Integer getYourPerilCode() {
		return yourPerilCode;
	}
	public void setYourPerilCode(Integer yourPerilCode) {
		this.yourPerilCode = yourPerilCode;
	}
	public BigDecimal getYourTsiAmt() {
		return yourTsiAmt;
	}
	public void setYourTsiAmt(BigDecimal yourTsiAmt) {
		this.yourTsiAmt = yourTsiAmt;
	}
	public BigDecimal getYourPremAmt() {
		return yourPremAmt;
	}
	public void setYourPremAmt(BigDecimal yourPremAmt) {
		this.yourPremAmt = yourPremAmt;
	}
	public Float getYourPremRt() {
		return yourPremRt;
	}
	public void setYourPremRt(Float yourPremRt) {
		this.yourPremRt = yourPremRt;
	}
	public String getYourDiscountSw() {
		return yourDiscountSw;
	}
	public void setYourDiscountSw(String yourDiscountSw) {
		this.yourDiscountSw = yourDiscountSw;
	}
	public Integer getFullPerilCode() {
		return fullPerilCode;
	}
	public void setFullPerilCode(Integer fullPerilCode) {
		this.fullPerilCode = fullPerilCode;
	}
	public BigDecimal getFullTsiAmt() {
		return fullTsiAmt;
	}
	public void setFullTsiAmt(BigDecimal fullTsiAmt) {
		this.fullTsiAmt = fullTsiAmt;
	}
	public BigDecimal getFullPremAmt() {
		return fullPremAmt;
	}
	public void setFullPremAmt(BigDecimal fullPremAmt) {
		this.fullPremAmt = fullPremAmt;
	}
	public Float getFullPremRt() {
		return fullPremRt;
	}
	public void setFullPremRt(Float fullPremRt) {
		this.fullPremRt = fullPremRt;
	}
	public String getFullDiscountSw() {
		return fullDiscountSw;
	}
	public void setFullDiscountSw(String fullDiscountSw) {
		this.fullDiscountSw = fullDiscountSw;
	}
	public BigDecimal getDspFullPremAmt() {
		return dspFullPremAmt;
	}
	public void setDspFullPremAmt(BigDecimal dspFullPremAmt) {
		this.dspFullPremAmt = dspFullPremAmt;
	}
	public BigDecimal getDspFullTsiAmt() {
		return dspFullTsiAmt;
	}
	public void setDspFullTsiAmt(BigDecimal dspFullTsiAmt) {
		this.dspFullTsiAmt = dspFullTsiAmt;
	}
	public String getPerilDesc() {
		return perilDesc;
	}
	public void setPerilDesc(String perilDesc) {
		this.perilDesc = perilDesc;
	}
	
	
	
}
