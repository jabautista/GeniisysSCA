package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISRecoveryStatus extends BaseEntity{


	private String recStatCd;
	private String recStatDesc;
	private String remarks;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String recStatType;
	
	public String getRecStatCd() {
		return recStatCd;
	}
	public void setRecStatCd(String recStatCd) {
		this.recStatCd = recStatCd;
	}
	public String getRecStatDesc() {
		return recStatDesc;
	}
	public void setRecStatDesc(String recStatDesc) {
		this.recStatDesc = recStatDesc;
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
	public String getRecStatType() {
		return recStatType;
	}
	public void setRecStatType(String recStatType) {
		this.recStatType = recStatType;
	}
	
}
