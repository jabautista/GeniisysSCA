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
 * The Class GIISLostBid.
 */
public class GIISLostBid extends BaseEntity {
	
	/** The reason cd. */
	private  Integer reasonCd;
	
	/** The reason desc. */
	private String reasonDesc;
	
	/** The remarks. */
	private String remarks;
	
	/** The line cd. */
	private String lineCd;
	
	
	private String lineName;
	
	private String activeTag;
	
	/**
	 * Gets the reason cd.
	 * 
	 * @return the reason cd
	 */
	public Integer getReasonCd() {
		return reasonCd;
	}

	/**
	 * Sets the reason cd.
	 * 
	 * @param reasonCd the new reason cd
	 */
	public void setReasonCd(Integer reasonCd) {
		this.reasonCd = reasonCd;
	}

	/**
	 * Gets the reason desc.
	 * 
	 * @return the reason desc
	 */
	public String getReasonDesc() {
		return reasonDesc;
	}

	/**
	 * Sets the reason desc.
	 * 
	 * @param reasonDesc the new reason desc
	 */
	public void setReasonDesc(String reasonDesc) {
		this.reasonDesc = reasonDesc;
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

	/**
	 * Gets the line cd.
	 * 
	 * @return the line cd
	 */
	public String getLineCd() {
		return lineCd;
	}

	/**
	 * Sets the line cd.
	 * 
	 * @param lineCd the new line cd
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}	

	public void setLineName(String lineName) {
		this.lineName = lineName;
	}

	public String getLineName() {
		return lineName;
	}

	public String getActiveTag() {
		return activeTag;
	}

	public void setActiveTag(String activeTag) {
		this.activeTag = activeTag;
	}

}
