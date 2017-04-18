/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.entity
	File Name: GIACChkReleaseInfo.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jun 20, 2012
	Description: 
*/


package com.geniisys.giac.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACChkReleaseInfo extends BaseEntity{
	private Integer gaccTranId;
	private Integer itemNo;
	private Integer checkNo;
	private Date checkReleaseDate;
	private String checkReleasedBy;
	private String checkReceivedBy;
	private String checkPrefSuf;
	private String orNo;
	private Date orDate;
	private Date clearingDate;
	private String userId;
	private Date lastUpdate;
	
	private String strCheckReleaseDate;
	private String strOrDate;
	private String strLastUpdate2;
	
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public Date getLastUpdate() {
		return lastUpdate;
	}
	
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	/**
	 * @return the strCheckReleaseDate
	 */
	public String getStrCheckReleaseDate() {
		return strCheckReleaseDate;
	}
	/**
	 * @param strCheckReleaseDate the strCheckReleaseDate to set
	 */
	public void setStrCheckReleaseDate(String strCheckReleaseDate) {
		this.strCheckReleaseDate = strCheckReleaseDate;
	}
	/**
	 * @return the strOrDate
	 */
	public String getStrOrDate() {
		return strOrDate;
	}
	/**
	 * @param strOrDate the strOrDate to set
	 */
	public void setStrOrDate(String strOrDate) {
		this.strOrDate = strOrDate;
	}
	/**
	 * @return the clearingDate
	 */
	public Date getClearingDate() {
		return clearingDate;
	}
	/**
	 * @param clearingDate the clearingDate to set
	 */
	public void setClearingDate(Date clearingDate) {
		this.clearingDate = clearingDate;
	}
	/**
	 * @return the gaccTranId
	 */
	public Integer getGaccTranId() {
		return gaccTranId;
	}
	/**
	 * @param gaccTranId the gaccTranId to set
	 */
	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}
	/**
	 * @return the itemNo
	 */
	public Integer getItemNo() {
		return itemNo;
	}
	/**
	 * @param itemNo the itemNo to set
	 */
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	/**
	 * @return the checkNo
	 */
	public Integer getCheckNo() {
		return checkNo;
	}
	/**
	 * @param checkNo the checkNo to set
	 */
	public void setCheckNo(Integer checkNo) {
		this.checkNo = checkNo;
	}
	/**
	 * @return the checkReleaseDate
	 */
	public Date getCheckReleaseDate() {
		return checkReleaseDate;
	}
	/**
	 * @param checkReleaseDate the checkReleaseDate to set
	 */
	public void setCheckReleaseDate(Date checkReleaseDate) {
		this.checkReleaseDate = checkReleaseDate;
	}
	/**
	 * @return the checkReleasedBy
	 */
	public String getCheckReleasedBy() {
		return checkReleasedBy;
	}
	/**
	 * @param checkReleasedBy the checkReleasedBy to set
	 */
	public void setCheckReleasedBy(String checkReleasedBy) {
		this.checkReleasedBy = checkReleasedBy;
	}
	/**
	 * @return the checkReceivedBy
	 */
	public String getCheckReceivedBy() {
		return checkReceivedBy;
	}
	/**
	 * @param checkReceivedBy the checkReceivedBy to set
	 */
	public void setCheckReceivedBy(String checkReceivedBy) {
		this.checkReceivedBy = checkReceivedBy;
	}
	/**
	 * @return the checkPrefSuf
	 */
	public String getCheckPrefSuf() {
		return checkPrefSuf;
	}
	/**
	 * @param checkPrefSuf the checkPrefSuf to set
	 */
	public void setCheckPrefSuf(String checkPrefSuf) {
		this.checkPrefSuf = checkPrefSuf;
	}
	/**
	 * @return the orNo
	 */
	public String getOrNo() {
		return orNo;
	}
	/**
	 * @param orNo the orNo to set
	 */
	public void setOrNo(String orNo) {
		this.orNo = orNo;
	}
	/**
	 * @return the orDate
	 */
	public Date getOrDate() {
		return orDate;
	}
	/**
	 * @param orDate the orDate to set
	 */
	public void setOrDate(Date orDate) {
		this.orDate = orDate;
	}

	public String getStrLastUpdate2() {
		return strLastUpdate2;
	}

	public void setStrLastUpdate2(String strLastUpdate2) {
		this.strLastUpdate2 = strLastUpdate2;
	}

	
	
}
