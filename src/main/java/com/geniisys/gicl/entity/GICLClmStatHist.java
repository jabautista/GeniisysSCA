package com.geniisys.gicl.entity;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLClmStatHist extends BaseEntity{
	private Integer claimId;
	private String  clmStatCd;
	private Date    clmStatDt;
	private String  remarks; 
	private String  userId;	
	
	public GICLClmStatHist(){
		
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
	 * @return the clmStatCd
	 */
	public String getClmStatCd() {
		return clmStatCd;
	}

	/**
	 * @param clmStatCd the clmStatCd to set
	 */
	public void setClmStatCd(String clmStatCd) {
		this.clmStatCd = clmStatCd;
	}

	/**
	 * @return the clmStatDt
	 */
	public String getClmStatDt() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (clmStatDt != null) {
			return df.format(clmStatDt);			
		} else {
			return null;
		}
	}

	/**
	 * @param clmStatDt the clmStatDt to set
	 */
	public void setClmStatDt(Date clmStatDt) {
		this.clmStatDt = clmStatDt;
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
	 * @return the userId
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * @param userId the userId to set
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
}
