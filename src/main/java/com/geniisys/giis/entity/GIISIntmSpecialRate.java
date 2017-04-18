package com.geniisys.giis.entity;


public class GIISIntmSpecialRate extends BaseEntity{

	private Integer intmNo;
	private String issCd;
	private Integer perilCd;
	private Double rate;
	private String lineCd;
	private String overrideTag;
	private String remarks;
	private String sublineCd;
	private String perilName;
	
	public Integer getIntmNo() {
		return intmNo;
	}
	
	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}
	
	public String getIssCd() {
		return issCd;
	}
	
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	
	public Integer getPerilCd() {
		return perilCd;
	}
	
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	
	public Double getRate() {
		return rate;
	}
	
	public void setRate(Double rate) {
		this.rate = rate;
	}
	
	public String getLineCd() {
		return lineCd;
	}
	
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	
	public String getOverrideTag() {
		return overrideTag;
	}
	
	public void setOverrideTag(String overrideTag) {
		this.overrideTag = overrideTag;
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

	public String getPerilName() {
		return perilName;
	}

	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}
	
}
