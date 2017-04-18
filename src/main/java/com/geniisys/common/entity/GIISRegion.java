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
 * The Class GIISRegion.
 */
public class GIISRegion extends BaseEntity{

	/** The region cd. */
	private String regionCd;
	
	/** The region desc. */
	private String regionDesc;
	
	
	private Integer indGrpCd;
	private String indGrpNm;
	
	/**
	 * Gets the region cd.
	 * 
	 * @return the region cd
	 */
	public String getRegionCd() {
		return regionCd;
	}
	
	/**
	 * Sets the region cd.
	 * 
	 * @param regionCd the new region cd
	 */
	public void setRegionCd(String regionCd) {
		this.regionCd = regionCd;
	}
	
	/**
	 * Gets the region desc.
	 * 
	 * @return the region desc
	 */
	public String getRegionDesc() {
		return regionDesc;
	}
	
	/**
	 * Sets the region desc.
	 * 
	 * @param regionDesc the new region desc
	 */
	public void setRegionDesc(String regionDesc) {
		this.regionDesc = regionDesc;
	}

	public Integer getIndGrpCd() {
		return indGrpCd;
	}

	public void setIndGrpCd(Integer indGrpCd) {
		this.indGrpCd = indGrpCd;
	}

	public String getIndGrpNm() {
		return indGrpNm;
	}

	public void setIndGrpNm(String indGrpNm) {
		this.indGrpNm = indGrpNm;
	}

}
