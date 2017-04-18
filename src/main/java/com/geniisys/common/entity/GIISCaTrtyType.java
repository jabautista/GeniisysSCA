package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISCaTrtyType extends BaseEntity{
	
	public Integer 	caTrtyType;
	public String 	trtySname;
	public String 	trtyLname;
	public String 	remarks;
	
	public Integer getCaTrtyType() {
		return caTrtyType;
	}
	public void setCaTrtyType(Integer caTrtyType) {
		this.caTrtyType = caTrtyType;
	}
	public String getTrtySname() {
		return trtySname;
	}
	public void setTrtySname(String trtySname) {
		this.trtySname = trtySname;
	}
	public String getTrtyLname() {
		return trtyLname;
	}
	public void setTrtyLname(String trtyLname) {
		this.trtyLname = trtyLname;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}	
}
