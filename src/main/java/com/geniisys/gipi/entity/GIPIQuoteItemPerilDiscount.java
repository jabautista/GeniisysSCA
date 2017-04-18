/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;


/**
 * The Class GIPIQuoteItemPerilDiscount.
 */
public class GIPIQuoteItemPerilDiscount extends GIPIQuoteItemDiscount {
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -6159367228155133419L;
	
	/** The peril cd. */
	private String perilCd;
	
	/** The peril name. */
	private String perilName;
	
	/** The level tag. */
	private String levelTag;
	
	/** The discount tag. */
	private String discountTag;
	
	/** The orig peril prem amt. */
	private BigDecimal origPerilPremAmt; 
	
	/**
	 * Instantiates a new gIPI quote item peril discount.
	 * 
	 * @param quoteId the quote id
	 * @param sequenceNo the sequence no
	 * @param lineCd the line cd
	 * @param sublineCd the subline cd
	 * @param itemNo the item no
	 * @param perilCd the peril cd
	 * @param perilName the peril name
	 * @param levelTag the level tag
	 * @param discountTag the discount tag
	 * @param discountRt the discount rt
	 * @param discountAmt the discount amt
	 * @param surchargeRt the surcharge rt
	 * @param surchargeAmt the surcharge amt
	 * @param origPerilPremAmt the orig peril prem amt
	 * @param origPremAmt the orig prem amt
	 * @param netPremAmt the net prem amt
	 * @param netGrossTag the net gross tag
	 * @param lastUpdate the last update
	 * @param remarks the remarks
	 */
	public GIPIQuoteItemPerilDiscount(int quoteId, int sequenceNo,
			String lineCd, String sublineCd, int itemNo, String perilCd, String perilName, 
			String levelTag, String discountTag, BigDecimal discountRt,
			BigDecimal discountAmt, BigDecimal surchargeRt,
			BigDecimal surchargeAmt, BigDecimal origPerilPremAmt, BigDecimal origPremAmt,
			BigDecimal netPremAmt, String netGrossTag, Date lastUpdate,
			String remarks){
		this(quoteId, sequenceNo, lineCd, sublineCd, itemNo, 
				discountRt, discountAmt, surchargeRt, surchargeAmt, origPremAmt, netPremAmt, 
				netGrossTag, lastUpdate, remarks);
		this.perilCd = perilCd;
		this.perilName = perilName;
		this.levelTag = levelTag;
		this.discountTag = discountTag;
		this.origPerilPremAmt = origPerilPremAmt;
	}
	
	
	/**
	 * Instantiates a new gIPI quote item peril discount.
	 * 
	 * @param quoteId the quote id
	 * @param sequenceNo the sequence no
	 * @param lineCd the line cd
	 * @param sublineCd the subline cd
	 * @param itemNo the item no
	 * @param discountRt the discount rt
	 * @param discountAmt the discount amt
	 * @param surchargeRt the surcharge rt
	 * @param surchargeAmt the surcharge amt
	 * @param origPremAmt the orig prem amt
	 * @param netPremAmt the net prem amt
	 * @param netGrossTag the net gross tag
	 * @param lastUpdate the last update
	 * @param remarks the remarks
	 */
	public GIPIQuoteItemPerilDiscount(int quoteId, int sequenceNo,
			String lineCd, String sublineCd, int itemNo, BigDecimal discountRt,
			BigDecimal discountAmt, BigDecimal surchargeRt,
			BigDecimal surchargeAmt, BigDecimal origPremAmt,
			BigDecimal netPremAmt, String netGrossTag, Date lastUpdate,
			String remarks){
			super(quoteId, sequenceNo, lineCd, sublineCd, itemNo,
					discountRt, discountAmt, surchargeRt, surchargeAmt, origPremAmt, netPremAmt, 
					netGrossTag, lastUpdate, remarks);		
	}

	
	/**
	 * Instantiates a new gIPI quote item peril discount.
	 */
	public GIPIQuoteItemPerilDiscount(){
		super();
	}

	/**
	 * Gets the peril cd.
	 * 
	 * @return the peril cd
	 */
	public String getPerilCd() {
		return perilCd;
	}


	/**
	 * Sets the peril cd.
	 * 
	 * @param perilCd the new peril cd
	 */
	public void setPerilCd(String perilCd) {
		this.perilCd = perilCd;
	}


	/**
	 * Gets the peril name.
	 * 
	 * @return the peril name
	 */
	public String getPerilName() {
		return perilName;
	}


	/**
	 * Sets the peril name.
	 * 
	 * @param perilName the new peril name
	 */
	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}


	/**
	 * Gets the level tag.
	 * 
	 * @return the level tag
	 */
	public String getLevelTag() {
		return levelTag;
	}


	/**
	 * Sets the level tag.
	 * 
	 * @param levelTag the new level tag
	 */
	public void setLevelTag(String levelTag) {
		this.levelTag = levelTag;
	}


	/**
	 * Gets the discount tag.
	 * 
	 * @return the discount tag
	 */
	public String getDiscountTag() {
		return discountTag;
	}


	/**
	 * Sets the discount tag.
	 * 
	 * @param discountTag the new discount tag
	 */
	public void setDiscountTag(String discountTag) {
		this.discountTag = discountTag;
	}


	/**
	 * Gets the orig peril prem amt.
	 * 
	 * @return the orig peril prem amt
	 */
	public BigDecimal getOrigPerilPremAmt() {
		return origPerilPremAmt;
	}


	/**
	 * Sets the orig peril prem amt.
	 * 
	 * @param origPerilPremAmt the new orig peril prem amt
	 */
	public void setOrigPerilPremAmt(BigDecimal origPerilPremAmt) {
		this.origPerilPremAmt = origPerilPremAmt;
	}
	
	

}
