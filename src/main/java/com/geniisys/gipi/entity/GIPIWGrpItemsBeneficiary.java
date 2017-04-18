package com.geniisys.gipi.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWGrpItemsBeneficiary extends BaseEntity{
	
	private Integer parId;
	private Integer itemNo;
	private String groupedItemNo;
	private String beneficiaryNo;
	private String beneficiaryName;
	private String beneficiaryAddr;
	private String relation;
	private Date dateOfBirth;
	private String age;
	private String civilStatus;
	private String sex;
	private String civilStatusDesc;	

	public GIPIWGrpItemsBeneficiary(){
		
	}
	
	public GIPIWGrpItemsBeneficiary(final Integer parId,final Integer itemNo,
			final String groupedItemNo, final String beneficiaryNo, final String beneficiaryName,
			final String beneficiaryAddr, final String relation, final Date dateOfBirth,
			final String age, final String civilStatus, final String sex){
		this.parId = parId;
		this.itemNo = itemNo;
		this.groupedItemNo = groupedItemNo;
		this.beneficiaryNo = beneficiaryNo;
		this.beneficiaryName = beneficiaryName;
		this.beneficiaryAddr = beneficiaryAddr;
		this.relation = relation;
		this.dateOfBirth = dateOfBirth;
		this.age = age;
		this.civilStatus = civilStatus;
		this.sex =sex;
	}
	
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
	public String getGroupedItemNo() {
		return groupedItemNo;
	}
	public void setGroupedItemNo(String groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}
	public String getBeneficiaryNo() {
		return beneficiaryNo;
	}
	public void setBeneficiaryNo(String beneficiaryNo) {
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
	public String getAge() {
		return age;
	}
	public void setAge(String age) {
		this.age = age;
	}
	public String getCivilStatus() {
		return civilStatus;
	}
	public void setCivilStatus(String civilStatus) {
		this.civilStatus = civilStatus;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public String getCivilStatusDesc() {
		return civilStatusDesc;
	}
	public void setCivilStatusDesc(String civilStatusDesc) {
		this.civilStatusDesc = civilStatusDesc;
	}
}
