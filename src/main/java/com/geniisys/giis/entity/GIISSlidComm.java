package com.geniisys.giis.entity;

import java.math.BigDecimal;

public class GIISSlidComm extends BaseEntity{

	private String lineCd;
	private String sublineCd;
	private Integer perilCd;
	private Double loPremLim;
	private Double hiPremLim;
	private Double slidCommRt;
	private String remarks;
	private BigDecimal oldLoPremLim;
	private BigDecimal oldHiPremLim;
	
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
	
	public Integer getPerilCd() {
		return perilCd;
	}
	
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	
	public Double getLoPremLim() {
		return loPremLim;
	}
	
	public void setLoPremLim(Double loPremLim) {
		this.loPremLim = loPremLim;
	}
	
	public Double getHiPremLim() {
		return hiPremLim;
	}
	
	public void setHiPremLim(Double hiPremLim) {
		this.hiPremLim = hiPremLim;
	}
	
	public Double getSlidCommRt() {
		return slidCommRt;
	}
	
	public void setSlidCommRt(Double slidCommRt) {
		this.slidCommRt = slidCommRt;
	}
	
	public String getRemarks() {
		return remarks;
	}
	
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public BigDecimal getOldLoPremLim() {
		return oldLoPremLim;
	}

	public void setOldLoPremLim(BigDecimal oldLoPremLim) {
		this.oldLoPremLim = oldLoPremLim;
	}

	public BigDecimal getOldHiPremLim() {
		return oldHiPremLim;
	}

	public void setOldHiPremLim(BigDecimal oldHiPremLim) {
		this.oldHiPremLim = oldHiPremLim;
	}
	
}
