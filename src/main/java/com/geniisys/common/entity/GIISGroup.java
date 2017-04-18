/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;



/**
 * The Class GIISGroup.
 */
public class GIISGroup extends BaseEntity{

	/** The group cd. */
	private int groupCd;
	
	/** The group desc. */
	private String groupDesc;
	
	private String remarks;
	/**
	 * Gets the group cd.
	 * 
	 * @return the group cd
	 */
	public int getGroupCd() {
		return groupCd;
	}
	
	/**
	 * Sets the group cd.
	 * 
	 * @param groupCd the new group cd
	 */
	public void setGroupCd(int groupCd) {
		this.groupCd = groupCd;
	}
	
	/**
	 * Gets the group desc.
	 * 
	 * @return the group desc
	 */
	public String getGroupDesc() {
		return groupDesc;
	}
	
	/**
	 * Sets the group desc.
	 * 
	 * @param groupDesc the new group desc
	 */
	public void setGroupDesc(String groupDesc) {
		this.groupDesc = groupDesc;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
}
