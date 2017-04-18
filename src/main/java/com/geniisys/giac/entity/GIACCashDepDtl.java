package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;

public class GIACCashDepDtl extends BaseEntity{
	
	private Integer gaccTranId;
	private Integer itemNo;
	private String fundCd;
	private String branchCd;
	private Integer dcbNo;
	private Integer dcbYear;
	private BigDecimal amount;
	private BigDecimal foreignCurrAmt;
	private BigDecimal currencyRt;
	private Integer currencyCd;
	private BigDecimal shortOver;
	private BigDecimal netDeposit;
	private String bookTag;
	private String remarks;
	
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
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
}
