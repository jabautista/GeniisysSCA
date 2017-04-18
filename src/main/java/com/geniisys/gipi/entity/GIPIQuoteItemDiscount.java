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
 * The Class GIPIQuoteItemDiscount.
 */
public class GIPIQuoteItemDiscount extends GIPIQuotePolicyBasicDiscount {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 3388478819197784498L;
	
	/** The item no. */
	private int itemNo;
	
	/** The item title. */
	private String itemTitle;
	
	/**
	 * Instantiates a new gIPI quote item discount.
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
	public GIPIQuoteItemDiscount(int quoteId, Integer sequenceNo,
			String lineCd, String sublineCd, int itemNo, BigDecimal discountRt,
			BigDecimal discountAmt, BigDecimal surchargeRt,
			BigDecimal surchargeAmt, BigDecimal origPremAmt,
			BigDecimal netPremAmt, String netGrossTag, Date lastUpdate,
			String remarks) {
		this(quoteId, sequenceNo, lineCd, sublineCd, 
				discountRt, discountAmt, surchargeRt, surchargeAmt, origPremAmt, netPremAmt, 
				netGrossTag, lastUpdate, remarks);
		this.itemNo = itemNo;
	}
	
	/**
	 * Instantiates a new gIPI quote item discount.
	 * 
	 * @param quoteId the quote id
	 * @param sequenceNo the sequence no
	 * @param lineCd the line cd
	 * @param sublineCd the subline cd
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
	public GIPIQuoteItemDiscount(int quoteId, Integer sequenceNo,
			String lineCd, String sublineCd, BigDecimal discountRt,
			BigDecimal discountAmt, BigDecimal surchargeRt,
			BigDecimal surchargeAmt, BigDecimal origPremAmt,
			BigDecimal netPremAmt, String netGrossTag, Date lastUpdate,
			String remarks){
		super(quoteId, sequenceNo, lineCd, sublineCd, 
				discountRt, discountAmt, surchargeRt, surchargeAmt, origPremAmt, netPremAmt, 
				netGrossTag, lastUpdate, remarks);
	}

	/**
	 * Instantiates a new gIPI quote item discount.
	 */
	public GIPIQuoteItemDiscount(){		
		super();
	}
	
	/**
	 * Gets the item no.
	 * 
	 * @return the item no
	 */
	public int getItemNo() {
		return itemNo;
	}

	/**
	 * Sets the item no.
	 * 
	 * @param itemNo the new item no
	 */
	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}

	/**
	 * Gets the item title.
	 * 
	 * @return the item title
	 */
	public String getItemTitle() {
		return itemTitle;
	}

	/**
	 * Sets the item title.
	 * 
	 * @param itemTitle the new item title
	 */
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}

}
