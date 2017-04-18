package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISLineSublineCoverages extends BaseEntity{
	private String 	lineCd;
	private String 	packLineCd;
	private String 	packSublineCd;
	private String 	requiredFlag;
	private String 	remarks;
	private String 	cpiRecNo;
	private String 	cpiBranchCd;
	
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getPackLineCd() {
		return packLineCd;
	}
	public void setPackLineCd(String packLineCd) {
		this.packLineCd = packLineCd;
	}
	public String getPackSublineCd() {
		return packSublineCd;
	}
	public void setPackSublineCd(String packSublineCd) {
		this.packSublineCd = packSublineCd;
	}
	public String getRequiredFlag() {
		return requiredFlag;
	}
	public void setRequiredFlag(String requiredFlag) {
		this.requiredFlag = requiredFlag;	
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
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
