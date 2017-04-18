/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIISTariff.
 */
public class GIISTariff extends BaseEntity {

	/** The tariff cd. */
	private String tariffCd;
	
	/** The tariff desc. */
	private String tariffDesc;
	
	/** The tariff rate. */
	private BigDecimal tariffRate;
	
	/** The tariff remarks. */
	private String tariffRemarks;
	
	/** The remarks. */
	private String remarks;
	
	/** The cpi rec no. */
	private Integer cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;
	
	private String occupancyCd;
	
	private String tariffZone;
	
	private String occupancyDesc;
	
	private String tariffZoneDesc;
	
	private String dspLastUpdate;

	/**
	 * Gets the tariff cd.
	 * 
	 * @return the tariff cd
	 */
	public String getTariffCd() {
		return tariffCd;
	}

	/**
	 * Sets the tariff cd.
	 * 
	 * @param tariffCd the new tariff cd
	 */
	public void setTariffCd(String tariffCd) {
		this.tariffCd = tariffCd;
	}

	/**
	 * Gets the tariff desc.
	 * 
	 * @return the tariff desc
	 */
	public String getTariffDesc() {
		return tariffDesc;
	}

	/**
	 * Sets the tariff desc.
	 * 
	 * @param tariffDesc the new tariff desc
	 */
	public void setTariffDesc(String tariffDesc) {
		this.tariffDesc = tariffDesc;
	}

	/**
	 * Gets the tariff rate.
	 * 
	 * @return the tariff rate
	 */
	public BigDecimal getTariffRate() {
		return tariffRate;
	}

	/**
	 * Sets the tariff rate.
	 * 
	 * @param tariffRate the new tariff rate
	 */
	public void setTariffRate(BigDecimal tariffRate) {
		this.tariffRate = tariffRate;
	}

	/**
	 * Gets the tariff remarks.
	 * 
	 * @return the tariff remarks
	 */
	public String getTariffRemarks() {
		return tariffRemarks;
	}

	/**
	 * Sets the tariff remarks.
	 * 
	 * @param tariffRemarks the new tariff remarks
	 */
	public void setTariffRemarks(String tariffRemarks) {
		this.tariffRemarks = tariffRemarks;
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

	public String getOccupancyCd() {
		return occupancyCd;
	}

	public void setOccupancyCd(String occupancyCd) {
		this.occupancyCd = occupancyCd;
	}

	public String getTariffZone() {
		return tariffZone;
	}

	public void setTariffZone(String tariffZone) {
		this.tariffZone = tariffZone;
	}

	public String getOccupancyDesc() {
		return occupancyDesc;
	}

	public void setOccupancyDesc(String occupancyDesc) {
		this.occupancyDesc = occupancyDesc;
	}

	public String getTariffZoneDesc() {
		return tariffZoneDesc;
	}

	public void setTariffZoneDesc(String tariffZoneDesc) {
		this.tariffZoneDesc = tariffZoneDesc;
	}

	public String getDspLastUpdate() {
		return dspLastUpdate;
	}

	public void setDspLastUpdate(String dspLastUpdate) {
		this.dspLastUpdate = dspLastUpdate;
	}	
}
