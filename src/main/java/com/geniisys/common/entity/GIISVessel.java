/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.giis.entity.BaseEntity;

/**
 * The Class GIISVessel.
 */
public class GIISVessel extends BaseEntity{

	/** The vessel cd. */
	private String vesselCd;
	
	/** The vessel name. */
	private String vesselName;
	
	/** The vessel old name. */
	private String vesselOldName;
	
	/** The vessel flag. */
	private String vesselFlag;
	
	/** The vessel type. */
	private String vesselType;
	
	/** The rpc no. */
	private String rpcNo;
	
	/** The air type cd. */
	private Integer airTypeCd;
	
	/** The air desc. */
	private String airDesc;
	
	/** The no of pass. */
	private String noOfPass;
	
	private String motorNo;
	private String serialNo;
	private String plateNo;
	
	private String vestypeCd;
	private String vestypeDesc;
	private String propelSw;
	private Integer hullTypeCd;
	private String hullTypeDesc;
	private String regOwner;
	private String regPlace;
	private BigDecimal grossTon;
	private Integer yearBuilt;
	private Integer vessClassCd;
	private String vessClassDesc;
	private Date dryDate;
	private String dryPlace;
	private String crewNat;
	private Integer noCrew;
	private Integer noPass;
	private String engineType;
	private Integer deadweight;
	private BigDecimal netTon;
	private String hullSw;
	private Integer aircraftWeight;
	private String makeType;
	private BigDecimal vesselLength;
	private BigDecimal vesselBreadth;
	private BigDecimal vesselDepth;
	private String remarks;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String origin;
	private String destination;
	
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
	 * Gets the vessel old name.
	 * 
	 * @return the vessel old name
	 */
	public String getVesselOldName() {
		return vesselOldName;
	}
	
	/**
	 * Sets the vessel old name.
	 * 
	 * @param vesselOldName the new vessel old name
	 */
	public void setVesselOldName(String vesselOldName) {
		this.vesselOldName = vesselOldName;
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
	 * Gets the rpc no.
	 * 
	 * @return the rpc no
	 */
	public String getRpcNo() {
		return rpcNo;
	}
	
	/**
	 * Sets the rpc no.
	 * 
	 * @param rpcNo the new rpc no
	 */
	public void setRpcNo(String rpcNo) {
		this.rpcNo = rpcNo;
	}
	
	/**
	 * Gets the air type cd.
	 * 
	 * @return the air type cd
	 */
	public Integer getAirTypeCd() {
		return airTypeCd;
	}
	
	/**
	 * Sets the air type cd.
	 * 
	 * @param airTypeCd the new air type cd
	 */
	public void setAirTypeCd(Integer airTypeCd) {
		this.airTypeCd = airTypeCd;
	}
	
	/**
	 * Gets the air desc.
	 * 
	 * @return the air desc
	 */
	public String getAirDesc() {
		return airDesc;
	}
	
	/**
	 * Sets the air desc.
	 * 
	 * @param airDesc the new air desc
	 */
	public void setAirDesc(String airDesc) {
		this.airDesc = airDesc;
	}
	
	/**
	 * Gets the no of pass.
	 * 
	 * @return the no of pass
	 */
	public String getNoOfPass() {
		return noOfPass;
	}
	
	/**
	 * Sets the no of pass.
	 * 
	 * @param noOfPass the new no of pass
	 */
	public void setNoOfPass(String noOfPass) {
		this.noOfPass = noOfPass;
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

	public String getMotorNo() {
		return motorNo;
	}

	public void setMotorNo(String motorNo) {
		this.motorNo = motorNo;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getPlateNo() {
		return plateNo;
	}

	public void setPlateNo(String plateNo) {
		this.plateNo = plateNo;
	}

	public String getVestypeCd() {
		return vestypeCd;
	}

	public void setVestypeCd(String vestypeCd) {
		this.vestypeCd = vestypeCd;
	}

	public String getPropelSw() {
		return propelSw;
	}

	public void setPropelSw(String propelSw) {
		this.propelSw = propelSw;
	}

	public Integer getHullTypeCd() {
		return hullTypeCd;
	}

	public void setHullTypeCd(Integer hullTypeCd) {
		this.hullTypeCd = hullTypeCd;
	}

	public String getRegOwner() {
		return regOwner;
	}

	public void setRegOwner(String regOwner) {
		this.regOwner = regOwner;
	}

	public String getRegPlace() {
		return regPlace;
	}

	public void setRegPlace(String regPlace) {
		this.regPlace = regPlace;
	}

	public BigDecimal getGrossTon() {
		return grossTon;
	}

	public void setGrossTon(BigDecimal grossTon) {
		this.grossTon = grossTon;
	}

	public Integer getYearBuilt() {
		return yearBuilt;
	}

	public void setYearBuilt(Integer yearBuilt) {
		this.yearBuilt = yearBuilt;
	}

	public Integer getVessClassCd() {
		return vessClassCd;
	}

	public void setVessClassCd(Integer vessClassCd) {
		this.vessClassCd = vessClassCd;
	}

	public Date getDryDate() {
		return dryDate;
	}

	public void setDryDate(Date dryDate) {
		this.dryDate = dryDate;
	}

	public String getDryPlace() {
		return dryPlace;
	}

	public void setDryPlace(String dryPlace) {
		this.dryPlace = dryPlace;
	}

	public String getCrewNat() {
		return crewNat;
	}

	public void setCrewNat(String crewNat) {
		this.crewNat = crewNat;
	}

	public Integer getNoCrew() {
		return noCrew;
	}

	public void setNoCrew(Integer noCrew) {
		this.noCrew = noCrew;
	}

	public String getEngineType() {
		return engineType;
	}

	public void setEngineType(String engineType) {
		this.engineType = engineType;
	}

	public Integer getDeadweight() {
		return deadweight;
	}

	public void setDeadweight(Integer deadweight) {
		this.deadweight = deadweight;
	}

	public BigDecimal getNetTon() {
		return netTon;
	}

	public void setNetTon(BigDecimal netTon) {
		this.netTon = netTon;
	}

	public String getHullSw() {
		return hullSw;
	}

	public void setHullSw(String hullSw) {
		this.hullSw = hullSw;
	}

	public Integer getAircraftWeight() {
		return aircraftWeight;
	}

	public void setAircraftWeight(Integer aircraftWeight) {
		this.aircraftWeight = aircraftWeight;
	}

	public String getMakeType() {
		return makeType;
	}

	public void setMakeType(String makeType) {
		this.makeType = makeType;
	}

	public BigDecimal getVesselLength() {
		return vesselLength;
	}

	public void setVesselLength(BigDecimal vesselLength) {
		this.vesselLength = vesselLength;
	}

	public BigDecimal getVesselBreadth() {
		return vesselBreadth;
	}

	public void setVesselBreadth(BigDecimal vesselBreadth) {
		this.vesselBreadth = vesselBreadth;
	}

	public BigDecimal getVesselDepth() {
		return vesselDepth;
	}

	public void setVesselDepth(BigDecimal vesselDepth) {
		this.vesselDepth = vesselDepth;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getDestination() {
		return destination;
	}

	public void setDestination(String destination) {
		this.destination = destination;
	}

	public String getVestypeDesc() {
		return vestypeDesc;
	}

	public void setVestypeDesc(String vestypeDesc) {
		this.vestypeDesc = vestypeDesc;
	}

	public String getVessClassDesc() {
		return vessClassDesc;
	}

	public void setVessClassDesc(String vessClassDesc) {
		this.vessClassDesc = vessClassDesc;
	}

	public String getHullTypeDesc() {
		return hullTypeDesc;
	}

	public void setHullTypeDesc(String hullTypeDesc) {
		this.hullTypeDesc = hullTypeDesc;
	}

	public Integer getNoPass() {
		return noPass;
	}

	public void setNoPass(Integer noPass) {
		this.noPass = noPass;
	}

}