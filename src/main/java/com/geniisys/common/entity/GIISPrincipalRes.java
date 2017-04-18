/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.common.entity
	File Name: GIISPrincipalRes.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: May 25, 2011
	Description: 
*/


package com.geniisys.common.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIISPrincipalRes extends BaseEntity{
	private Integer assdNo;
	private String principalResNo;
	private String principalResDate;
	private String principalResPlace;
	private Integer controlTypeCd;
	
	public Integer getAssdNo() {
		return assdNo;
	}
	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}
	public String getPrincipalResNo() {
		return principalResNo;
	}
	public void setPrincipalResNo(String principalResNo) {
		this.principalResNo = principalResNo;
	}
	public String getPrincipalResDate() {
		return principalResDate;
	}
	public void setPrincipalResDate(String principalResDate) {
		this.principalResDate = principalResDate;
	}
	
	/**
	 * @param principalResPlace the principalResPlace to set
	 */
	public void setPrincipalResPlace(String principalResPlace) {
		this.principalResPlace = principalResPlace;
	}
	/**
	 * @return the principalResPlace
	 */
	public String getPrincipalResPlace() {
		return principalResPlace;
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
	
}
