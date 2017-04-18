package com.geniisys.giac.entity;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACSpoiledOr extends BaseEntity {

	private String orPref;
	private Integer orNo;
	private String orPrefNo;
	private String fundCd;
	private String branchCd;
	private Date spoilDate;
	private String spoilTag;
	private Integer tranId;
	private Date orDate;
	private String remarks;
	private String spoilTagDesc;
	
	public GIACSpoiledOr() {	
	}
	
	public String getOrPref() {
		return orPref;
	}
	public void setOrPref(String orPref) {
		this.orPref = orPref;
	}
	public Integer getOrNo() {
		return orNo;
	}
	public void setOrNo(Integer orNo) {
		this.orNo = orNo;
	}
	public String getFundCd() {
		return fundCd;
	}
	public void setFundCd(String fundCd) {
		this.fundCd = fundCd;
	}
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	public String getSpoilDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aaa");
		if (spoilDate != null) {
			return df.format(spoilDate);			
		} else {
			return null;
		}
	}
	public void setSpoilDate(Date spoilDate) {
		this.spoilDate = spoilDate;
	}
	public String getSpoilTag() {
		return spoilTag;
	}
	public void setSpoilTag(String spoilTag) {
		this.spoilTag = spoilTag;
	}
	public Integer getTranId() {
		return tranId;
	}
	public void setTranId(Integer tranId) {
		this.tranId = tranId;
	}
	public String getOrDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (orDate != null) {
			return df.format(orDate);			
		} else {
			return null;
		}
	}
	public void setOrDate(Date orDate) {
		this.orDate = orDate;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public void setSpoilTagDesc(String spoilTagDesc) {
		this.spoilTagDesc = spoilTagDesc;
	}

	public String getSpoilTagDesc() {
		return spoilTagDesc;
	}

	public void setOrPrefNo(String orPrefNo) {
		this.orPrefNo = orPrefNo;
	}

	public String getOrPrefNo() {
		return orPrefNo;
	}
	
}
