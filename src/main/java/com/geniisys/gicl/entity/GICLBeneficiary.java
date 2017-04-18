package com.geniisys.gicl.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLBeneficiary extends BaseEntity {
	private Integer claimId;		
	private Integer itemNo;
	private Integer groupedItemNo;
	private Integer beneficiaryNo;		
	private String beneficiaryName;		
	private String beneficiaryAddr;		
	private String relation;		
	private String civilStatus;		
	private String dateOfBirth;		
	private Integer age;		
	private String sex;		
	private Integer positionCd;		
	private String position;
	private String dspSex;
	private String dspCivilStatus;
	private String dspBenPosition;
	
	
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
	public String getCivilStatus() {
		return civilStatus;
	}
	public void setCivilStatus(String civilStatus) {
		this.civilStatus = civilStatus;
	}
	public String getDateOfBirth() {
		return dateOfBirth;
	}
	public void setDateOfBirth(String dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}
	public Integer getAge() {
		return age;
	}
	public void setAge(Integer age) {
		this.age = age;
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
	public String getDspSex() {
		return dspSex;
	}
	public void setDspSex(String dspSex) {
		this.dspSex = dspSex;
	}
	public String getDspCivilStatus() {
		return dspCivilStatus;
	}
	public void setDspCivilStatus(String dspCivilStatus) {
		this.dspCivilStatus = dspCivilStatus;
	}
	public String getDspBenPosition() {
		return dspBenPosition;
	}
	public void setDspBenPosition(String dspBenPosition) {
		this.dspBenPosition = dspBenPosition;
	}
	
}
