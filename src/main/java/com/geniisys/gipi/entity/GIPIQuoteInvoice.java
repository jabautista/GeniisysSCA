/**
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import com.geniisys.common.entity.GIISTaxPeril;
import com.geniisys.framework.util.BaseEntity;

/**
 * The Class GIPIQuoteInvoice.
 */
public class GIPIQuoteInvoice extends BaseEntity {	
	
	/** The quote id. */
	private Integer quoteId;
	
	/** The iss cd. */
	private String issCd;
	
	/** The quote inv no. */
	private Integer quoteInvNo;
	
	/** The currency cd. */
	private Integer currencyCd;
	
	/**The currency desc */
	private String currencyDesc;
	
	/** The currency rt. */
	private BigDecimal currencyRt;
	
	/** The prem amt. */
	private BigDecimal premAmt;
	
	/** The intm no. */
	private Integer intmNo;
	
	/** The tax amt. */
	private BigDecimal taxAmt;
	
	
	// THE FF ARE NOT PART OF THE DB COLUMNS
	/** The list of tax invoices */	
	private List<GIPIQuoteInvTax> invoiceTaxes;
	/** List of default invoice Taxes	*/
	private List<GIISTaxPeril> defaultInvoiceTaxes;
	
	/** The Amount Due (computed value)*/
	private BigDecimal amountDue;
	
	/**
	 * Creates a gipiQuoteInvoiceSummary version of this object
	 * @return gipiQuoteInvoiceSummary
	 */
	public GIPIQuoteInvoiceSummary toGIPIQuoteInvoiceSummary(){
		Integer i;
		if(this.intmNo != null){
			i = this.intmNo;
		}else{
			i = new Integer(0);
		}
		
		GIPIQuoteInvoiceSummary summary = new GIPIQuoteInvoiceSummary(	this.getQuoteId(), this.getIssCd(), 
			this.getQuoteInvNo(), this.getCurrencyCd(), this.getCurrencyRt(), this.getPremAmt(), i, this.getTaxAmt());
		summary.setInvoiceTaxes(this.invoiceTaxes);
		return summary;
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
	 * Gets the iss cd.
	 * @return the iss cd
	 */
	public String getIssCd() {
		return issCd;
	}
	
	/**
	 * Sets the iss cd.
	 * @param issCd the new iss cd
	 */
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	
	/**
	 * Gets the quote inv no.
	 * @return the quote inv no
	 */
	public Integer getQuoteInvNo() {
		return quoteInvNo;
	}
	
	/**
	 * Sets the quote inv no.
	 * @param quoteInvNo the new quote inv no
	 */
	public void setQuoteInvNo(Integer quoteInvNo) {
		this.quoteInvNo = quoteInvNo;
	}
	
	/**
	 * Gets the currency cd.
	 * @return the currency cd
	 */
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	
	/**
	 * Sets the currency cd.
	 * @param currencyCd the new currency cd
	 */
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}

	public String getCurrencyDesc() {
		return currencyDesc;
	}

	/**
	 * Gets the currency rt.
	 * @return the currency rt
	 */
	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}
	
	/**
	 * Sets the currency rt.
	 * @param currencyRt the new currency rt
	 */
	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}
	
	/**
	 * Gets the prem amt.
	 * @return the prem amt
	 */
	public BigDecimal getPremAmt() {
		return premAmt;
	}
	
	/**
	 * Sets the prem amt.
	 * @param premAmt the new prem amt
	 */
	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}
	
	/**
	 * Gets the intm no.
	 * @return the intm no
	 */
	public Integer getIntmNo() {
		return intmNo;
	}
	
	/**
	 * Sets the intm no.
	 * @param intmNo the new intm no
	 */
	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}
	
	/**
	 * Gets the tax amt.
	 * @return the tax amt
	 */
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}
	
	/**
	 * Sets the tax amt.
	 * @param taxAmt the new tax amt
	 */
	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}
	
	/**
	 * @param invoiceTaxes the invoiceTaxes to set
	 */
	public void setInvoiceTaxes(List<GIPIQuoteInvTax> invoiceTaxes) {
		if(this.invoiceTaxes ==null){
			this.invoiceTaxes = new ArrayList<GIPIQuoteInvTax>();
		}
		this.invoiceTaxes = invoiceTaxes;
	}
	
	/**
	 * @return the invoiceTaxes
	 */
	public List<GIPIQuoteInvTax> getInvoiceTaxes() {
		return invoiceTaxes;
	}

	/**
	 * @param quoteInvTax
	 */
	public void addInvoiceTax(GIPIQuoteInvTax quoteInvTax){
		if(this.invoiceTaxes ==null){
			this.invoiceTaxes = new ArrayList<GIPIQuoteInvTax>();
		}
		this.getInvoiceTaxes().add(quoteInvTax);
	}
	
	/**
	 * @param amountDue the amountDue to set
	 */
	public void setAmountDue(BigDecimal amountDue) {
		this.amountDue = new BigDecimal(0);
		this.amountDue = amountDue;
	}

	/**
	 * @return the amountDue
	 */
	public BigDecimal getAmountDue() {
		return amountDue;
	}

	/**
	 * @param defaultInvoiceTaxes the defaultInvoiceTaxes to set
	 */
	public void setDefaultInvoiceTaxes(List<GIISTaxPeril> defaultInvoiceTaxes) {
		this.defaultInvoiceTaxes = defaultInvoiceTaxes;
	}

	/**
	 * @return the defaultInvoiceTaxes
	 */
	public List<GIISTaxPeril> getDefaultInvoiceTaxes() {
		return defaultInvoiceTaxes;
	}

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 3640801694143738460L;
}