/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIQuoteItemEN.
 */
public class GIPIQuoteItemEN extends BaseEntity {

	/** The quote id. */
	private Integer quoteId;
	
	/** The engg basic info num. */
	private Integer enggBasicInfoNum;
	
	/** The contract proj buss title. */
	private String contractProjBussTitle;
	
	/** The site location. */
	private String siteLocation;
	
	/** The construct start date. */
	private Date constructStartDate;
	
	/** The construct end date. */
	private Date constructEndDate;
	
	/** The maintain start date. */
	private Date maintainStartDate;
	
	/** The maintain end date. */
	private Date maintainEndDate;
	
	/** The testing start date. */
	private Date testingStartDate;
	
	/** The testing end date. */
	private Date testingEndDate;
	
	/** The weeks test. */
	private Integer weeksTest;
	
	/** The time excess. */
	private Integer timeExcess;
	
	/** The mbi policy no. */
	private String mbiPolicyNo;

	private GIPIQuoteItemEN gipiQuoteItemEN;
	
	/**
	 * Gets the quote id.
	 * 
	 * @return the quote id
	 */
	public Integer getQuoteId() {
		return quoteId;
	}

	/**
	 * Sets the quote id.
	 * 
	 * @param quoteId the new quote id
	 */
	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}

	/**
	 * Gets the engg basic info num.
	 * 
	 * @return the engg basic info num
	 */
	public Integer getEnggBasicInfoNum() {
		return enggBasicInfoNum;
	}

	/**
	 * Sets the engg basic info num.
	 * 
	 * @param enggBasicInfoNum the new engg basic info num
	 */
	public void setEnggBasicInfoNum(Integer enggBasicInfoNum) {
		this.enggBasicInfoNum = enggBasicInfoNum;
	}

	/**
	 * Gets the contract proj buss title.
	 * 
	 * @return the contract proj buss title
	 */
	public String getContractProjBussTitle() {
		return contractProjBussTitle;
	}

	/**
	 * Sets the contract proj buss title.
	 * 
	 * @param contractProjBussTitle the new contract proj buss title
	 */
	public void setContractProjBussTitle(String contractProjBussTitle) {
		this.contractProjBussTitle = contractProjBussTitle;
	}

	/**
	 * Gets the site location.
	 * 
	 * @return the site location
	 */
	public String getSiteLocation() {
		return siteLocation;
	}

	/**
	 * Sets the site location.
	 * 
	 * @param siteLocation the new site location
	 */
	public void setSiteLocation(String siteLocation) {
		this.siteLocation = siteLocation;
	}

	/**
	 * Gets the construct start date.
	 * 
	 * @return the construct start date
	 */
	public Date getConstructStartDate() {
		return constructStartDate;
	}

	/**
	 * Sets the construct start date.
	 * 
	 * @param constructStartDate the new construct start date
	 */
	public void setConstructStartDate(Date constructStartDate) {
		this.constructStartDate = constructStartDate;
	}

	/**
	 * Gets the construct end date.
	 * 
	 * @return the construct end date
	 */
	public Date getConstructEndDate() {
		return constructEndDate;
	}

	/**
	 * Sets the construct end date.
	 * 
	 * @param constructEndDate the new construct end date
	 */
	public void setConstructEndDate(Date constructEndDate) {
		this.constructEndDate = constructEndDate;
	}

	/**
	 * Gets the maintain start date.
	 * 
	 * @return the maintain start date
	 */
	public Date getMaintainStartDate() {
		return maintainStartDate;
	}

	/**
	 * Sets the maintain start date.
	 * 
	 * @param maintainStartDate the new maintain start date
	 */
	public void setMaintainStartDate(Date maintainStartDate) {
		this.maintainStartDate = maintainStartDate;
	}

	/**
	 * Gets the maintain end date.
	 * 
	 * @return the maintain end date
	 */
	public Date getMaintainEndDate() {
		return maintainEndDate;
	}

	/**
	 * Sets the maintain end date.
	 * 
	 * @param maintainEndDate the new maintain end date
	 */
	public void setMaintainEndDate(Date maintainEndDate) {
		this.maintainEndDate = maintainEndDate;
	}

	/**
	 * Gets the testing start date.
	 * 
	 * @return the testing start date
	 */
	public Date getTestingStartDate() {
		return testingStartDate;
	}

	/**
	 * Sets the testing start date.
	 * 
	 * @param testingStartDate the new testing start date
	 */
	public void setTestingStartDate(Date testingStartDate) {
		this.testingStartDate = testingStartDate;
	}

	/**
	 * Gets the testing end date.
	 * 
	 * @return the testing end date
	 */
	public Date getTestingEndDate() {
		return testingEndDate;
	}

	/**
	 * Sets the testing end date.
	 * 
	 * @param testingEndDate the new testing end date
	 */
	public void setTestingEndDate(Date testingEndDate) {
		this.testingEndDate = testingEndDate;
	}

	/**
	 * Gets the weeks test.
	 * 
	 * @return the weeks test
	 */
	public Integer getWeeksTest() {
		return weeksTest;
	}

	/**
	 * Sets the weeks test.
	 * 
	 * @param weeksTest the new weeks test
	 */
	public void setWeeksTest(Integer weeksTest) {
		this.weeksTest = weeksTest;
	}

	/**
	 * Gets the time excess.
	 * 
	 * @return the time excess
	 */
	public Integer getTimeExcess() {
		return timeExcess;
	}

	/**
	 * Sets the time excess.
	 * 
	 * @param timeExcess the new time excess
	 */
	public void setTimeExcess(Integer timeExcess) {
		this.timeExcess = timeExcess;
	}

	/**
	 * Gets the mbi policy no.
	 * 
	 * @return the mbi policy no
	 */
	public String getMbiPolicyNo() {
		return mbiPolicyNo;
	}

	/**
	 * Sets the mbi policy no.
	 * 
	 * @param mbiPolicyNo the new mbi policy no
	 */
	public void setMbiPolicyNo(String mbiPolicyNo) {
		this.mbiPolicyNo = mbiPolicyNo;
	}

	public void setGipiQuoteItemEN(GIPIQuoteItemEN gipiQuoteItemEN) {
		this.gipiQuoteItemEN = gipiQuoteItemEN;
	}

	public GIPIQuoteItemEN getGipiQuoteItemEN() {
		return gipiQuoteItemEN;
	}
}
