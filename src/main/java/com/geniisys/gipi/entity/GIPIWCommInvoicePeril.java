/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIWCommInvoicePeril.
 */
public class GIPIWCommInvoicePeril extends BaseEntity {

	/** The peril cd. */
	private int perilCd;
	
	/** The peril name. */
	private String perilName;
	
	/** The item group. */
	private int itemGroup;
	
	/** The takeup seq no. */
	private int takeupSeqNo;
	
	/** The par id. */
	private int parId;
	
	/** The intermediary intm no. */
	private int intermediaryIntmNo;
	
	/** The premium amount. */
	private BigDecimal premiumAmount;
	
	/** The commission rate. */
	private BigDecimal commissionRate;
	
	/** The commission amount. */
	private BigDecimal commissionAmount;
	
	/** The withholding tax. */
	private BigDecimal withholdingTax;
	
	/** The net commission. */
	private BigDecimal netCommission;
	
	/**
	 * Instantiates a new gIPIW comm invoice peril.
	 */
	public GIPIWCommInvoicePeril() {
		
	}
	
	/**
	 * Instantiates a new gIPIW comm invoice peril.
	 * 
	 * @param perilCd the peril cd
	 * @param perilName the peril name
	 * @param itemGroup the item group
	 * @param takeupSeqNo the takeup seq no
	 * @param parId the par id
	 * @param intermediaryIntmNo the intermediary intm no
	 * @param premiumAmount the premium amount
	 * @param commissionRate the commission rate
	 * @param commissionAmount the commission amount
	 * @param withholdingTax the withholding tax
	 * @param netCommission the net commission
	 */
	public GIPIWCommInvoicePeril(int perilCd, String perilName, int itemGroup,
			int takeupSeqNo, int parId, int intermediaryIntmNo, BigDecimal premiumAmount,
			BigDecimal commissionRate, BigDecimal commissionAmount, BigDecimal withholdingTax, 
			BigDecimal netCommission) {
		this.perilCd = perilCd;
		this.perilName = perilName;
		this.itemGroup = itemGroup;
		this.takeupSeqNo = takeupSeqNo;
		this.parId = parId;
		this.intermediaryIntmNo = intermediaryIntmNo;
		this.premiumAmount = premiumAmount;
		this.commissionRate = commissionRate;
		this.commissionAmount = commissionAmount;
		this.withholdingTax = withholdingTax;
		this.netCommission = netCommission;
	}

	/**
	 * Gets the peril cd.
	 * 
	 * @return the peril cd
	 */
	public int getPerilCd() {
		return perilCd;
	}

	/**
	 * Sets the peril cd.
	 * 
	 * @param perilCd the new peril cd
	 */
	public void setPerilCd(int perilCd) {
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
	 * Gets the item group.
	 * 
	 * @return the item group
	 */
	public int getItemGroup() {
		return itemGroup;
	}

	/**
	 * Sets the item group.
	 * 
	 * @param itemGroup the new item group
	 */
	public void setItemGroup(int itemGroup) {
		this.itemGroup = itemGroup;
	}

	/**
	 * Gets the takeup seq no.
	 * 
	 * @return the takeup seq no
	 */
	public int getTakeupSeqNo() {
		return takeupSeqNo;
	}

	/**
	 * Sets the takeup seq no.
	 * 
	 * @param takeupSeqNo the new takeup seq no
	 */
	public void setTakeupSeqNo(int takeupSeqNo) {
		this.takeupSeqNo = takeupSeqNo;
	}

	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public int getParId() {
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
	 * Gets the intermediary intm no.
	 * 
	 * @return the intermediary intm no
	 */
	public int getIntermediaryIntmNo() {
		return intermediaryIntmNo;
	}

	/**
	 * Sets the intermediary intm no.
	 * 
	 * @param intermediaryIntmNo the new intermediary intm no
	 */
	public void setIntermediaryIntmNo(int intermediaryIntmNo) {
		this.intermediaryIntmNo = intermediaryIntmNo;
	}

	/**
	 * Gets the premium amount.
	 * 
	 * @return the premium amount
	 */
	public BigDecimal getPremiumAmount() {
		return premiumAmount;
	}

	/**
	 * Sets the premium amount.
	 * 
	 * @param premiumAmount the new premium amount
	 */
	public void setPremiumAmount(BigDecimal premiumAmount) {
		this.premiumAmount = premiumAmount;
	}

	/**
	 * Gets the commission rate.
	 * 
	 * @return the commission rate
	 */
	public BigDecimal getCommissionRate() {
		return commissionRate;
	}

	/**
	 * Sets the commission rate.
	 * 
	 * @param commissionRate the new commission rate
	 */
	public void setCommissionRate(BigDecimal commissionRate) {
		this.commissionRate = commissionRate;
	}

	/**
	 * Gets the commission amount.
	 * 
	 * @return the commission amount
	 */
	public BigDecimal getCommissionAmount() {
		return commissionAmount;
	}

	/**
	 * Sets the commission amount.
	 * 
	 * @param commissionAmount the new commission amount
	 */
	public void setCommissionAmount(BigDecimal commissionAmount) {
		this.commissionAmount = commissionAmount;
	}

	/**
	 * Gets the withholding tax.
	 * 
	 * @return the withholding tax
	 */
	public BigDecimal getWithholdingTax() {
		return withholdingTax;
	}

	/**
	 * Sets the withholding tax.
	 * 
	 * @param withholdingTax the new withholding tax
	 */
	public void setWithholdingTax(BigDecimal withholdingTax) {
		this.withholdingTax = withholdingTax;
	}

	/**
	 * Gets the net commission.
	 * 
	 * @return the net commission
	 */
	public BigDecimal getNetCommission() {
		return netCommission;
	}

	/**
	 * Sets the net commission.
	 * 
	 * @param netCommission the new net commission
	 */
	public void setNetCommission(BigDecimal netCommission) {
		this.netCommission = netCommission;
	}
	
}
