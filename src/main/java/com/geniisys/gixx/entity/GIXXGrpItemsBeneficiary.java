package com.geniisys.gixx.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIXXGrpItemsBeneficiary extends BaseEntity{
	
	private Integer extractId;
	private Integer policyId;
	private Integer itemNo;
	private Integer groupedItemNo;
	private Integer beneficiaryNo;
	private String beneficiaryName;
	private String beneficiaryAddr;
	private String relation;
	private Date dateOfBirth;
	private Integer age;
	private String civil_status;
	private String sex;
	private String userId;
	private Date lastUpdate;
	private String civilStatus;
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
	public Integer getGroupedItemNo() {
		return groupedItemNo;
	}
	public void setGroupedItemNo(Integer groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
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
	public String getRelation() {
		return relation;
	}
	public void setRelation(String relation) {
		this.relation = relation;
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
	public String getCivil_status() {
		return civil_status;
	}
	public void setCivil_status(String civil_status) {
		this.civil_status = civil_status;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public Date getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	public String getCivilStatus() {
		return civilStatus;
	}
	public void setCivilStatus(String civilStatus) {
		this.civilStatus = civilStatus;
	}
	
	

}
