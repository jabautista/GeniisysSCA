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
 * The Class GIISSectionOrHazard.
 */
public class GIISSectionOrHazard extends BaseEntity{

	/** The section line cd. */
	private String sectionLineCd;
	
	/** The section subline cd. */
	private String sectionSublineCd;
	
	/** The section or hazard cd. */
	private String sectionOrHazardCd;
	
	/** The section or hazard title. */
	private String sectionOrHazardTitle;
	
	private String remarks;
	private String lastUpdate;
	private String userId;
	
	/**
	 * Gets the section line cd.
	 * 
	 * @return the section line cd
	 */
	public String getSectionLineCd() {
		return sectionLineCd;
	}
	
	/**
	 * Sets the section line cd.
	 * 
	 * @param sectionLineCd the new section line cd
	 */
	public void setSectionLineCd(String sectionLineCd) {
		this.sectionLineCd = sectionLineCd;
	}
	
	/**
	 * Gets the section subline cd.
	 * 
	 * @return the section subline cd
	 */
	public String getSectionSublineCd() {
		return sectionSublineCd;
	}
	
	/**
	 * Sets the section subline cd.
	 * 
	 * @param sectionSublineCd the new section subline cd
	 */
	public void setSectionSublineCd(String sectionSublineCd) {
		this.sectionSublineCd = sectionSublineCd;
	}
	
	/**
	 * Gets the section or hazard cd.
	 * 
	 * @return the section or hazard cd
	 */
	public String getSectionOrHazardCd() {
		return sectionOrHazardCd;
	}
	
	/**
	 * Sets the section or hazard cd.
	 * 
	 * @param sectionOrHazardCd the new section or hazard cd
	 */
	public void setSectionOrHazardCd(String sectionOrHazardCd) {
		this.sectionOrHazardCd = sectionOrHazardCd;
	}
	
	/**
	 * Gets the section or hazard title.
	 * 
	 * @return the section or hazard title
	 */
	public String getSectionOrHazardTitle() {
		return sectionOrHazardTitle;
	}
	
	/**
	 * Sets the section or hazard title.
	 * 
	 * @param sectionOrHazardTitle the new section or hazard title
	 */
	public void setSectionOrHazardTitle(String sectionOrHazardTitle) {
		this.sectionOrHazardTitle = sectionOrHazardTitle;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(String lastUpdate) {
		this.lastUpdate = lastUpdate;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	
}
