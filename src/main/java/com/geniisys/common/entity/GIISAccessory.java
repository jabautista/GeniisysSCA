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
 * The Class GIISAccessory.
 */
public class GIISAccessory extends BaseEntity {

	/** The accessory cd. */
	private Integer accessoryCd;

	/** The accessory desc. */
	private String accessoryDesc;

	/** The acc amt. */
	private String accAmt;

	/** The remarks. */
	private String remarks;

	/**
	 * Gets the accessory cd.
	 * 
	 * @return the accessory cd
	 */
	public Integer getAccessoryCd() {
		return accessoryCd;
	}

	/**
	 * Sets the accessory cd.
	 * 
	 * @param accessoryCd
	 *            the new accessory cd
	 */
	public void setAccessoryCd(Integer accessoryCd) {
		this.accessoryCd = accessoryCd;
	}

	/**
	 * Gets the accessory desc.
	 * 
	 * @return the accessory desc
	 */
	public String getAccessoryDesc() {
		return accessoryDesc;
	}

	/**
	 * Sets the accessory desc.
	 * 
	 * @param accessoryDesc
	 *            the new accessory desc
	 */
	public void setAccessoryDesc(String accessoryDesc) {
		this.accessoryDesc = accessoryDesc;
	}

	/**
	 * Gets the acc amt.
	 * 
	 * @return the acc amt
	 */
	public String getAccAmt() {
		return accAmt;
	}

	/**
	 * Sets the acc amt.
	 * 
	 * @param accAmt
	 *            the new acc amt
	 */
	public void setAccAmt(String accAmt) {
		this.accAmt = accAmt;
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
	 * Sets the acc amt.
	 * 
	 * @param accAmt
	 *            the new acc amt
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

}
