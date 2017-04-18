package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

//import com.geniisys.framework.util.BaseEntity;

public class GIISEndtText extends BaseEntity{

	private String endtId;
	private String endtCd;
	private String endtTitle;
	private String endtText;
	private String remarks;
	private String activeTag;

	public String getEndtId() {
		return endtId;
	}
	public void setEndtId(String endtId) {
		this.endtId = endtId;
	}
	public String getEndtCd() {
		return endtCd;
	}
	public void setEndtCd(String endtCd) {
		this.endtCd = endtCd;
	}
	public String getEndtTitle() {
		return endtTitle;
	}
	public void setEndtTitle(String endtTitle) {
		this.endtTitle = endtTitle;
	}
	public String getEndtText() {
		return endtText;
	}
	public void setEndtText(String endtText) {
		this.endtText = endtText;
	}
	public String getRemarks() {
		return remarks;
	}
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
