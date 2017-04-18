package com.geniisys.gicl.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLProcessorHist extends BaseEntity{
	private Integer claimId;
	private String inHouAdj;
	private String userId;
	private Date lastUpdate;
	
	public GICLProcessorHist(){
		
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
	 * @return the inHouAdj
	 */
	public String getInHouAdj() {
		return inHouAdj;
	}

	/**
	 * @param inHouAdj the inHouAdj to set
	 */
	public void setInHouAdj(String inHouAdj) {
		this.inHouAdj = inHouAdj;
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

	/**
	 * @return the lastUpdate
	 */
	public Date getLastUpdate() {
		return lastUpdate;
	}

	/**
	 * @param lastUpdate the lastUpdate to set
	 */
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
		
	}
	
	
}
