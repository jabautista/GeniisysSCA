/**
 * 
 */
package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

/**
 * @author steven
 *
 */
public class GIACUsers extends BaseEntity{

	private String giacUserId;
	private String userName;
	private String designation;
	private String activeDt;
	private String inactiveDt;
	private String activeTag;
	private String remarks;
	private String tranUserId;
	
	/**
	 * @return the giacUserId
	 */
	public String getGiacUserId() {
		return giacUserId;
	}
	/**
	 * @param giacUserId the giacUserId to set
	 */
	public void setGiacUserId(String giacUserId) {
		this.giacUserId = giacUserId;
	}
	/**
	 * @return the designation
	 */
	public String getDesignation() {
		return designation;
	}
	/**
	 * @param designation the designation to set
	 */
	public void setDesignation(String designation) {
		this.designation = designation;
	}
	/**
	 * @return the activeDt
	 */
	public String getActiveDt() {
		return activeDt;
	}
	/**
	 * @param activeDt the activeDt to set
	 */
	public void setActiveDt(String activeDt) {
		this.activeDt = activeDt;
	}
	/**
	 * @return the inactiveDt
	 */
	public String getInactiveDt() {
		return inactiveDt;
	}
	/**
	 * @param inactiveDt the inactiveDt to set
	 */
	public void setInactiveDt(String inactiveDt) {
		this.inactiveDt = inactiveDt;
	}
	/**
	 * @return the activeTag
	 */
	public String getActiveTag() {
		return activeTag;
	}
	/**
	 * @param activeTag the activeTag to set
	 */
	public void setActiveTag(String activeTag) {
		this.activeTag = activeTag;
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
	 * @return the tranUserId
	 */
	public String getTranUserId() {
		return tranUserId;
	}
	/**
	 * @param tranUserId the tranUserId to set
	 */
	public void setTranUserId(String tranUserId) {
		this.tranUserId = tranUserId;
	}
	/**
	 * @return the userName
	 */
	public String getUserName() {
		return userName;
	}
	/**
	 * @param userName the userName to set
	 */
	public void setUserName(String userName) {
		this.userName = userName;
	}
}
