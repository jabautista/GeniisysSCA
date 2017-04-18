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
 * The Class GIISMCMake.
 */
public class GIISMCMake extends BaseEntity {

	/** The make cd. */
	private Integer makeCd;
	
	/** The make. */
	private String make;
	
	/** The car company cd. */
	private Integer carCompanyCd;
	
	/** The subline cd. */
	private String sublineCd;
	
	/** The remarks. */
	private String remarks;
	
	/** The cpi rec no. */
	private Integer cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;
	
	/** The no of pass. */
	private Integer noOfPass;
	
	private String carCompany;
	
	private String dspLastUpdate;
	
	private String sublineName;

	/**
	 * Gets the make cd.
	 * 
	 * @return the make cd
	 */
	public Integer getMakeCd() {
		return makeCd;
	}

	/**
	 * Sets the make cd.
	 * 
	 * @param makeCd the new make cd
	 */
	public void setMakeCd(Integer makeCd) {
		this.makeCd = makeCd;
	}

	/**
	 * Gets the make.
	 * 
	 * @return the make
	 */
	public String getMake() {
		return make;
	}

	/**
	 * Sets the make.
	 * 
	 * @param make the new make
	 */
	public void setMake(String make) {
		this.make = make;
	}

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
	 * Gets the subline cd.
	 * 
	 * @return the subline cd
	 */
	public String getSublineCd() {
		return sublineCd;
	}

	/**
	 * Sets the subline cd.
	 * 
	 * @param sublineCd the new subline cd
	 */
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
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
	 * Gets the no of pass.
	 * 
	 * @return the no of pass
	 */
	public Integer getNoOfPass() {
		return noOfPass;
	}

	/**
	 * Sets the no of pass.
	 * 
	 * @param noOfPass the new no of pass
	 */
	public void setNoOfPass(Integer noOfPass) {
		this.noOfPass = noOfPass;
	}

	public String getCarCompany() {
		return carCompany;
	}

	public void setCarCompany(String carCompany) {
		this.carCompany = carCompany;
	}

	public String getDspLastUpdate() {
		return dspLastUpdate;
	}

	public void setDspLastUpdate(String dspLastUpdate) {
		this.dspLastUpdate = dspLastUpdate;
	}

	public String getSublineName() {
		return sublineName;
	}

	public void setSublineName(String sublineName) {
		this.sublineName = sublineName;
	}	
}
