package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACFunction extends BaseEntity {

	private Integer moduleId;
	private String functionCode;
	private String functionName;
	private String remarks;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String activeTag;
	private String overrideSw;
	private String functionDesc;
	
	public GIACFunction(){
		
	}
	
	public GIACFunction(Integer moduleId, String functionCode,
			String functionName, String remarks, Integer cpiRecNo,
			String cpiBranchCd, String activeTag, String overrideSw,
			String functionDesc) {
		super();
		this.moduleId = moduleId;
		this.functionCode = functionCode;
		this.functionName = functionName;
		this.remarks = remarks;
		this.cpiRecNo = cpiRecNo;
		this.cpiBranchCd = cpiBranchCd;
		this.activeTag = activeTag;
		this.overrideSw = overrideSw;
		this.functionDesc = functionDesc;
	}

	public Integer getModuleId() {
		return moduleId;
	}

	public void setModuleId(Integer moduleId) {
		this.moduleId = moduleId;
	}

	public String getFunctionCode() {
		return functionCode;
	}

	public void setFunctionCode(String functionCode) {
		this.functionCode = functionCode;
	}

	public String getFunctionName() {
		return functionName;
	}

	public void setFunctionName(String functionName) {
		this.functionName = functionName;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	public String getActiveTag() {
		return activeTag;
	}

	public void setActiveTag(String activeTag) {
		this.activeTag = activeTag;
	}

	public String getOverrideSw() {
		return overrideSw;
	}

	public void setOverrideSw(String overrideSw) {
		this.overrideSw = overrideSw;
	}

	public String getFunctionDesc() {
		return functionDesc;
	}

	public void setFunctionDesc(String functionDesc) {
		this.functionDesc = functionDesc;
	}
		
}
