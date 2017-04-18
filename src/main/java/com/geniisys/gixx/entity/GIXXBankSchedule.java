package com.geniisys.gixx.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIXXBankSchedule extends BaseEntity{

	private Integer extractId;
	private Integer bankItemNo;	
	private String bank;
	private BigDecimal cashInVault;		
	private BigDecimal cashInTransit;	
	private String bankLineCd;		
	private String bankSublineCd;		
	private String bankIssCd;		
	private Integer bankIssueYy;		
	private Integer bankPolSeqNo;		
	private Integer bankEndtSeqNo;		
	private Integer bankRenewNo;		
	private Date bankEffDate;	
	private String includeTag;		
	private String bankAddress;
	
	
	public Integer getExtractId() {
		return extractId;
	}
	public void setExtractId(Integer extractId) {
		this.extractId = extractId;
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
	public String getBankLineCd() {
		return bankLineCd;
	}
	public void setBankLineCd(String bankLineCd) {
		this.bankLineCd = bankLineCd;
	}
	public String getBankSublineCd() {
		return bankSublineCd;
	}
	public void setBankSublineCd(String bankSublineCd) {
		this.bankSublineCd = bankSublineCd;
	}
	public String getBankIssCd() {
		return bankIssCd;
	}
	public void setBankIssCd(String bankIssCd) {
		this.bankIssCd = bankIssCd;
	}
	public Integer getBankIssueYy() {
		return bankIssueYy;
	}
	public void setBankIssueYy(Integer bankIssueYy) {
		this.bankIssueYy = bankIssueYy;
	}
	public Integer getBankPolSeqNo() {
		return bankPolSeqNo;
	}
	public void setBankPolSeqNo(Integer bankPolSeqNo) {
		this.bankPolSeqNo = bankPolSeqNo;
	}
	public Integer getBankEndtSeqNo() {
		return bankEndtSeqNo;
	}
	public void setBankEndtSeqNo(Integer bankEndtSeqNo) {
		this.bankEndtSeqNo = bankEndtSeqNo;
	}
	public Integer getBankRenewNo() {
		return bankRenewNo;
	}
	public void setBankRenewNo(Integer bankRenewNo) {
		this.bankRenewNo = bankRenewNo;
	}
	public Date getBankEffDate() {
		return bankEffDate;
	}
	public void setBankEffDate(Date bankEffDate) {
		this.bankEffDate = bankEffDate;
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
	
	
}
