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
 * The Class GIISProvince.
 */
public class GIISProvince extends BaseEntity {

	/** The province cd. */
	private String provinceCd;
	
	/** The province desc. */
	private String provinceDesc;
	
	/** The region cd. */
	private int regionCd;
	
	/** The remarks. */
	private String remarks;
	
	/**
	 * Gets the province cd.
	 * 
	 * @return the province cd
	 */
	public String getProvinceCd() {
		return provinceCd;
	}

	/**
	 * Sets the province cd.
	 * 
	 * @param provinceCd the new province cd
	 */
	public void setProvinceCd(String provinceCd) {
		this.provinceCd = provinceCd;
	}

	/**
	 * Gets the province desc.
	 * 
	 * @return the province desc
	 */
	public String getProvinceDesc() {
		return provinceDesc;
	}

	/**
	 * Sets the province desc.
	 * 
	 * @param provinceDesc the new province desc
	 */
	public void setProvinceDesc(String provinceDesc) {
		this.provinceDesc = provinceDesc;
	}

	/**
	 * Gets the region cd.
	 * 
	 * @return the region cd
	 */
	public int getRegionCd() {
		return regionCd;
	}

	/**
	 * Sets the region cd.
	 * 
	 * @param regionCd the new region cd
	 */
	public void setRegionCd(int regionCd) {
		this.regionCd = regionCd;
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
