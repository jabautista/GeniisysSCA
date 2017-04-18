/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIWInvoice.
 */
public class GIPIWInvoice extends BaseEntity {
	
	/** The par id. */
	private Integer parId;
	
	/** The item grp. */
	private int itemGrp;
	
	/** The insured. */
	private String insured;
	
	/** The property. */
	private String property;
	
	/** The takeup seq no. */
	private Integer takeupSeqNo;
	
	/** The multi booking mm. */
	private String multiBookingMM;
	
	/** The multi booking yy. */
	private Integer multiBookingYY;
	
	/** The ref inv no. */
	private String refInvNo;
	
	/** The policy currency. */
	private String policyCurrency;
	
	/** The payt terms. */
	private String paytTerms;
	
	/** The due date. */
	private Date dueDate;
	
	/** The other charges. */
	private BigDecimal otherCharges;
	
	/** The tax amt. */
	private BigDecimal taxAmt;
	
	/** The prem amt. */
	private BigDecimal premAmt;
	
	/** The prem seq no. */
	private Integer premSeqNo;
	
	/** The remarks. */
	private String remarks;
	
	/** The ri comm amt. */
	private BigDecimal riCommAmt;
	
	/** The pay type. */
	private String payType;
	
	/** The card name. */
	private String cardName;
	
	/** The card no. */
	private Integer cardNo;
	
	/** The expiry date. */
	private Date expiryDate;
	
	/** The incept date. */
	private Date inceptDate;
	
	/** The approval cd. */
	private String approvalCd;
	
	/** The ri comm vat. */
	private BigDecimal riCommVat;
	
	/** The changed tag. */
	private String changedTag;
	
	/** The notarial fee. */
	private BigDecimal notarialFee;
	
	/** The currency cd. */
	private int currencyCd;
	
	/** The currency rt. */
	private BigDecimal currencyRt; //change by steven 07.23.2014 from int to BigDecimal
	
	/** The dist flag. */
	private String distFlag;
	
	/** The bond rate. */
	private BigDecimal bondRate;
	
	/** The bond tsi amt. */
	private BigDecimal bondTsiAmt;
	
	/** The no of takeup. */
	private Integer noOfTakeup;
	
	/** The no of payt. */
	private int noOfPayt;
	
	/** The amount due. */
	private BigDecimal amountDue;
	
	/** The currency desc. */
	private String currencyDesc;
	
	/** The multi booking date. */
	private String multiBookingDate;
	
	/** The multi booking mm num. */
	private Integer multiBookingMMNum;
	
	private String invoice;
	
	private List<GIPIWinvTax> taxCodes;
	
	private Date wpolbasExpiryDate;
	
	private Date effDate;
	
	private Date endtExpiryDate;
	
	private GIPIOrigInvoice gipiOrigInv;
	
	/** The ri comm vat. */
	private BigDecimal riCommRt;
	
	
	/**
	 * Instantiates a new GIPIWInvoice.
	 */
	public GIPIWInvoice(){
		
	}

	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public Integer getParId() {
		return parId;
	}

	/**
	 * Sets the par id.
	 * 
	 * @param parId the new par id
	 */
	public void setParId(int parId) {
		this.parId = parId;
	}

	/**
	 * Gets the item grp.
	 * 
	 * @return the item grp
	 */
	public int getItemGrp() {
		return itemGrp;
	}

	/**
	 * Sets the item grp.
	 * 
	 * @param itemGrp the new item grp
	 */
	public void setItemGrp(int itemGrp) {
		this.itemGrp = itemGrp;
	}

	/**
	 * Gets the insured.
	 * 
	 * @return the insured
	 */
	public String getInsured() {
		return insured;
	}

	/**
	 * Sets the insured.
	 * 
	 * @param insured the new insured
	 */
	public void setInsured(String insured) {
		this.insured = insured;
	}

	/**
	 * Gets the property.
	 * 
	 * @return the property
	 */
	public String getProperty() {
		return property;
	}

	/**
	 * Sets the property.
	 * 
	 * @param property the new property
	 */
	public void setProperty(String property) {
		this.property = property;
	}

	/**
	 * Gets the takeup seq no.
	 * 
	 * @return the takeup seq no
	 */
	public Integer getTakeupSeqNo() {
		return takeupSeqNo;
	}

	/**
	 * Sets the takeup seq no.
	 * 
	 * @param takeupSeqNo the new takeup seq no
	 */
	public void setTakeupSeqNo(Integer takeupSeqNo) {
		this.takeupSeqNo = takeupSeqNo;
	}

	/**
	 * Gets the multi booking mm.
	 * 
	 * @return the multi booking mm
	 */
	public String getMultiBookingMM() {
		return multiBookingMM;
	}

	/**
	 * Sets the multi booking mm.
	 * 
	 * @param multiBookingMM the new multi booking mm
	 */
	public void setMultiBookingMM(String multiBookingMM) {
		this.multiBookingMM = multiBookingMM;
	}

	/**
	 * Gets the multi booking yy.
	 * 
	 * @return the multi booking yy
	 */
	public Integer getMultiBookingYY() {
		return multiBookingYY;
	}

	/**
	 * Sets the multi booking yy.
	 * 
	 * @param multiBookingYY the new multi booking yy
	 */
	public void setMultiBookingYY(Integer multiBookingYY) {
		this.multiBookingYY = multiBookingYY;
	}

	/**
	 * Gets the ref inv no.
	 * 
	 * @return the ref inv no
	 */
	public String getRefInvNo() {
		return refInvNo;
	}

	/**
	 * Sets the ref inv no.
	 * 
	 * @param refInvNo the new ref inv no
	 */
	public void setRefInvNo(String refInvNo) {
		this.refInvNo = refInvNo;
	}

	/**
	 * Gets the policy currency.
	 * 
	 * @return the policy currency
	 */
	public String getPolicyCurrency() {
		return policyCurrency;
	}

	/**
	 * Sets the policy currency.
	 * 
	 * @param policyCurrency the new policy currency
	 */
	public void setPolicyCurrency(String policyCurrency) {
		this.policyCurrency = policyCurrency;
	}

	/**
	 * Gets the payt terms.
	 * 
	 * @return the payt terms
	 */
	public String getPaytTerms() {
		return paytTerms;
	}

	/**
	 * Sets the payt terms.
	 * 
	 * @param paytTerms the new payt terms
	 */
	public void setPaytTerms(String paytTerms) {
		this.paytTerms = paytTerms;
	}

	// public String getDueDate() {
	// DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
	// return sdf.format(dueDate);
	//		
	// }

	/**
	 * Gets the due date.
	 * 
	 * @return the due date
	 */
	public String getDueDate() {
		//return dueDate;
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (dueDate != null) {
			return df.format(dueDate);			
		} else {
			return null;
		}	

	}

	/**
	 * Sets the due date.
	 * 
	 * @param dueDate the new due date
	 */
	public void setDueDate(Date dueDate) {
		this.dueDate = dueDate;
	}

	/**
	 * Gets the other charges.
	 * 
	 * @return the other charges
	 */
	public BigDecimal getOtherCharges() {
		return otherCharges;
	}

	/**
	 * Sets the other charges.
	 * 
	 * @param otherCharges the new other charges
	 */
	public void setOtherCharges(BigDecimal otherCharges) {
		this.otherCharges = otherCharges;
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
	 * Gets the prem seq no.
	 * 
	 * @return the prem seq no
	 */
	public Integer getPremSeqNo() {
		return premSeqNo;
	}

	/**
	 * Sets the prem seq no.
	 * 
	 * @param premSeqNo the new prem seq no
	 */
	public void setPremSeqNo(Integer premSeqNo) {
		this.premSeqNo = premSeqNo;
	}

	/**
	 * Gets the remarks.
	 * 
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * Sets the remarks.
	 * 
	 * @param remarks the new remarks
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	/**
	 * Gets the ri comm amt.
	 * 
	 * @return the ri comm amt
	 */
	public BigDecimal getRiCommAmt() {
		return riCommAmt;
	}

	/**
	 * Sets the ri comm amt.
	 * 
	 * @param riCommAmt the new ri comm amt
	 */
	public void setRiCommAmt(BigDecimal riCommAmt) {
		this.riCommAmt = riCommAmt;
	}

	/**
	 * Gets the pay type.
	 * 
	 * @return the pay type
	 */
	public String getPayType() {
		return payType;
	}

	/**
	 * Sets the pay type.
	 * 
	 * @param payType the new pay type
	 */
	public void setPayType(String payType) {
		this.payType = payType;
	}

	/**
	 * Gets the card name.
	 * 
	 * @return the card name
	 */
	public String getCardName() {
		return cardName;
	}

	/**
	 * Sets the card name.
	 * 
	 * @param cardName the new card name
	 */
	public void setCardName(String cardName) {
		this.cardName = cardName;
	}

	/**
	 * Gets the card no.
	 * 
	 * @return the card no
	 */
	public Integer getCardNo() {
		return cardNo;
	}

	/**
	 * Sets the card no.
	 * 
	 * @param cardNo the new card no
	 */
	public void setCardNo(Integer cardNo) {
		this.cardNo = cardNo;
	}

	/**
	 * Gets the expiry date.
	 * 
	 * @return the expiry date
	 */
	/*
	public Date getExpiryDate() {
		return expiryDate;
	}*/
	
	public String getExpiryDate() {
		//return dueDate;
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (expiryDate != null) {
			return df.format(expiryDate);			
		} else {
			return null;
		}	

	}

	/**
	 * Sets the expiry date.
	 * 
	 * @param expiryDate the new expiry date
	 */
	
	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}

	/**
	 * Gets the approval cd.
	 * 
	 * @return the approval cd
	 */
	public String getApprovalCd() {
		return approvalCd;
	}

	/**
	 * Sets the approval cd.
	 * 
	 * @param approvalCd the new approval cd
	 */
	public void setApprovalCd(String approvalCd) {
		this.approvalCd = approvalCd;
	}

	/**
	 * Gets the ri comm vat.
	 * 
	 * @return the ri comm vat
	 */
	public BigDecimal getRiCommVat() {
		return riCommVat;
	}

	/**
	 * Sets the ri comm vat.
	 * 
	 * @param riCommVat the new ri comm vat
	 */
	public void setRiCommVat(BigDecimal riCommVat) {
		this.riCommVat = riCommVat;
	}

	/**
	 * Gets the changed tag.
	 * 
	 * @return the changed tag
	 */
	public String getChangedTag() {
		return changedTag;
	}

	/**
	 * Sets the changed tag.
	 * 
	 * @param changedTag the new changed tag
	 */
	public void setChangedTag(String changedTag) {
		this.changedTag = changedTag;
	}

	/**
	 * Sets the notarial fee.
	 * 
	 * @param notarialFee the new notarial fee
	 */
	public void setNotarialFee(BigDecimal notarialFee) {
		this.notarialFee = notarialFee;
	}

	/**
	 * Gets the notarial fee.
	 * 
	 * @return the notarial fee
	 */
	public BigDecimal getNotarialFee() {
		return notarialFee;
	}

	/**
	 * Sets the dist flag.
	 * 
	 * @param distFlag the new dist flag
	 */
	public void setDistFlag(String distFlag) {
		this.distFlag = distFlag;
	}

	/**
	 * Gets the dist flag.
	 * 
	 * @return the dist flag
	 */
	public String getDistFlag() {
		return distFlag;
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
	 * Gets the currency rt.
	 * 
	 * @return the currency rt
	 */
	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}

	/**
	 * Sets the currency cd.
	 * 
	 * @param currencyCd the new currency cd
	 */
	public void setCurrencyCd(int currencyCd) {
		this.currencyCd = currencyCd;
	}

	/**
	 * Gets the currency cd.
	 * 
	 * @return the currency cd
	 */
	public int getCurrencyCd() {
		return currencyCd;
	}

	/**
	 * Sets the bond rate.
	 * 
	 * @param bondRate the new bond rate
	 */
	public void setBondRate(BigDecimal bondRate) {
		this.bondRate = bondRate;
	}

	/**
	 * Gets the bond rate.
	 * 
	 * @return the bond rate
	 */
	public BigDecimal getBondRate() {
		return bondRate;
	}

	/**
	 * Sets the bond tsi amt.
	 * 
	 * @param bondTsiAmt the new bond tsi amt
	 */
	public void setBondTsiAmt(BigDecimal bondTsiAmt) {
		this.bondTsiAmt = bondTsiAmt;
	}

	/**
	 * Gets the bond tsi amt.
	 * 
	 * @return the bond tsi amt
	 */
	public BigDecimal getBondTsiAmt() {
		return bondTsiAmt;
	}

	/**
	 * Sets the no of takeup.
	 * 
	 * @param noOfTakeup the new no of takeup
	 */
	public void setNoOfTakeup(Integer noOfTakeup) {
		this.noOfTakeup = noOfTakeup;
	}

	/**
	 * Gets the no of takeup.
	 * 
	 * @return the no of takeup
	 */
	public Integer getNoOfTakeup() {
		return noOfTakeup;
	}

	/**
	 * Sets the no of payt.
	 * 
	 * @param noOfPayt the new no of payt
	 */
	public void setNoOfPayt(int noOfPayt) {
		this.noOfPayt = noOfPayt;
	}

	/**
	 * Gets the no of payt.
	 * 
	 * @return the no of payt
	 */
	public int getNoOfPayt() {
		return noOfPayt;
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
	 * Gets the amount due.
	 * 
	 * @return the amount due
	 */
	public BigDecimal getAmountDue() {
		return amountDue;
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
	 * Gets the currency desc.
	 * 
	 * @return the currency desc
	 */
	public String getCurrencyDesc() {
		return currencyDesc;
	}

	/**
	 * Sets the incept date.
	 * 
	 * @param inceptDate the new incept date
	 */
	public void setInceptDate(Date inceptDate) {
		this.inceptDate = inceptDate;
	}

	/**
	 * Gets the incept date.
	 * 
	 * @return the incept date
	 */
	/*
	public Date getInceptDate() {
		return inceptDate;
	}*/
	
	public String getInceptDate() {
		//return dueDate;
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (inceptDate != null) {
			return df.format(inceptDate);			
		} else {
			return null;
		}	

	}
	

	/**
	 * Sets the multi booking date.
	 * 
	 * @param multiBookingDate the new multi booking date
	 */
	public void setMultiBookingDate(String multiBookingDate) {
		this.multiBookingDate = multiBookingDate;
	}

	/**
	 * Gets the multi booking date.
	 * 
	 * @return the multi booking date
	 */
	public String getMultiBookingDate() {
		return multiBookingDate;
	}

	/**
	 * Sets the multi booking mm num.
	 * 
	 * @param multiBookingMMNum the new multi booking mm num
	 */
	public void setMultiBookingMMNum(Integer multiBookingMMNum) {
		this.multiBookingMMNum = multiBookingMMNum;
	}

	/**
	 * Gets the multi booking mm num.
	 * 
	 * @return the multi booking mm num
	 */
	public Integer getMultiBookingMMNum() {
		return multiBookingMMNum;
	}

	/**
	 * @param invoice the invoice to set
	 */
	public void setInvoice(String invoice) {
		this.invoice = invoice;
	}

	/**
	 * @return the invoice
	 */
	public String getInvoice() {
		return invoice;
	}

	/**
	 * @return the taxCodes
	 */
	public List<GIPIWinvTax> getTaxCodes() {
		return taxCodes;
	}

	/**
	 * @param taxCodes the taxCodes to set
	 */
	public void setTaxCodes(List<GIPIWinvTax> taxCodes) {
		this.taxCodes = taxCodes;
	}

	/**
	 * @return the wpolbasExpiryDate
	 */

	public String getWpolbasExpiryDate() {
		//return dueDate;
		DateFormat df = new SimpleDateFormat("MMMM dd,yyyy"); //
		if (wpolbasExpiryDate != null) {
			return df.format(wpolbasExpiryDate);			
		} else {
			return null;
		}	

	}
	
	/**
	 * @param wpolbasExpiryDate the wpolbasExpiryDate to set
	 */
	public void setWpolbasExpiryDate(Date wpolbasExpiryDate) {
		this.wpolbasExpiryDate = wpolbasExpiryDate;
	}

	/**
	 * @return the effDate
	 */
	
	public String getEffDate() {
		//return dueDate;
		DateFormat df = new SimpleDateFormat("MMMM dd,yyyy");
		if (effDate != null) {
			return df.format(effDate);			
		} else {
			return null;
		}	

	}

	/**
	 * @param effDate the effDate to set
	 */
	public void setEffDate(Date effDate) {
		this.effDate = effDate;
	}

	/**
	 * @return the endtExpiryDate
	 */
	public String getEndtExpiryDate() {
		//return dueDate;
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (endtExpiryDate != null) {
			return df.format(endtExpiryDate);			
		} else {
			return null;
		}	

	}

	/**
	 * @param endtExpiryDate the endtExpiryDate to set
	 */
	public void setEndtExpiryDate(Date endtExpiryDate) {
		this.endtExpiryDate = endtExpiryDate;
	}

	public void setGipiOrigInv(GIPIOrigInvoice gipiOrigInv) {
		this.gipiOrigInv = gipiOrigInv;
	}

	public GIPIOrigInvoice getGipiOrigInv() {
		return gipiOrigInv;
	}

	/**
	 * @return the riCommRt
	 */
	public BigDecimal getRiCommRt() {
		return riCommRt;
	}

	/**
	 * @param riCommRt the riCommRt to set
	 */
	public void setRiCommRt(BigDecimal riCommRt) {
		this.riCommRt = riCommRt;
	}

	
	

}
