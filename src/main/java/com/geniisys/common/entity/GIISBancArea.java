package com.geniisys.common.entity;

import java.util.Date;

import com.geniisys.giis.entity.BaseEntity;

public class GIISBancArea extends BaseEntity{

	private String areaCd;
	private String areaDesc;
	private Date effDate;
	private String remarks;
	
	public String getAreaCd() {
		return areaCd;
	}
	public void setAreaCd(String areaCd) {
		this.areaCd = areaCd;
	}
	public String getAreaDesc() {
		return areaDesc;
	}
	public void setAreaDesc(String areaDesc) {
		this.areaDesc = areaDesc;
	}
	public Date getEffDate() {
		return effDate;
	}
	public void setEffDate(Date effDate) {
		this.effDate = effDate;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
}
