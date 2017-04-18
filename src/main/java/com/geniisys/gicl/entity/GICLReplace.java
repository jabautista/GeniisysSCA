/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.controllers
	File Name: GICLReplaceController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 5, 2012
	Description: 
*/


package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLReplace extends BaseEntity{
	private Integer evalId;
	private String payeeTypeCd;
	private Integer payeeCd;
	private String lossExpCd;
	private String partType;
	private BigDecimal partOrigAmt;
	private String origPayeeTypeCd;
	private Integer origPayeeCd;
	private BigDecimal partAmt;
	private BigDecimal totalPartAmt;
	private BigDecimal baseAmt;
	private Integer noOfUnits;
	private String withVat;
	private String revisedSw;
	private String paytPayeeTypeCd;
	private Integer paytPayeeCd;
	private Integer replaceId;
	private Integer replacedMasterId;
	private Integer itemNo;
	private String updateSw;
	
	// attribute not included in main table
	private String dspPartDesc;
	private String dspCompanyType;
	private String dspCompany;
	private String dspPartTypeDesc;
	
	public String getDspPartTypeDesc() {
		return dspPartTypeDesc;
	}
	public void setDspPartTypeDesc(String dspPartTypeDesc) {
		this.dspPartTypeDesc = dspPartTypeDesc;
	}
	public Integer getEvalId() {
		return evalId;
	}
	public void setEvalId(Integer evalId) {
		this.evalId = evalId;
	}
	public String getPayeeTypeCd() {
		return payeeTypeCd;
	}
	public void setPayeeTypeCd(String payeeTypeCd) {
		this.payeeTypeCd = payeeTypeCd;
	}
	public Integer getPayeeCd() {
		return payeeCd;
	}
	public void setPayeeCd(Integer payeeCd) {
		this.payeeCd = payeeCd;
	}
	public String getLossExpCd() {
		return lossExpCd;
	}
	public void setLossExpCd(String lossExpCd) {
		this.lossExpCd = lossExpCd;
	}
	public String getPartType() {
		return partType;
	}
	public void setPartType(String partType) {
		this.partType = partType;
	}
	public BigDecimal getPartOrigAmt() {
		return partOrigAmt;
	}
	public void setPartOrigAmt(BigDecimal partOrigAmt) {
		this.partOrigAmt = partOrigAmt;
	}
	public String getOrigPayeeTypeCd() {
		return origPayeeTypeCd;
	}
	public void setOrigPayeeTypeCd(String origPayeeTypeCd) {
		this.origPayeeTypeCd = origPayeeTypeCd;
	}
	public Integer getOrigPayeeCd() {
		return origPayeeCd;
	}
	public void setOrigPayeeCd(Integer origPayeeCd) {
		this.origPayeeCd = origPayeeCd;
	}
	public BigDecimal getPartAmt() {
		return partAmt;
	}
	public void setPartAmt(BigDecimal partAmt) {
		this.partAmt = partAmt;
	}
	public BigDecimal getTotalPartAmt() {
		return totalPartAmt;
	}
	public void setTotalPartAmt(BigDecimal totalPartAmt) {
		this.totalPartAmt = totalPartAmt;
	}
	public BigDecimal getBaseAmt() {
		return baseAmt;
	}
	public void setBaseAmt(BigDecimal baseAmt) {
		this.baseAmt = baseAmt;
	}
	public Integer getNoOfUnits() {
		return noOfUnits;
	}
	public void setNoOfUnits(Integer noOfUnits) {
		this.noOfUnits = noOfUnits;
	}
	public String getWithVat() {
		return withVat;
	}
	public void setWithVat(String withVat) {
		this.withVat = withVat;
	}
	public String getRevisedSw() {
		return revisedSw;
	}
	public void setRevisedSw(String revisedSw) {
		this.revisedSw = revisedSw;
	}
	public String getPaytPayeeTypeCd() {
		return paytPayeeTypeCd;
	}
	public void setPaytPayeeTypeCd(String paytPayeeTypeCd) {
		this.paytPayeeTypeCd = paytPayeeTypeCd;
	}
	public Integer getPaytPayeeCd() {
		return paytPayeeCd;
	}
	public void setPaytPayeeCd(Integer paytPayeeCd) {
		this.paytPayeeCd = paytPayeeCd;
	}
	public Integer getReplaceId() {
		return replaceId;
	}
	public void setReplaceId(Integer replaceId) {
		this.replaceId = replaceId;
	}
	public Integer getReplacedMasterId() {
		return replacedMasterId;
	}
	public void setReplacedMasterId(Integer replacedMasterId) {
		this.replacedMasterId = replacedMasterId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public String getUpdateSw() {
		return updateSw;
	}
	public void setUpdateSw(String updateSw) {
		this.updateSw = updateSw;
	}
	public String getDspPartDesc() {
		return dspPartDesc;
	}
	public void setDspPartDesc(String dspPartDesc) {
		this.dspPartDesc = dspPartDesc;
	}
	public String getDspCompany() {
		return dspCompany;
	}
	public void setDspCompany(String dspCompany) {
		this.dspCompany = dspCompany;
	}
	public String getDspCompanyType() {
		return dspCompanyType;
	}
	public void setDspCompanyType(String dspCompanyType) {
		this.dspCompanyType = dspCompanyType;
	}
	
	
}
