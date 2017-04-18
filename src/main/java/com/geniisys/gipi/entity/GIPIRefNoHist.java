package com.geniisys.gipi.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIPIRefNoHist extends BaseEntity{

	private String acctIssCd;
	private String branchCd;
	private String refNo;
	private String modNo;
	private String remarks;
	private String bankRefNo;
	
	public String getAcctIssCd() {
		return acctIssCd;
	}
	public void setAcctIssCd(String acctIssCd) {
		this.acctIssCd = acctIssCd;
	}
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	public String getRefNo() {
		return refNo;
	}
	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}
	public String getModNo() {
		return modNo;
	}
	public void setModNo(String modNo) {
		this.modNo = modNo;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getBankRefNo() {
		return bankRefNo;
	}
	public void setBankRefNo(String bankRefNo) {
		this.bankRefNo = bankRefNo;
	}
	
}
