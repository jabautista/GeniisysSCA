/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.entity;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIWOpenCargo.
 */
public class GIPIWOpenCargo extends BaseEntity{

	/** The par id. */
	private int parId;
	
	/** The geog cd. */
	private int geogCd;
	
	/** The cargo class cd. */
	private int cargoClassCd;
	
	/** The cargo class desc. */
	private String cargoClassDesc;
	
	/** The rec flag. */
	private String recFlag;
	
	/**
	 * Instantiates a new gIPIW open cargo.
	 */
	public GIPIWOpenCargo() {
		
	}

	/**
	 * Instantiates a new gIPIW open cargo.
	 * 
	 * @param parId the par id
	 * @param geogCd the geog cd
	 * @param cargoClassCd the cargo class cd
	 * @param cargoClassDesc the cargo class desc
	 * @param recFlag the rec flag
	 */
	public GIPIWOpenCargo(int parId, int geogCd, int cargoClassCd, String cargoClassDesc, String recFlag) {
		this.parId = parId;
		this.geogCd = geogCd;
		this.cargoClassCd = cargoClassCd;
		this.setCargoClassDesc(cargoClassDesc);
		this.recFlag = recFlag;
	}

	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public int getParId() {
		return parId;
	}

	/**
	 * Sets the par id.
	 * 
	 * @param parId the new par id
	 */
	public void setParId(int parId) {
		this.parId = parId;
	}

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
	 * Gets the rec flag.
	 * 
	 * @return the rec flag
	 */
	public String getRecFlag() {
		return recFlag;
	}

	/**
	 * Sets the rec flag.
	 * 
	 * @param recFlag the new rec flag
	 */
	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
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
	 * Gets the cargo class desc.
	 * 
	 * @return the cargo class desc
	 */
	public String getCargoClassDesc() {
		return cargoClassDesc;
	}
	
}
