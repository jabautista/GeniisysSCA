package com.geniisys.giac.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACReinstatedOr extends BaseEntity{
	
	private String orPref;
	private Integer orNo;
	private String fundCd;
	private String branchCd;
	private Date reinstateDate;
	private Date spoilDate;
	private Date prevOrDate;
	private Integer preTranId;
	private String remarks;
	
	public GIACReinstatedOr(){
		
	}

	/**
	 * @return the orPref
	 */
	public String getOrPref() {
		return orPref;
	}

	/**
	 * @param orPref the orPref to set
	 */
	public void setOrPref(String orPref) {
		this.orPref = orPref;
	}

	/**
	 * @return the orNo
	 */
	public Integer getOrNo() {
		return orNo;
	}

	/**
	 * @param orNo the orNo to set
	 */
	public void setOrNo(Integer orNo) {
		this.orNo = orNo;
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
	 * @return the branchCd
	 */
	public String getBranchCd() {
		return branchCd;
	}

	/**
	 * @param branchCd the branchCd to set
	 */
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}

	/**
	 * @return the reinstateDate
	 */
	public Date getReinstateDate() {
		return reinstateDate;
	}

	/**
	 * @param reinstateDate the reinstateDate to set
	 */
	public void setReinstateDate(Date reinstateDate) {
		this.reinstateDate = reinstateDate;
	}

	/**
	 * @return the spoilDate
	 */
	public Date getSpoilDate() {
		return spoilDate;
	}

	/**
	 * @param spoilDate the spoilDate to set
	 */
	public void setSpoilDate(Date spoilDate) {
		this.spoilDate = spoilDate;
	}

	/**
	 * @return the prevOrDate
	 */
	public Date getPrevOrDate() {
		return prevOrDate;
	}

	/**
	 * @param prevOrDate the prevOrDate to set
	 */
	public void setPrevOrDate(Date prevOrDate) {
		this.prevOrDate = prevOrDate;
	}

	/**
	 * @return the preTranId
	 */
	public Integer getPreTranId() {
		return preTranId;
	}

	/**
	 * @param preTranId the preTranId to set
	 */
	public void setPreTranId(Integer preTranId) {
		this.preTranId = preTranId;
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

	
}
