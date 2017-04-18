package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISSpoilageReason extends BaseEntity{

	private String spoilCd;
	private String spoilDesc;
	private String remarks;
	private String activeTag;
	/**
	 * @return the spoilCd
	 */
	public String getSpoilCd() {
		return spoilCd;
	}
	/**
	 * @param spoilCd the spoilCd to set
	 */
	public void setSpoilCd(String spoilCd) {
		this.spoilCd = spoilCd;
	}
	/**
	 * @return the spoilDesc
	 */
	public String getSpoilDesc() {
		return spoilDesc;
	}
	/**
	 * @param spoilDesc the spoilDesc to set
	 */
	public void setSpoilDesc(String spoilDesc) {
		this.spoilDesc = spoilDesc;
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
	public String getActiveTag() {
		return activeTag;
	}
	public void setActiveTag(String activeTag) {
		this.activeTag = activeTag;
	}
	
	
}
