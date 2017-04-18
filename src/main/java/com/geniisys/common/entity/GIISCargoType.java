/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIISCargoType.
 */
public class GIISCargoType extends BaseEntity{
	
	private int cargoClassCd;
	private String cargoType;
	private String cargoTypeDesc;
	private String remarks;
	private String cpiRecNo;
	private String cpiBranchCd;
	/**
	 * @return the cargoClassCd
	 */
	public int getCargoClassCd() {
		return cargoClassCd;
	}
	/**
	 * @param cargoClassCd the cargoClassCd to set
	 */
	public void setCargoClassCd(int cargoClassCd) {
		this.cargoClassCd = cargoClassCd;
	}
	/**
	 * @return the cargoType
	 */
	public String getCargoType() {
		return cargoType;
	}
	/**
	 * @param cargoType the cargoType to set
	 */
	public void setCargoType(String cargoType) {
		this.cargoType = cargoType;
	}
	/**
	 * @return the cargoTypeDesc
	 */
	public String getCargoTypeDesc() {
		return cargoTypeDesc;
	}
	/**
	 * @param cargoTypeDesc the cargoTypeDesc to set
	 */
	public void setCargoTypeDesc(String cargoTypeDesc) {
		this.cargoTypeDesc = cargoTypeDesc;
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