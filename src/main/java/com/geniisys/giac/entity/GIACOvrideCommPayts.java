package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACOvrideCommPayts extends BaseEntity {

	private Integer gaccTranId;
	
	private Integer transactionType;
	
	private String issCd;
	
	private Integer premSeqNo;
	
	private Integer intmNo;
	
	private Integer childIntmNo;
	
	private BigDecimal commAmt;
	
	private BigDecimal inputVAT;
	
	private BigDecimal wtaxAmt;
	
	private BigDecimal drvCommAmt;
	
	private String particulars;
	
	private String userId;
	
	private Date lastUpdate;
	
	private BigDecimal foreignCurrAmt;
	
	private BigDecimal convertRt;
	
	private Integer currencyCd;
	
	private String currencyDesc;
	
	private String policyNo;
	
	private String assdName;
	
	private String childIntmName;
	
	private String intermediaryName;

	public Integer getGaccTranId() {
		return gaccTranId;
	}

	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}

	public Integer getTransactionType() {
		return transactionType;
	}

	public void setTransactionType(Integer transactionType) {
		this.transactionType = transactionType;
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

	public Integer getIntmNo() {
		return intmNo;
	}

	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}

	public Integer getChildIntmNo() {
		return childIntmNo;
	}

	public void setChildIntmNo(Integer childIntmNo) {
		this.childIntmNo = childIntmNo;
	}

	public BigDecimal getCommAmt() {
		return commAmt;
	}

	public void setCommAmt(BigDecimal commAmt) {
		this.commAmt = commAmt;
	}

	public BigDecimal getInputVAT() {
		return inputVAT;
	}

	public void setInputVAT(BigDecimal inputVAT) {
		this.inputVAT = inputVAT;
	}

	public BigDecimal getWtaxAmt() {
		return wtaxAmt;
	}

	public void setWtaxAmt(BigDecimal wtaxAmt) {
		this.wtaxAmt = wtaxAmt;
	}

	public BigDecimal getDrvCommAmt() {
		return drvCommAmt;
	}

	public void setDrvCommAmt(BigDecimal drvCommAmt) {
		this.drvCommAmt = drvCommAmt;
	}

	public String getParticulars() {
		return particulars;
	}

	public void setParticulars(String particulars) {
		this.particulars = particulars;
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

	public BigDecimal getForeignCurrAmt() {
		return foreignCurrAmt;
	}

	public void setForeignCurrAmt(BigDecimal foreignCurrAmt) {
		this.foreignCurrAmt = foreignCurrAmt;
	}

	public BigDecimal getConvertRt() {
		return convertRt;
	}

	public void setConvertRt(BigDecimal convertRt) {
		this.convertRt = convertRt;
	}

	public Integer getCurrencyCd() {
		return currencyCd;
	}

	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}

	public String getCurrencyDesc() {
		return currencyDesc;
	}

	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}

	public String getPolicyNo() {
		return policyNo;
	}

	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}

	public String getAssdName() {
		return assdName;
	}

	public void setAssdName(String assdName) {
		this.assdName = assdName;
	}

	public String getChildIntmName() {
		return childIntmName;
	}

	public void setChildIntmName(String childIntmName) {
		this.childIntmName = childIntmName;
	}

	public String getIntermediaryName() {
		return intermediaryName;
	}

	public void setIntermediaryName(String intermediaryName) {
		this.intermediaryName = intermediaryName;
	}
}
