/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Jul 20, 2011
 ***************************************************/
/**
 * 
 */
package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

/**
 * @author rencela
 */
public class GICLClaimLoss extends BaseEntity{
	
	private Integer claimId;
	private Integer historySequenceNumber;
	private Integer itemNumber;
	private Integer perilCode;
	private Integer payeeCode;
	private String payeeClassCode;
	private String distributionSwitch;
	private String exGratiaSwitch;
	private Integer currencyCode;
	private BigDecimal convertRate;
	private Date accountEntryDate;
	private Date olEntryDate;
	private BigDecimal lossPdAmount;
	private BigDecimal lossAdvAmount;
	private BigDecimal lossResAmount;
	private BigDecimal lossNetAmount;
	private Integer cpiRecNo;
	private String cpiBranchCode;
	
	public GICLClaimLoss(){
		/* empty constructor */
	}

	public Integer getClaimId() {
		return claimId;
	}

	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}

	public Integer getHistorySequenceNumber() {
		return historySequenceNumber;
	}

	public void setHistorySequenceNumber(Integer historySequenceNumber) {
		this.historySequenceNumber = historySequenceNumber;
	}

	public Integer getItemNumber() {
		return itemNumber;
	}

	public void setItemNumber(Integer itemNumber) {
		this.itemNumber = itemNumber;
	}

	public Integer getPerilCode() {
		return perilCode;
	}

	public void setPerilCode(Integer perilCode) {
		this.perilCode = perilCode;
	}

	public Integer getPayeeCode() {
		return payeeCode;
	}

	public void setPayeeCode(Integer payeeCode) {
		this.payeeCode = payeeCode;
	}

	public String getPayeeClassCode() {
		return payeeClassCode;
	}

	public void setPayeeClassCode(String payeeClassCode) {
		this.payeeClassCode = payeeClassCode;
	}

	public String getDistributionSwitch() {
		return distributionSwitch;
	}

	public void setDistributionSwitch(String distributionSwitch) {
		this.distributionSwitch = distributionSwitch;
	}

	public String getExGratiaSwitch() {
		return exGratiaSwitch;
	}

	public void setExGratiaSwitch(String exGratiaSwitch) {
		this.exGratiaSwitch = exGratiaSwitch;
	}

	public Integer getCurrencyCode() {
		return currencyCode;
	}

	public void setCurrencyCode(Integer currencyCode) {
		this.currencyCode = currencyCode;
	}

	public BigDecimal getConvertRate() {
		return convertRate;
	}

	public void setConvertRate(BigDecimal convertRate) {
		this.convertRate = convertRate;
	}

	public Date getAccountEntryDate() {
		return accountEntryDate;
	}

	public void setAccountEntryDate(Date accountEntryDate) {
		this.accountEntryDate = accountEntryDate;
	}

	public Date getOlEntryDate() {
		return olEntryDate;
	}

	public void setOlEntryDate(Date olEntryDate) {
		this.olEntryDate = olEntryDate;
	}

	public BigDecimal getLossPdAmount() {
		return lossPdAmount;
	}

	public void setLossPdAmount(BigDecimal lossPdAmount) {
		this.lossPdAmount = lossPdAmount;
	}

	public BigDecimal getLossAdvAmount() {
		return lossAdvAmount;
	}

	public void setLossAdvAmount(BigDecimal lossAdvAmount) {
		this.lossAdvAmount = lossAdvAmount;
	}

	public BigDecimal getLossResAmount() {
		return lossResAmount;
	}

	public void setLossResAmount(BigDecimal lossResAmount) {
		this.lossResAmount = lossResAmount;
	}

	public BigDecimal getLossNetAmount() {
		return lossNetAmount;
	}

	public void setLossNetAmount(BigDecimal lossNetAmount) {
		this.lossNetAmount = lossNetAmount;
	}

	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	public String getCpiBranchCode() {
		return cpiBranchCode;
	}

	public void setCpiBranchCode(String cpiBranchCode) {
		this.cpiBranchCode = cpiBranchCode;
	}
	
}