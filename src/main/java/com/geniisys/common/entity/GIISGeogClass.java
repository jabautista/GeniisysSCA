package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISGeogClass extends BaseEntity{
	private String geogCd;
	private String geogDesc;
	private String classType;
	private String sublineCd;
	private String remarks;
	private String lineCd;
	private String cpiRecNo;
	private String cpiBranchCd;
	
	public String getGeogCd() {
		return geogCd;
	}
	public void setGeogCd(String geogCd) {
		this.geogCd = geogCd;
	}
	public String getGeogDesc() {
		return geogDesc;
	}
	public void setGeogDesc(String geogDesc) {
		this.geogDesc = geogDesc;
	}
	public String getClassType() {
		return classType;
	}
	public void setClassType(String classType) {
		this.classType = classType;
	}
	public String getSublineCd() {
		return sublineCd;
	}
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getCpiRecNo() {
		return cpiRecNo;
	}
	public void setCpiRecNo(String cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}	
}
