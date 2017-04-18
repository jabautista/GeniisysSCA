package com.geniisys.gipi.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWBeneficiary extends BaseEntity{

	private String parId;
	private String itemNo;
	private String beneficiaryNo;
	private String beneficiaryName;
	private String beneficiaryAddr;
	private String deleteSw;
	private String relation;
	private String remarks;
	private String adultSw;
	private String age;
	private String civilStatus;
	private Date dateOfBirth;
	private String positionCd;
	private String sex;
	
	public GIPIWBeneficiary(){
	
	}
	
	public GIPIWBeneficiary(final String parId, final String itemNo,
			final String beneficiaryNo, final String beneficiaryName,
			final String beneficiaryAddr, final String relation,
			final Date dateOfBirth, final String age,
			final String remarks){
		this.parId = parId;
		this.itemNo = itemNo;
		this.beneficiaryNo = beneficiaryNo;
		this.beneficiaryName = beneficiaryName;
		this.beneficiaryAddr = beneficiaryAddr;
		this.relation = relation;
		this.dateOfBirth = dateOfBirth;
		this.age = age;
		this.remarks = remarks;
	}
	
	public String getParId() {
		return parId;
	}
	public void setParId(String parId) {
		this.parId = parId;
	}
	public String getItemNo() {
		return itemNo;
	}
	public void setItemNo(String itemNo) {
		this.itemNo = itemNo;
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
	public String getAdultSw() {
		return adultSw;
	}
	public void setAdultSw(String adultSw) {
		this.adultSw = adultSw;
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
	public Date getDateOfBirth() {
		return dateOfBirth;
	}
	public void setDateOfBirth(Date dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}
	public String getPositionCd() {
		return positionCd;
	}
	public void setPositionCd(String positionCd) {
		this.positionCd = positionCd;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	
}
