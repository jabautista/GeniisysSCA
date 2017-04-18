package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;

public class GICLLossProfile extends BaseEntity {

	private String lineCd;
	private String sublineCd;
	private BigDecimal rangeFrom;
	private BigDecimal rangeTo;
	private String dateFrom;
	private String dateTo;
	private String lossDateFrom;
	private String lossDateTo;
	
	private String type;
	private BigDecimal oldFrom;
	private BigDecimal oldTo;
	
	public String getLineCd() {
		return lineCd;
	}
	
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	
	public String getSublineCd() {
		return sublineCd;
	}
	
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	
	public BigDecimal getRangeFrom() {
		return rangeFrom;
	}
	
	public void setRangeFrom(BigDecimal rangeFrom) {
		this.rangeFrom = rangeFrom;
	}
	
	public BigDecimal getRangeTo() {
		return rangeTo;
	}
	
	public void setRangeTo(BigDecimal rangeTo) {
		this.rangeTo = rangeTo;
	}

	public String getDateFrom() {
		return dateFrom;
	}

	public void setDateFrom(String dateFrom) {
		this.dateFrom = dateFrom;
	}

	public String getDateTo() {
		return dateTo;
	}

	public void setDateTo(String dateTo) {
		this.dateTo = dateTo;
	}

	public String getLossDateFrom() {
		return lossDateFrom;
	}

	public void setLossDateFrom(String lossDateFrom) {
		this.lossDateFrom = lossDateFrom;
	}

	public String getLossDateTo() {
		return lossDateTo;
	}

	public void setLossDateTo(String lossDateTo) {
		this.lossDateTo = lossDateTo;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public BigDecimal getOldFrom() {
		return oldFrom;
	}

	public void setOldFrom(BigDecimal oldFrom) {
		this.oldFrom = oldFrom;
	}

	public BigDecimal getOldTo() {
		return oldTo;
	}

	public void setOldTo(BigDecimal oldTo) {
		this.oldTo = oldTo;
	}
	
}
