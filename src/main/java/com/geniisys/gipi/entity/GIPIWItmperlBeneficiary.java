package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWItmperlBeneficiary extends BaseEntity{

	private Integer parId;
	private Integer itemNo;
	private String groupedItemNo;
	private String beneficiaryNo;
	private String lineCd;
	private String perilCd;
	private String recFlag;
	private BigDecimal premRt;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private BigDecimal annTsiAmt;
	private BigDecimal annPremAmt;
	private String perilName;
	
	public GIPIWItmperlBeneficiary(){
		
	}

	public GIPIWItmperlBeneficiary(final Integer parId, final Integer itemNo,
			final String groupeditemNo, final String beneficiaryNo, final String lineCd,
			final String perilCd, final String recFlag, final BigDecimal premRt,
			final BigDecimal tsiAmt, final BigDecimal premAmt, final BigDecimal annTsiAmt,
			final BigDecimal annPremAmt){
		this.parId = parId;
		this.itemNo = itemNo;
		this.groupedItemNo = groupeditemNo;
		this.beneficiaryNo = beneficiaryNo;
		this.lineCd = lineCd;
		this.recFlag = recFlag;
		this.perilCd = perilCd;
		this.premRt = premRt;
		this.tsiAmt = tsiAmt;
		this.premAmt = premAmt;
		this.annTsiAmt = annTsiAmt;
		this.annPremAmt = annPremAmt;
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
	public String getGroupedItemNo() {
		return groupedItemNo;
	}
	public void setGroupedItemNo(String groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}
	public String getBeneficiaryNo() {
		return beneficiaryNo;
	}
	public void setBeneficiaryNo(String beneficiaryNo) {
		this.beneficiaryNo = beneficiaryNo;
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
	public String getPerilName() {
		return perilName;
	}
	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}
	
}
