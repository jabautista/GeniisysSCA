package com.geniisys.gicl.entity;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLClmAdjuster extends BaseEntity{
	private Integer claimId;
	private Integer clmAdjId;
	private Integer adjCompanyCd;
	private Integer privAdjCd;
	private Date 	assignDate;
	private String	cancelTag;
	private Date    compltDate;
	private String	deleteTag;
	private String 	remarks;
	private String  surveyorSw;
	private String  dspAdjCoName;
	private String  dspPrivAdjName;
	private Integer payeeNo;
	
	public GICLClmAdjuster(){
		
	}

	/**
	 * @return the claimId
	 */
	public Integer getClaimId() {
		return claimId;
	}

	/**
	 * @param claimId the claimId to set
	 */
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}

	/**
	 * @return the clmAdjId
	 */
	public Integer getClmAdjId() {
		return clmAdjId;
	}

	/**
	 * @param clmAdjId the clmAdjId to set
	 */
	public void setClmAdjId(Integer clmAdjId) {
		this.clmAdjId = clmAdjId;
	}

	/**
	 * @return the ajdCompanyId
	 */
	public Integer getAdjCompanyCd() {
		return adjCompanyCd;
	}

	/**
	 * @param ajdCompanyId the ajdCompanyId to set
	 */
	public void setAdjCompanyCd(Integer adjCompanyCd) {
		this.adjCompanyCd = adjCompanyCd;
	}

	/**
	 * @return the privAdjCd
	 */
	public Integer getPrivAdjCd() {
		return privAdjCd;
	}

	/**
	 * @param privAdjCd the privAdjCd to set
	 */
	public void setPrivAdjCd(Integer privAdjCd) {
		this.privAdjCd = privAdjCd;
	}

	/**
	 * @return the assignDate
	 */
	public Object getStrAssignDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (assignDate != null) {
			return df.format(assignDate);			
		} else {
			return null;
		}
	}
	
	public Date getAssignDate() {
		return assignDate;
	}

	/**
	 * @param assignDate the assignDate to set
	 */
	public void setAssignDate(Date assignDate) {
		this.assignDate = assignDate;
	}

	/**
	 * @return the cancelTag
	 */
	public String getCancelTag() {
		return cancelTag;
	}

	/**
	 * @param cancelTag the cancelTag to set
	 */
	public void setCancelTag(String cancelTag) {
		this.cancelTag = cancelTag;
	}

	/**
	 * @return the compltDate
	 */
	public Object getStrCompltDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (compltDate != null) {
			return df.format(compltDate);			
		} else {
			return null;
		}
	}
	
	public Date getCompltDate() {
		return compltDate;
	}

	/**
	 * @param compltDate the compltDate to set
	 */
	public void setCompltDate(Date compltDate) {
		this.compltDate = compltDate;
	}

	/**
	 * @return the deleteTag
	 */
	public String getDeleteTag() {
		return deleteTag;
	}

	/**
	 * @param deleteTag the deleteTag to set
	 */
	public void setDeleteTag(String deleteTag) {
		this.deleteTag = deleteTag;
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
	 * @return the surveyorSw
	 */
	public String getSurveyorSw() {
		return surveyorSw;
	}

	/**
	 * @param surveyorSw the surveyorSw to set
	 */
	public void setSurveyorSw(String surveyorSw) {
		this.surveyorSw = surveyorSw;
	}

	/**
	 * @return the dspAdjCoName
	 */
	public String getDspAdjCoName() {
		return dspAdjCoName;
	}

	/**
	 * @param dspAdjCoName the dspAdjCoName to set
	 */
	public void setDspAdjCoName(String dspAdjCoName) {
		this.dspAdjCoName = dspAdjCoName;
	}

	/**
	 * @return the dspPrivAdjName
	 */
	public String getDspPrivAdjName() {
		return dspPrivAdjName;
	}

	/**
	 * @param dspPrivAdjName the dspPrivAdjName to set
	 */
	public void setDspPrivAdjName(String dspPrivAdjName) {
		this.dspPrivAdjName = dspPrivAdjName;
	}

	/**
	 * @return the payeeNo
	 */
	public Integer getPayeeNo() {
		return payeeNo;
	}

	/**
	 * @param payeeNo the payeeNo to set
	 */
	public void setPayeeNo(Integer payeeNo) {
		this.payeeNo = payeeNo;
	}
	
}
