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

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIWInstallment.
 */
public class GIPIWInstallment extends BaseEntity {
	
	/** The par id. */
	private int parId;
	
	/** The item grp. */
	private int itemGrp;
	
	/** The takeup seq no. */
	private int takeupSeqNo;
	
	/** The inst no. */
	private Integer instNo;
	
	/** The due date. */
	private Date dueDate;
	
	/** The share pct. */
	private BigDecimal sharePct;
	
	/** The prem amt. */
	private BigDecimal premAmt;
	
	/** The tax amt. */
	private BigDecimal taxAmt;
	
	/** The total due. */
	private BigDecimal totalDue;
	
	/** The total share pct. */
	private BigDecimal totalSharePct;
	
	/** The total prem amt. */
	private BigDecimal totalPremAmt;
	
	/** The total tax amt. */
	private BigDecimal totalTaxAmt;
	
	/** The total amount due. */
	private BigDecimal totalAmountDue;

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
	 * Gets the inst no.
	 * 
	 * @return the inst no
	 */
	public Integer getInstNo() {
		return instNo;
	}

	/**
	 * Sets the inst no.
	 * 
	 * @param instNo the new inst no
	 */
	public void setInstNo(Integer instNo) {
		this.instNo = instNo;
	}

	/**
	 * Gets the due date.
	 * 
	 * @return the due date
	 */
	public String getDueDate() {
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
	 * Gets the share pct.
	 * 
	 * @return the share pct
	 */
	public BigDecimal getSharePct() {
		return sharePct;
	}

	/**
	 * Sets the share pct.
	 * 
	 * @param sharePct the new share pct
	 */
	public void setSharePct(BigDecimal sharePct) {
		this.sharePct = sharePct;
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
	 * Gets the total due.
	 * 
	 * @return the total due
	 */
	public BigDecimal getTotalDue() {
		return totalDue;
	}

	/**
	 * Sets the total due.
	 * 
	 * @param totalDue the new total due
	 */
	public void setTotalDue(BigDecimal totalDue) {
		this.totalDue = totalDue;
	}

	/**
	 * Gets the total share pct.
	 * 
	 * @return the total share pct
	 */
	public BigDecimal getTotalSharePct() {
		return totalSharePct;
	}

	/**
	 * Sets the total share pct.
	 * 
	 * @param totalSharePct the new total share pct
	 */
	public void setTotalSharePct(BigDecimal totalSharePct) {
		this.totalSharePct = totalSharePct;
	}

	/**
	 * Gets the total prem amt.
	 * 
	 * @return the total prem amt
	 */
	public BigDecimal getTotalPremAmt() {
		return totalPremAmt;
	}

	/**
	 * Sets the total prem amt.
	 * 
	 * @param totalPremAmt the new total prem amt
	 */
	public void setTotalPremAmt(BigDecimal totalPremAmt) {
		this.totalPremAmt = totalPremAmt;
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
	 * Gets the total amount due.
	 * 
	 * @return the total amount due
	 */
	public BigDecimal getTotalAmountDue() {
		return totalAmountDue;
	}

	/**
	 * Sets the total amount due.
	 * 
	 * @param totalAmountDue the new total amount due
	 */
	public void setTotalAmountDue(BigDecimal totalAmountDue) {
		this.totalAmountDue = totalAmountDue;
	}

}
