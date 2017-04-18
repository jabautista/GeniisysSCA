package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;


public class GIISPrincipalSignatory extends BaseEntity {
	
	private String prinSignor;
	private String designation;
	private Integer prinId;
	private String resCert;
	private String issueDate;
	private String issuePlace;
	private String remarks;
	private String address;
	private Integer controlTypeCd;
	private String controlTypeDesc;
	private String bondSw;
	private String indemSw;
	private String ackSw;
	private String certSw;
	private String riSw;
	
	public String getResCert() {
		return resCert;
	}
	public void setResCert(String resCert) {
		this.resCert = resCert;
	}
	public String getIssueDate() {
		return issueDate;
	}
	public void setIssueDate(String issueDate) {
		this.issueDate = issueDate;
	}
	public String getIssuePlace() {
		return issuePlace;
	}
	public void setIssuePlace(String issuePlace) {
		this.issuePlace = issuePlace;
	}
	public String getPrinSignor() {
		return prinSignor;
	}
	public void setPrinSignor(String prinSignor) {
		this.prinSignor = prinSignor;
	}
	public String getDesignation() {
		return designation;
	}
	public void setDesignation(String designation) {
		this.designation = designation;
	}
	public Integer getPrinId() {
		return prinId;
	}
	public void setPrinId(Integer prinId) {
		this.prinId = prinId;
	}
	/**
	 * @param remarks the remarks to set
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	/**
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}
	/**
	 * @param address the address to set
	 */
	public void setAddress(String address) {
		this.address = address;
	}
	/**
	 * @return the address
	 */
	public String getAddress() {
		return address;
	}
	/**
	 * @return the controlTypeCd
	 */
	public Integer getControlTypeCd() {
		return controlTypeCd;
	}
	/**
	 * @param controlTypeCd the controlTypeCd to set
	 */
	public void setControlTypeCd(Integer controlTypeCd) {
		this.controlTypeCd = controlTypeCd;
	}
	/**
	 * @return the controlTypeDesc
	 */
	public String getControlTypeDesc() {
		return controlTypeDesc;
	}
	/**
	 * @param controlTypeDesc the controlTypeDesc to set
	 */
	public void setControlTypeDesc(String controlTypeDesc) {
		this.controlTypeDesc = controlTypeDesc;
	}
	/**
	 * @return the bondSw
	 */
	public String getBondSw() {
		return bondSw;
	}
	/**
	 * @param bondSw the bondSw to set
	 */
	public void setBondSw(String bondSw) {
		this.bondSw = bondSw;
	}
	/**
	 * @return the indemSw
	 */
	public String getIndemSw() {
		return indemSw;
	}
	/**
	 * @param indemSw the indemSw to set
	 */
	public void setIndemSw(String indemSw) {
		this.indemSw = indemSw;
	}
	/**
	 * @return the ackSw
	 */
	public String getAckSw() {
		return ackSw;
	}
	/**
	 * @param ackSw the ackSw to set
	 */
	public void setAckSw(String ackSw) {
		this.ackSw = ackSw;
	}
	/**
	 * @return the certSw
	 */
	public String getCertSw() {
		return certSw;
	}
	/**
	 * @param certSw the certSw to set
	 */
	public void setCertSw(String certSw) {
		this.certSw = certSw;
	}
	/**
	 * @return the riSw
	 */
	public String getRiSw() {
		return riSw;
	}
	/**
	 * @param riSw the riSw to set
	 */
	public void setRiSw(String riSw) {
		this.riSw = riSw;
	}
	
}
