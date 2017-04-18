/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.entity
	File Name: GICLAccidentDtl.java
	Author: Computer Professional Inc
	Created By: Belle
	Created Date: 11.28.2011
*/
package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLAccidentDtl extends BaseEntity {
	private Integer claimId;
	private Date lossDate;
    private Integer itemNo;                 
    private String  itemTitle;              
    private Integer groupedItemNo;         
    private String  groupedItemTitle;      
    private Integer	currencyCd;             
    private String	dspCurrency;            
    private BigDecimal currencyRate;           
    private Integer	positionCd;             
    private String dspPosition;            
    private BigDecimal monthlySalary; 
    private String controlCd;
    private Integer controlTypeCd;
    private String  dspControlType;        
    private String itemDesc;               
    private String itemDesc2;             
    private Integer levelCd;                
    private String salaryGrade;            
    private String dateOfBirth;  
    private String civilStatus;
    private String dspCivilStat;   
    private String sex;
    private String dspSex;                 
    private Integer age;                      
    private BigDecimal amountCoverage;
    private String lineCd;
    private String sublineCd;
    private String giclItemPerilExist;
	private String giclMortgageeExist;
	private String giclItemPerilMsg;
    
	private String beneficiaryName;
	private String beneficiaryAddr;
	private String relation;
	
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
	public Date getLossDate() {
		return lossDate;
	}
	public void setLossDate(Date lossDate) {
		this.lossDate = lossDate;
	}
	public String getItemTitle() {
		return itemTitle;
	}
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}
	public Integer getGroupedItemNo() {
		return groupedItemNo;
	}
	public void setGroupedItemNo(Integer groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}
	public String getGroupedItemTitle() {
		return groupedItemTitle;
	}
	public void setGroupedItemTitle(String groupedItemTitle) {
		this.groupedItemTitle = groupedItemTitle;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public String getDspCurrency() {
		return dspCurrency;
	}
	public void setDspCurrency(String dspCurrency) {
		this.dspCurrency = dspCurrency;
	}
	public BigDecimal getCurrencyRate() {
		return currencyRate;
	}
	public void setCurrencyRate(BigDecimal currencyRate) {
		this.currencyRate = currencyRate;
	}
	public Integer getPositionCd() {
		return positionCd;
	}
	public void setPositionCd(Integer positionCd) {
		this.positionCd = positionCd;
	}
	public String getDspPosition() {
		return dspPosition;
	}
	public void setDspPosition(String dspPosition) {
		this.dspPosition = dspPosition;
	}
	public BigDecimal getMonthlySalary() {
		return monthlySalary;
	}
	public void setMonthlySalary(BigDecimal monthlySalary) {
		this.monthlySalary = monthlySalary;
	}
	public String getControlCd() {
		return controlCd;
	}
	public void setControlCd(String controlCd) {
		this.controlCd = controlCd;
	}
	public Integer getControlTypeCd() {
		return controlTypeCd;
	}
	public void setControlTypeCd(Integer controlTypeCd) {
		this.controlTypeCd = controlTypeCd;
	}
	public String getDspControlType() {
		return dspControlType;
	}
	public void setDspControlType(String dspControlType) {
		this.dspControlType = dspControlType;
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
	public Integer getLevelCd() {
		return levelCd;
	}
	public void setLevelCd(Integer levelCd) {
		this.levelCd = levelCd;
	}
	public String getSalaryGrade() {
		return salaryGrade;
	}
	public void setSalaryGrade(String salaryGrade) {
		this.salaryGrade = salaryGrade;
	}
	public String getDateOfBirth() {
		return dateOfBirth;
	}
	public void setDateOfBirth(String dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}
	public String getCivilStatus() {
		return civilStatus;
	}
	public void setCivilStatus(String civilStatus) {
		this.civilStatus = civilStatus;
	}
	public String getDspCivilStat() {
		return dspCivilStat;
	}
	public void setDspCivilStat(String dspCivilStat) {
		this.dspCivilStat = dspCivilStat;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public String getDspSex() {
		return dspSex;
	}
	public void setDspSex(String dspSex) {
		this.dspSex = dspSex;
	}
	public Integer getAge() {
		return age;
	}
	public void setAge(Integer age) {
		this.age = age;
	}
	public BigDecimal getAmountCoverage() {
		return amountCoverage;
	}
	public void setAmountCoverage(BigDecimal amountCoverage) {
		this.amountCoverage = amountCoverage;
	}  
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getSublineCd() {
		return sublineCd;
	}
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
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
	public String getBeneficiaryName() {
		return beneficiaryName;
	}
	public void setBeneficiaryName(String beneficiaryName) {
		this.beneficiaryName = beneficiaryName;
	}
	public String getBeneficiaryAddr() {
		return beneficiaryAddr;
	}
	public void setBeneficiaryAddr(String beneficiaryAddr) {
		this.beneficiaryAddr = beneficiaryAddr;
	}
	public String getRelation() {
		return relation;
	}
	public void setRelation(String relation) {
		this.relation = relation;
	}
}
