package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACEomCheckingScripts extends BaseEntity {
	
	private Integer eomScriptNo;
	private String eomScriptTitle;
	private String eomScriptText1;
	private String eomScriptText2;
	private String eomScriptSoln;
	private String remarks;
	
	public Integer getEomScriptNo() {
		return eomScriptNo;
	}
	
	public void setEomScriptNo(Integer eomScriptNo) {
		this.eomScriptNo = eomScriptNo;
	}
	
	public String getEomScriptTitle() {
		return eomScriptTitle;
	}
	
	public void setEomScriptTitle(String eomScriptTitle) {
		this.eomScriptTitle = eomScriptTitle;
	}
	
	public String getEomScriptText1() {
		return eomScriptText1;
	}
	
	public void setEomScriptText1(String eomScriptText1) {
		this.eomScriptText1 = eomScriptText1;
	}
	
	public String getEomScriptText2() {
		return eomScriptText2;
	}
	
	public void setEomScriptText2(String eomScriptText2) {
		this.eomScriptText2 = eomScriptText2;
	}
	
	public String getEomScriptSoln() {
		return eomScriptSoln;
	}
	
	public void setEomScriptSoln(String eomScriptSoln) {
		this.eomScriptSoln = eomScriptSoln;
	}
	
	public String getRemarks() {
		return remarks;
	}
	
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
}
