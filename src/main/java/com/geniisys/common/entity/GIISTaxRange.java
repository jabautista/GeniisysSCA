package com.geniisys.common.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;

public class GIISTaxRange extends BaseEntity{
	private String lineCd;
	private String issCd;
	private Integer taxCd;
	private Integer taxId;
	private BigDecimal minValue;
	private BigDecimal maxValue;
	private BigDecimal taxAmount;
	
	private BigDecimal minMinValue;
	private BigDecimal maxMaxValue;
	private Integer recCount;;
	
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public Integer getTaxCd() {
		return taxCd;
	}
	public void setTaxCd(Integer taxCd) {
		this.taxCd = taxCd;
	}
	public Integer getTaxId() {
		return taxId;
	}
	public void setTaxId(Integer taxId) {
		this.taxId = taxId;
	}
	public BigDecimal getMinValue() {
		return minValue;
	}
	public void setMinValue(BigDecimal minValue) {
		this.minValue = minValue;
	}
	public BigDecimal getMaxValue() {
		return maxValue;
	}
	public void setMaxValue(BigDecimal maxValue) {
		this.maxValue = maxValue;
	}
	public BigDecimal getTaxAmount() {
		return taxAmount;
	}
	public void setTaxAmount(BigDecimal taxAmount) {
		this.taxAmount = taxAmount;
	}
	public BigDecimal getMinMinValue() {
		return minMinValue;
	}
	public void setMinMinValue(BigDecimal minMinValue) {
		this.minMinValue = minMinValue;
	}
	public BigDecimal getMaxMaxValue() {
		return maxMaxValue;
	}
	public void setMaxMaxValue(BigDecimal maxMaxValue) {
		this.maxMaxValue = maxMaxValue;
	}
	public Integer getRecCount() {
		return recCount;
	}
	public void setRecCount(Integer recCount) {
		this.recCount = recCount;
	}
}
