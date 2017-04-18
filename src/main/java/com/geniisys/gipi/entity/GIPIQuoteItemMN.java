/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIQuoteItemMN.
 */
public class GIPIQuoteItemMN extends BaseEntity {

	/** The quote id. */
	private Integer quoteId;
	
	/** The item no. */
	private Integer itemNo;
	
	/** The geog cd. */
	private Integer geogCd;
	
	/** The geog desc. */
	private String geogDesc;
	
	/** The vessel cd. */
	private String vesselCd;
	
	/** The vessel name. */
	private String vesselName;
	
	/** The cargo class cd. */
	private Integer cargoClassCd;
	
	/** The cargo class desc. */
	private String cargoClassDesc;
	
	/** The cargo type. */
	private String cargoType;
	
	/** The cargo type desc. */
	private String cargoTypeDesc;
	
	/** The pack method. */
	private String packMethod;
	
	/** The bl awb. */
	private String blAwb;
	
	/** The tranship origin. */
	private String transhipOrigin;
	
	/** The tranship destination. */
	private String transhipDestination;
	
	/** The voyage no. */
	private String voyageNo;
	
	/** The lc no. */
	private String lcNo;
	
	/** The etd. */
	private Date etd;
	
	/** The eta. */
	private Date eta;
	
	/** The print tag. */
	private Integer printTag;
	
	/** The print tag desc. */
	private String printTagDesc;
	
	/** The origin. */
	private String origin;
	
	/** The destn. */
	private String destn;

	/**
	 * Gets the quote id.
	 * 
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
	 * Gets the geog cd.
	 * 
	 * @return the geog cd
	 */
	public Integer getGeogCd() {
		return geogCd;
	}

	/**
	 * Sets the geog cd.
	 * 
	 * @param geogCd the new geog cd
	 */
	public void setGeogCd(Integer geogCd) {
		this.geogCd = geogCd;
	}

	/**
	 * Gets the geog desc.
	 * 
	 * @return the geog desc
	 */
	public String getGeogDesc() {
		return geogDesc;
	}

	/**
	 * Sets the geog desc.
	 * 
	 * @param geogDesc the new geog desc
	 */
	public void setGeogDesc(String geogDesc) {
		this.geogDesc = geogDesc;
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
	 * Gets the cargo class cd.
	 * 
	 * @return the cargo class cd
	 */
	public Integer getCargoClassCd() {
		return cargoClassCd;
	}

	/**
	 * Sets the cargo class cd.
	 * 
	 * @param cargoClassCd the new cargo class cd
	 */
	public void setCargoClassCd(Integer cargoClassCd) {
		this.cargoClassCd = cargoClassCd;
	}

	/**
	 * Gets the cargo class desc.
	 * 
	 * @return the cargo class desc
	 */
	public String getCargoClassDesc() {
		return cargoClassDesc;
	}

	/**
	 * Sets the cargo class desc.
	 * 
	 * @param cargoClassDesc the new cargo class desc
	 */
	public void setCargoClassDesc(String cargoClassDesc) {
		this.cargoClassDesc = cargoClassDesc;
	}

	/**
	 * Gets the cargo type.
	 * 
	 * @return the cargo type
	 */
	public String getCargoType() {
		return cargoType;
	}

	/**
	 * Sets the cargo type.
	 * 
	 * @param cargoType the new cargo type
	 */
	public void setCargoType(String cargoType) {
		this.cargoType = cargoType;
	}

	/**
	 * Gets the cargo type desc.
	 * 
	 * @return the cargo type desc
	 */
	public String getCargoTypeDesc() {
		return cargoTypeDesc;
	}

	/**
	 * Sets the cargo type desc.
	 * 
	 * @param cargoTypeDesc the new cargo type desc
	 */
	public void setCargoTypeDesc(String cargoTypeDesc) {
		this.cargoTypeDesc = cargoTypeDesc;
	}

	/**
	 * Gets the pack method.
	 * 
	 * @return the pack method
	 */
	public String getPackMethod() {
		return packMethod;
	}

	/**
	 * Sets the pack method.
	 * 
	 * @param packMethod the new pack method
	 */
	public void setPackMethod(String packMethod) {
		this.packMethod = packMethod;
	}

	/**
	 * Gets the bl awb.
	 * 
	 * @return the bl awb
	 */
	public String getBlAwb() {
		return blAwb;
	}

	/**
	 * Sets the bl awb.
	 * 
	 * @param blAwb the new bl awb
	 */
	public void setBlAwb(String blAwb) {
		this.blAwb = blAwb;
	}

	/**
	 * Gets the tranship origin.
	 * 
	 * @return the tranship origin
	 */
	public String getTranshipOrigin() {
		return transhipOrigin;
	}

	/**
	 * Sets the tranship origin.
	 * 
	 * @param transhipOrigin the new tranship origin
	 */
	public void setTranshipOrigin(String transhipOrigin) {
		this.transhipOrigin = transhipOrigin;
	}

	/**
	 * Gets the tranship destination.
	 * 
	 * @return the tranship destination
	 */
	public String getTranshipDestination() {
		return transhipDestination;
	}

	/**
	 * Sets the tranship destination.
	 * 
	 * @param transhipDestination the new tranship destination
	 */
	public void setTranshipDestination(String transhipDestination) {
		this.transhipDestination = transhipDestination;
	}

	/**
	 * Gets the voyage no.
	 * 
	 * @return the voyage no
	 */
	public String getVoyageNo() {
		return voyageNo;
	}

	/**
	 * Sets the voyage no.
	 * 
	 * @param voyageNo the new voyage no
	 */
	public void setVoyageNo(String voyageNo) {
		this.voyageNo = voyageNo;
	}

	/**
	 * Gets the lc no.
	 * 
	 * @return the lc no
	 */
	public String getLcNo() {
		return lcNo;
	}

	/**
	 * Sets the lc no.
	 * 
	 * @param lcNo the new lc no
	 */
	public void setLcNo(String lcNo) {
		this.lcNo = lcNo;
	}

	/**
	 * Gets the etd.
	 * 
	 * @return the etd
	 */
	public Date getEtd() {
		return etd;
	}

	/**
	 * Sets the etd.
	 * 
	 * @param etd the new etd
	 */
	public void setEtd(Date etd) {
		this.etd = etd;
	}

	/**
	 * Gets the eta.
	 * 
	 * @return the eta
	 */
	public Date getEta() {
		return eta;
	}

	/**
	 * Sets the eta.
	 * 
	 * @param eta the new eta
	 */
	public void setEta(Date eta) {
		this.eta = eta;
	}

	/**
	 * Gets the prints the tag.
	 * 
	 * @return the prints the tag
	 */
	public Integer getPrintTag() {
		return printTag;
	}

	/**
	 * Sets the prints the tag.
	 * 
	 * @param printTag the new prints the tag
	 */
	public void setPrintTag(Integer printTag) {
		this.printTag = printTag;
	}

	/**
	 * Gets the prints the tag desc.
	 * 
	 * @return the prints the tag desc
	 */
	public String getPrintTagDesc() {
		return printTagDesc;
	}

	/**
	 * Sets the prints the tag desc.
	 * 
	 * @param printTagDesc the new prints the tag desc
	 */
	public void setPrintTagDesc(String printTagDesc) {
		this.printTagDesc = printTagDesc;
	}

	/**
	 * Gets the origin.
	 * 
	 * @return the origin
	 */
	public String getOrigin() {
		return origin;
	}

	/**
	 * Sets the origin.
	 * 
	 * @param origin the new origin
	 */
	public void setOrigin(String origin) {
		this.origin = origin;
	}

	/**
	 * Gets the destn.
	 * 
	 * @return the destn
	 */
	public String getDestn() {
		return destn;
	}

	/**
	 * Sets the destn.
	 * 
	 * @param destn the new destn
	 */
	public void setDestn(String destn) {
		this.destn = destn;
	}
}