package com.geniisys.gixx.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIXXBeneficiary extends BaseEntity{

	private Integer extractId;
	private Integer policyId;		
	private Integer itemNo;		
	private Integer beneficiaryNo;		
	private String beneficiaryName;		
	private String beneficiaryAddr;		
	private String deleteSw;		
	private String relation;		
	private String remarks;		
	private String civilStatus;		
	private Date dateOfBirth;		
	private Integer age;		
	private String adultSw;		
	private String sex;		
	private Integer positionCd;		
	
	private String position;
	private String meanSex;
	private String meanCivilStatus;
	
	
	public Integer getExtractId() {
		return extractId;
	}
	public void setExtractId(Integer extractId) {
		this.extractId = extractId;
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
	public Integer getBeneficiaryNo() {
		return beneficiaryNo;
	}
	public void setBeneficiaryNo(Integer beneficiaryNo) {
		this.beneficiaryNo = beneficiaryNo;
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
	public String getDeleteSw() {
		return deleteSw;
	}
	public void setDeleteSw(String deleteSw) {
		this.deleteSw = deleteSw;
	}
	public String getRelation() {
		return relation;
	}
	public void setRelation(String relation) {
		this.relation = relation;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getCivilStatus() {
		return civilStatus;
	}
	public void setCivilStatus(String civilStatus) {
		this.civilStatus = civilStatus;
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
	public String getAdultSw() {
		return adultSw;
	}
	public void setAdultSw(String adultSw) {
		this.adultSw = adultSw;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public Integer getPositionCd() {
		return positionCd;
	}
	public void setPositionCd(Integer positionCd) {
		this.positionCd = positionCd;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public String getMeanSex() {
		return meanSex;
	}
	public void setMeanSex(String meanSex) {
		this.meanSex = meanSex;
	}
	public String getMeanCivilStatus() {
		return meanCivilStatus;
	}
	public void setMeanCivilStatus(String meanCivilStatus) {
		this.meanCivilStatus = meanCivilStatus;
	}
	
	
	
}
