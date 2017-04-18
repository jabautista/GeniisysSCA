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
 * The Class GIISMCEngineSeries.
 */
public class GIISMCEngineSeries extends BaseEntity {

	/** The make cd. */
	private int makeCd;
	
	/** The series cd. */
	private int seriesCd;
	
	/** The engine series. */
	private String engineSeries;
	
	/** The cpi rec no. */
	private Integer cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;
	
	/** The remarks. */
	private String remarks;
	
	/** The car company cd. */
	private Integer carCompanyCd;
	
	private String carCompany;
	
	private String make;

	/**
	 * Gets the make cd.
	 * 
	 * @return the make cd
	 */
	public int getMakeCd() {
		return makeCd;
	}

	/**
	 * Sets the make cd.
	 * 
	 * @param makeCd the new make cd
	 */
	public void setMakeCd(int makeCd) {
		this.makeCd = makeCd;
	}

	/**
	 * Gets the series cd.
	 * 
	 * @return the series cd
	 */
	public int getSeriesCd() {
		return seriesCd;
	}

	/**
	 * Sets the series cd.
	 * 
	 * @param seriesCd the new series cd
	 */
	public void setSeriesCd(int seriesCd) {
		this.seriesCd = seriesCd;
	}

	/**
	 * Gets the engine series.
	 * 
	 * @return the engine series
	 */
	public String getEngineSeries() {
		return engineSeries;
	}

	/**
	 * Sets the engine series.
	 * 
	 * @param engineSeries the new engine series
	 */
	public void setEngineSeries(String engineSeries) {
		this.engineSeries = engineSeries;
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

	public String getCarCompany() {
		return carCompany;
	}

	public void setCarCompany(String carCompany) {
		this.carCompany = carCompany;
	}

	public String getMake() {
		return make;
	}

	public void setMake(String make) {
		this.make = make;
	}	
}
