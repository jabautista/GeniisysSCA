/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.util.Date;

import com.seer.framework.util.Entity;


/**
 * The Class GIPIWRequiredDocuments.
 */
@SuppressWarnings("rawtypes")
public class GIPIWRequiredDocuments extends Entity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The doc cd. */
	private String docCd;
	
	/** The doc name. */
	private String docName;
	
	/** The par id. */
	private String parId;
	
	/** The doc sw. */
	private String docSw;
	
	/** The line cd. */
	private String lineCd;
	
	/** The date submitted. */
	private Date dateSubmitted;
	
	/** The user id. */
	private String userId;
	
	/** The last update. */
	private Date lastUpdate;
	
	/** The remarks. */
	private String remarks;
	
	/** The expiry date. */
	private Date expiryDate;
	
	/**
	 * Gets the doc cd.
	 * 
	 * @return the doc cd
	 */
	public String getDocCd() {
		return docCd;
	}
	
	/**
	 * Sets the doc cd.
	 * 
	 * @param docCd the new doc cd
	 */
	public void setDocCd(String docCd) {
		this.docCd = docCd;
	}
	
	/**
	 * Gets the doc name.
	 * 
	 * @return the doc name
	 */
	public String getDocName() {
		return docName;
	}
	
	/**
	 * Sets the doc name.
	 * 
	 * @param docName the new doc name
	 */
	public void setDocName(String docName) {
		this.docName = docName;
	}
	
	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public String getParId() {
		return parId;
	}
	
	/**
	 * Sets the par id.
	 * 
	 * @param parId the new par id
	 */
	public void setParId(String parId) {
		this.parId = parId;
	}
	
	/**
	 * Gets the doc sw.
	 * 
	 * @return the doc sw
	 */
	public String getDocSw() {
		return docSw;
	}
	
	/**
	 * Sets the doc sw.
	 * 
	 * @param docSw the new doc sw
	 */
	public void setDocSw(String docSw) {
		this.docSw = docSw;
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
	 * Gets the date submitted.
	 * 
	 * @return the date submitted
	 */
	public Date getDateSubmitted() {
		return dateSubmitted;
	}
	
	/**
	 * Sets the date submitted.
	 * 
	 * @param dateSubmitted the new date submitted
	 */
	public void setDateSubmitted(Date dateSubmitted) {
		this.dateSubmitted = dateSubmitted;
	}
	
	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#getUserId()
	 */
	@Override
	public String getUserId() {
		return userId;
	}
	
	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#setUserId(java.lang.String)
	 */
	@Override
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#getLastUpdate()
	 */
	@Override
	public Date getLastUpdate() {
		return lastUpdate;
	}
	
	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#setLastUpdate(java.util.Date)
	 */
	@Override
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
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
	
	/**
	 * Gets the expiry date.
	 * 
	 * @return the expiry date
	 */
	public Date getExpiryDate() {
		return expiryDate;
	}
	
	/**
	 * Sets the expiry date.
	 * 
	 * @param expiryDate the new expiry date
	 */
	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}
	
	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#getId()
	 */
	@Override
	public Object getId() {
		return null;
	}
	
	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#setId(java.lang.Object)
	 */
	@Override
	public void setId(Object id) {
		
	}

}
