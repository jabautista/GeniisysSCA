package com.geniisys.common.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;

public class GIISTaxIssuePlace extends BaseEntity{
	private String lineCd;
	private String issCd;
	private Integer taxCd;
	private Integer taxId;
	private String placeCd;
	private BigDecimal rate;
	private String place;
	
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
	public String getPlaceCd() {
		return placeCd;
	}
	public void setPlaceCd(String placeCd) {
		this.placeCd = placeCd;
	}
	public BigDecimal getRate() {
		return rate;
	}
	public void setRate(BigDecimal rate) {
		this.rate = rate;
	}
	public String getPlace() {
		return place;
	}
	public void setPlace(String place) {
		this.place = place;
	}
}
