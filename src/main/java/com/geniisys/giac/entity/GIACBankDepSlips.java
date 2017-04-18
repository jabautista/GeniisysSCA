package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACBankDepSlips extends BaseEntity {

	private Integer depId;
	
	private Integer depNo;
	
	private Integer gaccTranId;
	
	private Integer itemNo;
	
	private String fundCd;
	
	private String branchCd;
	
	private Integer dcbNo;
	
	private Integer dcbYear;
	
	private String checkClass;
	
	private Date validationDt;
	
	private BigDecimal amount;
	
	private BigDecimal foreignCurrAmt;
	
	private BigDecimal currencyRt;
	
	private Integer currencyCd;
	
	private BigDecimal shortOver;
	private BigDecimal netDeposit;
	private String bookTag;

	public BigDecimal getShortOver() {
		return shortOver;
	}

	public void setShortOver(BigDecimal shortOver) {
		this.shortOver = shortOver;
	}

	public BigDecimal getNetDeposit() {
		return netDeposit;
	}

	public void setNetDeposit(BigDecimal netDeposit) {
		this.netDeposit = netDeposit;
	}

	public String getBookTag() {
		return bookTag;
	}

	public void setBookTag(String bookTag) {
		this.bookTag = bookTag;
	}

	public Integer getDepId() {
		return depId;
	}

	public void setDepId(Integer depId) {
		this.depId = depId;
	}

	public Integer getGaccTranId() {
		return gaccTranId;
	}

	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
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

	public Integer getDcbNo() {
		return dcbNo;
	}

	public void setDcbNo(Integer dcbNo) {
		this.dcbNo = dcbNo;
	}

	public Integer getDcbYear() {
		return dcbYear;
	}

	public void setDcbYear(Integer dcbYear) {
		this.dcbYear = dcbYear;
	}

	public String getCheckClass() {
		return checkClass;
	}

	public void setCheckClass(String checkClass) {
		this.checkClass = checkClass;
	}

	public Date getValidationDt() {
		return validationDt;
	}

	public void setValidationDt(Date validationDt) {
		this.validationDt = validationDt;
	}

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
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

	public Integer getCurrencyCd() {
		return currencyCd;
	}

	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}

	public void setDepNo(Integer depNo) {
		this.depNo = depNo;
	}

	public Integer getDepNo() {
		return depNo;
	}
}
