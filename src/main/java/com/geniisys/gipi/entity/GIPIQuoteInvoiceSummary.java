/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIQuoteInvoiceSummary.
 */
public class GIPIQuoteInvoiceSummary extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 8826637421580722696L;

	/** The quote id. */
	private Integer quoteId;
	
	/** The quote inv no. */
	private Integer quoteInvNo;
	
	/** The inv no. */
	private String invNo;
	
	/** The currency cd. */
	private Integer currencyCd;
	
	/** The currency desc. */
	private String currencyDesc;
	
	/** The currency rt. */
	private BigDecimal currencyRt;
	
	/** The prem amt. */
	private BigDecimal premAmt;
	
	/** The intm no. */
	private Integer intmNo;
	
	/** The intm name. */
	private String intmName;
	
	/** The total tax amt. */
	private BigDecimal totalTaxAmt;
	
	/** The tax cd. */
	private Integer taxCd;
	
	/** The tax desc. */
	private String taxDesc;
	
	/** The tax amt. */
	private BigDecimal taxAmt;
	
	/** The amount due. */
	private BigDecimal amountDue;
	
	/** The tax id. */
	private Integer taxId;
	
	/** The rate. */
	private BigDecimal rate;

	/** The issue Code*/
	private String issCd;
	
	private List<GIPIQuoteInvTax> invoiceTaxes;
	
	/**
	 * Instantiates a new gIPI quote invoice summary.
	 */
	public GIPIQuoteInvoiceSummary() {

	}

	/**
	 * Instantiates a new gIPI quote invoice summary.
	 * 
	 * @param quoteId the quote id
	 * @param quoteInvNo the quote inv no
	 * @param invNo the inv no
	 * @param currencyCd the currency cd
	 * @param currencyDesc the currency desc
	 * @param currencyRt the currency rt
	 * @param premAmt the prem amt
	 * @param intmNo the intm no
	 * @param intmName the intm name
	 * @param totalTaxAmt the total tax amt
	 * @param taxCd the tax cd
	 * @param taxDesc the tax desc
	 * @param taxAmt the tax amt
	 * @param amountDue the amount due
	 * @param taxId the tax id
	 * @param rate the rate
	 */
	public GIPIQuoteInvoiceSummary(Integer quoteId, Integer quoteInvNo, String invNo,
			Integer currencyCd, String currencyDesc, BigDecimal currencyRt,
			BigDecimal premAmt, Integer intmNo, String intmName,
			BigDecimal totalTaxAmt, Integer taxCd, String taxDesc,
			BigDecimal taxAmt, BigDecimal amountDue, Integer taxId,
			BigDecimal rate) {
		this.invoiceTaxes = new ArrayList<GIPIQuoteInvTax>();
		this.quoteId = quoteId;
		this.quoteInvNo = quoteInvNo;
		this.invNo = invNo;
		this.currencyCd = currencyCd;
		this.currencyDesc = currencyDesc;
		this.currencyRt = currencyRt;
		this.premAmt = premAmt;
		this.intmNo = intmNo;
		this.intmName = intmName;
		this.totalTaxAmt = totalTaxAmt;
		this.taxCd = taxCd;
		this.taxDesc = taxDesc;
		this.taxAmt = taxAmt;
		this.amountDue = amountDue;
		this.taxId = taxId;
		this.rate = rate;
	}
	
	/**
	 * Instantiates a new gIPI quote invoice summary.
	 * 
	 * @param quoteId the quote id
	 * @param quoteInvNo the quote inv no
	 * @param invNo the inv no
	 * @param currencyCd the currency cd
	 * @param currencyDesc the currency desc
	 * @param currencyRt the currency rt
	 * @param premAmt the prem amt
	 * @param intmNo the intm no
	 * @param intmName the intm name
	 * @param totalTaxAmt the total tax amt
	 * @param taxCd the tax cd
	 * @param taxDesc the tax desc
	 * @param taxAmt the tax amt
	 * @param amountDue the amount due
	 * @param taxId the tax id
	 * @param rate the rate
	 */
	public GIPIQuoteInvoiceSummary(Integer quoteId, Integer quoteInvNo, String invNo,
			Integer currencyCd, String currencyDesc, BigDecimal currencyRt,
			BigDecimal premAmt, Integer intmNo, String intmName,
			BigDecimal totalTaxAmt, Integer taxCd, String taxDesc,
			BigDecimal taxAmt, BigDecimal amountDue, Integer taxId,
			BigDecimal rate, String issCd) {
		this.invoiceTaxes = new ArrayList<GIPIQuoteInvTax>();
		this.quoteId = quoteId;
		this.quoteInvNo = quoteInvNo;
		this.invNo = invNo;
		this.currencyCd = currencyCd;
		this.currencyDesc = currencyDesc;
		this.currencyRt = currencyRt;
		this.premAmt = premAmt;
		this.intmNo = intmNo;
		this.intmName = intmName;
		this.totalTaxAmt = totalTaxAmt;
		this.taxCd = taxCd;
		this.taxDesc = taxDesc;
		this.taxAmt = taxAmt;
		this.amountDue = amountDue;
		this.taxId = taxId;
		this.rate = rate;
	this.issCd = issCd;
	}

	/**
	 * Instantiates a new GIPI Quote Invoice Summary that contains only GIPIQuoteInvoice values 
	 * @param quoteId
	 * @param issCd
	 * @param quoteInvoiceNumber
	 * @param currencyCd
	 * @param currencyRate
	 * @param premiumAmount
	 * @param intm
	 * @param taxAmount
	 */
	public GIPIQuoteInvoiceSummary(Integer quoteId, String issCd, Integer quoteInvoiceNumber, Integer currencyCd, BigDecimal currencyRate, BigDecimal premiumAmount, Integer intermediaryNumber, BigDecimal totalTaxAmount){
		this.quoteId = quoteId;
		this.issCd = issCd;
		this.quoteInvNo = quoteInvoiceNumber;
		this.currencyCd = currencyCd;
		this.currencyRt = currencyRate;
		this.premAmt = premiumAmount;
		this.intmNo = intermediaryNumber;
		this.totalTaxAmt = totalTaxAmount;
		this.taxAmt = totalTaxAmount;
		this.invoiceTaxes = new ArrayList<GIPIQuoteInvTax>();
	}
	
	/**
	 * Creates a GIPIQuoteInvoice of this class
	 * @author rencela
	 * @return GIPIQuoteInvoice version of this GIPIQuoteInvoiceSummary to this  
	 */
	public GIPIQuoteInvoice toGIPIQuoteInvoice(){
		GIPIQuoteInvoice invoice = new GIPIQuoteInvoice();
		
		invoice.setCreateDate(this.getCreateDate());
		invoice.setCreateUser(this.getCreateUser());
		invoice.setCurrencyCd(this.getCurrencyCd());
		invoice.setCurrencyRt(this.getCurrencyRt());
		invoice.setIntmNo(this.getIntmNo());
		invoice.setInvoiceTaxes(this.getInvoiceTaxes());
		invoice.setIssCd(this.getIssCd());
		invoice.setLastUpdate(this.getLastUpdate());
		invoice.setPremAmt(this.getPremAmt());
		invoice.setQuoteId(this.getQuoteId());
		invoice.setQuoteInvNo(this.getQuoteInvNo());
		invoice.setTaxAmt(this.getTaxAmt());
		invoice.setUserId(this.getUserId());
		
		return invoice;
	}
	
	/**
	 * Compares the quoteId, currencyCode, and currencyRate properties
	 * @param anotherInvoiceSummary
	 * @return true/false
	 */
	public boolean equals(GIPIQuoteInvoiceSummary anotherInvoiceSummary){
		if(	anotherInvoiceSummary.getQuoteId()					== this.quoteId &&
			anotherInvoiceSummary.getCurrencyCd() 				== this.currencyCd &&
			anotherInvoiceSummary.getCurrencyRt().floatValue() 	== this.currencyRt.floatValue()){
			return true;
		}
		
		return false;
	}
	
	/**
	 * Compare the list of invTaxes of this object to another GIPIQuoteInvoiceSummary's list of invTaxes
	 * - this is used for checking updates done to a 
	 * @return
	 */
	public boolean hasSimilarTaxValues(GIPIQuoteInvoiceSummary anotherInvoiceSummary){
		for(GIPIQuoteInvTax localInvTax: this.invoiceTaxes){
			System.out.println("tax ID   : " + localInvTax.getTaxId());
			System.out.println("tax desc : " + localInvTax.getTaxDescription());
			System.out.println("tax cd   : " + localInvTax.getTaxCd());
			System.out.println("tax alloc: " + localInvTax.getTaxAllocation());
			System.out.println("tax amt  : " + localInvTax.getTaxAmt());
//			for(GIPIQuoteInvTax outerInvTax: anotherInvoiceSummary.getInvoiceTaxes()){
				
				//if(localInvTax.get)
				// Check if they have similar id/name
					// if true 
					//		compare values
					//		if different, return false
//			}
		}
		
		return true;
	}
	/**
	 * Copies the values of host object
	 * @author rencela
	 * @param host
	 */
	public void copyValues(GIPIQuoteInvoiceSummary host){
		this.amountDue = host.getAmountDue();
		this.currencyCd		= host.getCurrencyCd();
		this.currencyDesc	= host.getCurrencyDesc();
		this.currencyRt		= host.getCurrencyRt();
		this.intmName		= host.getIntmName();
		this.intmNo			= host.getIntmNo();
		this.invNo			= host.getInvNo();
		this.invoiceTaxes 	= host.getInvoiceTaxes();
		this.issCd			= host.getIssCd();
		this.premAmt		= host.getPremAmt();
		this.quoteId		= host.getQuoteId();
		this.quoteInvNo		= host.getQuoteInvNo();
		this.rate			= host.getRate();
		this.taxAmt			= host.getTaxAmt();
		this.taxCd			= host.getTaxCd();
		this.taxDesc		= host.getTaxDesc();
		this.taxId 			= host.getTaxId();
		this.totalTaxAmt 	= host.getTotalTaxAmt();
	}
	
	/**
	 * Gets the quote id.
	 * 
	 * @return the quote id
	 */
	public Integer getQuoteId() {
		return quoteId;
	}

	/**
	 * Sets the quote id.
	 * 
	 * @param quoteId the new quote id
	 */
	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}

	/**
	 * Gets the quote inv no.
	 * 
	 * @return the quote inv no
	 */
	public Integer getQuoteInvNo() {
		return quoteInvNo;
	}

	/**
	 * Sets the quote inv no.
	 * 
	 * @param quoteInvNo the new quote inv no
	 */
	public void setQuoteInvNo(Integer quoteInvNo) {
		this.quoteInvNo = quoteInvNo;
	}

	/**
	 * Gets the inv no.
	 * 
	 * @return the inv no
	 */
	public String getInvNo() {
		return invNo;
	}

	/**
	 * Sets the inv no.
	 * 
	 * @param invNo the new inv no
	 */
	public void setInvNo(String invNo) {
		this.invNo = invNo;
	}

	/**
	 * Gets the currency cd.
	 * 
	 * @return the currency cd
	 */
	public Integer getCurrencyCd() {
		return currencyCd;
	}

	/**
	 * Sets the currency cd.
	 * 
	 * @param currencyCd the new currency cd
	 */
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}

	/**
	 * Gets the currency desc.
	 * 
	 * @return the currency desc
	 */
	public String getCurrencyDesc() {
		return currencyDesc;
	}

	/**
	 * Sets the currency desc.
	 * 
	 * @param currencyDesc the new currency desc
	 */
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}

	/**
	 * Gets the currency rt.
	 * 
	 * @return the currency rt
	 */
	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}

	/**
	 * Sets the currency rt.
	 * 
	 * @param currencyRt the new currency rt
	 */
	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}

	/**
	 * Gets the prem amt.
	 * 
	 * @return the prem amt
	 */
	public BigDecimal getPremAmt() {
		return premAmt;
	}

	/**
	 * Sets the prem amt.
	 * 
	 * @param premAmt the new prem amt
	 */
	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}

	/**
	 * Gets the intm name.
	 * 
	 * @return the intm name
	 */
	public String getIntmName() {
		return intmName;
	}

	/**
	 * Sets the intm name.
	 * 
	 * @param intmName the new intm name
	 */
	public void setIntmName(String intmName) {
		this.intmName = intmName;
	}

	/**
	 * Gets the total tax amt.
	 * 
	 * @return the total tax amt
	 */
	public BigDecimal getTotalTaxAmt() {
		return totalTaxAmt;
	}

	/**
	 * Sets the total tax amt.
	 * 
	 * @param totalTaxAmt the new total tax amt
	 */
	public void setTotalTaxAmt(BigDecimal totalTaxAmt) {
		this.totalTaxAmt = totalTaxAmt;
	}

	/**
	 * Gets the tax cd.
	 * 
	 * @return the tax cd
	 */
	public Integer getTaxCd() {
		return taxCd;
	}

	/**
	 * Sets the tax cd.
	 * 
	 * @param taxCd the new tax cd
	 */
	public void setTaxCd(Integer taxCd) {
		this.taxCd = taxCd;
	}

	/**
	 * Gets the tax desc.
	 * 
	 * @return the tax desc
	 */
	public String getTaxDesc() {
		return taxDesc;
	}

	/**
	 * Sets the tax desc.
	 * 
	 * @param taxDesc the new tax desc
	 */
	public void setTaxDesc(String taxDesc) {
		this.taxDesc = taxDesc;
	}

	/**
	 * Gets the tax amt.
	 * 
	 * @return the tax amt
	 */
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}

	/**
	 * Sets the tax amt.
	 * 
	 * @param taxAmt the new tax amt
	 */
	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}

	/**
	 * Gets the amount due.
	 * 
	 * @return the amount due
	 */
	public BigDecimal getAmountDue() {
		return amountDue;
	}

	/**
	 * Sets the amount due.
	 * 
	 * @param amountDue the new amount due
	 */
	public void setAmountDue(BigDecimal amountDue) {
		this.amountDue = amountDue;
	}

	/**
	 * Gets the intm no.
	 * 
	 * @return the intm no
	 */
	public Integer getIntmNo() {
		return intmNo;
	}

	/**
	 * Sets the intm no.
	 * 
	 * @param intmNo the new intm no
	 */
	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}

	/**
	 * Gets the tax id.
	 * 
	 * @return the tax id
	 */
	public Integer getTaxId() {
		return taxId;
	}

	/**
	 * Sets the tax id.
	 * 
	 * @param taxId the new tax id
	 */
	public void setTaxId(Integer taxId) {
		this.taxId = taxId;
	}

	/**
	 * Gets the rate.
	 * 
	 * @return the rate
	 */
	public BigDecimal getRate() {
		return rate;
	}

	/**
	 * Sets the rate.
	 * 
	 * @param rate the new rate
	 */
	public void setRate(BigDecimal rate) {
		this.rate = rate;
	}

	/**
	 * @param issCd the issCd to set
	 */
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	/**
	 * @return the issCd
	 */
	public String getIssCd() {
		return issCd;
	}

	/**
	 * @param quoteInvTax the quoteInvTax to set
	 */
	public void setInvoiceTaxes(List<GIPIQuoteInvTax> quoteInvTax) {
		if(this.invoiceTaxes == null){
			quoteInvTax = new ArrayList<GIPIQuoteInvTax>();
		}
		this.invoiceTaxes = quoteInvTax;
	}

	/**
	 * @return the quoteInvTax
	 */
	public List<GIPIQuoteInvTax> getInvoiceTaxes() {
		return this.invoiceTaxes;
	}

	/**
	 * 
	 * @param quoteInvTax
	 */
	public void addInvoiceTax(GIPIQuoteInvTax quoteInvTax){
		this.invoiceTaxes.add(quoteInvTax);
	}
	
	
	
}
