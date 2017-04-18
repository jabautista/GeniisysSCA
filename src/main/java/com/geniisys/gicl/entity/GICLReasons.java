package com.geniisys.gicl.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GICLReasons extends BaseEntity{
	private String reasonCd;
	private String reasonDesc;
	private String clmStatCd;
	private String remarks;
		
	public GICLReasons() {
	}
	
	public String getReasonCd() {
		return reasonCd;
	}
	public void setReasonCd(String reasonCd) {
		this.reasonCd = reasonCd;
	}
	public String getReasonDesc() {
		return reasonDesc;
	}
	public void setReasonDesc(String reasonDesc) {
		this.reasonDesc = reasonDesc;
	}
	public String getClmStatCd() {
		return clmStatCd;
	}
	public void setClmStatCd(String clmStatCd) {
		this.clmStatCd = clmStatCd;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}	
}
