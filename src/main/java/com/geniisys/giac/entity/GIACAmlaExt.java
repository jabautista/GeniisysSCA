package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;

public class GIACAmlaExt extends BaseEntity {
	private Integer seqNo;
	private String branchCd;
	private String tranDate;
	private String tranType;
	private String refNo;
	private String clientType;
	private BigDecimal localAmt;
	private BigDecimal foreignAmt;
	private String currencySname;
	private String payorType;
	private String corporateName;
	private String lastNAme;
	private String firstNAme;
	private String middleNAme;
	private String address1;
	private String address2;
	private String address3;
	private String birthDate;
	private String policyNo;		//added by Mark C. 07132015 - policyNo, effDate, expiryDate
	private String effDate;
	private String expiryDate;
	
	public Integer getSeqNo() {
		return seqNo;
	}
	public void setSeqNo(Integer seqNo) {
		this.seqNo = seqNo;
	}
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	public String getTranDate() {
		return tranDate;
	}
	public void setTranDate(String tranDate) {
		this.tranDate = tranDate;
	}
	public String getTranType() {
		return tranType;
	}
	public void setTranType(String tranType) {
		this.tranType = tranType;
	}
	public String getRefNo() {
		return refNo;
	}
	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}
	public String getClientType() {
		return clientType;
	}
	public void setClientType(String clientType) {
		this.clientType = clientType;
	}
	public BigDecimal getLocalAmt() {
		return localAmt;
	}
	public void setLocalAmt(BigDecimal localAmt) {
		this.localAmt = localAmt;
	}
	public BigDecimal getForeignAmt() {
		return foreignAmt;
	}
	public void setForeignAmt(BigDecimal foreignAmt) {
		this.foreignAmt = foreignAmt;
	}
	public String getCurrencySname() {
		return currencySname;
	}
	public void setCurrencySname(String currencySname) {
		this.currencySname = currencySname;
	}
	public String getPayorType() {
		return payorType;
	}
	public void setPayorType(String payorType) {
		this.payorType = payorType;
	}
	public String getCorporateName() {
		return corporateName;
	}
	public void setCorporateName(String corporateName) {
		this.corporateName = corporateName;
	}
	public String getLastNAme() {
		return lastNAme;
	}
	public void setLastNAme(String lastNAme) {
		this.lastNAme = lastNAme;
	}
	public String getFirstNAme() {
		return firstNAme;
	}
	public void setFirstNAme(String firstNAme) {
		this.firstNAme = firstNAme;
	}
	public String getMiddleNAme() {
		return middleNAme;
	}
	public void setMiddleNAme(String middleNAme) {
		this.middleNAme = middleNAme;
	}
	public String getAddress1() {
		return address1;
	}
	public void setAddress1(String address1) {
		this.address1 = address1;
	}
	public String getAddress2() {
		return address2;
	}
	public void setAddress2(String address2) {
		this.address2 = address2;
	}
	public String getAddress3() {
		return address3;
	}
	public void setAddress3(String address3) {
		this.address3 = address3;
	}
	public String getBirthDate() {
		return birthDate;
	}
	public void setBirthDate(String birthDate) {
		this.birthDate = birthDate;
	}
	public String getPolicyNo() {
		return policyNo;
	}
	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}
	public String getEffDate() {
		return effDate;
	}
	public void setEffDate(String effDate) {
		this.effDate = effDate;
	}	
	public String getExpiryDate() {
		return expiryDate;
	}
	public void setExpiryDate(String expiryDate) {
		this.expiryDate = expiryDate;
	}
}
