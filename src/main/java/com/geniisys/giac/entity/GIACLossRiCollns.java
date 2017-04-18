 package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIACLossRiCollns extends BaseEntity{

	private Integer gaccTranId;
	private Integer a180RiCd; 
	private Integer transactionType;
	private String e150LineCd;
	private Integer e150LaYy;
	private Integer e150FlaSeqNo;
	private BigDecimal collectionAmt;
	private BigDecimal totalCollectionAmt;
	private Integer claimId;
	private Integer currencyCd; 
	private BigDecimal convertRate;
	private BigDecimal foreignCurrAmt;
	private String orPrintTag;
	private String particulars;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String shareType;
	private String payeeType;
    //non-base table
	private String riName;
	private String currencyDesc;
	private String shareTypeDesc;
	private String transactionTypeDesc;
	private String dspPolicy;
	private String dspClaim;
	private String dspAssdName;

	public Integer getGaccTranId() {
		return gaccTranId;
	}
	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}
	public Integer getA180RiCd() {
		return a180RiCd;
	}
	public void setA180RiCd(Integer a180RiCd) {
		this.a180RiCd = a180RiCd;
	}
	public Integer getTransactionType() {
		return transactionType;
	}
	public void setTransactionType(Integer transactionType) {
		this.transactionType = transactionType;
	}
	public String getE150LineCd() {
		return e150LineCd;
	}
	public void setE150LineCd(String e150LineCd) {
		this.e150LineCd = e150LineCd;
	}
	public Integer getE150LaYy() {
		return e150LaYy;
	}
	public void setE150LaYy(Integer e150LaYy) {
		this.e150LaYy = e150LaYy;
	}
	public Integer getE150FlaSeqNo() {
		return e150FlaSeqNo;
	}
	public void setE150FlaSeqNo(Integer e150FlaSeqNo) {
		this.e150FlaSeqNo = e150FlaSeqNo;
	}
	public BigDecimal getCollectionAmt() {
		return collectionAmt;
	}
	public void setCollectionAmt(BigDecimal collectionAmt) {
		this.collectionAmt = collectionAmt;
	}
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
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
	public String getOrPrintTag() {
		return orPrintTag;
	}
	public void setOrPrintTag(String orPrintTag) {
		this.orPrintTag = orPrintTag;
	}
	public String getParticulars() {
		return particulars;
	}
	public void setParticulars(String particulars) {
		this.particulars = particulars;
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
	public String getShareType() {
		return shareType;
	}
	public void setShareType(String shareType) {
		this.shareType = shareType;
	}
	public String getPayeeType() {
		return payeeType;
	}
	public void setPayeeType(String payeeType) {
		this.payeeType = payeeType;
	}
	public String getRiName() {
		return riName;
	}
	public void setRiName(String riName) {
		this.riName = riName;
	}
	public String getCurrencyDesc() {
		return currencyDesc;
	}
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}
	public String getShareTypeDesc() {
		return shareTypeDesc;
	}
	public void setShareTypeDesc(String shareTypeDesc) {
		this.shareTypeDesc = shareTypeDesc;
	}
	public String getTransactionTypeDesc() {
		return transactionTypeDesc;
	}
	public void setTransactionTypeDesc(String transactionTypeDesc) {
		this.transactionTypeDesc = transactionTypeDesc;
	}
	public String getDspPolicy() {
		return dspPolicy;
	}
	public void setDspPolicy(String dspPolicy) {
		this.dspPolicy = dspPolicy;
	}
	public String getDspClaim() {
		return dspClaim;
	}
	public void setDspClaim(String dspClaim) {
		this.dspClaim = dspClaim;
	}
	public String getDspAssdName() {
		return dspAssdName;
	}
	public void setDspAssdName(String dspAssdName) {
		this.dspAssdName = dspAssdName;
	}
	/**
	 * @return the totalCollectionAmt
	 */
	public BigDecimal getTotalCollectionAmt() {
		return totalCollectionAmt;
	}
	/**
	 * @param totalCollectionAmt the totalCollectionAmt to set
	 */
	public void setTotalCollectionAmt(BigDecimal totalCollectionAmt) {
		this.totalCollectionAmt = totalCollectionAmt;
	}
}
