/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.entity;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIWVesAir.
 */
public class GIPIWVesAir extends BaseEntity{

	/** The par id. */
	private int parId;
	
	/** The vessel cd. */
	private String vesselCd;
	
	/** The vessel name. */
	private String vesselName;
	
	/** The vessel flag. */
	private String vesselFlag;
	
	/** The vessel type. */
	private String vesselType;
	
	/** The rec flag. */
	private String recFlag;
	
	/**
	 * Instantiates a new gIPIW ves air.
	 */
	public GIPIWVesAir() {
	}

	/**
	 * Instantiates a new gIPIW ves air.
	 * 
	 * @param parId the par id
	 * @param vesselCd the vessel cd
	 * @param vesselFlag the vessel flag
	 * @param voyLimit the voy limit
	 * @param vesselName the vessel name
	 * @param vesCon the ves con
	 * @param recFlag the rec flag
	 */
	public GIPIWVesAir(int parId, String vesselCd, String vesselFlag,
			String voyLimit, String vesselName, String vesCon, String recFlag) {
		this.parId      = parId;
		this.vesselCd   = vesselCd;
		this.vesselFlag = vesselFlag;
		this.vesselName = vesselName;
		this.recFlag    = recFlag;
	}

	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public int getParId() {
		return parId;
	}

	/**
	 * Sets the par id.
	 * 
	 * @param parId the new par id
	 */
	public void setParId(int parId) {
		this.parId = parId;
	}

	/**
	 * Gets the vessel cd.
	 * 
	 * @return the vessel cd
	 */
	public String getVesselCd() {
		return vesselCd;
	}

	/**
	 * Sets the vessel cd.
	 * 
	 * @param vesselCd the new vessel cd
	 */
	public void setVesselCd(String vesselCd) {
		this.vesselCd = vesselCd;
	}

	/**
	 * Gets the vessel flag.
	 * 
	 * @return the vessel flag
	 */
	public String getVesselFlag() {
		return vesselFlag;
	}

	/**
	 * Sets the vessel flag.
	 * 
	 * @param vesselFlag the new vessel flag
	 */
	public void setVesselFlag(String vesselFlag) {
		this.vesselFlag = vesselFlag;
	}

	/**
	 * Gets the vessel name.
	 * 
	 * @return the vessel name
	 */
	public String getVesselName() {
		return vesselName;
	}

	/**
	 * Sets the vessel name.
	 * 
	 * @param vesselName the new vessel name
	 */
	public void setVesselName(String vesselName) {
		this.vesselName = vesselName;
	}

	/**
	 * Gets the rec flag.
	 * 
	 * @return the rec flag
	 */
	public String getRecFlag() {
		return recFlag;
	}

	/**
	 * Sets the rec flag.
	 * 
	 * @param recFlag the new rec flag
	 */
	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}

	/**
	 * Sets the vessel type.
	 * 
	 * @param vesselType the new vessel type
	 */
	public void setVesselType(String vesselType) {
		this.vesselType = vesselType;
	}

	/**
	 * Gets the vessel type.
	 * 
	 * @return the vessel type
	 */
	public String getVesselType() {
		return vesselType;
	}
				
}
