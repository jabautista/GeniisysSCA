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
 * The Class GIISIssourcePlace.
 */
public class GIISIssourcePlace extends BaseEntity{

	/** The place cd. */
	private String placeCd;
	
	/** The place. */
	private String place;
	
	private String issCd;
	
	/**
	 * Gets the place cd.
	 * 
	 * @return the place cd
	 */
	public String getPlaceCd() {
		return placeCd;
	}
	
	/**
	 * Sets the place cd.
	 * 
	 * @param placeCd the new place cd
	 */
	public void setPlaceCd(String placeCd) {
		this.placeCd = placeCd;
	}
	
	/**
	 * Gets the place.
	 * 
	 * @return the place
	 */
	public String getPlace() {
		return place;
	}
	
	/**
	 * Sets the place.
	 * 
	 * @param place the new place
	 */
	public void setPlace(String place) {
		this.place = place;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	
	
}
