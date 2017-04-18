package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISHullType extends BaseEntity{

	private Integer hullTypeCd;	
	private String hullDesc;
	private String remarks;
	
	public GIISHullType (){
		
	}

	public Integer getHullTypeCd() {
		return hullTypeCd;
	}

	public void setHullTypeCd(Integer hullTypeCd) {
		this.hullTypeCd = hullTypeCd;
	}

	public String getHullDesc() {
		return hullDesc;
	}

	public void setHullDesc(String hullDesc) {
		this.hullDesc = hullDesc;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

}
