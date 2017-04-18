package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACDCBBankDep extends BaseEntity {

	private Integer gaccTranId;
	
	private String fundCd;
	
	private String branchCd;
	
	private Integer dcbYear;
	
	private Integer dcbNo;
	
	private Integer itemNo;
	
	private Date dcbDate;
	
	private String bankCd;
	
	private String bankAcctCd;
	
	private String payMode;
	
	private BigDecimal amount;
	
	private Integer currencyCd;
	
	private BigDecimal foreignCurrAmt;
	
	private BigDecimal currencyRt;
	
	private BigDecimal oldDepAmt;
	
	private BigDecimal adjAmt;
	
	private String remarks;
	
	private String userId;
	
	private Date lastUpdate;

	public Integer getGaccTranId() {
		return gaccTranId;
	}

	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}

	public String getFundCd() {
		return fundCd;
	}

	public void setFundCd(String fundCd) {
		this.fundCd = fundCd;
	}

	public String getBranchCd() {
		return branchCd;
	}

	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}

	public Integer getDcbYear() {
		return dcbYear;
	}

	public void setDcbYear(Integer dcbYear) {
		this.dcbYear = dcbYear;
	}

	public Integer getDcbNo() {
		return dcbNo;
	}

	public void setDcbNo(Integer dcbNo) {
		this.dcbNo = dcbNo;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	public Date getDcbDate() {
		return dcbDate;
	}

	public void setDcbDate(Date dcbDate) {
		this.dcbDate = dcbDate;
	}

	public String getBankCd() {
		return bankCd;
	}

	public void setBankCd(String bankCd) {
		this.bankCd = bankCd;
	}

	public String getBankAcctCd() {
		return bankAcctCd;
	}

	public void setBankAcctCd(String bankAcctCd) {
		this.bankAcctCd = bankAcctCd;
	}

	public String getPayMode() {
		return payMode;
	}

	public void setPayMode(String payMode) {
		this.payMode = payMode;
	}

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	public Integer getCurrencyCd() {
		return currencyCd;
	}

	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}

	public BigDecimal getForeignCurrAmt() {
		return foreignCurrAmt;
	}

	public void setForeignCurrAmt(BigDecimal foreignCurrAmt) {
		this.foreignCurrAmt = foreignCurrAmt;
	}

	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}

	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}

	public BigDecimal getOldDepAmt() {
		return oldDepAmt;
	}

	public void setOldDepAmt(BigDecimal oldDepAmt) {
		this.oldDepAmt = oldDepAmt;
	}

	public BigDecimal getAdjAmt() {
		return adjAmt;
	}

	public void setAdjAmt(BigDecimal adjAmt) {
		this.adjAmt = adjAmt;
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

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getRemarks() {
		return remarks;
	}
}
