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
 * The Class GIPIWCommInvoice.
 */
public class GIPIWCommInvoice extends BaseEntity{

	/** The par id. */
	private int parId;
	
	/** The item group. */
	private int itemGroup;
	
	/** The takeup seq no. */
	private int takeupSeqNo;
	
	/** The intermediary no. */
	private int intermediaryNo;
	
	/** The intermediary name. */
	private String intermediaryName;
	
	/** The parent intermediary no. */
	private Integer parentIntermediaryNo;
	
	/** The parent intermediary name. */
	private String parentIntermediaryName;
	
	/** The share percentage. */
	private BigDecimal sharePercentage;
	
	/** The premium amount. */
	private BigDecimal premiumAmount;
	
	/** The commission amount. */
	private BigDecimal commissionAmount;
	
	/** The withholding tax. */
	private BigDecimal withholdingTax;
	
	/** The net commission. */
	private BigDecimal netCommission;
	
	private String parentIntmLicTag;
	private String parentIntmSpecialRate;
	
	/** The lic tag. */
	private String licTag; /*added by christian 08.25.2012*/
	
	/** The special rate. */
	private String specialRate; /*added by christian 08.25.2012*/
	
	
	
	
	/**
	 * @return the parentIntmLicTag
	 */
	public String getParentIntmLicTag() {
		return parentIntmLicTag;
	}

	/**
	 * @param parentIntmLicTag the parentIntmLicTag to set
	 */
	public void setParentIntmLicTag(String parentIntmLicTag) {
		this.parentIntmLicTag = parentIntmLicTag;
	}

	/**
	 * @return the parentIntmSpecialRate
	 */
	public String getParentIntmSpecialRate() {
		return parentIntmSpecialRate;
	}

	/**
	 * @param parentIntmSpecialRate the parentIntmSpecialRate to set
	 */
	public void setParentIntmSpecialRate(String parentIntmSpecialRate) {
		this.parentIntmSpecialRate = parentIntmSpecialRate;
	}

	/**
	 * Instantiates a new gIPIW comm invoice.
	 */
	public GIPIWCommInvoice() {
	}

	/**
	 * Instantiates a new gIPIW comm invoice.
	 * 
	 * @param parId the par id
	 * @param itemGroup the item group
	 * @param takeupSeqNo the takeup seq no
	 * @param intermediaryNo the intermediary no
	 * @param intermediaryName the intermediary name
	 * @param parentIntermediaryNo the parent intermediary no
	 * @param parentIntermediaryName the parent intermediary name
	 * @param sharePercentage the share percentage
	 * @param premiumAmount the premium amount
	 * @param commissionAmount the commission amount
	 * @param withholdingTax the withholding tax
	 * @param netCommission the net commission
	 */
	public GIPIWCommInvoice(int parId, int itemGroup, int takeupSeqNo,
			int intermediaryNo, String intermediaryName,
			int parentIntermediaryNo, String parentIntermediaryName,
			BigDecimal sharePercentage, BigDecimal premiumAmount,
			BigDecimal commissionAmount, BigDecimal withholdingTax,
			BigDecimal netCommission) {
		this.parId = parId;
		this.itemGroup = itemGroup;
		this.takeupSeqNo = takeupSeqNo;
		this.intermediaryNo = intermediaryNo;
		this.intermediaryName = intermediaryName;
		this.parentIntermediaryNo = parentIntermediaryNo;
		this.parentIntermediaryName = parentIntermediaryName;
		this.sharePercentage = sharePercentage;
		this.premiumAmount = premiumAmount;
		this.commissionAmount = commissionAmount;
		this.withholdingTax = withholdingTax;
		this.netCommission = netCommission;
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
	 * Gets the intermediary no.
	 * 
	 * @return the intermediary no
	 */
	public int getIntermediaryNo() {
		return intermediaryNo;
	}

	/**
	 * Sets the intermediary no.
	 * 
	 * @param intermediaryNo the new intermediary no
	 */
	public void setIntermediaryNo(int intermediaryNo) {
		this.intermediaryNo = intermediaryNo;
	}

	/**
	 * Gets the intermediary name.
	 * 
	 * @return the intermediary name
	 */
	public String getIntermediaryName() {
		return intermediaryName;
	}

	/**
	 * Sets the intermediary name.
	 * 
	 * @param intermediaryName the new intermediary name
	 */
	public void setIntermediaryName(String intermediaryName) {
		this.intermediaryName = intermediaryName;
	}

	/**
	 * Gets the parent intermediary no.
	 * 
	 * @return the parent intermediary no
	 */
	public Integer getParentIntermediaryNo() {
		return parentIntermediaryNo;
	}

	/**
	 * Sets the parent intermediary no.
	 * 
	 * @param parentIntermediaryNo the new parent intermediary no
	 */
	public void setParentIntermediaryNo(Integer parentIntermediaryNo) {
		this.parentIntermediaryNo = parentIntermediaryNo;
	}

	/**
	 * Gets the parent intermediary name.
	 * 
	 * @return the parent intermediary name
	 */
	public String getParentIntermediaryName() {
		return parentIntermediaryName;
	}

	/**
	 * Sets the parent intermediary name.
	 * 
	 * @param parentIntermediaryName the new parent intermediary name
	 */
	public void setParentIntermediaryName(String parentIntermediaryName) {
		this.parentIntermediaryName = parentIntermediaryName;
	}

	/**
	 * Gets the share percentage.
	 * 
	 * @return the share percentage
	 */
	public BigDecimal getSharePercentage() {
		return sharePercentage;
	}

	/**
	 * Sets the share percentage.
	 * 
	 * @param sharePercentage the new share percentage
	 */
	public void setSharePercentage(BigDecimal sharePercentage) {
		this.sharePercentage = sharePercentage;
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

	/**
	 * @return the licTag
	 */
	public String getLicTag() {
		return licTag;
	}

	/**
	 * @param licTag the licTag to set
	 */
	public void setLicTag(String licTag) {
		this.licTag = licTag;
	}

	/**
	 * @return the specialRate
	 */
	public String getSpecialRate() {
		return specialRate;
	}

	/**
	 * @param specialRate the specialRate to set
	 */
	public void setSpecialRate(String specialRate) {
		this.specialRate = specialRate;
	}
	
}
