package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;


public class GIISAirType extends BaseEntity {
	private String airTypeCd;
	private String airDesc;
	private String remarks;
	
	public GIISAirType(){
		
	}
	public GIISAirType(String airTypeCd, String airDesc, String remarks) {
		super();
		this.airTypeCd = airTypeCd;
		this.airDesc = airDesc;
		this.remarks = remarks;
	}
	
	public String getAirTypeCd() {
		return airTypeCd;
	}
	public void setAirTypeCd(String airTypeCd) {
		this.airTypeCd = airTypeCd;
	}
	public String getAirDesc() {
		return airDesc;
	}
	public void setAirDesc(String airDesc) {
		this.airDesc = airDesc;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
}
