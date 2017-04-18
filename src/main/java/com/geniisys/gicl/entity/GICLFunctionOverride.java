package com.geniisys.gicl.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLFunctionOverride extends BaseEntity {
	
	private Integer moduleId;
	private String functionCd;
	private String functionName;
	private String moduleName;
	
	private Integer overrideId;
	private String lineCd;
	private String issCd;
	private String display;
	private Date requestDate;
	private String requestBy;
	private String overrideUser;
	private Date overrideDate;
	private String remarks;
	private String userId;
	private Date lastUpdate;
	
	
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
	public String getFunctionName() {
		return functionName;
	}
	public void setFunctionName(String functionName) {
		this.functionName = functionName;
	}
	public String getModuleName() {
		return moduleName;
	}
	public void setModuleName(String moduleName) {
		this.moduleName = moduleName;
	}
	public Integer getOverrideId() {
		return overrideId;
	}
	public void setOverrideId(Integer overrideId) {
		this.overrideId = overrideId;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public String getDisplay() {
		return display;
	}
	public void setDisplay(String display) {
		this.display = display;
	}	
	public Date getRequestDate() {
		return requestDate;
	}
	public void setRequestDate(Date requestDate) {
		this.requestDate = requestDate;
	}
	public String getRequestBy() {
		return requestBy;
	}
	public void setRequestBy(String requestBy) {
		this.requestBy = requestBy;
	}
	public String getOverrideUser() {
		return overrideUser;
	}
	public void setOverrideUser(String overrideUser) {
		this.overrideUser = overrideUser;
	}
	public Date getOverrideDate() {
		return overrideDate;
	}
	public void setOverrideDate(Date overrideDate) {
		this.overrideDate = overrideDate;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public Date getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}

	
}
