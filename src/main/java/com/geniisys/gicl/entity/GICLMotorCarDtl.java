/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.entity
	File Name: GICLMotorCarDtl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 23, 2011
	Description: 
*/


package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLMotorCarDtl extends BaseEntity{
	private Integer claimId;
	private Integer itemNo;
	private String motorNo;
	private String itemTitle;
	private String modelYear;
	private String plateNo;
	private String drvrOccCd;
	private String drvrName;
	private String drvrSex;
	private Integer drvrAge;
	private Integer motcarCompCd;
	private Integer makeCd;
	private String color;
	private String sublineTypeCd;
	private String basicColorCd;
	private Integer colorCd;
	private String serialNo;
	private String lossDate;
	private Integer currencyCd;
	private Integer motType;
	private Integer seriesCd;
	private BigDecimal currencyRate;
	private Integer noOfPass;
	private BigDecimal towing;
	private String drvrAdd;
	private String otherInfo;
	private Integer drvngExp;
	private String nationalityCd;
	private String relation;
	private String assignee;
	private String itemDesc;
	private String itemDesc2;
	private String mvFileNo;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	
	private String dspCurrencyDesc;
	private String sublineTypeDesc;
	private String motcarCompDesc;
	private String makeDesc;
	private String basicColor;
	private String motTypeDesc;
	private String engineSeries;
	private String drvrOccDesc;
	private String nationalityDesc;
	private String giclItemPerilExist;
	private String giclMortgageeExist;
	private String giclItemPerilMsg;
	
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
	public String getGiclItemPerilExist() {
		return giclItemPerilExist;
	}
	public void setGiclItemPerilExist(String giclItemPerilExist) {
		this.giclItemPerilExist = giclItemPerilExist;
	}
	public String getGiclMortgageeExist() {
		return giclMortgageeExist;
	}
	public void setGiclMortgageeExist(String giclMortgageeExist) {
		this.giclMortgageeExist = giclMortgageeExist;
	}
	public String getGiclItemPerilMsg() {
		return giclItemPerilMsg;
	}
	public void setGiclItemPerilMsg(String giclItemPerilMsg) {
		this.giclItemPerilMsg = giclItemPerilMsg;
	}
	public String getDrvrOccDesc() {
		return drvrOccDesc;
	}
	public void setDrvrOccDesc(String drvrOccDesc) {
		this.drvrOccDesc = drvrOccDesc;
	}
	public String getNationalityDesc() {
		return nationalityDesc;
	}
	public void setNationalityDesc(String nationalityDesc) {
		this.nationalityDesc = nationalityDesc;
	}
	public String getSublineTypeDesc() {
		return sublineTypeDesc;
	}
	public void setSublineTypeDesc(String sublineTypeDesc) {
		this.sublineTypeDesc = sublineTypeDesc;
	}
	public String getMotcarCompDesc() {
		return motcarCompDesc;
	}
	public void setMotcarCompDesc(String motcarCompDesc) {
		this.motcarCompDesc = motcarCompDesc;
	}
	public String getMakeDesc() {
		return makeDesc;
	}
	public void setMakeDesc(String makeDesc) {
		this.makeDesc = makeDesc;
	}
	public String getBasicColor() {
		return basicColor;
	}
	public void setBasicColor(String basicColor) {
		this.basicColor = basicColor;
	}
	public String getMotTypeDesc() {
		return motTypeDesc;
	}
	public void setMotTypeDesc(String motTypeDesc) {
		this.motTypeDesc = motTypeDesc;
	}
	public String getEngineSeries() {
		return engineSeries;
	}
	public void setEngineSeries(String engineSeries) {
		this.engineSeries = engineSeries;
	}
	public String getItemDesc() {
		return itemDesc;
	}
	public void setItemDesc(String itemDesc) {
		this.itemDesc = itemDesc;
	}
	public String getItemDesc2() {
		return itemDesc2;
	}
	public void setItemDesc2(String itemDesc2) {
		this.itemDesc2 = itemDesc2;
	}
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public String getMotorNo() {
		return motorNo;
	}
	public void setMotorNo(String motorNo) {
		this.motorNo = motorNo;
	}
	public String getItemTitle() {
		return itemTitle;
	}
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}
	public String getModelYear() {
		return modelYear;
	}
	public void setModelYear(String modelYear) {
		this.modelYear = modelYear;
	}
	public String getPlateNo() {
		return plateNo;
	}
	public void setPlateNo(String plateNo) {
		this.plateNo = plateNo;
	}
	public String getDrvrOccCd() {
		return drvrOccCd;
	}
	public void setDrvrOccCd(String drvrOccCd) {
		this.drvrOccCd = drvrOccCd;
	}
	public String getDrvrName() {
		return drvrName;
	}
	public void setDrvrName(String drvrName) {
		this.drvrName = drvrName;
	}
	public String getDrvrSex() {
		return drvrSex;
	}
	public void setDrvrSex(String drvrSex) {
		this.drvrSex = drvrSex;
	}
	public Integer getDrvrAge() {
		return drvrAge;
	}
	public void setDrvrAge(Integer drvrAge) {
		this.drvrAge = drvrAge;
	}
	public Integer getMotcarCompCd() {
		return motcarCompCd;
	}
	public void setMotcarCompCd(Integer motcarCompCd) {
		this.motcarCompCd = motcarCompCd;
	}
	public Integer getMakeCd() {
		return makeCd;
	}
	public void setMakeCd(Integer makeCd) {
		this.makeCd = makeCd;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public String getSublineTypeCd() {
		return sublineTypeCd;
	}
	public void setSublineTypeCd(String sublineTypeCd) {
		this.sublineTypeCd = sublineTypeCd;
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
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	public String getLossDate() {
		return lossDate;
	}
	public void setLossDate(String lossDate) {
		this.lossDate = lossDate;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public Integer getMotType() {
		return motType;
	}
	public void setMotType(Integer motType) {
		this.motType = motType;
	}
	public Integer getSeriesCd() {
		return seriesCd;
	}
	public void setSeriesCd(Integer seriesCd) {
		this.seriesCd = seriesCd;
	}
	public BigDecimal getCurrencyRate() {
		return currencyRate;
	}
	public void setCurrencyRate(BigDecimal currencyRate) {
		this.currencyRate = currencyRate;
	}
	public Integer getNoOfPass() {
		return noOfPass;
	}
	public void setNoOfPass(Integer noOfPass) {
		this.noOfPass = noOfPass;
	}
	public BigDecimal getTowing() {
		return towing;
	}
	public void setTowing(BigDecimal towing) {
		this.towing = towing;
	}
	public String getDrvrAdd() {
		return drvrAdd;
	}
	public void setDrvrAdd(String drvrAdd) {
		this.drvrAdd = drvrAdd;
	}
	public String getOtherInfo() {
		return otherInfo;
	}
	public void setOtherInfo(String otherInfo) {
		this.otherInfo = otherInfo;
	}
	public Integer getDrvngExp() {
		return drvngExp;
	}
	public void setDrvngExp(Integer drvngExp) {
		this.drvngExp = drvngExp;
	}
	public String getNationalityCd() {
		return nationalityCd;
	}
	public void setNationalityCd(String nationalityCd) {
		this.nationalityCd = nationalityCd;
	}
	public String getRelation() {
		return relation;
	}
	public void setRelation(String relation) {
		this.relation = relation;
	}
	public String getAssignee() {
		return assignee;
	}
	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}
	/**
	 * @param mvFileNo the mvFileNo to set
	 */
	public void setMvFileNo(String mvFileNo) {
		this.mvFileNo = mvFileNo;
	}
	/**
	 * @return the mvFileNo
	 */
	public String getMvFileNo() {
		return mvFileNo;
	}
	/**
	 * @param dspCurrencyDesc the dspCurrencyDesc to set
	 */
	public void setDspCurrencyDesc(String dspCurrencyDesc) {
		this.dspCurrencyDesc = dspCurrencyDesc;
	}
	/**
	 * @return the dspCurrencyDesc
	 */
	public String getDspCurrencyDesc() {
		return dspCurrencyDesc;
	}
	
	
}
