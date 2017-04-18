package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISIntmType extends BaseEntity{
	private String 	intmType;
	private String 	intmDesc;
	private Integer acctIntmCd;
	private String 	remarks;
	private Integer cpiRecNo;
	private String 	cpiBranchCd;
	/**
	 * @return the intmType
	 */
	public String getIntmType() {
		return intmType;
	}
	/**
	 * @param intmType the intmType to set
	 */
	public void setIntmType(String intmType) {
		this.intmType = intmType;
	}
	/**
	 * @return the intmDesc
	 */
	public String getIntmDesc() {
		return intmDesc;
	}
	/**
	 * @param intmDesc the intmDesc to set
	 */
	public void setIntmDesc(String intmDesc) {
		this.intmDesc = intmDesc;
	}
	/**
	 * @return the acctIntmCd
	 */
	public Integer getAcctIntmCd() {
		return acctIntmCd;
	}
	/**
	 * @param acctIntmCd the acctIntmCd to set
	 */
	public void setAcctIntmCd(Integer acctIntmCd) {
		this.acctIntmCd = acctIntmCd;
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
