package com.geniisys.common.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIISENPrincipal extends BaseEntity {

	private int principalCd;
	private String principalName;
	private String principalType;
	private String sublineCd;
	private String address1;
	private String address2;
	private String address3;
	private String remarks;
	private int cpiRecNo;
	private String cpiBranchCd;
	private int principalId;

	public int getPrincipalCd() {
		return principalCd;
	}

	public void setPrincipalCd(int principalCd) {
		this.principalCd = principalCd;
	}

	public String getPrincipalName() {
		return principalName;
	}

	public void setPrincipalName(String principalName) {
		this.principalName = principalName;
	}

	public String getPrincipalType() {
		return principalType;
	}

	public void setPrincipalType(String principalType) {
		this.principalType = principalType;
	}

	public String getSublineCd() {
		return sublineCd;
	}

	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	public String getAddress1() {
		return address1;
	}

	public void setAddress1(String address1) {
		this.address1 = address1;
	}

	public String getAddress2() {
		return address2;
	}

	public void setAddress2(String address2) {
		this.address2 = address2;
	}

	public String getAddress3() {
		return address3;
	}

	public void setAddress3(String address3) {
		this.address3 = address3;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public int getCpiRecNo() {
		return cpiRecNo;
	}

	public void setCpiRecNo(int cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	public int getPrincipalId() {
		return principalId;
	}

	public void setPrincipalId(int principalId) {
		this.principalId = principalId;
	}

}
