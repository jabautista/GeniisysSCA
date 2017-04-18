package com.geniisys.common.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;

public class GIISIntmTypeComrt extends BaseEntity{
	
	private String issCd;
	private String coIntmType;
	private String lineCd;
	private Integer perilCd;
	private BigDecimal commRate;
	private String remarks;
	private String sublineCd;
	private String dspPerilName;
	
	public GIISIntmTypeComrt(){
		
	}
	
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public String getCoIntmType() {
		return coIntmType;
	}
	public void setCoIntmType(String coIntmType) {
		this.coIntmType = coIntmType;
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
	public BigDecimal getCommRate() {
		return commRate;
	}
	public void setCommRate(BigDecimal commRate) {
		this.commRate = commRate;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getSublineCd() {
		return sublineCd;
	}
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	public String getDspPerilName() {
		return dspPerilName;
	}

	public void setDspPerilName(String dspPerilName) {
		this.dspPerilName = dspPerilName;
	}
}
