package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACInwFaculPremCollns extends BaseEntity{
	
	private Integer gaccTranId;
	private Integer transactionType;
	private Integer a180RiCd;
	private String b140IssCd;
	private Integer b140PremSeqNo;
	private Integer instNo;
	private BigDecimal premiumAmt;
	private BigDecimal commAmt;
	private BigDecimal wholdingTax;
	private String particulars;
	private Integer currencyCd;
	private BigDecimal convertRate;
	private BigDecimal foreignCurrAmt;
	private BigDecimal collectionAmt;
	private String orPrintTag;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private BigDecimal taxAmount;
	private BigDecimal commVat;
	private String userId;
	private Date lastUpdate;
	//non-base table item
	private String transactionTypeDesc;
	private String transactionTypeAndDesc;
	private String riName;
	private String assdNo;
	private String assdName;
	private String riPolicyNo;
	private String drvPolicyNo;
	private String currencyDesc;
	private String savedItems;
	private String refNo;
	private Date tranDate;
	private BigDecimal premTax;
	private BigDecimal commWtax;
	private BigDecimal totalPremWtax;
	private BigDecimal totalCommWtax;
	private BigDecimal totalCollection;
	
	private Integer revGaccTranId;
	
	
	public GIACInwFaculPremCollns(Integer gaccTranId, Integer transactionType, Integer a180RiCd,
			String b140IssCd, Integer b140PremSeqNo, Integer instNo, BigDecimal premiumAmt,
			BigDecimal commAmt, BigDecimal wholdingTax, String particulars,
			Integer currencyCd, BigDecimal convertRate, BigDecimal foreignCurrAmt,
			BigDecimal collectionAmt, String orPrintTag, Integer cpiRecNo,
			String cpiBranchCd, BigDecimal taxAmount, BigDecimal commVat,
			String savedItems, String userId) {
		this.gaccTranId = gaccTranId;
		this.transactionType = transactionType;
		this.a180RiCd = a180RiCd;
		this.b140IssCd = b140IssCd;
		this.b140PremSeqNo = b140PremSeqNo;
		this.instNo = instNo;
		this.premiumAmt = premiumAmt;
		this.commAmt = commAmt;
		this.wholdingTax = wholdingTax;
		this.particulars = particulars;
		this.currencyCd = currencyCd;
		this.convertRate = convertRate;
		this.foreignCurrAmt = foreignCurrAmt;
		this.collectionAmt = collectionAmt;
		this.orPrintTag = orPrintTag;
		this.cpiRecNo = cpiRecNo;
		this.cpiBranchCd = cpiBranchCd;
		this.taxAmount = taxAmount;
		this.commVat = commVat;
		this.savedItems = savedItems;
		this.userId = userId;
	}
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
	public Integer getA180RiCd() {
		return a180RiCd;
	}
	public void setA180RiCd(Integer a180RiCd) {
		this.a180RiCd = a180RiCd;
	}
	public String getB140IssCd() {
		return b140IssCd;
	}
	public void setB140IssCd(String b140IssCd) {
		this.b140IssCd = b140IssCd;
	}
	public Integer getB140PremSeqNo() {
		return b140PremSeqNo;
	}
	public void setB140PremSeqNo(Integer b140PremSeqNo) {
		this.b140PremSeqNo = b140PremSeqNo;
	}
	public Integer getInstNo() {
		return instNo;
	}
	public void setInstNo(Integer instNo) {
		this.instNo = instNo;
	}
	public BigDecimal getPremiumAmt() {
		return premiumAmt;
	}
	public void setPremiumAmt(BigDecimal premiumAmt) {
		this.premiumAmt = premiumAmt;
	}
	public BigDecimal getCommAmt() {
		return commAmt;
	}
	public void setCommAmt(BigDecimal commAmt) {
		this.commAmt = commAmt;
	}
	public BigDecimal getWholdingTax() {
		return wholdingTax;
	}
	public void setWholdingTax(BigDecimal wholdingTax) {
		this.wholdingTax = wholdingTax;
	}
	public String getParticulars() {
		return particulars;
	}
	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public BigDecimal getConvertRate() {
		return convertRate;
	}
	public void setConvertRate(BigDecimal convertRate) {
		this.convertRate = convertRate;
	}
	public BigDecimal getForeignCurrAmt() {
		return foreignCurrAmt;
	}
	public void setForeignCurrAmt(BigDecimal foreignCurrAmt) {
		this.foreignCurrAmt = foreignCurrAmt;
	}
	public BigDecimal getCollectionAmt() {
		return collectionAmt;
	}
	public void setCollectionAmt(BigDecimal collectionAmt) {
		this.collectionAmt = collectionAmt;
	}
	public String getOrPrintTag() {
		return orPrintTag;
	}
	public void setOrPrintTag(String orPrintTag) {
		this.orPrintTag = orPrintTag;
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
	public BigDecimal getTaxAmount() {
		return taxAmount;
	}
	public void setTaxAmount(BigDecimal taxAmount) {
		this.taxAmount = taxAmount;
	}
	public BigDecimal getCommVat() {
		return commVat;
	}
	public void setCommVat(BigDecimal commVat) {
		this.commVat = commVat;
	}
	public String getTransactionTypeDesc() {
		return transactionTypeDesc;
	}
	public void setTransactionTypeDesc(String transactionTypeDesc) {
		this.transactionTypeDesc = transactionTypeDesc;
	}
	public String getRiName() {
		return riName;
	}
	public void setRiName(String riName) {
		this.riName = riName;
	}
	public String getAssdNo() {
		return assdNo;
	}
	public void setAssdNo(String assdNo) {
		this.assdNo = assdNo;
	}
	public String getAssdName() {
		return assdName;
	}
	public void setAssdName(String assdName) {
		this.assdName = assdName;
	}
	public String getRiPolicyNo() {
		return riPolicyNo;
	}
	public void setRiPolicyNo(String riPolicyNo) {
		this.riPolicyNo = riPolicyNo;
	}
	public String getDrvPolicyNo() {
		return drvPolicyNo;
	}
	public void setDrvPolicyNo(String drvPolicyNo) {
		this.drvPolicyNo = drvPolicyNo;
	}
	public String getCurrencyDesc() {
		return currencyDesc;
	}
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}
	public String getSavedItems() {
		return savedItems;
	}
	public void setSavedItems(String savedItems) {
		this.savedItems = savedItems;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}	
	
	public BigDecimal getTotalCommWtax() {
		return totalCommWtax;
	}

	public void setTotalCommWtax(BigDecimal totalCommWtax) {
		this.totalCommWtax = totalCommWtax;
	}

	public BigDecimal getTotalCollection() {
		return totalCollection;
	}

	public void setTotalCollection(BigDecimal totalCollection) {
		this.totalCollection = totalCollection;
	}

	public String getRefNo() {
		return refNo;
	}

	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}

	public Date getTranDate() {
		return tranDate;
	}

	public void setTranDate(Date tranDate) {
		this.tranDate = tranDate;
	}

	public BigDecimal getPremTax() {
		return premTax;
	}

	public void setPremTax(BigDecimal premTax) {
		this.premTax = premTax;
	}

	public BigDecimal getCommWtax() {
		return commWtax;
	}

	public void setCommWtax(BigDecimal commWtax) {
		this.commWtax = commWtax;
	}

	public GIACInwFaculPremCollns(){
		
	}
	public BigDecimal getTotalPremWtax() {
		return totalPremWtax;
	}
	public void setTotalPremWtax(BigDecimal totalPremWtax) {
		this.totalPremWtax = totalPremWtax;
	}
	public Date getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	public void setTransactionTypeAndDesc(String transactionTypeAndDesc) {
		this.transactionTypeAndDesc = transactionTypeAndDesc;
	}
	public String getTransactionTypeAndDesc() {
		return transactionTypeAndDesc;
	}
	public Integer getRevGaccTranId() {
		return revGaccTranId;
	}
	public void setRevGaccTranId(Integer revGaccTranId) {
		this.revGaccTranId = revGaccTranId;
	}
	
}
