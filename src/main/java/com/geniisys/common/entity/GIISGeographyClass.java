/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIISGeographyClass.
 */
public class GIISGeographyClass extends BaseEntity{

	/** The geog cd. */
	private int geogCd;
	
	/** The geog desc. */
	private String geogDesc;
	
	/** The geog type. */
	private String geogType;
	
	private String geogClassType;
	
	/**
	 * Gets the geog cd.
	 * 
	 * @return the geog cd
	 */
	public int getGeogCd() {
		return geogCd;
	}
	
	/**
	 * Sets the geog cd.
	 * 
	 * @param geogCd the new geog cd
	 */
	public void setGeogCd(int geogCd) {
		this.geogCd = geogCd;
	}
	
	/**
	 * Gets the geog desc.
	 * 
	 * @return the geog desc
	 */
	public String getGeogDesc() {
		return geogDesc;
	}
	
	/**
	 * Sets the geog desc.
	 * 
	 * @param geogDesc the new geog desc
	 */
	public void setGeogDesc(String geogDesc) {
		this.geogDesc = geogDesc;
	}
	
	/**
	 * Gets the geog type.
	 * 
	 * @return the geog type
	 */
	public String getGeogType() {
		return geogType;
	}
	
	/**
	 * Sets the geog type.
	 * 
	 * @param geogType the new geog type
	 */
	public void setGeogType(String geogType) {
		this.geogType = geogType;
	}

	public String getGeogClassType() {
		return geogClassType;
	}

	public void setGeogClassType(String geogClassType) {
		this.geogClassType = geogClassType;
	}
	
}
