/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import com.geniisys.common.entity.GIISMarineHull;


/**
 * The Class GIPIQuoteItemMH.
 */
public class GIPIQuoteItemMH extends GIISMarineHull {

	/** The quote id. */
	private Integer quoteId;
	
	/** The item no. */
	private Integer itemNo;
	
	/** The geog limit. */
	private String geogLimit;
	
	/** The rec flag. */
	private String recFlag;
	
	/** The deduct text. */
	private String deductText;

	/**
	 * Gets the quote id.
	 * 
	 * @return the quote id
	 */
	public Integer getQuoteId() {
		return quoteId;
	}

	/**
	 * Sets the quote id.
	 * 
	 * @param quoteId the new quote id
	 */
	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}

	/**
	 * Gets the item no.
	 * 
	 * @return the item no
	 */
	public Integer getItemNo() {
		return itemNo;
	}

	/**
	 * Sets the item no.
	 * 
	 * @param itemNo the new item no
	 */
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	/**
	 * Gets the geog limit.
	 * 
	 * @return the geog limit
	 */
	public String getGeogLimit() {
		return geogLimit;
	}

	/**
	 * Sets the geog limit.
	 * 
	 * @param geogLimit the new geog limit
	 */
	public void setGeogLimit(String geogLimit) {
		this.geogLimit = geogLimit;
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
	 * Gets the deduct text.
	 * 
	 * @return the deduct text
	 */
	public String getDeductText() {
		return deductText;
	}

	/**
	 * Sets the deduct text.
	 * 
	 * @param deductText the new deduct text
	 */
	public void setDeductText(String deductText) {
		this.deductText = deductText;
	}
}