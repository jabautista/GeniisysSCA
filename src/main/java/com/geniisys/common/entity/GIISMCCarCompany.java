/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;




/**
 * The Class GIISMCCarCompany.
 */
public class GIISMCCarCompany extends BaseEntity {

	/** The car company cd. */
	private Integer carCompanyCd;
	
	/** The car company. */
	private String carCompany;
	
	/** The cpi rec no. */
	private Integer cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;
	
	/** The remarks. */
	private String remarks;

	/**
	 * Gets the car company cd.
	 * 
	 * @return the car company cd
	 */
	public Integer getCarCompanyCd() {
		return carCompanyCd;
	}

	/**
	 * Sets the car company cd.
	 * 
	 * @param carCompanyCd the new car company cd
	 */
	public void setCarCompanyCd(Integer carCompanyCd) {
		this.carCompanyCd = carCompanyCd;
	}

	/**
	 * Gets the car company.
	 * 
	 * @return the car company
	 */
	public String getCarCompany() {
		return carCompany;
	}

	/**
	 * Sets the car company.
	 * 
	 * @param carCompany the new car company
	 */
	public void setCarCompany(String carCompany) {
		this.carCompany = carCompany;
	}

	/**
	 * Gets the cpi rec no.
	 * 
	 * @return the cpi rec no
	 */
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	/**
	 * Sets the cpi rec no.
	 * 
	 * @param cpiRecNo the new cpi rec no
	 */
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	/**
	 * Gets the cpi branch cd.
	 * 
	 * @return the cpi branch cd
	 */
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	/**
	 * Sets the cpi branch cd.
	 * 
	 * @param cpiBranchCd the new cpi branch cd
	 */
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	/**
	 * Gets the remarks.
	 * 
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * Sets the remarks.
	 * 
	 * @param remarks the new remarks
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
}
