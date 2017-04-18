package com.geniisys.gipi.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIBeneficiary extends BaseEntity{

	private Integer policyId;		
	private Integer itemNo;		
	private Integer beneficiaryNo;		
	private String beneficiaryName;		
	private String beneficiaryAddr;		
	private String deleteSw;		
	private String relation;		
	private Integer cpiRecNo;		
	private String cpiBranchCd;		
	private String remarks;		
	private String civilStatus;		
	private Date dateOfBirth;		
	private Integer age;		
	private String adultSw;		
	private String sex;		
	private Integer positionCd;		
	private String arcExtData;
	
	private String position;
	private String meanSex;
	private String meanCivilStatus;
	
	public GIPIBeneficiary() {
		super();
	}

	public GIPIBeneficiary(Integer policyId, Integer itemNo,
			Integer beneficiaryNo, String beneficiaryName,
			String beneficiaryAddr, String deleteSw, String relation,
			Integer cpiRecNo, String cpiBranchCd, String remarks,
			String civilStatus, Date dateOfBirth, Integer age, String adultSw,
			String sex, Integer positionCd, String arcExtData) {
		super();
		this.policyId = policyId;
		this.itemNo = itemNo;
		this.beneficiaryNo = beneficiaryNo;
		this.beneficiaryName = beneficiaryName;
		this.beneficiaryAddr = beneficiaryAddr;
		this.deleteSw = deleteSw;
		this.relation = relation;
		this.cpiRecNo = cpiRecNo;
		this.cpiBranchCd = cpiBranchCd;
		this.remarks = remarks;
		this.civilStatus = civilStatus;
		this.dateOfBirth = dateOfBirth;
		this.age = age;
		this.adultSw = adultSw;
		this.sex = sex;
		this.positionCd = positionCd;
		this.arcExtData = arcExtData;
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

	public String getArcExtData() {
		return arcExtData;
	}

	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
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

