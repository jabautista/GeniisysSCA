package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISRecoveryType extends BaseEntity{
	
	private String recTypeCd;
	private String recTypeDesc;
	private String remarks;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	
	public String getRecTypeCd() {
		return recTypeCd;
	}
	public void setRecTypeCd(String recTypeCd) {
		this.recTypeCd = recTypeCd;
	}
	public String getRecTypeDesc() {
		return recTypeDesc;
	}
	public void setRecTypeDesc(String recTypeDesc) {
		this.recTypeDesc = recTypeDesc;
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
