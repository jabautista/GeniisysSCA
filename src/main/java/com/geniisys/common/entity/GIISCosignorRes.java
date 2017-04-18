/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.common.entity
	File Name: GIISCosignorRes.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: May 24, 2011
	Description: 
*/


package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;


public class GIISCosignorRes extends BaseEntity{
	private String cosignName;
	private String designation;
	private Integer cosignId;
	private String cosignResNo;
	private String cosignResDate;
	private String cosignResPlace;
	private String address;
	private Integer controlTypeCd;
	private String controlTypeDesc;
	
	public String getCosignName() {
		return cosignName;
	}
	public void setCosignName(String cosignName) {
		this.cosignName = cosignName;
	}
	public Integer getCosignId() {
		return cosignId;
	}
	public void setCosignId(Integer cosignId) {
		this.cosignId = cosignId;
	}
	public String getCosignResNo() {
		return cosignResNo;
	}
	public void setCosignResNo(String cosignResNo) {
		this.cosignResNo = cosignResNo;
	}
	public String getCosignResDate() {
		return cosignResDate;
	}
	public void setCosignResDate(String cosignResDate) {
		this.cosignResDate = cosignResDate;
	}
	public String getCosignResPlace() {
		return cosignResPlace;
	}
	public void setCosignResPlace(String cosignResPlace) {
		this.cosignResPlace = cosignResPlace;
	}
	private String remarks;
	
	public String getDesignation() {
		return designation;
	}
	public void setDesignation(String designation) {
		this.designation = designation;
	}

	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
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
	
}
