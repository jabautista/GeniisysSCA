/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.common.entity
	File Name: GIISNationality.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Sep 14, 2011
	Description: 
*/


package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

//import com.geniisys.framework.util.BaseEntity;

public class GIISNationality extends BaseEntity{
	private String nationalityCd;
	private String nationalityDesc;
	private String remarks;
	
	public String getNationalityCd() {
		return nationalityCd;
	}
	public void setNationalityCd(String nationalityCd) {
		this.nationalityCd = nationalityCd;
	}
	public String getNationalityDesc() {
		return nationalityDesc;
	}
	public void setNationalityDesc(String nationalityDesc) {
		this.nationalityDesc = nationalityDesc;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	
}
