package com.geniisys.giac.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACApdcPayt extends BaseEntity{

	private Integer apdcId;
	private String fundCd;
	private String branchCd;
	private Date apdcDate;
	private String apdcPref;
	private String apdcNo;
	private Integer cashierCd;
	private String payor;
	private String apdcFlag;
	private String apdcFlagMeaning;
	private String userId;
	private Date lastUpdate;
	private String particulars;
	private String refApdcNo;
	private String cicPrintTag;
	private String address1;
	private String address2;
	private String address3;
	
	public GIACApdcPayt(){
		
	}
	
	public GIACApdcPayt(Integer apdcId, String fundCd, String branchCd,
			Date apdcDate, String apdcPref, String apdcNo, Integer cashierCd,
			String payor, String apdcFlag, String apdcFlagMeaning,
			String userId, Date lastUpdate, String particulars,
			String refApdcNo, String cicPrintTag, String address1,
			String address2, String address3) {
		super();
		this.apdcId = apdcId;
		this.fundCd = fundCd;
		this.branchCd = branchCd;
		this.apdcDate = apdcDate;
		this.apdcPref = apdcPref;
		this.apdcNo = apdcNo;
		this.cashierCd = cashierCd;
		this.payor = payor;
		this.apdcFlag = apdcFlag;
		this.apdcFlagMeaning = apdcFlagMeaning;
		this.userId = userId;
		this.lastUpdate = lastUpdate;
		this.particulars = particulars;
		this.refApdcNo = refApdcNo;
		this.cicPrintTag = cicPrintTag;
		this.address1 = address1;
		this.address2 = address2;
		this.address3 = address3;
	}

	public Integer getApdcId() {
		return apdcId;
	}
	public void setApdcId(Integer apdcId) {
		this.apdcId = apdcId;
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
	public Date getApdcDate() {
		return apdcDate;
	}
	public void setApdcDate(Date apdcDate) {
		this.apdcDate = apdcDate;
	}
	public String getApdcPref() {
		return apdcPref;
	}
	public void setApdcPref(String apdcPref) {
		this.apdcPref = apdcPref;
	}
	public String getApdcNo() {
		return apdcNo;
	}
	public void setApdcNo(String apdcNo) {
		this.apdcNo = apdcNo;
	}
	public Integer getCashierCd() {
		return cashierCd;
	}
	public void setCashierCd(Integer cashierCd) {
		this.cashierCd = cashierCd;
	}
	public String getPayor() {
		return payor;
	}
	public void setPayor(String payor) {
		this.payor = payor;
	}
	public String getApdcFlag() {
		return apdcFlag;
	}
	public void setApdcFlag(String apdcFlag) {
		this.apdcFlag = apdcFlag;
	}
	public String getApdcFlagMeaning() {
		return apdcFlagMeaning;
	}
	public void setApdcFlagMeaning(String apdcFlagMeaning) {
		this.apdcFlagMeaning = apdcFlagMeaning;
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
	public String getParticulars() {
		return particulars;
	}
	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}
	public String getRefApdcNo() {
		return refApdcNo;
	}
	public void setRefApdcNo(String refApdcNo) {
		this.refApdcNo = refApdcNo;
	}
	public String getCicPrintTag() {
		return cicPrintTag;
	}
	public void setCicPrintTag(String cicPrintTag) {
		this.cicPrintTag = cicPrintTag;
	}
	public String getAddress1() {
		return address1;
	}
	public void setAddress1(String address1) {
		this.address1 = address1;
	}
	public String getAddress2() {
		return address2;
	}
	public void setAddress2(String address2) {
		this.address2 = address2;
	}
	public String getAddress3() {
		return address3;
	}
	public void setAddress3(String address3) {
		this.address3 = address3;
	}

	
}
