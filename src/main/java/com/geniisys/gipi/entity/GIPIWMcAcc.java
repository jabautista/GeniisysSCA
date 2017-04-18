/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIWMcAcc.
 */
public class GIPIWMcAcc extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The par id. */
	private int parId;
	
	/** The item no. */
	private int itemNo;
	
	/** The accessory cd. */
	private String accessoryCd;
	
	/** The acc amt. */
	private BigDecimal accAmt;
	
	/** The user id. */
	private String userId;
	
	/** The delete sw. */
	private String deleteSw;
	
	/** The accessory desc. */
	private String accessoryDesc;

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseEntity#getUserId()
	 */
	@Override
	public String getUserId() {
		return userId;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseEntity#setUserId(java.lang.String)
	 */
	@Override
	public void setUserId(String userId) {
		this.userId = userId;
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
	 * @param accessoryDesc the new accessory desc
	 */
	public void setAccessoryDesc(String accessoryDesc) {
		this.accessoryDesc = accessoryDesc;
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
	 * Gets the item no.
	 * 
	 * @return the item no
	 */
	public int getItemNo() {
		return itemNo;
	}

	/**
	 * Sets the item no.
	 * 
	 * @param itemNo the new item no
	 */
	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}

	/**
	 * Gets the accessory cd.
	 * 
	 * @return the accessory cd
	 */
	public String getAccessoryCd() {
		return accessoryCd;
	}

	/**
	 * Sets the accessory cd.
	 * 
	 * @param accCds the new accessory cd
	 */
	public void setAccessoryCd(String accCds) {
		this.accessoryCd = accCds;
	}

	/**
	 * Gets the acc amt.
	 * 
	 * @return the acc amt
	 */
	public BigDecimal getAccAmt() {
		return accAmt;
	}

	/**
	 * Sets the acc amt.
	 * 
	 * @param bigDecimal the new acc amt
	 */
	public void setAccAmt(BigDecimal bigDecimal) {
		this.accAmt = bigDecimal;
	}

	/**
	 * Gets the delete sw.
	 * 
	 * @return the delete sw
	 */
	public String getDeleteSw() {
		return deleteSw;
	}

	/**
	 * Sets the delete sw.
	 * 
	 * @param deleteSw the new delete sw
	 */
	public void setDeleteSw(String deleteSw) {
		this.deleteSw = deleteSw;
	}
}
