package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIVehicle extends BaseEntity{
	
	private Integer policyId;		
	private Integer itemNo;		
	private String sublineCd;		
	private String motorNo;		
	private Integer cocYy;		
	private Integer cocSeqNo;		
	private Integer cocSerialNo;		
	private String cocType;		
	private BigDecimal repairLim;		
	private String color;		
	private String modelYear;		
	private String make;		
	private Integer motType;		
	private BigDecimal estValue;		
	private String serialNo;		
	private BigDecimal towing;		
	private String asignee;		
	private String plateNo;		
	private String sublineTypeCd;		
	private Integer noOfPass;		
	private String tariffZone;		
	private Date cocIssueDate;		
	private String mvFileNo;		
	private String acquiredFrom;		
	private String ctvTag;		
	private Integer carCompanyCd;		
	private Integer cpiRecNo;		
	private String cpiBranchCd;		
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
	private String actExtData;
	private String policyNo;
	private String polFlag;
	private String status;
	private String assignee;
	private String carCompany;
	private String engineSeries;
	private String typeDesc;
	private BigDecimal deductible;
	private String sublineTypeDesc;
	private String typeOfBody;
	private String itemTitle;
	
	private String vesselCd;
	private String vesselName;
	private String regType;
	private String mvType;
	private String mvPremType;
	private String taxType;
	private String mvTypeDesc;
	private String mvPremTypeDesc;
	
	
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

	public GIPIVehicle() {
		super();
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

	public Integer getCocYy() {
		return cocYy;
	}

	public void setCocYy(Integer cocYy) {
		this.cocYy = cocYy;
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

	public BigDecimal getRepairLim() {
		return repairLim;
	}

	public void setRepairLim(BigDecimal repairLim) {
		this.repairLim = repairLim;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public String getModelYear() {
		return modelYear;
	}

	public void setModelYear(String modelYear) {
		this.modelYear = modelYear;
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

	public BigDecimal getEstValue() {
		return estValue;
	}

	public void setEstValue(BigDecimal estValue) {
		this.estValue = estValue;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public BigDecimal getTowing() {
		return towing;
	}

	public void setTowing(BigDecimal towing) {
		this.towing = towing;
	}

	public String getAsignee() {
		return asignee;
	}

	public void setAsignee(String asignee) {
		this.asignee = asignee;
	}

	public String getPlateNo() {
		return plateNo;
	}

	public void setPlateNo(String plateNo) {
		this.plateNo = plateNo;
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

	public Date getCocIssueDate() {
		return cocIssueDate;
	}

	public void setCocIssueDate(Date cocIssueDate) {
		this.cocIssueDate = cocIssueDate;
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

	public String getActExtData() {
		return actExtData;
	}

	public void setActExtData(String actExtData) {
		this.actExtData = actExtData;
	}

	public String getPolicyNo() {
		return policyNo;
	}

	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getPolFlag() {
		return polFlag;
	}

	public void setPolFlag(String polFlag) {
		this.polFlag = polFlag;
	}

	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}

	public String getAssignee() {
		return assignee;
	}

	public void setCarCompany(String carCompany) {
		this.carCompany = carCompany;
	}

	public String getCarCompany() {
		return carCompany;
	}

	public void setEngineSeries(String engineSeries) {
		this.engineSeries = engineSeries;
	}

	public String getEngineSeries() {
		return engineSeries;
	}

	public void setBasicColor(String basicColor) {
		this.basicColor = basicColor;
	}

	public String getBasicColor() {
		return basicColor;
	}

	public String getTypeDesc() {
		return typeDesc;
	}

	public void setTypeDesc(String typeDesc) {
		this.typeDesc = typeDesc;
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

	public String getTypeOfBody() {
		return typeOfBody;
	}

	public void setTypeOfBody(String typeOfBody) {
		this.typeOfBody = typeOfBody;
	}

	public String getItemTitle() {
		return itemTitle;
	}

	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
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
