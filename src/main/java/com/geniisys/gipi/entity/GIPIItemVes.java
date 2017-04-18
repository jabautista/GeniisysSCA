package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIItemVes extends BaseEntity{
	
	private Integer policyId;		
	private Integer itemNo;		
	private String vesselCd;	
	private String geogLimit;		
	private String recFlag;		
	private String deductText;		
	private String dryPlace;		
	private Integer cpiRecNo;		
	private String cpiBranchCd;		
	private String arcExtData;
	private String dryDate;
	private String policyNo;
	private String vesselName;
	private String vesselFlag;
	private String vesselOldName;
	private String vesTypeDesc;
	private String propelSw;
	private String vessClassDesc;
	private String hullDesc;
	private String regOwner;
	private String regPlace;
	private String grossTon;
	private String yearBuilt;
	private String deadWeight;
	private String crewNat;
	private String vesselLength;
	private String vesselBreadth;
	private String vesselDepth;
	private BigDecimal netTon;
	private Integer noCrew;
	private String itemTitle;
	private String propelSwDesc;

	public GIPIItemVes() {
		super();
	}

	public GIPIItemVes(Integer policyId, Integer itemNo, String vesselCd,
			String geogLimit, String recFlag, String deductText,
			String dryPlace, Integer cpiRecNo, String cpiBranchCd,
			String arcExtData, String dryDate, String policyNo,
			String vesselName, String vesselFlag, String vesselOldName,
			String vesTypeDesc, String propelSw, String vessClassDesc,
			String hullDesc, String regOwner, String regPlace, String grossTon,
			String yearBuilt, String deadWeight, String crewNat,
			String vesselLength, String vesselBreadth, String vesselDepth) {
		super();
		this.policyId = policyId;
		this.itemNo = itemNo;
		this.vesselCd = vesselCd;
		this.geogLimit = geogLimit;
		this.recFlag = recFlag;
		this.deductText = deductText;
		this.dryPlace = dryPlace;
		this.cpiRecNo = cpiRecNo;
		this.cpiBranchCd = cpiBranchCd;
		this.arcExtData = arcExtData;
		this.dryDate = dryDate;
		this.policyNo = policyNo;
		this.vesselName = vesselName;
		this.vesselFlag = vesselFlag;
		this.vesselOldName = vesselOldName;
		this.vesTypeDesc = vesTypeDesc;
		this.propelSw = propelSw;
		this.vessClassDesc = vessClassDesc;
		this.hullDesc = hullDesc;
		this.regOwner = regOwner;
		this.regPlace = regPlace;
		this.grossTon = grossTon;
		this.yearBuilt = yearBuilt;
		this.deadWeight = deadWeight;
		this.crewNat = crewNat;
		this.vesselLength = vesselLength;
		this.vesselBreadth = vesselBreadth;
		this.vesselDepth = vesselDepth;
	}

	public String getVesselFlag() {
		return vesselFlag;
	}

	public void setVesselFlag(String vesselFlag) {
		this.vesselFlag = vesselFlag;
	}

	public String getVesselOldName() {
		return vesselOldName;
	}

	public void setVesselOldName(String vesselOldName) {
		this.vesselOldName = vesselOldName;
	}

	public String getVesTypeDesc() {
		return vesTypeDesc;
	}

	public void setVesTypeDesc(String vesTypeDesc) {
		this.vesTypeDesc = vesTypeDesc;
	}

	public String getPropelSw() {
		return propelSw;
	}

	public void setPropelSw(String propelSw) {
		this.propelSw = propelSw;
	}

	public String getVessClassDesc() {
		return vessClassDesc;
	}

	public void setVessClassDesc(String vessClassDesc) {
		this.vessClassDesc = vessClassDesc;
	}

	public String getHullDesc() {
		return hullDesc;
	}

	public void setHullDesc(String hullDesc) {
		this.hullDesc = hullDesc;
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

	public String getGrossTon() {
		return grossTon;
	}

	public void setGrossTon(String grossTon) {
		this.grossTon = grossTon;
	}

	public String getYearBuilt() {
		return yearBuilt;
	}

	public void setYearBuilt(String yearBuilt) {
		this.yearBuilt = yearBuilt;
	}

	public String getDeadWeight() {
		return deadWeight;
	}

	public void setDeadWeight(String deadWeight) {
		this.deadWeight = deadWeight;
	}

	public String getCrewNat() {
		return crewNat;
	}

	public void setCrewNat(String crewNat) {
		this.crewNat = crewNat;
	}

	public String getVesselLength() {
		return vesselLength;
	}

	public void setVesselLength(String vesselLength) {
		this.vesselLength = vesselLength;
	}

	public String getVesselBreadth() {
		return vesselBreadth;
	}

	public void setVesselBreadth(String vesselBreadth) {
		this.vesselBreadth = vesselBreadth;
	}

	public String getVesselDepth() {
		return vesselDepth;
	}

	public void setVesselDepth(String vesselDepth) {
		this.vesselDepth = vesselDepth;
	}

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	public String getVesselCd() {
		return vesselCd;
	}

	public void setVesselCd(String vesselCd) {
		this.vesselCd = vesselCd;
	}

	public String getGeogLimit() {
		return geogLimit;
	}

	public void setGeogLimit(String geogLimit) {
		this.geogLimit = geogLimit;
	}

	public String getRecFlag() {
		return recFlag;
	}

	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}

	public String getDeductText() {
		return deductText;
	}

	public void setDeductText(String deductText) {
		this.deductText = deductText;
	}

	public String getDryDate() {
		return dryDate;
	}

	public void setDryDate(String dryDate) {
		this.dryDate = dryDate;
	}

	public String getDryPlace() {
		return dryPlace;
	}

	public void setDryPlace(String dryPlace) {
		this.dryPlace = dryPlace;
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

	public String getArcExtData() {
		return arcExtData;
	}

	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}

	public String getPolicyNo() {
		return policyNo;
	}

	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}

	public String getVesselName() {
		return vesselName;
	}

	public void setVesselName(String vesselName) {
		this.vesselName = vesselName;
	}

	public BigDecimal getNetTon() {
		return netTon;
	}

	public void setNetTon(BigDecimal netTon) {
		this.netTon = netTon;
	}

	public Integer getNoCrew() {
		return noCrew;
	}

	public void setNoCrew(Integer noCrew) {
		this.noCrew = noCrew;
	}

	public String getItemTitle() {
		return itemTitle;
	}

	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}

	public String getPropelSwDesc() {
		return propelSwDesc;
	}

	public void setPropelSwDesc(String propelSwDesc) {
		this.propelSwDesc = propelSwDesc;
	}
	
}
