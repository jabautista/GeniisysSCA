/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.entity
	File Name: GICLDrvrOccptn.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Sep 14, 2011
	Description: 
*/


package com.geniisys.gicl.entity;

import com.geniisys.framework.util.BaseEntity;

public class GICLDrvrOccptn extends BaseEntity{
	private String drvrOccCd;
	private String occDesc;
	private String remarks;
	
	public String getDrvrOccCd() {
		return drvrOccCd;
	}
	public void setDrvrOccCd(String drvrOccCd) {
		this.drvrOccCd = drvrOccCd;
	}
	public String getOccDesc() {
		return occDesc;
	}
	public void setOccDesc(String occDesc) {
		this.occDesc = occDesc;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	
}
