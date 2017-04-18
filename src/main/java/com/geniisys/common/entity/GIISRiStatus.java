package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISRiStatus extends BaseEntity{	
	private String statusCd;
	private String statusDesc;
	private String remarks;
	private String cpiRecNo;
	private String cpiBranchCd;
	/**
	 * @return the statusCd
	 */
	public String getStatusCd() {
		return statusCd;
	}
	/**
	 * @param statusCd the statusCd to set
	 */
	public void setStatusCd(String statusCd) {
		this.statusCd = statusCd;
	}
	/**
	 * @return the statusDesc
	 */
	public String getStatusDesc() {
		return statusDesc;
	}
	/**
	 * @param statusDesc the statusDesc to set
	 */
	public void setStatusDesc(String statusDesc) {
		this.statusDesc = statusDesc;
	}
	/**
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}
	/**
	 * @param remarks the remarks to set
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	/**
	 * @return the cpiRecNo
	 */
	public String getCpiRecNo() {
		return cpiRecNo;
	}
	/**
	 * @param cpiRecNo the cpiRecNo to set
	 */
	public void setCpiRecNo(String cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	/**
	 * @return the cpiBranchCd
	 */
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	/**
	 * @param cpiBranchCd the cpiBranchCd to set
	 */
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
}
