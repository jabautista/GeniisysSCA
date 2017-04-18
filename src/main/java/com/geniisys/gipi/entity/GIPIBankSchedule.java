package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIBankSchedule extends BaseEntity{
	

	private Integer policyId;		
	private String bankLineCd;		
	private String bankSublineCd;		
	private String bankIssCd;		
	private Integer bankIssueYy;		
	private Integer bankPolSeqNo;		
	private Integer bankEndtSeqNo;		
	private Integer bankRenewNo;		
	private Date bankEffDate;		
	private Integer bankItemNo;		
	private String bank;		
	private String includeTag;		
	private String bankAddress;		
	private BigDecimal cashInVault;		
	private BigDecimal cashInTransit;		
	private String remarks;		
	private Integer cpiRecNo;		
	private String cpiBranchCd;		
	private String arcExtData;
	
	public GIPIBankSchedule() {
		super();
		// TODO Auto-generated constructor stub
	}

	public GIPIBankSchedule(Integer policyId, String bankLineCd,
			String bankSublineCd, String bankIssCd, Integer bankIssueYy,
			Integer bankPolSeqNo, Integer bankEndtSeqNo, Integer bankRenewNo,
			Date bankEffDate, Integer bankItemNo, String bank,
			String includeTag, String bankAddress, BigDecimal cashInVault,
			BigDecimal cashInTransit, String remarks, Integer cpiRecNo,
			String cpiBranchCd, String arcExtData) {
		super();
		this.policyId = policyId;
		this.bankLineCd = bankLineCd;
		this.bankSublineCd = bankSublineCd;
		this.bankIssCd = bankIssCd;
		this.bankIssueYy = bankIssueYy;
		this.bankPolSeqNo = bankPolSeqNo;
		this.bankEndtSeqNo = bankEndtSeqNo;
		this.bankRenewNo = bankRenewNo;
		this.bankEffDate = bankEffDate;
		this.bankItemNo = bankItemNo;
		this.bank = bank;
		this.includeTag = includeTag;
		this.bankAddress = bankAddress;
		this.cashInVault = cashInVault;
		this.cashInTransit = cashInTransit;
		this.remarks = remarks;
		this.cpiRecNo = cpiRecNo;
		this.cpiBranchCd = cpiBranchCd;
		this.arcExtData = arcExtData;
	}

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
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

	public String getArcExtData() {
		return arcExtData;
	}

	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}
	
	

}
