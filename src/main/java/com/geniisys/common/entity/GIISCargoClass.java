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
 * The Class GIISCargoClass.
 */
public class GIISCargoClass extends BaseEntity{

	/** The cargo class cd. */
	private int cargoClassCd;
	
	/** The cargo class desc. */
	private String cargoClassDesc;
	
	/** The remarks. */
	private String remarks;
	

	/**
	 * Gets the cargo class cd.
	 * 
	 * @return the cargo class cd
	 */
	public int getCargoClassCd() {
		return cargoClassCd;
	}
	
	/**
	 * Sets the cargo class cd.
	 * 
	 * @param cargoClassCd the new cargo class cd
	 */
	public void setCargoClassCd(int cargoClassCd) {
		this.cargoClassCd = cargoClassCd;
	}
	
	/**
	 * Gets the cargo class desc.
	 * 
	 * @return the cargo class desc
	 */
	public String getCargoClassDesc() {
		return cargoClassDesc;
	}
	
	/**
	 * Sets the cargo class desc.
	 * 
	 * @param cargoClassDesc the new cargo class desc
	 */
	public void setCargoClassDesc(String cargoClassDesc) {
		this.cargoClassDesc = cargoClassDesc;
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
	 * @param remarks the new cargo remarks
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
}
