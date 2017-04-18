/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

/**
 * The Class GIACAcctrans.
 */
public class GIACAgingSoaDetail extends BaseEntity{

	/** The iss cd. */
	private String issCd;
	
	/** The prem seq no. */
	private Integer premSeqNo;
	
	/** The inst no. */
	private Integer instNo;
	
	/** The policy id. */
	private Integer policyId;
	
	/** The gagp aging id. */
	private Integer gagpAgingId;
	
	/** The line cd. */
	private String a150LineCd;
	
	/** The assd no. */
	private Integer a020AssdNo;
	
	/** The tot amt due. */
	private BigDecimal totAmtDue;
	
	/** The tot payments. */
	private BigDecimal totPaymts;
	
	/** The temp payments. */
	private BigDecimal tempPaymts;
	
	/** The balance amt due. */
	private BigDecimal balAmtDue;
	
	/** The prem balance due. */
	private BigDecimal premBalDue;
	
	/** The tax balance due. */
	private BigDecimal taxBalDue;
	
	/** The next age level dt. */
	private Date nextAgeLevelDt;
	
	/** The full paid dt. */
	private Date fullPaidDt;
	
	private String nextAgeLevelDtStr;
	
	private Integer currencyCd;
	
	private BigDecimal currencyRt;
	
	
	public GIACAgingSoaDetail(){
		
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

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	public Integer getGagpAgingId() {
		return gagpAgingId;
	}

	public void setGagpAgingId(Integer gagpAgingId) {
		this.gagpAgingId = gagpAgingId;
	}

	public String getA150LineCd() {
		return a150LineCd;
	}

	public void setA150LineCd(String a150LineCd) {
		this.a150LineCd = a150LineCd;
	}

	public Integer getA020AssdNo() {
		return a020AssdNo;
	}

	public void setA020AssdNo(Integer a020AssdNo) {
		this.a020AssdNo = a020AssdNo;
	}

	public BigDecimal getTotAmtDue() {
		return totAmtDue;
	}

	public void setTotAmtDue(BigDecimal totAmtDue) {
		this.totAmtDue = totAmtDue;
	}

	public BigDecimal getTotPaymts() {
		return totPaymts;
	}

	public void setTotPaymts(BigDecimal totPaymts) {
		this.totPaymts = totPaymts;
	}

	public BigDecimal getTempPaymts() {
		return tempPaymts;
	}

	public void setTempPaymts(BigDecimal tempPaymts) {
		this.tempPaymts = tempPaymts;
	}

	public BigDecimal getBalAmtDue() {
		return balAmtDue;
	}

	public void setBalAmtDue(BigDecimal balAmtDue) {
		this.balAmtDue = balAmtDue;
	}

	public BigDecimal getPremBalDue() {
		return premBalDue;
	}

	public void setPremBalDue(BigDecimal premBalDue) {
		this.premBalDue = premBalDue;
	}

	public BigDecimal getTaxBalDue() {
		return taxBalDue;
	}

	public void setTaxBalDue(BigDecimal taxBalDue) {
		this.taxBalDue = taxBalDue;
	}

	public Date getNextAgeLevelDt() {
		return nextAgeLevelDt;
	}

	public void setNextAgeLevelDt(Date nextAgeLevelDt) {
		this.nextAgeLevelDt = nextAgeLevelDt;
	}

	public Date getFullPaidDt() {
		return fullPaidDt;
	}

	public void setFullPaidDt(Date fullPaidDt) {
		this.fullPaidDt = fullPaidDt;
	}

	public String getNextAgeLevelDtStr() {
		return nextAgeLevelDtStr;
	}

	public void setNextAgeLevelDtStr(String nextAgeLevelDtStr) {
		this.nextAgeLevelDtStr = nextAgeLevelDtStr;
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
}
