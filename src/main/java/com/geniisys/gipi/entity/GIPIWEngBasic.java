package com.geniisys.gipi.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWEngBasic extends BaseEntity {

	private int parId;
	private int enggBasicInfoNum;
	private String projTitle;
	private String siteLocation;
	private Date consStartDate;
	private Date consEndDate;
	private Date maintStartDate;
	private Date maintEndDate;
	private Date testStartDate;
	private Date testEndDate;
	private String weeksTest;
	private String timeExcess;
	private String mbiPolicyNo;

	public int getParId() {
		return parId;
	}

	public void setParId(int parId) {
		this.parId = parId;
	}

	public int getEnggBasicInfoNum() {
		return enggBasicInfoNum;
	}

	public void setEnggBasicInfoNum(int enggBasicInfoNum) {
		this.enggBasicInfoNum = enggBasicInfoNum;
	}

	public String getProjTitle() {
		return projTitle;
	}

	public void setProjTitle(String projTitle) {
		this.projTitle = projTitle;
	}

	public String getSiteLocation() {
		return siteLocation;
	}

	public void setSiteLocation(String siteLocation) {
		this.siteLocation = siteLocation;
	}

	public Date getConsStartDate() {
		return consStartDate;
	}

	public void setConsStartDate(Date consStartDate) {
		this.consStartDate = consStartDate;
	}

	public Date getConsEndDate() {
		return consEndDate;
	}

	public void setConsEndDate(Date consEndDate) {
		this.consEndDate = consEndDate;
	}

	public Date getMaintStartDate() {
		return maintStartDate;
	}

	public void setMaintStartDate(Date maintStartDate) {
		this.maintStartDate = maintStartDate;
	}

	public Date getMaintEndDate() {
		return maintEndDate;
	}

	public void setMaintEndDate(Date maintEndDate) {
		this.maintEndDate = maintEndDate;
	}

	public Date getTestStartDate() {
		return testStartDate;
	}

	public void setTestStartDate(Date testStartDate) {
		this.testStartDate = testStartDate;
	}

	public Date getTestEndDate() {
		return testEndDate;
	}

	public void setTestEndDate(Date testEndDate) {
		this.testEndDate = testEndDate;
	}

	public String getTimeExcess() {
		return timeExcess;
	}

	public void setTimeExcess(String timeExcess) {
		this.timeExcess = timeExcess;
	}

	public String getMbiPolicyNo() {
		return mbiPolicyNo;
	}

	public void setMbiPolicyNo(String mbiPolicyNo) {
		this.mbiPolicyNo = mbiPolicyNo;
	}

	public void setWeeksTest(String weeksTest) {
		this.weeksTest = weeksTest;
	}

	public String getWeeksTest() {
		return weeksTest;
	}
}
