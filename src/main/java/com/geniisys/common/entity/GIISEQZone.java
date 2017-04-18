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
 * The Class GIISEQZone.
 */
public class GIISEQZone extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -734830049127263262L;
	
	/** The eq zone. */
	private String eqZone;
	
	/** The eq desc. */
	private String eqDesc;
	
	/** The remarks. */
	private String remarks;
	
	/** The zone grp. */
	private String zoneGrp;
	
	/**
	 * Gets the eq zone.
	 * 
	 * @return the eq zone
	 */
	public String getEqZone() {
		return eqZone;
	}

	/**
	 * Sets the eq zone.
	 * 
	 * @param eqZone the new eq zone
	 */
	public void setEqZone(String eqZone) {
		this.eqZone = eqZone;
	}

	/**
	 * Gets the eq desc.
	 * 
	 * @return the eq desc
	 */
	public String getEqDesc() {
		return eqDesc;
	}

	/**
	 * Sets the eq desc.
	 * 
	 * @param eqDesc the new eq desc
	 */
	public void setEqDesc(String eqDesc) {
		this.eqDesc = eqDesc;
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
