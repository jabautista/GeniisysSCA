/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.fire.entity;

import com.geniisys.giis.entity.BaseEntity;



/**
 * The Class GIISFireConstruction.
 */
public class GIISFireConstruction extends BaseEntity {

	/** The construction cd. */
	private String constructionCd;
	
	/** The construction desc. */
	private String constructionDesc;
	
	/** The remarks. */
	private String remarks;
	
	/**
	 * Gets the construction cd.
	 * 
	 * @return the construction cd
	 */
	public String getConstructionCd() {
		return constructionCd;
	}

	/**
	 * Sets the construction cd.
	 * 
	 * @param constructionCd the new construction cd
	 */
	public void setConstructionCd(String constructionCd) {
		this.constructionCd = constructionCd;
	}

	/**
	 * Gets the construction desc.
	 * 
	 * @return the construction desc
	 */
	public String getConstructionDesc() {
		return constructionDesc;
	}

	/**
	 * Sets the construction desc.
	 * 
	 * @param constructionDesc the new construction desc
	 */
	public void setConstructionDesc(String constructionDesc) {
		this.constructionDesc = constructionDesc;
	}

	/**
	 * Gets the remarks.
	 * 
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * Sets the remarks.
	 * 
	 * @param remarks the new remarks
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
}
