package com.geniisys.quote.entity;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIQuoteENItem extends BaseEntity{
	
	private Integer quoteId;
	private Integer enggBasicInfonum;
	private String contractProjBussTitle;
	private String siteLocation;
	private Date constructStartDate;
	private Date constructEndDate;
	private Date maintainStartDate;
	private Date maintainEndDate;
	private Date testingStartDate;
	private Date testingEndDate;
	private Integer weeksTest;
	private Integer timeExcess;
	private String mbiPolicyNo;
	private String userId;
	private Date lastUpdate;
	
	public GIPIQuoteENItem() {
		super();
	}

	public Integer getQuoteId() {
		return quoteId;
	}

	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}

	public Integer getEnggBasicInfonum() {
		return enggBasicInfonum;
	}

	public void setEnggBasicInfonum(Integer enggBasicInfonum) {
		this.enggBasicInfonum = enggBasicInfonum;
	}

	public String getContractProjBussTitle() {
		return contractProjBussTitle;
	}

	public void setContractProjBussTitle(String contractProjBussTitle) {
		this.contractProjBussTitle = contractProjBussTitle;
	}

	public String getSiteLocation() {
		return siteLocation;
	}

	public void setSiteLocation(String siteLocation) {
		this.siteLocation = siteLocation;
	}

	public Date getConstructStartDate() {
		return constructStartDate;
	}

	public void setConstructStartDate(Date constructStartDate) {
		this.constructStartDate = constructStartDate;
	}
	
	public Object getStrConstructStartDate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (constructStartDate != null) {
			return df.format(constructStartDate);
		} else {
			return null;
		}
	}

	public Date getConstructEndDate() {
		return constructEndDate;
	}

	public void setConstructEndDate(Date constructEndDate) {
		this.constructEndDate = constructEndDate;
	}
	
	public Object getStrConstructEndDate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (constructEndDate != null) {
			return df.format(constructEndDate);
		} else {
			return null;
		}
	}

	public Date getMaintainStartDate() {
		return maintainStartDate;
	}

	public void setMaintainStartDate(Date maintainStartDate) {
		this.maintainStartDate = maintainStartDate;
	}
	
	public Object getStrMaintainStartDate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (maintainStartDate != null) {
			return df.format(maintainStartDate);
		} else {
			return null;
		}
	}

	public Date getMaintainEndDate() {
		return maintainEndDate;
	}

	public void setMaintainEndDate(Date maintainEndDate) {
		this.maintainEndDate = maintainEndDate;
	}
	
	public Object getStrMaintainEndDate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (maintainEndDate != null) {
			return df.format(maintainEndDate);
		} else {
			return null;
		}
	}

	public Date getTestingStartDate() {
		return testingStartDate;
	}

	public void setTestingStartDate(Date testingStartDate) {
		this.testingStartDate = testingStartDate;
	}
	
	public Object getStrTestingStartDate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (testingStartDate != null) {
			return df.format(testingStartDate);
		} else {
			return null;
		}
	}

	public Date getTestingEndDate() {
		return testingEndDate;
	}

	public void setTestingEndDate(Date testingEndDate) {
		this.testingEndDate = testingEndDate;
	}
	
	public Object getStrTestingEndDate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (testingEndDate != null) {
			return df.format(testingEndDate);
		} else {
			return null;
		}
	}

	public Integer getWeeksTest() {
		return weeksTest;
	}

	public void setWeeksTest(Integer weeksTest) {
		this.weeksTest = weeksTest;
	}

	public Integer getTimeExcess() {
		return timeExcess;
	}

	public void setTimeExcess(Integer timeExcess) {
		this.timeExcess = timeExcess;
	}

	public String getMbiPolicyNo() {
		return mbiPolicyNo;
	}

	public void setMbiPolicyNo(String mbiPolicyNo) {
		this.mbiPolicyNo = mbiPolicyNo;
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
	
	public Object getStrLastUpdate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (lastUpdate != null) {
			return df.format(lastUpdate);
		} else {
			return null;
		}
	}

}
