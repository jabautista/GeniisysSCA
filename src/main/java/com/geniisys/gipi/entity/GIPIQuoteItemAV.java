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
 * The Class GIPIQuoteItemAV.
 */
public class GIPIQuoteItemAV extends BaseEntity {

	/** The quote id. */
	private Integer quoteId;
	
	/** The item no. */
	private Integer itemNo;
	
	/** The vessel cd. */
	private String vesselCd;
	
	/** The rec flag. */
	private String recFlag;
	
	/** The fixed wing. */
	private String fixedWing;
	
	/** The rotor. */
	private String rotor;
	
	/** The purpose. */
	private String purpose;
	
	/** The deduct text. */
	private String deductText;
	
	/** The prev util hrs. */
	private Integer prevUtilHrs;
	
	/** The est util hrs. */
	private Integer estUtilHrs;
	
	/** The total fly time. */
	private Integer totalFlyTime;
	
	/** The qualification. */
	private String qualification;
	
	/** The geog limit. */
	private String geogLimit;

	/**
	 * Gets the quote id.
	 * @return the quote id
	 */
	public Integer getQuoteId() {
		return quoteId;
	}

	/**
	 * Sets the quote id.
	 * 
	 * @param quoteId the new quote id
	 */
	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}

	/**
	 * Gets the item no.
	 * 
	 * @return the item no
	 */
	public Integer getItemNo() {
		return itemNo;
	}

	/**
	 * Sets the item no.
	 * 
	 * @param itemNo the new item no
	 */
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
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
	 * Gets the fixed wing.
	 * 
	 * @return the fixed wing
	 */
	public String getFixedWing() {
		return fixedWing;
	}

	/**
	 * Sets the fixed wing.
	 * 
	 * @param fixedWing the new fixed wing
	 */
	public void setFixedWing(String fixedWing) {
		this.fixedWing = fixedWing;
	}

	/**
	 * Gets the rotor.
	 * 
	 * @return the rotor
	 */
	public String getRotor() {
		return rotor;
	}

	/**
	 * Sets the rotor.
	 * 
	 * @param rotor the new rotor
	 */
	public void setRotor(String rotor) {
		this.rotor = rotor;
	}

	/**
	 * Gets the purpose.
	 * 
	 * @return the purpose
	 */
	public String getPurpose() {
		return purpose;
	}

	/**
	 * Sets the purpose.
	 * 
	 * @param purpose the new purpose
	 */
	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}

	/**
	 * Gets the deduct text.
	 * 
	 * @return the deduct text
	 */
	public String getDeductText() {
		return deductText;
	}

	/**
	 * Sets the deduct text.
	 * 
	 * @param deductText the new deduct text
	 */
	public void setDeductText(String deductText) {
		this.deductText = deductText;
	}

	/**
	 * Gets the est util hrs.
	 * 
	 * @return the est util hrs
	 */
	public Integer getEstUtilHrs() {
		return estUtilHrs;
	}

	/**
	 * Sets the est util hrs.
	 * 
	 * @param estUtilHrs the new est util hrs
	 */
	public void setEstUtilHrs(Integer estUtilHrs) {
		this.estUtilHrs = estUtilHrs;
	}

	/**
	 * Gets the total fly time.
	 * 
	 * @return the total fly time
	 */
	public Integer getTotalFlyTime() {
		return totalFlyTime;
	}

	/**
	 * Sets the total fly time.
	 * 
	 * @param totalFlyTime the new total fly time
	 */
	public void setTotalFlyTime(Integer totalFlyTime) {
		this.totalFlyTime = totalFlyTime;
	}

	/**
	 * Gets the qualification.
	 * 
	 * @return the qualification
	 */
	public String getQualification() {
		return qualification;
	}

	/**
	 * Sets the qualification.
	 * 
	 * @param qualification the new qualification
	 */
	public void setQualification(String qualification) {
		this.qualification = qualification;
	}

	/**
	 * Gets the geog limit.
	 * 
	 * @return the geog limit
	 */
	public String getGeogLimit() {
		return geogLimit;
	}

	/**
	 * Sets the geog limit.
	 * 
	 * @param geogLimit the new geog limit
	 */
	public void setGeogLimit(String geogLimit) {
		this.geogLimit = geogLimit;
	}

	/**
	 * Gets the prev util hrs.
	 * 
	 * @return the prev util hrs
	 */
	public Integer getPrevUtilHrs() {
		return prevUtilHrs;
	}

	/**
	 * Sets the prev util hrs.
	 * 
	 * @param prevUtilHrs the new prev util hrs
	 */
	public void setPrevUtilHrs(Integer prevUtilHrs) {
		this.prevUtilHrs = prevUtilHrs;
	}

}
