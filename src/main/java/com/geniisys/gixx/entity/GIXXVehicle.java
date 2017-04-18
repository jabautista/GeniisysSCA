package com.geniisys.gixx.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIXXVehicle extends BaseEntity{
	
	private Integer extractId;
	private Integer itemNo;
	
	// cargo carrier
	private String vesselCd;
	private String vesselName;
	
	
	// motor car
	private String assignee;
	private String cocType;
	private Integer cocSerialNo;
	private Integer cocYy;
	private String acquiredFrom;
	private Integer typeOfBodyCd;
	private String plateNo;
	private String modelYear;
	private Integer carCompanyCd;
	private String mvFileNo;
	private Integer noOfPass;
	private String make;
	private String basicColorCd;
	private Integer colorCd;
	private String color;
	private String basicColor;
	private Integer seriesCd;
	private Integer makeCd;
	private Float towing;
	private Integer motType;
	private String unladenWt;
	private String serialNo;
	private String sublineCd;
	private String sublineTypeCd;
	private BigDecimal repairLim;
	private String motorNo;
	private String engineSeries;
	private String carCompany;
	private String typeOfBody;
	private String motorTypeDesc;
	private BigDecimal deductible;
	private String sublineTypeDesc;
	
	// cargo carrier
	public Integer getExtractId() {
		return extractId;
	}
	public void setExtractId(Integer extractId) {
		this.extractId = extractId;
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
	public String getVesselName() {
		return vesselName;
	}
	public void setVesselName(String vesselName) {
		this.vesselName = vesselName;
	}
	
	
	// motor car
	public String getAssignee() {
		return assignee;
	}
	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}
	public String getCocType() {
		return cocType;
	}
	public void setCocType(String cocType) {
		this.cocType = cocType;
	}
	public Integer getCocSerialNo() {
		return cocSerialNo;
	}
	public void setCocSerialNo(Integer cocSerialNo) {
		this.cocSerialNo = cocSerialNo;
	}
	public Integer getCocYy() {
		return cocYy;
	}
	public void setCocYy(Integer cocYy) {
		this.cocYy = cocYy;
	}
	public String getAcquiredFrom() {
		return acquiredFrom;
	}
	public void setAcquiredFrom(String acquiredFrom) {
		this.acquiredFrom = acquiredFrom;
	}
	public Integer getTypeOfBodyCd() {
		return typeOfBodyCd;
	}
	public void setTypeOfBodyCd(Integer typeOfBodyCd) {
		this.typeOfBodyCd = typeOfBodyCd;
	}
	public String getPlateNo() {
		return plateNo;
	}
	public void setPlateNo(String plateNo) {
		this.plateNo = plateNo;
	}
	public String getModelYear() {
		return modelYear;
	}
	public void setModelYear(String modelYear) {
		this.modelYear = modelYear;
	}
	public Integer getCarCompanyCd() {
		return carCompanyCd;
	}
	public void setCarCompanyCd(Integer carCompanyCd) {
		this.carCompanyCd = carCompanyCd;
	}
	public String getMvFileNo() {
		return mvFileNo;
	}
	public void setMvFileNo(String mvFileNo) {
		this.mvFileNo = mvFileNo;
	}
	public Integer getNoOfPass() {
		return noOfPass;
	}
	public void setNoOfPass(Integer noOfPass) {
		this.noOfPass = noOfPass;
	}
	public String getMake() {
		return make;
	}
	public void setMake(String make) {
		this.make = make;
	}
	public String getBasicColorCd() {
		return basicColorCd;
	}
	public void setBasicColorCd(String basicColorCd) {
		this.basicColorCd = basicColorCd;
	}
	public Integer getColorCd() {
		return colorCd;
	}
	public void setColorCd(Integer colorCd) {
		this.colorCd = colorCd;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public String getBasicColor() {
		return basicColor;
	}
	public void setBasicColor(String basicColor) {
		this.basicColor = basicColor;
	}
	public Integer getSeriesCd() {
		return seriesCd;
	}
	public void setSeriesCd(Integer seriesCd) {
		this.seriesCd = seriesCd;
	}
	public Integer getMakeCd() {
		return makeCd;
	}
	public void setMakeCd(Integer makeCd) {
		this.makeCd = makeCd;
	}
	public Float getTowing() {
		return towing;
	}
	public void setTowing(Float towing) {
		this.towing = towing;
	}
	public Integer getMotType() {
		return motType;
	}
	public void setMotType(Integer motType) {
		this.motType = motType;
	}
	public String getUnladenWt() {
		return unladenWt;
	}
	public void setUnladenWt(String unladenWt) {
		this.unladenWt = unladenWt;
	}
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	public String getSublineCd() {
		return sublineCd;
	}
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	public String getSublineTypeCd() {
		return sublineTypeCd;
	}
	public void setSublineTypeCd(String sublineTypeCd) {
		this.sublineTypeCd = sublineTypeCd;
	}
	public BigDecimal getRepairLim() {
		return repairLim;
	}
	public void setRepairLim(BigDecimal repairLim) {
		this.repairLim = repairLim;
	}
	public String getMotorNo() {
		return motorNo;
	}
	public void setMotorNo(String motorNo) {
		this.motorNo = motorNo;
	}
	public String getEngineSeries() {
		return engineSeries;
	}
	public void setEngineSeries(String engineSeries) {
		this.engineSeries = engineSeries;
	}
	public String getCarCompany() {
		return carCompany;
	}
	public void setCarCompany(String carCompany) {
		this.carCompany = carCompany;
	}
	public String getTypeOfBody() {
		return typeOfBody;
	}
	public void setTypeOfBody(String typeOfBody) {
		this.typeOfBody = typeOfBody;
	}
	public String getMotorTypeDesc() {
		return motorTypeDesc;
	}
	public void setMotorTypeDesc(String motorTypeDesc) {
		this.motorTypeDesc = motorTypeDesc;
	}
	public BigDecimal getDeductible() {
		return deductible;
	}
	public void setDeductible(BigDecimal deductible) {
		this.deductible = deductible;
	}
	public String getSublineTypeDesc() {
		return sublineTypeDesc;
	}
	public void setSublineTypeDesc(String sublineTypeDesc) {
		this.sublineTypeDesc = sublineTypeDesc;
	}
	
}
