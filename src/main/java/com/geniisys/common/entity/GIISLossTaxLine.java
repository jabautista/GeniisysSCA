package com.geniisys.common.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIISLossTaxLine extends BaseEntity {
	private Integer lossTaxId;
	private String lineCd;
	private String lossExpCd;
	private BigDecimal taxRate;
	private String lossExpType;
	
	public GIISLossTaxLine(Integer lossTaxId, String lineCd, String lossExpCd,
			BigDecimal taxRate, String lossExpType) {
		super();
		this.lossTaxId = lossTaxId;
		this.lineCd = lineCd;
		this.lossExpCd = lossExpCd;
		this.taxRate = taxRate;
		this.lossExpType = lossExpType;
	}
	
	public GIISLossTaxLine() {
		
	}

	public Integer getLossTaxId() {
		return lossTaxId;
	}

	public void setLossTaxId(Integer lossTaxId) {
		this.lossTaxId = lossTaxId;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getLossExpCd() {
		return lossExpCd;
	}

	public void setLossExpCd(String lossExpCd) {
		this.lossExpCd = lossExpCd;
	}

	public BigDecimal getTaxRate() {
		return taxRate;
	}

	public void setTaxRate(BigDecimal taxRate) {
		this.taxRate = taxRate;
	}

	public String getLossExpType() {
		return lossExpType;
	}

	public void setLossExpType(String lossExpType) {
		this.lossExpType = lossExpType;
	}

	
}
