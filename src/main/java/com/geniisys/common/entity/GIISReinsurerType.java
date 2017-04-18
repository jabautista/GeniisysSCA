package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISReinsurerType extends BaseEntity{
	
	public String riType;
	public String riTypeDesc;
	public String remarks;
	public Integer cpiRecNo;
	public String cpiBranchCd;
	
	public String getRiType() {
		return riType;
	}
	public void setRiType(String riType) {
		this.riType = riType;
	}
	public String getRiTypeDesc() {
		return riTypeDesc;
	}
	public void setRiTypeDesc(String riTypeDesc) {
		this.riTypeDesc = riTypeDesc;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}	
	
}
