package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISVestype extends BaseEntity {
	private String vestypeCd;
	private String vestypeDesc;
	private String remarks;
	
	public GIISVestype(){
		
	}
	
	public String getVestypeCd() {
		return vestypeCd;
	}

	public void setVestypeCd(String vestypeCd) {
		this.vestypeCd = vestypeCd;
	}

	public String getVestypeDesc() {
		return vestypeDesc;
	}

	public void setVestypeDesc(String vestypeDesc) {
		this.vestypeDesc = vestypeDesc;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
}
