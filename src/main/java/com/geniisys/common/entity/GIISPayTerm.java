/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;


/**
 * The Class GIISPayTerm.
 */
public class GIISPayTerm {
	
	/** The payt terms. */
	private String paytTerms;
	
	/** The payt terms desc. */
	private String paytTermsDesc;
	
	/** The no of payt. */
	private int noOfPayt;
	
	/** The annual sw. */
	private String annualSw;
	
	/** The no of days. */
	private Integer noOfDays;
	
	/** The on incept tag. */
	private String onInceptTag;

	/** The no of payt days */
	private Integer noPaytDays;
	/**
	 * Gets the payt terms.
	 * 
	 * @return the payt terms
	 */
	public String getPaytTerms() {
		return paytTerms;
	}

	/**
	 * Sets the payt terms.
	 * 
	 * @param paytTerms the new payt terms
	 */
	public void setPaytTerms(String paytTerms) {
		this.paytTerms = paytTerms;
	}

	/**
	 * Gets the payt terms desc.
	 * 
	 * @return the payt terms desc
	 */
	public String getPaytTermsDesc() {
		return paytTermsDesc;
	}

	/**
	 * Sets the payt terms desc.
	 * 
	 * @param paytTermsDesc the new payt terms desc
	 */
	public void setPaytTermsDesc(String paytTermsDesc) {
		this.paytTermsDesc = paytTermsDesc;
	}

	/**
	 * Gets the no of payt.
	 * 
	 * @return the no of payt
	 */
	public int getNoOfPayt() {
		return noOfPayt;
	}

	/**
	 * Sets the no of payt.
	 * 
	 * @param noOfPayt the new no of payt
	 */
	public void setNoOfPayt(int noOfPayt) {
		this.noOfPayt = noOfPayt;
	}

	/**
	 * Gets the annual sw.
	 * 
	 * @return the annual sw
	 */
	public String getAnnualSw() {
		return annualSw;
	}

	/**
	 * Sets the annual sw.
	 * 
	 * @param annualSw the new annual sw
	 */
	public void setAnnualSw(String annualSw) {
		this.annualSw = annualSw;
	}

	/**
	 * @return the noOfDays
	 */
	public Integer getNoOfDays() {
		return noOfDays;
	}

	/**
	 * @param noOfDays the noOfDays to set
	 */
	public void setNoOfDays(Integer noOfDays) {
		this.noOfDays = noOfDays;
	}

	/**
	 * @return the onInceptTag
	 */
	public String getOnInceptTag() {
		return onInceptTag;
	}

	/**
	 * @param onInceptTag the onInceptTag to set
	 */
	public void setOnInceptTag(String onInceptTag) {
		this.onInceptTag = onInceptTag;
	}

	public Integer getNoPaytDays() {
		return noPaytDays;
	}

	public void setNoPaytDays(Integer noPaytDays) {
		this.noPaytDays = noPaytDays;
	}

	

	
}
