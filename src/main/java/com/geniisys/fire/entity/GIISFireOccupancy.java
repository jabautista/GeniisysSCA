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
 * The Class GIISFireOccupancy.
 */
public class GIISFireOccupancy extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -7660572588371911579L;

	/** The occupancy cd. */
	private String occupancyCd;
	
	/** The occupancy desc. */
	private String occupancyDesc;
	
	/** The active tag. */
	private String activeTag;
	
	/** The remarks. */
	private String remarks;
	
	/** The cpi rec no. */
	private Integer cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;

	/**
	 * Gets the occupancy cd.
	 * 
	 * @return the occupancy cd
	 */
	public String getOccupancyCd() {
		return occupancyCd;
	}

	/**
	 * Sets the occupancy cd.
	 * 
	 * @param occupancyCd the new occupancy cd
	 */
	public void setOccupancyCd(String occupancyCd) {
		this.occupancyCd = occupancyCd;
	}

	/**
	 * Gets the occupancy desc.
	 * 
	 * @return the occupancy desc
	 */
	public String getOccupancyDesc() {
		return occupancyDesc;
	}

	/**
	 * Sets the occupancy desc.
	 * 
	 * @param occupancyDesc the new occupancy desc
	 */
	public void setOccupancyDesc(String occupancyDesc) {
		this.occupancyDesc = occupancyDesc;
	}
	
	/**
	 * @return the activeTag
	 */
	public String getActiveTag() {
		return activeTag;
	}

	/**
	 * @param activeTag the activeTag to set
	 */
	public void setActiveTag(String activeTag) {
		this.activeTag = activeTag;
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
	 * Gets the cpi rec no.
	 * 
	 * @return the cpi rec no
	 */
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	/**
	 * Sets the cpi rec no.
	 * 
	 * @param cpiRecNo the new cpi rec no
	 */
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	/**
	 * Gets the cpi branch cd.
	 * 
	 * @return the cpi branch cd
	 */
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	/**
	 * Sets the cpi branch cd.
	 * 
	 * @param cpiBranchCd the new cpi branch cd
	 */
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
}
