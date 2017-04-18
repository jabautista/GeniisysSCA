package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIItmperilBeneficiary extends BaseEntity{


	private Integer policyId;		
	private Integer itemNo;		
	private Integer groupedItemNo;		
	private Integer beneficiaryNo;		
	private String lineCd;		
	private Integer perilCd;		
	private String recFlag;
	private BigDecimal premRt;		
	private BigDecimal tsiAmt;		
	private BigDecimal premAmt;		
	private BigDecimal annTsiAmt;		
	private BigDecimal annPremAmt;		
	private String arcExtData;
	
	private String perilName;
	
	public GIPIItmperilBeneficiary() {
		super();
	}
	
	public GIPIItmperilBeneficiary(Integer policyId, Integer itemNo,
			Integer groupedItemNo, Integer beneficiaryNo, String lineCd,
			Integer perilCd, String recFlag, BigDecimal premRt,
			BigDecimal tsiAmt, BigDecimal premAmt, BigDecimal annTsiAmt,
			BigDecimal annPremAmt, String arcExtData) {
		super();
		this.policyId = policyId;
		this.itemNo = itemNo;
		this.groupedItemNo = groupedItemNo;
		this.beneficiaryNo = beneficiaryNo;
		this.lineCd = lineCd;
		this.perilCd = perilCd;
		this.recFlag = recFlag;
		this.premRt = premRt;
		this.tsiAmt = tsiAmt;
		this.premAmt = premAmt;
		this.annTsiAmt = annTsiAmt;
		this.annPremAmt = annPremAmt;
		this.arcExtData = arcExtData;
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
	public Integer getBeneficiaryNo() {
		return beneficiaryNo;
	}
	public void setBeneficiaryNo(Integer beneficiaryNo) {
		this.beneficiaryNo = beneficiaryNo;
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
	

}
