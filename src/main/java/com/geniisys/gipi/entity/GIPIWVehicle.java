package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWVehicle extends BaseEntity{
	private Integer parId;
	private Integer itemNo;
	private String sublineCd;
	private String motorNo;
	private String plateNo;
	private BigDecimal estValue;	
	private Integer motType;
	private String color;
	private BigDecimal repairLim;
	private String serialNo;
	private Integer cocSeqNo;
	private Integer cocSerialNo;
	private String cocType;
	private String assignee;
	private String modelYear;
	private Date cocIssueDate;
	private Integer cocYy;
	private BigDecimal towing;
	private String sublineTypeCd;
	private Integer noOfPass;
	private String tariffZone;
	private String mvFileNo;
	private String acquiredFrom;
	private String ctvTag;
	private Integer carCompanyCd;
	private Integer typeOfBodyCd;
	private String unladenWt;
	private Integer makeCd;
	private Integer seriesCd;
	private String basicColorCd;
	private String basicColor;
	private Integer colorCd;
	private String origin;
	private String destination;
	private String cocAtcn;
	private String motorCoverage;
	private String cocSerialSw;
	private String carCompany;
	private String make;
	private String engineSeries;
	private String regType;
	private String mvType;
	private String mvPremType;
	private String taxType;
	private String mvTypeDesc;
	private String mvPremTypeDesc;

	public Integer getParId() {
		return parId;
	}
	public void setParId(Integer parId) {
		this.parId = parId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public String getSublineCd() {
		return sublineCd;
	}
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	public String getMotorNo() {
		return motorNo;
	}
	public void setMotorNo(String motorNo) {
		this.motorNo = motorNo;
	}
	public String getPlateNo() {
		return plateNo;
	}
	public void setPlateNo(String plateNo) {
		this.plateNo = plateNo;
	}
	public BigDecimal getEstValue() {
		return estValue;
	}
	public void setEstValue(BigDecimal estValue) {
		this.estValue = estValue;
	}
	public String getMake() {
		return make;
	}
	public void setMake(String make) {
		this.make = make;
	}
	public Integer getMotType() {
		return motType;
	}
	public void setMotType(Integer motType) {
		this.motType = motType;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public BigDecimal getRepairLim() {
		return repairLim;
	}
	public void setRepairLim(BigDecimal repairLim) {
		this.repairLim = repairLim;
	}
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	public Integer getCocSeqNo() {
		return cocSeqNo;
	}
	public void setCocSeqNo(Integer cocSeqNo) {
		this.cocSeqNo = cocSeqNo;
	}
	public Integer getCocSerialNo() {
		return cocSerialNo;
	}
	public void setCocSerialNo(Integer cocSerialNo) {
		this.cocSerialNo = cocSerialNo;
	}
	public String getCocType() {
		return cocType;
	}
	public void setCocType(String cocType) {
		this.cocType = cocType;
	}
	public String getAssignee() {
		return assignee;
	}
	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}
	public String getModelYear() {
		return modelYear;
	}
	public void setModelYear(String modelYear) {
		this.modelYear = modelYear;
	}
	public Date getCocIssueDate() {
		return cocIssueDate;
	}
	public void setCocIssueDate(Date cocIssueDate) {
		this.cocIssueDate = cocIssueDate;
	}
	public Integer getCocYy() {
		return cocYy;
	}
	public void setCocYy(Integer cocYy) {
		this.cocYy = cocYy;
	}
	public BigDecimal getTowing() {
		return towing;
	}
	public void setTowing(BigDecimal towing) {
		this.towing = towing;
	}
	public String getSublineTypeCd() {
		return sublineTypeCd;
	}
	public void setSublineTypeCd(String sublineTypeCd) {
		this.sublineTypeCd = sublineTypeCd;
	}
	public Integer getNoOfPass() {
		return noOfPass;
	}
	public void setNoOfPass(Integer noOfPass) {
		this.noOfPass = noOfPass;
	}
	public String getTariffZone() {
		return tariffZone;
	}
	public void setTariffZone(String tariffZone) {
		this.tariffZone = tariffZone;
	}
	public String getMvFileNo() {
		return mvFileNo;
	}
	public void setMvFileNo(String mvFileNo) {
		this.mvFileNo = mvFileNo;
	}
	public String getAcquiredFrom() {
		return acquiredFrom;
	}
	public void setAcquiredFrom(String acquiredFrom) {
		this.acquiredFrom = acquiredFrom;
	}
	public String getCtvTag() {
		return ctvTag;
	}
	public void setCtvTag(String ctvTag) {
		this.ctvTag = ctvTag;
	}
	public Integer getCarCompanyCd() {
		return carCompanyCd;
	}
	public void setCarCompanyCd(Integer carCompanyCd) {
		this.carCompanyCd = carCompanyCd;
	}
	public Integer getTypeOfBodyCd() {
		return typeOfBodyCd;
	}
	public void setTypeOfBodyCd(Integer typeOfBodyCd) {
		this.typeOfBodyCd = typeOfBodyCd;
	}
	public String getUnladenWt() {
		return unladenWt;
	}
	public void setUnladenWt(String unladenWt) {
		this.unladenWt = unladenWt;
	}
	public Integer getMakeCd() {
		return makeCd;
	}
	public void setMakeCd(Integer makeCd) {
		this.makeCd = makeCd;
	}
	public Integer getSeriesCd() {
		return seriesCd;
	}
	public void setSeriesCd(Integer seriesCd) {
		this.seriesCd = seriesCd;
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
	public String getCocAtcn() {
		return cocAtcn;
	}
	public void setCocAtcn(String cocAtcn) {
		this.cocAtcn = cocAtcn;
	}
	public String getMotorCoverage() {
		return motorCoverage;
	}
	public void setMotorCoverage(String motorCoverage) {
		this.motorCoverage = motorCoverage;
	}
	public String getCocSerialSw() {
		return cocSerialSw;
	}
	public void setCocSerialSw(String cocSerialSw) {
		this.cocSerialSw = cocSerialSw;
	}
	public String getCarCompany() {
		return carCompany;
	}
	public void setCarCompany(String carCompany) {
		this.carCompany = carCompany;
	}
	public String getEngineSeries() {
		return engineSeries;
	}
	public void setEngineSeries(String engineSeries) {
		this.engineSeries = engineSeries;
	}
	public void setBasicColor(String basicColor) {
		this.basicColor = basicColor;
	}
	public String getBasicColor() {
		return basicColor;
	}

	public String getRegType() {
		return regType;
	}

	public void setRegType(String regType) {
		this.regType = regType;
	}

	public String getMvType() {
		return mvType;
	}

	public void setMvType(String mvType) {
		this.mvType = mvType;
	}

	public String getMvPremType() {
		return mvPremType;
	}

	public void setMvPremType(String mvPremType) {
		this.mvPremType = mvPremType;
	}

	public String getTaxType() {
		return taxType;
	}

	public void setTaxType(String taxType) {
		this.taxType = taxType;
	}

	public String getMvTypeDesc() {
		return mvTypeDesc;
	}

	public void setMvTypeDesc(String mvTypeDesc) {
		this.mvTypeDesc = mvTypeDesc;
	}

	public String getMvPremTypeDesc() {
		return mvPremTypeDesc;
	}

	public void setMvPremTypeDesc(String mvPremTypeDesc) {
		this.mvPremTypeDesc = mvPremTypeDesc;
	}
	
}
