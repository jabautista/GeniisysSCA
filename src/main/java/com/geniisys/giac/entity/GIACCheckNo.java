package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACCheckNo extends BaseEntity{

	private String fundCd;
	private String branchCd;
	private String bankCd;
	private String bankAcctCd;
	private Double checkSeqNo;
	private String chkPrefix;
	private String remarks;
	private String inUse;
	private Double oldCheckSeqNo;
	
	public String getFundCd() {
		return fundCd;
	}
	
	public void setFundCd(String fundCd) {
		this.fundCd = fundCd;
	}
	
	public String getBranchCd() {
		return branchCd;
	}
	
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	
	public String getBankCd() {
		return bankCd;
	}
	
	public void setBankCd(String bankCd) {
		this.bankCd = bankCd;
	}
	
	public String getBankAcctCd() {
		return bankAcctCd;
	}
	
	public void setBankAcctCd(String bankAcctCd) {
		this.bankAcctCd = bankAcctCd;
	}
	
	public Double getCheckSeqNo() {
		return checkSeqNo;
	}
	
	public void setCheckSeqNo(Double checkSeqNo) {
		this.checkSeqNo = checkSeqNo;
	}
	
	public String getChkPrefix() {
		return chkPrefix;
	}
	
	public void setChkPrefix(String chkPrefix) {
		this.chkPrefix = chkPrefix;
	}
	
	public String getRemarks() {
		return remarks;
	}
	
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getInUse() {
		return inUse;
	}

	public void setInUse(String inUse) {
		this.inUse = inUse;
	}

	public Double getOldCheckSeqNo() {
		return oldCheckSeqNo;
	}

	public void setOldCheckSeqNo(Double oldCheckSeqNo) {
		this.oldCheckSeqNo = oldCheckSeqNo;
	}
	
}
