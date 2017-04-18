package com.geniisys.giis.entity;

public class GIISControlType extends BaseEntity{

	private Integer controlTypeCd;
	private String controlTypeDesc;
	private String remarks;
	
	public Integer getControlTypeCd() {
		return controlTypeCd;
	}
	
	public void setControlTypeCd(Integer controlTypeCd) {
		this.controlTypeCd = controlTypeCd;
	}
	
	public String getControlTypeDesc() {
		return controlTypeDesc;
	}
	
	public void setControlTypeDesc(String controlTypeDesc) {
		this.controlTypeDesc = controlTypeDesc;
	}
	
	public String getRemarks() {
		return remarks;
	}
	
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
}
