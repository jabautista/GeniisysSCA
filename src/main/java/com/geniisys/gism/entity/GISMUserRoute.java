package com.geniisys.gism.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GISMUserRoute extends BaseEntity{
	
	public String keyword;
	public Integer parameter;
	public String queryStmt;
	public String returnMsg;
	public String paramType;
	public String errMsg;
	public String paramName;
	public String restrictNumber;
	public String validatePin;
	public String remarks;
	public String numberSw;
	public String pinSw;
	public String validSw;
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public Integer getParameter() {
		return parameter;
	}
	public void setParameter(Integer parameter) {
		this.parameter = parameter;
	}
	public String getQueryStmt() {
		return queryStmt;
	}
	public void setQueryStmt(String queryStmt) {
		this.queryStmt = queryStmt;
	}
	public String getReturnMsg() {
		return returnMsg;
	}
	public void setReturnMsg(String returnMsg) {
		this.returnMsg = returnMsg;
	}
	public String getParamType() {
		return paramType;
	}
	public void setParamType(String paramType) {
		this.paramType = paramType;
	}
	public String getErrMsg() {
		return errMsg;
	}
	public void setErrMsg(String errMsg) {
		this.errMsg = errMsg;
	}
	public String getParamName() {
		return paramName;
	}
	public void setParamName(String paramName) {
		this.paramName = paramName;
	}
	public String getRestrictNumber() {
		return restrictNumber;
	}
	public void setRestrictNumber(String restrictNumber) {
		this.restrictNumber = restrictNumber;
	}
	public String getValidatePin() {
		return validatePin;
	}
	public void setValidatePin(String validatePin) {
		this.validatePin = validatePin;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getNumberSw() {
		return numberSw;
	}
	public void setNumberSw(String numberSw) {
		this.numberSw = numberSw;
	}
	public String getPinSw() {
		return pinSw;
	}
	public void setPinSw(String pinSw) {
		this.pinSw = pinSw;
	}
	public String getValidSw() {
		return validSw;
	}
	public void setValidSw(String validSw) {
		this.validSw = validSw;
	}	
}
