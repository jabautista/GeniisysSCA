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
 * The Class GIISCity.
 */
public class GIISCity extends BaseEntity {	
	
	/** The province cd. */
	private String provinceCd;
	
	/** The city cd. */
	private String cityCd;
	
	/** The city. */
	private String city;
	
	/** The remarks. */
	private String remarks;
	
	/** The province desc. */
	private String provinceDesc;
	
	private String regionCd;

	public String getRegionCd() {
		return regionCd;
	}

	public void setRegionCd(String regionCd) {
		this.regionCd = regionCd;
	}

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
	 * Gets the city cd.
	 * 
	 * @return the city cd
	 */
	public String getCityCd() {
		return cityCd;
	}

	/**
	 * Sets the city cd.
	 * 
	 * @param cityCd the new city cd
	 */
	public void setCityCd(String cityCd) {
		this.cityCd = cityCd;
	}

	/**
	 * Gets the city.
	 * 
	 * @return the city
	 */
	public String getCity() {
		return city;
	}

	/**
	 * Sets the city.
	 * 
	 * @param city the new city
	 */
	public void setCity(String city) {
		this.city = city;
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

}
