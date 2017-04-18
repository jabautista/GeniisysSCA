package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;



public class GICLMcPartCost extends BaseEntity {
	
	private Integer partCostId;
	private String modelYear;
	private Integer carCompanyCd;
	private Integer makeCd;
	private String lossExpCd;
	private BigDecimal origAmt;
	private BigDecimal surpAmt;
	private String remarks;
	
	public Integer getPartCostId() {
		return partCostId;
	}
	public void setPartCostId(Integer partCostId) {
		this.partCostId = partCostId;
	}
	public String getModelYear() {
		return modelYear;
	}
	public void setModelYear(String modelYear) {
		this.modelYear = modelYear;
	}
	public Integer getCarCompanyCd() {
		return carCompanyCd;
	}
	public void setCarCompanyCd(Integer carCompanyCd) {
		this.carCompanyCd = carCompanyCd;
	}
	public Integer getMakeCd() {
		return makeCd;
	}
	public void setMakeCd(Integer makeCd) {
		this.makeCd = makeCd;
	}
	public String getLossExpCd() {
		return lossExpCd;
	}
	public void setLossExpCd(String lossExpCd) {
		this.lossExpCd = lossExpCd;
	}
	public BigDecimal getOrigAmt() {
		return origAmt;
	}
	public void setOrigAmt(BigDecimal origAmt) {
		this.origAmt = origAmt;
	}
	public BigDecimal getSurpAmt() {
		return surpAmt;
	}
	public void setSurpAmt(BigDecimal surpAmt) {
		this.surpAmt = surpAmt;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
}
