package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACFunctionDisplay extends BaseEntity{
	
	private Integer moduleId;
	private String functionCd;
	private Integer displayColId;
	
	public GIACFunctionDisplay() {

	}

	public GIACFunctionDisplay(Integer moduleId, String functionCd,
			Integer displayColId) {
		super();
		this.moduleId = moduleId;
		this.functionCd = functionCd;
		this.displayColId = displayColId;
	}

	public Integer getModuleId() {
		return moduleId;
	}

	public void setModuleId(Integer moduleId) {
		this.moduleId = moduleId;
	}

	public String getFunctionCd() {
		return functionCd;
	}

	public void setFunctionCd(String functionCd) {
		this.functionCd = functionCd;
	}

	public Integer getDisplayColId() {
		return displayColId;
	}

	public void setDisplayColId(Integer displayColId) {
		this.displayColId = displayColId;
	}
	
	

}
