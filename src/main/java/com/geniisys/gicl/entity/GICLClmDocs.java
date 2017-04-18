/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.giac.entity
	File Name: GICLClmDocs.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 9, 2011
	Description: 
*/


package com.geniisys.gicl.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLClmDocs extends BaseEntity{
	private String lineCd;
	private String sublineCd;
	private String clmDocCd;
	private String clmDocDesc;
	private String clmDocRemarks;
	private String priorityCd;
	
	private Date docCmpltdDt; 
	private String clmDocRemark;
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getSublineCd() {
		return sublineCd;
	}
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	public String getClmDocCd() {
		return clmDocCd;
	}
	public void setClmDocCd(String clmDocCd) {
		this.clmDocCd = clmDocCd;
	}
	public String getClmDocDesc() {
		return clmDocDesc;
	}
	public void setClmDocDesc(String clmDocDesc) {
		this.clmDocDesc = clmDocDesc;
	}
	public String getClmDocRemarks() {
		return clmDocRemarks;
	}
	public void setClmDocRemarks(String clmDocRemarks) {
		this.clmDocRemarks = clmDocRemarks;
	}
	public String getPriorityCd() {
		return priorityCd;
	}
	public void setPriorityCd(String priorityCd) {
		this.priorityCd = priorityCd;
	}
	public Date getDocCmpltdDt() {
		return docCmpltdDt;
	}
	public void setDocCmpltdDt(Date docCmpltdDt) {
		this.docCmpltdDt = docCmpltdDt;
	}
	public String getClmDocRemark() {
		return clmDocRemark;
	}
	public void setClmDocRemark(String clmDocRemark) {
		this.clmDocRemark = clmDocRemark;
	}
}
