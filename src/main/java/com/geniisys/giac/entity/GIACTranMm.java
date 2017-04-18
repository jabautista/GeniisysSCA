/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;


/**
 * The Class GIACTranMm.
 */
public class GIACTranMm extends BaseEntity{
	
	/** The fundCd. */
	private String fundCd; 
	
	/** The branchCd. */
	private String branchCd; 
	
	/** The tranMM. */
	private Integer tranMm; 
	
	/** The tranYr. */
	private Integer tranYr; 
	
	/** The closed tag. */
	private String closedTag; 
	
	/** The remarks. */
	private String remarks; 
	
	private String bookingMonth;
	private Integer bookingYear;
	
	private String clmClosedTag;
	private String dspMonth;
	private String dspClosed;
	private String chkTc;
	private String chkCct;
	private String updateCct;
	private String updateCt;
	
	public GIACTranMm(){
		
	}

	/**
	 * @return the fundCd
	 */
	public String getFundCd() {
		return fundCd;
	}

	/**
	 * @param fundCd the fundCd to set
	 */
	public void setFundCd(String fundCd) {
		this.fundCd = fundCd;
	}

	/**
	 * @return the brachCd
	 */
	public String getBranchCd() {
		return branchCd;
	}

	/**
	 * @param tranMm the tranMm to set
	 */
	public void setTranMm(Integer tranMm) {
		this.tranMm = tranMm;
	}

	/**
	 * @return the tranYr
	 */
	public Integer getTranYr() {
		return tranYr;
	}

	/**
	 * @param tranYr the tranYr to set
	 */
	public void setTranYr(Integer tranYr) {
		this.tranYr = tranYr;
	}

	/**
	 * @return the closedTag
	 */
	public String getClosedTag() {
		return closedTag;
	}

	/**
	 * @param closedTag the closedTag to set
	 */
	public void setClosedTag(String closedTag) {
		this.closedTag = closedTag;
	}

	/**
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * @param remarks the remarks to set
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	/**
	 * @return the tranMm
	 */
	public Integer getTranMm() {
		return tranMm;
	}

	/**
	 * @param branchCd the branchCd to set
	 */
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}

	public String getBookingMonth() {
		return bookingMonth;
	}

	public void setBookingMonth(String bookingMonth) {
		this.bookingMonth = bookingMonth;
	}

	public Integer getBookingYear() {
		return bookingYear;
	}

	public void setBookingYear(Integer bookingYear) {
		this.bookingYear = bookingYear;
	}

	public String getClmClosedTag() {
		return clmClosedTag;
	}

	public void setClmClosedTag(String clmClosedTag) {
		this.clmClosedTag = clmClosedTag;
	}

	public String getDspMonth() {
		return dspMonth;
	}

	public void setDspMonth(String dspMonth) {
		this.dspMonth = dspMonth;
	}

	public String getDspClosed() {
		return dspClosed;
	}

	public void setDspClosed(String dspClosed) {
		this.dspClosed = dspClosed;
	}

	public String getChkTc() {
		return chkTc;
	}

	public void setChkTc(String chkTc) {
		this.chkTc = chkTc;
	}

	public String getChkCct() {
		return chkCct;
	}

	public void setChkCct(String chkCct) {
		this.chkCct = chkCct;
	}

	public String getUpdateCct() {
		return updateCct;
	}

	public void setUpdateCct(String updateCct) {
		this.updateCct = updateCct;
	}

	public String getUpdateCt() {
		return updateCt;
	}

	public void setUpdateCt(String updateCt) {
		this.updateCt = updateCt;
	}
	
	
}
