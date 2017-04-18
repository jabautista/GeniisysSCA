package com.geniisys.gipi.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIAccidentItem extends BaseEntity {
	private Integer policyId;
	private Integer itemNo;
	private Date dateOfBirth;
	private Integer age;
	private String civilStatus;
	private Integer positionCd;
	private Integer monthlySalary;
	//private Integer salaryGrade; replaced by: Nica 05.14.2013
	private String salaryGrade;
	private Integer noOfPersons;
	private String destination;
	private String height;
	private String weight;
	private String sex;
	private String acClassCd;
	private String groupPrintSw;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String levelCd;
	private Integer parentLevelCd;
	private Integer arcExtData;
	
	private String sexDesc;
	private String position;
	private String status;
	private Date travelFromDate;
	private Date travelToDate;
	private String itemTitle;
	private String paytTerms;
	private Date effFromDate;
	private Date effToDate;
	private String packageCd;
	
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
	public Date getDateOfBirth() {
		return dateOfBirth;
	}
	public void setDateOfBirth(Date dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}
	public Integer getAge() {
		return age;
	}
	public void setAge(Integer age) {
		this.age = age;
	}
	public String getCivilStatus() {
		return civilStatus;
	}
	public void setCivilStatus(String civilStatus) {
		this.civilStatus = civilStatus;
	}
	public Integer getPositionCd() {
		return positionCd;
	}
	public void setPositionCd(Integer positionCd) {
		this.positionCd = positionCd;
	}
	public Integer getMonthlySalary() {
		return monthlySalary;
	}
	public void setMonthlySalary(Integer monthlySalary) {
		this.monthlySalary = monthlySalary;
	}
	public String getSalaryGrade() {
		return salaryGrade;
	}
	public void setSalaryGrade(String salaryGrade) {
		this.salaryGrade = salaryGrade;
	}
	/*public Integer getSalaryGrade() {
		return salaryGrade;
	}
	public void setSalaryGrade(Integer salaryGrade) {
		this.salaryGrade = salaryGrade;
	}*/
	public Integer getNoOfPersons() {
		return noOfPersons;
	}
	public void setNoOfPersons(Integer noOfPersons) {
		this.noOfPersons = noOfPersons;
	}
	public String getDestination() {
		return destination;
	}
	public void setDestination(String destination) {
		this.destination = destination;
	}
	public String getHeight() {
		return height;
	}
	public void setHeight(String height) {
		this.height = height;
	}
	public String getWeight() {
		return weight;
	}
	public void setWeight(String weight) {
		this.weight = weight;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public String getAcClassCd() {
		return acClassCd;
	}
	public void setAcClassCd(String acClassCd) {
		this.acClassCd = acClassCd;
	}
	public String getGroupPrintSw() {
		return groupPrintSw;
	}
	public void setGroupPrintSw(String groupPrintSw) {
		this.groupPrintSw = groupPrintSw;
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
	public String getLevelCd() {
		return levelCd;
	}
	public void setLevelCd(String levelCd) {
		this.levelCd = levelCd;
	}
	public Integer getParentLevelCd() {
		return parentLevelCd;
	}
	public void setParentLevelCd(Integer parentLevelCd) {
		this.parentLevelCd = parentLevelCd;
	}
	public Integer getArcExtData() {
		return arcExtData;
	}
	public void setArcExtData(Integer arcExtData) {
		this.arcExtData = arcExtData;
	}
	public String getSexDesc() {
		return sexDesc;
	}
	public void setSexDesc(String sexDesc) {
		this.sexDesc = sexDesc;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Date getTravelFromDate() {
		return travelFromDate;
	}
	public void setTravelFromDate(Date travelFromDate) {
		this.travelFromDate = travelFromDate;
	}
	public Date getTravelToDate() {
		return travelToDate;
	}
	public void setTravelToDate(Date travelToDate) {
		this.travelToDate = travelToDate;
	}
	public String getItemTitle() {
		return itemTitle;
	}
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}
	public String getPaytTerms() {
		return paytTerms;
	}
	public void setPaytTerms(String paytTerms) {
		this.paytTerms = paytTerms;
	}
	public Date getEffFromDate() {
		return effFromDate;
	}
	public void setEffFromDate(Date effFromDate) {
		this.effFromDate = effFromDate;
	}
	public Date getEffToDate() {
		return effToDate;
	}
	public void setEffToDate(Date effToDate) {
		this.effToDate = effToDate;
	}
	public String getPackageCd() {
		return packageCd;
	}
	public void setPackageCd(String packageCd) {
		this.packageCd = packageCd;
	}	
	
}
