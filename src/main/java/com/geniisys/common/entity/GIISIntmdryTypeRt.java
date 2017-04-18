package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISIntmdryTypeRt extends BaseEntity{

	private String issCd;
	private String intmType;
	private String lineCd;
	private Integer perilCd;
	private Double commRate;
	private String remarks;
	private String sublineCd;
	
	private String dspLastUpdate;
	private String perilName;
	
	public String getIssCd() {
		return issCd;
	}
	
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	
	public String getIntmType() {
		return intmType;
	}
	
	public void setIntmType(String intmType) {
		this.intmType = intmType;
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
	
	public Double getCommRate() {
		return commRate;
	}
	
	public void setCommRate(Double commRate) {
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
	
	public String getDspLastUpdate() {
		return dspLastUpdate;
	}
	
	public void setDspLastUpdate(String dspLastUpdate) {
		this.dspLastUpdate = dspLastUpdate;
	}
	
	public String getPerilName() {
		return perilName;
	}
	
	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}
	
}
