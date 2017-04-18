/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;


/**
 * The Class GIISTakeupTerm.
 */
public class GIISTakeupTerm extends BaseEntity{

	/** The takeup term. */
	private String takeupTerm;
	
	/** The takeup term desc. */
	private String takeupTermDesc;
	
	/** The no of takeup. */
	private String noOfTakeup;
	
	/** The yearly tag. */
	private String yearlyTag;
	
	private String remarks;
	
	/**
	 * Gets the takeup term.
	 * 
	 * @return the takeup term
	 */
	public String getTakeupTerm() {
		return takeupTerm;
	}
	
	/**
	 * Sets the takeup term.
	 * 
	 * @param takeupTerm the new takeup term
	 */
	public void setTakeupTerm(String takeupTerm) {
		this.takeupTerm = takeupTerm;
	}
	
	/**
	 * Gets the takeup term desc.
	 * 
	 * @return the takeup term desc
	 */
	public String getTakeupTermDesc() {
		return takeupTermDesc;
	}
	
	/**
	 * Sets the takeup term desc.
	 * 
	 * @param takeupTermDesc the new takeup term desc
	 */
	public void setTakeupTermDesc(String takeupTermDesc) {
		this.takeupTermDesc = takeupTermDesc;
	}
	
	/**
	 * Gets the no of takeup.
	 * 
	 * @return the no of takeup
	 */
	public String getNoOfTakeup() {
		return noOfTakeup;
	}
	
	/**
	 * Sets the no of takeup.
	 * 
	 * @param noOfTakeup the new no of takeup
	 */
	public void setNoOfTakeup(String noOfTakeup) {
		this.noOfTakeup = noOfTakeup;
	}
	
	/**
	 * Gets the yearly tag.
	 * 
	 * @return the yearly tag
	 */
	public String getYearlyTag() {
		return yearlyTag;
	}
	
	/**
	 * Sets the yearly tag.
	 * 
	 * @param yearlyTag the new yearly tag
	 */
	public void setYearlyTag(String yearlyTag) {
		this.yearlyTag = yearlyTag;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	
}
