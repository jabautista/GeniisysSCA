package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISVessClass extends BaseEntity{
	private Integer vessClassCd;
	private String 	vessClassDesc;
	private String  remarks;
	private Integer cpiRecNo;
	private String  cpiBranchCd;
	/**
	 * @return the vessClassCd
	 */
	public Integer getVessClassCd() {
		return vessClassCd;
	}
	/**
	 * @param vessClassCd the vessClassCd to set
	 */
	public void setVessClassCd(Integer vessClassCd) {
		this.vessClassCd = vessClassCd;
	}
	/**
	 * @return the vessClassDesc
	 */
	public String getVessClassDesc() {
		return vessClassDesc;
	}
	/**
	 * @param vessClassDesc the vessClassDesc to set
	 */
	public void setVessClassDesc(String vessClassDesc) {
		this.vessClassDesc = vessClassDesc;
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
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	/**
	 * @param cpiRecNo the cpiRecNo to set
	 */
	public void setCpiRecNo(Integer cpiRecNo) {
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
