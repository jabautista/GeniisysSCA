package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWBankSchedule extends BaseEntity{
	
	private Integer parId;
	private Integer bankItemNo;
	private String bankItemNoC;
	private String bank;
	private String includeTag;
	private String bankAddress;
	private BigDecimal cashInVault;
	private BigDecimal cashInTransit;
	private String remarks;
	public Integer getParId() {
		return parId;
	}
	public void setParId(Integer parId) {
		this.parId = parId;
	}
	public Integer getBankItemNo() {
		return bankItemNo;
	}
	public void setBankItemNo(Integer bankItemNo) {
		this.bankItemNo = bankItemNo;
	}
	public String getBank() {
		return bank;
	}
	public void setBank(String bank) {
		this.bank = bank;
	}
	public String getIncludeTag() {
		return includeTag;
	}
	public void setIncludeTag(String includeTag) {
		this.includeTag = includeTag;
	}
	public String getBankAddress() {
		return bankAddress;
	}
	public void setBankAddress(String bankAddress) {
		this.bankAddress = bankAddress;
	}
	public BigDecimal getCashInVault() {
		return cashInVault;
	}
	public void setCashInVault(BigDecimal cashInVault) {
		this.cashInVault = cashInVault;
	}
	public BigDecimal getCashInTransit() {
		return cashInTransit;
	}
	public void setCashInTransit(BigDecimal cashInTransit) {
		this.cashInTransit = cashInTransit;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public void setBankItemNoC(String bankItemNoC) {
		this.bankItemNoC = bankItemNoC;
	}
	public String getBankItemNoC() {
		return bankItemNoC;
	}
	
	

}
