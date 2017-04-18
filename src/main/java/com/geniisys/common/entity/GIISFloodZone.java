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
 * The Class GIISFloodZone.
 */
public class GIISFloodZone extends BaseEntity {

	/** The flood zone. */
	private String floodZone;
	
	/** The flood zone desc. */
	private String floodZoneDesc;
	
	/** The zone grp. */
	private String zoneGrp;
	
	private String remarks;

	/**
	 * Gets the flood zone.
	 * 
	 * @return the flood zone
	 */
	public String getFloodZone() {
		return floodZone;
	}

	/**
	 * Sets the flood zone.
	 * 
	 * @param floodZone the new flood zone
	 */
	public void setFloodZone(String floodZone) {
		this.floodZone = floodZone;
	}

	/**
	 * Gets the flood zone desc.
	 * 
	 * @return the flood zone desc
	 */
	public String getFloodZoneDesc() {
		return floodZoneDesc;
	}

	/**
	 * Sets the flood zone desc.
	 * 
	 * @param floodZoneDesc the new flood zone desc
	 */
	public void setFloodZoneDesc(String floodZoneDesc) {
		this.floodZoneDesc = floodZoneDesc;
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

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

}
