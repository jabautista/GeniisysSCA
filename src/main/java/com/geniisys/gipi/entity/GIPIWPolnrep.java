/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIWPolnrep.
 */
public class GIPIWPolnrep extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 8005802943216520236L;

	/** The par id. */
	//private int parId;
	
	// change from int to Integer RSIC-SR-15092 & 15094 cannot handle null/no result set return of query JCBrigino
	//parId, polSeqNo, issueYy, renewNo
	
	private Integer parId; 
	
	/** The old policy id. */
	private Integer oldPolicyId;
	
	/** The line cd. */
	private String lineCd;
	
	/** The subline cd. */
	private String sublineCd;
	
	/** The pol seq no. */
	private Integer polSeqNo;
	
	/** The iss cd. */
	private String issCd;
	
	/** The issue yy. */
	private Integer issueYy;
	
	/** The renew no. */
	private Integer renewNo;
	
	/** The rec flag. */
	private String recFlag;
	
	/** The ren rep sw. */
	private String renRepSw;
	
	/** The user id. */
	private String userId;
	
	private Date expiryDate;  //added, 05092012

	/**
	 * Instantiates a new gIPIW polnrep.
	 */
	public GIPIWPolnrep() {

	}

	/**
	 * Instantiates a new gIPIW polnrep.
	 * 
	 * @param parId the par id
	 * @param oldPolicyId the old policy id
	 * @param lineCd the line cd
	 * @param sublineCd the subline cd
	 * @param polSeqNo the pol seq no
	 * @param issCd the iss cd
	 * @param issYy the iss yy
	 * @param renewNo the renew no
	 * @param recFlag the rec flag
	 * @param renRepSw the ren rep sw
	 * @param userId the user id
	 */
	public GIPIWPolnrep(Integer parId, Integer oldPolicyId, String lineCd,
			String sublineCd, Integer polSeqNo, String issCd, Integer issYy,
			Integer renewNo, String recFlag, String renRepSw, String userId) {
		this.parId = parId;
		this.oldPolicyId = oldPolicyId;
		this.lineCd = lineCd;
		this.sublineCd = sublineCd;
		this.polSeqNo = polSeqNo;
		this.issCd = issCd;
		this.issueYy = issYy;
		this.renewNo = renewNo;
		this.recFlag = recFlag;
		this.renRepSw = renRepSw;
		this.userId = userId;
	}

	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public Integer getParId() {
		return parId;
	}

	/**
	 * Sets the par id.
	 * 
	 * @param parId the new par id
	 */
	public void setParId(Integer parId) {
		this.parId = parId;
	}

	/**
	 * Gets the old policy id.
	 * 
	 * @return the old policy id
	 */
	public Integer getOldPolicyId() {
		return oldPolicyId;
	}

	/**
	 * Sets the old policy id.
	 * 
	 * @param oldPolicyId the new old policy id
	 */
	public void setOldPolicyId(Integer oldPolicyId) {
		this.oldPolicyId = oldPolicyId;
	}

	/**
	 * Gets the line cd.
	 * 
	 * @return the line cd
	 */
	public String getLineCd() {
		return lineCd;
	}

	/**
	 * Sets the line cd.
	 * 
	 * @param lineCd the new line cd
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	/**
	 * Gets the subline cd.
	 * 
	 * @return the subline cd
	 */
	public String getSublineCd() {
		return sublineCd;
	}

	/**
	 * Sets the subline cd.
	 * 
	 * @param sublineCd the new subline cd
	 */
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	/**
	 * Gets the pol seq no.
	 * 
	 * @return the pol seq no
	 */
	public Integer getPolSeqNo() {
		return polSeqNo;
	}

	/**
	 * Sets the pol seq no.
	 * 
	 * @param polSeqNo the new pol seq no
	 */
	public void setPolSeqNo(Integer polSeqNo) {
		this.polSeqNo = polSeqNo;
	}

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
	 * Gets the issue yy.
	 * 
	 * @return the issue yy
	 */
	public Integer getIssueYy() {
		return issueYy;
	}

	/**
	 * Sets the issue yy.
	 * 
	 * @param issueYy the new issue yy
	 */
	public void setIssueYy(Integer issueYy) {
		this.issueYy = issueYy;
	}

	/**
	 * Gets the renew no.
	 * 
	 * @return the renew no
	 */
	public Integer getRenewNo() {
		return renewNo;
	}

	/**
	 * Sets the renew no.
	 * 
	 * @param renewNo the new renew no
	 */
	public void setRenewNo(Integer renewNo) {
		this.renewNo = renewNo;
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
	 * Gets the ren rep sw.
	 * 
	 * @return the ren rep sw
	 */
	public String getRenRepSw() {
		return renRepSw;
	}

	/**
	 * Sets the ren rep sw.
	 * 
	 * @param renRepSw the new ren rep sw
	 */
	public void setRenRepSw(String renRepSw) {
		this.renRepSw = renRepSw;
	}

	/**
	 * Gets the serialversionuid.
	 * 
	 * @return the serialversionuid
	 */
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseEntity#setUserId(java.lang.String)
	 */
	@Override
	public void setUserId(String userId) {
		this.userId = userId;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseEntity#getUserId()
	 */
	@Override
	public String getUserId() {
		return userId;
	}

	public Date getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}

}
