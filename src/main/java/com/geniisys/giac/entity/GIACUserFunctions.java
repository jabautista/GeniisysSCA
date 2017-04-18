package com.geniisys.giac.entity;

import java.util.Date;

import com.geniisys.giis.entity.BaseEntity;

public class GIACUserFunctions extends BaseEntity{

	private Integer moduleId;
	private String functionCode;
	private Integer userFunctionId;
	private String validTag;
	private Date validityDt;
	private Date terminationDt;
	private String tranUserId;
	private String remarks;
	private String userName;
	private String dspValidTag;
	
	public GIACUserFunctions(){
		
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

	public Integer getUserFunctionId() {
		return userFunctionId;
	}

	public void setUserFunctionId(Integer userFunctionId) {
		this.userFunctionId = userFunctionId;
	}

	public String getValidTag() {
		return validTag;
	}

	public void setValidTag(String validTag) {
		this.validTag = validTag;
	}

	public Date getValidityDt() {
		return validityDt;
	}

	public void setValidityDt(Date validityDt) {
		this.validityDt = validityDt;
	}

	public Date getTerminationDt() {
		return terminationDt;
	}

	public void setTerminationDt(Date terminationDt) {
		this.terminationDt = terminationDt;
	}

	public String getTranUserId() {
		return tranUserId;
	}

	public void setTranUserId(String tranUserId) {
		this.tranUserId = tranUserId;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getDspValidTag() {
		return dspValidTag;
	}

	public void setDspValidTag(String dspValidTag) {
		this.dspValidTag = dspValidTag;
	}
	
	
}
