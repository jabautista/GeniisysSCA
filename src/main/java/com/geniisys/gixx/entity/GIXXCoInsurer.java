package com.geniisys.gixx.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIXXCoInsurer extends BaseEntity{

	private Integer extractId;
	private Integer coRiCd;
	private Float coRiShrPct;
	private BigDecimal coRiPremAmt;
	private BigDecimal coRiTsiAmt;
	private String riSname;
	
	
	public Integer getExtractId() {
		return extractId;
	}
	public void setExtractId(Integer extractId) {
		this.extractId = extractId;
	}
	public Integer getCoRiCd() {
		return coRiCd;
	}
	public void setCoRiCd(Integer coRiCd) {
		this.coRiCd = coRiCd;
	}
	public Float getCoRiShrPct() {
		return coRiShrPct;
	}
	public void setCoRiShrPct(Float coRiShrPct) {
		this.coRiShrPct = coRiShrPct;
	}
	public BigDecimal getCoRiPremAmt() {
		return coRiPremAmt;
	}
	public void setCoRiPremAmt(BigDecimal coRiPremAmt) {
		this.coRiPremAmt = coRiPremAmt;
	}
	public BigDecimal getCoRiTsiAmt() {
		return coRiTsiAmt;
	}
	public void setCoRiTsiAmt(BigDecimal coRiTsiAmt) {
		this.coRiTsiAmt = coRiTsiAmt;
	}
	public String getRiSname() {
		return riSname;
	}
	public void setRiSname(String riSname) {
		this.riSname = riSname;
	}
	
	
}
