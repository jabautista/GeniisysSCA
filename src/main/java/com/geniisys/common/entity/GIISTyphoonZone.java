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
 * The Class GIISTyphoonZone.
 */
public class GIISTyphoonZone extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 9080775489983846595L;

	/** The typhoon zone. */
	private String typhoonZone;
	
	/** The typhoon zone desc. */
	private String typhoonZoneDesc;
	
	/** The remarks. */
	private String remarks;
	
	/** The cpi rec no. */
	private String cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;
	
	/** The zone grp. */
	private String zoneGrp;

	/**
	 * Gets the typhoon zone.
	 * 
	 * @return the typhoon zone
	 */
	public String getTyphoonZone() {
		return typhoonZone;
	}

	/**
	 * Sets the typhoon zone.
	 * 
	 * @param typhoonZone the new typhoon zone
	 */
	public void setTyphoonZone(String typhoonZone) {
		this.typhoonZone = typhoonZone;
	}

	/**
	 * Gets the typhoon zone desc.
	 * 
	 * @return the typhoon zone desc
	 */
	public String getTyphoonZoneDesc() {
		return typhoonZoneDesc;
	}

	/**
	 * Sets the typhoon zone desc.
	 * 
	 * @param typhoonZoneDesc the new typhoon zone desc
	 */
	public void setTyphoonZoneDesc(String typhoonZoneDesc) {
		this.typhoonZoneDesc = typhoonZoneDesc;
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
	public String getCpiRecNo() {
		return cpiRecNo;
	}

	/**
	 * Sets the cpi rec no.
	 * 
	 * @param cpiRecNo the new cpi rec no
	 */
	public void setCpiRecNo(String cpiRecNo) {
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
	 * Gets the zone grp.
	 * 
	 * @return the zone grp
	 */
	public String getZoneGrp() {
		return zoneGrp;
	}

	/**
	 * Sets the zone grp.
	 * 
	 * @param zoneGrp the new zone grp
	 */
	public void setZoneGrp(String zoneGrp) {
		this.zoneGrp = zoneGrp;
	}

}
