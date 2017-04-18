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
 * The Class GIPIWOpenPeril.
 */
public class GIPIWOpenPeril extends BaseEntity{

	/** The par id. */
	private int parId;
	
	/** The geog cd. */
	private int geogCd;
	
	/** The peril cd. */
	private int perilCd;
	
	/** The line cd. */
	private String lineCd;
	
	/** The peril name. */
	private String perilName;
	
	/** The premium rate. */
	private Double premiumRate;
	//private BigDecimal premiumRate;
	//changed premiumRate datatype to Double due to errors encountered when saving very small decimal
	//to the database(e.g. 0.000000005) when Bigdecimal was used. -darwin
	
	/** The remarks. */
	private String remarks;
	
	/** The rec flag. */
	private String recFlag;
	
	private String perilType;
	private String basicPerilCd;
	
	public String getPerilType() {
		return perilType;
	}

	public void setPerilType(String perilType) {
		this.perilType = perilType;
	}

	public String getBasicPerilCd() {
		return basicPerilCd;
	}

	public void setBasicPerilCd(String basicPerilCd) {
		this.basicPerilCd = basicPerilCd;
	}

	/**
	 * Instantiates a new gIPIW open peril.
	 */
	public GIPIWOpenPeril() {
		
	}

	/**
	 * Instantiates a new gIPIW open peril.
	 * 
	 * @param parId the par id
	 * @param geogCd the geog cd
	 * @param perilCd the peril cd
	 * @param lineCd the line cd
	 * @param perilName the peril name
	 * @param premiumRate the premium rate
	 * @param remarks the remarks
	 * @param recFlag the rec flag
	 */
	public GIPIWOpenPeril(int parId, int geogCd, int perilCd, String lineCd, String perilName,
			Double premiumRate, String remarks, String recFlag, String perilType, String basicPerilCd) {
		this.parId = parId;
		this.geogCd = geogCd;
		this.perilCd = perilCd;
		this.lineCd = lineCd;
		this.perilName = perilName;
		this.premiumRate = premiumRate;
		this.remarks = remarks;
		this.recFlag = recFlag;
		this.basicPerilCd = basicPerilCd;
		this.perilType = perilType;
	}

	/**
	 * Gets the peril cd.
	 * 
	 * @return the peril cd
	 */
	public int getPerilCd() {
		return perilCd;
	}

	/**
	 * Sets the peril cd.
	 * 
	 * @param perilCd the new peril cd
	 */
	public void setPerilCd(int perilCd) {
		this.perilCd = perilCd;
	}

	/**
	 * Gets the peril name.
	 * 
	 * @return the peril name
	 */
	public String getPerilName() {
		return perilName;
	}

	/**
	 * Sets the peril name.
	 * 
	 * @param perilName the new peril name
	 */
	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}

	/**
	 * Gets the premium rate.
	 * 
	 * @return the premium rate
	 */
	public Double getPremiumRate() {
		return premiumRate;
	}

	/**
	 * Sets the premium rate.
	 * 
	 * @param premiumRate the new premium rate
	 */
	public void setPremiumRate(Double premiumRate) {
		this.premiumRate = premiumRate;
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
	 * Gets the geog cd.
	 * 
	 * @return the geog cd
	 */
	public int getGeogCd() {
		return geogCd;
	}

	/**
	 * Sets the geog cd.
	 * 
	 * @param geogCd the new geog cd
	 */
	public void setGeogCd(int geogCd) {
		this.geogCd = geogCd;
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
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public int getParId() {
		return parId;
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
	 * Gets the line cd.
	 * 
	 * @return the line cd
	 */
	public String getLineCd() {
		return lineCd;
	}
	
}
