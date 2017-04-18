/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class ControlType.
 */
public class ControlType extends BaseEntity {

	/** The control type cd. */
	private int controlTypeCd;
	
	/** The control type desc. */
	private String controlTypeDesc;
	
	/** The remarks. */
	private String remarks;
	
	/**
	 * Gets the control type cd.
	 * 
	 * @return the control type cd
	 */
	public int getControlTypeCd() {
		return controlTypeCd;
	}
	
	/**
	 * Sets the control type cd.
	 * 
	 * @param controlTypeCd the new control type cd
	 */
	public void setControlTypeCd(int controlTypeCd) {
		this.controlTypeCd = controlTypeCd;
	}
	
	/**
	 * Gets the control type desc.
	 * 
	 * @return the control type desc
	 */
	public String getControlTypeDesc() {
		return controlTypeDesc;
	}
	
	/**
	 * Sets the control type desc.
	 * 
	 * @param controlTypeDesc the new control type desc
	 */
	public void setControlTypeDesc(String controlTypeDesc) {
		this.controlTypeDesc = controlTypeDesc;
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
}
