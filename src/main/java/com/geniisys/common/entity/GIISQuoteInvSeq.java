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
 * The Class GIISQuoteInvSeq.
 */
public class GIISQuoteInvSeq extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -4870283962298951660L;

	/** The iss cd. */
	private String issCd;
	
	/** The quote inv no. */
	private int quoteInvNo;
	
	/** The remarks. */
	private String remarks;

	/**
	 * Gets the iss cd.
	 * 
	 * @return the iss cd
	 */
	public String getIssCd() {
		return issCd;
	}

	/**
	 * Sets the iss cd.
	 * 
	 * @param issCd the new iss cd
	 */
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	/**
	 * Gets the quote inv no.
	 * 
	 * @return the quote inv no
	 */
	public int getQuoteInvNo() {
		return quoteInvNo;
	}

	/**
	 * Sets the quote inv no.
	 * 
	 * @param quoteInvNo the new quote inv no
	 */
	public void setQuoteInvNo(int quoteInvNo) {
		this.quoteInvNo = quoteInvNo;
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
