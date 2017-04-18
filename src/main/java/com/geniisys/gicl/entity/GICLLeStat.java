package com.geniisys.gicl.entity;


import com.geniisys.framework.util.BaseEntity;

public class GICLLeStat extends BaseEntity{
	
	private String leStatCd;
	private String leStatDesc;
	private String remarks;
	
	public String getLeStatCd() {
		return leStatCd;
	}
	public void setLeStatCd(String leStatCd) {
		this.leStatCd = leStatCd;
	}
	public String getLeStatDesc() {
		return leStatDesc;
	}
	public void setLeStatDesc(String leStatDesc) {
		this.leStatDesc = leStatDesc;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	
}
