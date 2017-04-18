/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Nov 17, 2010
 ***************************************************/
package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLAccountEntries extends BaseEntity{
	private Integer 	accountEntryId;
	private Integer 	adviceId;
	private Integer 	batchCsrId;
	private Integer 	batchDvId;
	private Integer 	claimId;
	private Integer 	claimLossId;
	private BigDecimal	creditAmount;
	private BigDecimal	debitAmount;
	private String 		generationType;
	private Integer		glAccountCategory;
	private Integer		glAccountId;
	private Integer		glControlAccount;
	private Integer		glSubAccount1;
	private Integer		glSubAccount2;
	private Integer		glSubAccount3;
	private Integer		glSubAccount4;
	private Integer		glSubAccount5;
	private Integer		glSubAccount6;
	private Integer		glSubAccount7;
	private Integer		payeeCode;
	private	String		payeeClassCode;
	private String		remarks;
	private Integer		slCode;
	private String 		slSourceCode;
	private String 		slTypeCode;
	private String		nbtGlAcctName;
	private String		glAcctCode;
	
	public Integer getAccountEntryId() {
		return accountEntryId;
	}
	public void setAccountEntryId(Integer accountEntryId) {
		this.accountEntryId = accountEntryId;
	}
	public Integer getAdviceId() {
		return adviceId;
	}
	public void setAdviceId(Integer adviceId) {
		this.adviceId = adviceId;
	}
	public Integer getBatchCsrId() {
		return batchCsrId;
	}
	public void setBatchCsrId(Integer batchCsrId) {
		this.batchCsrId = batchCsrId;
	}
	public Integer getBatchDvId() {
		return batchDvId;
	}
	public void setBatchDvId(Integer batchDvId) {
		this.batchDvId = batchDvId;
	}
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public Integer getClaimLossId() {
		return claimLossId;
	}
	public void setClaimLossId(Integer claimLossId) {
		this.claimLossId = claimLossId;
	}
	public BigDecimal getCreditAmount() {
		return creditAmount;
	}
	public void setCreditAmount(BigDecimal creditAmount) {
		this.creditAmount = creditAmount;
	}
	public BigDecimal getDebitAmount() {
		return debitAmount;
	}
	public void setDebitAmount(BigDecimal debitAmount) {
		this.debitAmount = debitAmount;
	}
	public String getGenerationType() {
		return generationType;
	}
	public void setGenerationType(String generationType) {
		this.generationType = generationType;
	}
	public Integer getGlAccountCategory() {
		return glAccountCategory;
	}
	public void setGlAccountCategory(Integer glAccountCategory) {
		this.glAccountCategory = glAccountCategory;
	}
	public Integer getGlAccountId() {
		return glAccountId;
	}
	public void setGlAccountId(Integer glAccountId) {
		this.glAccountId = glAccountId;
	}
	public Integer getGlControlAccount() {
		return glControlAccount;
	}
	public void setGlControlAccount(Integer glControlAccount) {
		this.glControlAccount = glControlAccount;
	}
	public Integer getGlSubAccount1() {
		return glSubAccount1;
	}
	public void setGlSubAccount1(Integer glSubAccount1) {
		this.glSubAccount1 = glSubAccount1;
	}
	public Integer getGlSubAccount2() {
		return glSubAccount2;
	}
	public void setGlSubAccount2(Integer glSubAccount2) {
		this.glSubAccount2 = glSubAccount2;
	}
	public Integer getGlSubAccount3() {
		return glSubAccount3;
	}
	public void setGlSubAccount3(Integer glSubAccount3) {
		this.glSubAccount3 = glSubAccount3;
	}
	public Integer getGlSubAccount4() {
		return glSubAccount4;
	}
	public void setGlSubAccount4(Integer glSubAccount4) {
		this.glSubAccount4 = glSubAccount4;
	}
	public Integer getGlSubAccount5() {
		return glSubAccount5;
	}
	public void setGlSubAccount5(Integer glSubAccount5) {
		this.glSubAccount5 = glSubAccount5;
	}
	public Integer getGlSubAccount6() {
		return glSubAccount6;
	}
	public void setGlSubAccount6(Integer glSubAccount6) {
		this.glSubAccount6 = glSubAccount6;
	}
	public Integer getGlSubAccount7() {
		return glSubAccount7;
	}
	public void setGlSubAccount7(Integer glSubAccount7) {
		this.glSubAccount7 = glSubAccount7;
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
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public Integer getSlCode() {
		return slCode;
	}
	public void setSlCode(Integer slCode) {
		this.slCode = slCode;
	}
	public String getSlSourceCode() {
		return slSourceCode;
	}
	public void setSlSourceCode(String slSourceCode) {
		this.slSourceCode = slSourceCode;
	}
	public String getSlTypeCode() {
		return slTypeCode;
	}
	public void setSlTypeCode(String slTypeCode) {
		this.slTypeCode = slTypeCode;
	}
	public void setNbtGlAcctName(String nbtGlAcctName) {
		this.nbtGlAcctName = nbtGlAcctName;
	}
	public String getNbtGlAcctName() {
		return nbtGlAcctName;
	}
	public void setGlAcctCode(String glAcctCode) {
		this.glAcctCode = glAcctCode;
	}
	public String getGlAcctCode() {
		return glAcctCode;
	}
}