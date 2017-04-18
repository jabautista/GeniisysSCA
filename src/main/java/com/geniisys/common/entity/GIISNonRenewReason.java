package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

//import com.geniisys.framework.util.BaseEntity;

public class GIISNonRenewReason extends BaseEntity{
	
	private String nonRenReasonCd;
	private String nonRenReasonDesc;
	private String remarks;
//	private String userId;
//	private Date lastUpdate;
	private String lineCd;
	private String activeTag;
	
	public GIISNonRenewReason() {
		super();
	}

	public String getNonRenReasonCd() {
		return nonRenReasonCd;
	}

	public void setNonRenReasonCd(String nonRenReasonCd) {
		this.nonRenReasonCd = nonRenReasonCd;
	}

	public String getNonRenReasonDesc() {
		return nonRenReasonDesc;
	}

	public void setNonRenReasonDesc(String nonRenReasonDesc) {
		this.nonRenReasonDesc = nonRenReasonDesc;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

//	public String getUserId() {
//		return userId;
//	}
//
//	public void setUserId(String userId) {
//		this.userId = userId;
//	}
//
//	public Date getLastUpdate() {
//		return lastUpdate;
//	}
//
//	public void setLastUpdate(Date lastUpdate) {
//		this.lastUpdate = lastUpdate;
//	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getActiveTag() {
		return activeTag;
	}

	public void setActiveTag(String activeTag) {
		this.activeTag = activeTag;
	}

}
