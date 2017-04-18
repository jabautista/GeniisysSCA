package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;

public class GIACPdcPayts extends BaseEntity{
	private Integer gaccTranId;
	private String issCd;
	private Integer premSeqNo;
	private Integer instNo;
	private BigDecimal collectionAmt;
	private Integer currencyCd;
	private BigDecimal currencyRt;
	private BigDecimal fcurrencyAmt;
	private String particulars;
	private String recordFlag;
	private Integer transactionType;
	
	public GIACPdcPayts(Integer gaccTranId, String issCd, Integer premSeqNo,
			Integer instNo, BigDecimal collectionAmt, Integer currencyCd,
			BigDecimal currencyRt, BigDecimal fcurrencyAmt, String particulars,
			String recordFlag, Integer transactionType) {
		this.gaccTranId = gaccTranId;
		this.issCd = issCd;
		this.premSeqNo = premSeqNo;
		this.instNo = instNo;
		this.collectionAmt = collectionAmt;
		this.currencyCd = currencyCd;
		this.currencyRt = currencyRt;
		this.fcurrencyAmt = fcurrencyAmt;
		this.particulars = particulars;
		this.recordFlag = recordFlag;
		this.transactionType = transactionType;
	}

	public GIACPdcPayts() {

	}

	public Integer getGaccTranId() {
		return gaccTranId;
	}

	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public Integer getPremSeqNo() {
		return premSeqNo;
	}

	public void setPremSeqNo(Integer premSeqNo) {
		this.premSeqNo = premSeqNo;
	}

	public Integer getInstNo() {
		return instNo;
	}

	public void setInstNo(Integer instNo) {
		this.instNo = instNo;
	}

	public BigDecimal getCollectionAmt() {
		return collectionAmt;
	}

	public void setCollectionAmt(BigDecimal collectionAmt) {
		this.collectionAmt = collectionAmt;
	}

	public Integer getCurrencyCd() {
		return currencyCd;
	}

	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}

	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}

	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}

	public BigDecimal getFcurrencyAmt() {
		return fcurrencyAmt;
	}

	public void setFcurrencyAmt(BigDecimal fcurrencyAmt) {
		this.fcurrencyAmt = fcurrencyAmt;
	}

	public String getParticulars() {
		return particulars;
	}

	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}

	public String getRecordFlag() {
		return recordFlag;
	}

	public void setRecordFlag(String recordFlag) {
		this.recordFlag = recordFlag;
	}

	public Integer getTransactionType() {
		return transactionType;
	}

	public void setTransactionType(Integer transactionType) {
		this.transactionType = transactionType;
	}

}
