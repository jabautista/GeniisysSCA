/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;


import java.util.Date;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIISTariffZone.
 */
public class GIISTariffZone extends BaseEntity{
	
	/** The tariff zone. */
	private String tariffZone;
	
	/** The tariff zone desc. */
	private String tariffZoneDesc;
	
	/** The line cd. */
	private String lineCd;
	
	/** The subline cd. */
	private String sublineCd;
	
	/** The remarks. */
	private String remarks;	
	
	/** The user id. */
	private String userId;
	
	/** The last update. */
	private Date lastUpdate;	
	
	/** The cpi rec no. */
	private Integer cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;	
	
	/** The tariff cd. */
	private String tariffCd;

	/**
	 * Gets the tariff zone.
	 * 
	 * @return the tariff zone
	 */
	public String getTariffZone() {
		return tariffZone;
	}

	/**
	 * Sets the tariff zone.
	 * 
	 * @param tariffZone the new tariff zone
	 */
	public void setTariffZone(String tariffZone) {
		this.tariffZone = tariffZone;
	}
	
	/**
	 * Gets the tariff zone desc.
	 * 
	 * @return the tariff zone desc
	 */
	public String getTariffZoneDesc() {
		return tariffZoneDesc;
	}

	/**
	 * Sets the tariff zone desc.
	 * 
	 * @param tariffZoneDesc the new tariff zone desc
	 */
	public void setTariffZoneDesc(String tariffZoneDesc) {
		this.tariffZoneDesc = tariffZoneDesc;
	}

	/**
	 * Gets the line cd.
	 * 
	 * @return the line cd
	 */
	public String getLineCd() {
		return lineCd;
	}

	/**
	 * Sets the line cd.
	 * 
	 * @param lineCd the new line cd
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
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

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#getUserId()
	 */
	@Override
	public String getUserId() {
		return userId;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#setUserId(java.lang.String)
	 */
	@Override
	public void setUserId(String userId) {
		this.userId = userId;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#getLastUpdate()
	 */
	@Override
	public Date getLastUpdate() {
		return lastUpdate;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#setLastUpdate(java.util.Date)
	 */
	@Override
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
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

}
