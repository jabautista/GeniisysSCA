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

import com.geniisys.framework.util.BaseEntity;

/**
 * The Class GIPIInstallment.
 */
public class GIPIInstallment extends BaseEntity{
	
	/** The iss cd. */
	private String issCd;
	
	/** The prem seq no. */
	private Integer premSeqNo;
	
	/** The inst no. */
	private Integer instNo;
	
	/** The item group. */
	private Integer itmGrp;
	
	/** The share percentage. */
	private Integer sharePerctg;
	
	/** The tax amt. */
	private Integer taxAmt;
	
	/** The prem amt. */
	private Integer premAmt;
	
	/** The due date. */
	private Date dueDate;
	
	private BigDecimal premAmount;
	
	private BigDecimal taxAmount;
	
	private BigDecimal sharePercentage;
	
	private String dueDateStr;
	
	public GIPIInstallment(){
		
	}
	

	/**
	 * @return the issCd
	 */
	public String getIssCd() {
		return issCd;
	}

	/**
	 * @param issCd the issCd to set
	 */
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	/**
	 * @return the premSeqNo
	 */
	public Integer getPremSeqNo() {
		return premSeqNo;
	}

	/**
	 * @param premSeqNo the premSeqNo to set
	 */
	public void setPremSeqNo(Integer premSeqNo) {
		this.premSeqNo = premSeqNo;
	}

	/**
	 * @return the instNo
	 */
	public Integer getInstNo() {
		return instNo;
	}

	/**
	 * @param instNo the instNo to set
	 */
	public void setInstNo(Integer instNo) {
		this.instNo = instNo;
	}

	/**
	 * @return the itmGrp
	 */
	public Integer getItmGrp() {
		return itmGrp;
	}

	/**
	 * @param itmGrp the itmGrp to set
	 */
	public void setItmGrp(Integer itmGrp) {
		this.itmGrp = itmGrp;
	}

	/**
	 * @return the sharePerctg
	 */
	public Integer getSharePerctg() {
		return sharePerctg;
	}

	/**
	 * @param sharePerctg the sharePerctg to set
	 */
	public void setSharePerctg(Integer sharePerctg) {
		this.sharePerctg = sharePerctg;
	}

	/**
	 * @return the taxAmt
	 */
	public Integer getTaxAmt() {
		return taxAmt;
	}

	/**
	 * @param taxAmt the taxAmt to set
	 */
	public void setTaxAmt(Integer taxAmt) {
		this.taxAmt = taxAmt;
	}

	/**
	 * @return the premAmt
	 */
	public Integer getPremAmt() {
		return premAmt;
	}

	/**
	 * @param premAmt the premAmt to set
	 */
	public void setPremAmt(Integer premAmt) {
		this.premAmt = premAmt;
	}

	/**
	 * @return the dueDate
	 */
	public Date getDueDate() {
		return dueDate;
	}


	/**
	 * @param dueDate the dueDate to set
	 */
	public void setDueDate(Date dueDate) {
		this.dueDate = dueDate;
	}


	public void setPremAmount(BigDecimal premAmount) {
		this.premAmount = premAmount;
	}


	public BigDecimal getPremAmount() {
		return premAmount;
	}


	public void setTaxAmount(BigDecimal taxAmount) {
		this.taxAmount = taxAmount;
	}


	public BigDecimal getTaxAmount() {
		return taxAmount;
	}


	public void setSharePercentage(BigDecimal sharePercentage) {
		this.sharePercentage = sharePercentage;
	}


	public BigDecimal getSharePercentage() {
		return sharePercentage;
	}


	public String getDueDateStr() {
		return dueDateStr;
	}


	public void setDueDateStr(String dueDateStr) {
		this.dueDateStr = dueDateStr;
	}
	
	
	
	

}
