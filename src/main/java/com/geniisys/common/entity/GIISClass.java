package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISClass extends BaseEntity {

	private String classCd;
	private String classDesc;
	private String remarks;
	
	public GIISClass(){
		
	}

	public String getClassCd() {
		return classCd;
	}

	public void setClassCd(String classCd) {
		this.classCd = classCd;
	}

	public String getClassDesc() {
		return classDesc;
	}

	public void setClassDesc(String classDesc) {
		this.classDesc = classDesc;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
}
