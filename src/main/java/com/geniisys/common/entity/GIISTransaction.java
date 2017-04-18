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
 * The Class GIISTransaction.
 */
public class GIISTransaction extends BaseEntity {

	/** The tran cd. */
	private Integer tranCd;
	
	/** The tran desc. */
	private String tranDesc;
	
	/** The remarks. */
	private String remarks;

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
	 * Gets the tran cd.
	 * 
	 * @return the tran cd
	 */
	public Integer getTranCd() {
		return tranCd;
	}

	/**
	 * Sets the tran cd.
	 * 
	 * @param tranCd the new tran cd
	 */
	public void setTranCd(Integer tranCd) {
		this.tranCd = tranCd;
	}

	/**
	 * Gets the tran desc.
	 * 
	 * @return the tran desc
	 */
	public String getTranDesc() {
		return tranDesc;
	}

	/**
	 * Sets the tran desc.
	 * 
	 * @param tranDesc the new tran desc
	 */
	public void setTranDesc(String tranDesc) {
		this.tranDesc = tranDesc;
	}

}
