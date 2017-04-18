package com.geniisys.giis.entity;

import java.math.BigDecimal;

public class GIISDefaultDistDtl extends BaseEntity {
	
	private Integer defaultNo;
	private String lineCd;
	private Integer shareCd;
	private BigDecimal sharePct;
	private String sublineCd;
	private String issCd;
	private BigDecimal rangeTo;
	private BigDecimal rangeFrom;
	
	public GIISDefaultDistDtl(){
		
	}

	public Integer getDefaultNo() {
		return defaultNo;
	}

	public void setDefaultNo(Integer defaultNo) {
		this.defaultNo = defaultNo;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public Integer getShareCd() {
		return shareCd;
	}

	public void setShareCd(Integer shareCd) {
		this.shareCd = shareCd;
	}

	public BigDecimal getSharePct() {
		return sharePct;
	}

	public void setSharePct(BigDecimal sharePct) {
		this.sharePct = sharePct;
	}

	public String getSublineCd() {
		return sublineCd;
	}

	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public BigDecimal getRangeTo() {
		return rangeTo;
	}

	public void setRangeTo(BigDecimal rangeTo) {
		this.rangeTo = rangeTo;
	}

	public BigDecimal getRangeFrom() {
		return rangeFrom;
	}

	public void setRangeFrom(BigDecimal rangeFrom) {
		this.rangeFrom = rangeFrom;
	}
	
}
