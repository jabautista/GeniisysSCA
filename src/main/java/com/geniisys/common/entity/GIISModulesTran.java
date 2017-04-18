package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISModulesTran extends BaseEntity {
	private String moduleId;
	private Integer tranCd;
	private String tranDesc;
	
	public GIISModulesTran(){
		
	}
	
	public String getModuleId() {
		return moduleId;
	}
	
	public void setModuleId(String moduleId) {
		this.moduleId = moduleId;
	}
	
	public Integer getTranCd() {
		return tranCd;
	}
	
	public void setTranCd(Integer tranCd) {
		this.tranCd = tranCd;
	}

	public String getTranDesc() {
		return tranDesc;
	}

	public void setTranDesc(String tranDesc) {
		this.tranDesc = tranDesc;
	}
}
