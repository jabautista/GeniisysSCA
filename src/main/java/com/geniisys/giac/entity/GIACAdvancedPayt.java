package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACAdvancedPayt extends BaseEntity{
	
	/** The gacc_tran_id */
	private Integer gaccTranId;
	
	/** The policy_id */
	private Integer policyId;
	
	/** The transaction_type */
	private Integer transactionType;
	
	/** The iss_cd */
	private String issCd;
	
	/** The prem_seq_no */
	private Integer premSeqNo;
	
	/** The premium_amt */
	private BigDecimal premiumAmt;
	
	/** The tax_amt */
	private BigDecimal taxAmt;
	
	/** The inst_no */
	private Integer instNo;
	
	/** The acct_ent_date */
	private Date acctEntDate;
	
	/** The user_id */
	private String userId;
	
	/** The last_update */
	private Date lastUpdate;
	
	/** The booking_mth */
	private String bookingMth;
	
	/** The booking_year */
	private Integer bookingYear;
	
	/** The cancel_date */
	private Date cancelDate;
	
	/** The rev_gacc_tran_id */
	private Integer revGaccTranId;
	
	/** The batch_gacc_tran_id */
	private Integer batchGaccTranId;
	
	/** The assd_no */
	private Integer assdNo;
	
	public GIACAdvancedPayt() {
		
	}

	/**
	 * @return the gaccTranId
	 */
	public Integer getGaccTranId() {
		return gaccTranId;
	}

	/**
	 * @param gaccTranId the gaccTranId to set
	 */
	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}

	/**
	 * @return the policyId
	 */
	public Integer getPolicyId() {
		return policyId;
	}

	/**
	 * @param policyId the policyId to set
	 */
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	/**
	 * @return the transactionType
	 */
	public Integer getTransactionType() {
		return transactionType;
	}

	/**
	 * @param transactionType the transactionType to set
	 */
	public void setTransactionType(Integer transactionType) {
		this.transactionType = transactionType;
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
	 * @return the premiumAmt
	 */
	public BigDecimal getPremiumAmt() {
		return premiumAmt;
	}

	/**
	 * @param premiumAmt the premiumAmt to set
	 */
	public void setPremiumAmt(BigDecimal premiumAmt) {
		this.premiumAmt = premiumAmt;
	}

	/**
	 * @return the taxAmt
	 */
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}

	/**
	 * @param taxAmt the taxAmt to set
	 */
	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
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
	 * @return the acctEntDate
	 */
	public Date getAcctEntDate() {
		return acctEntDate;
	}

	/**
	 * @param acctEntDate the acctEntDate to set
	 */
	public void setAcctEntDate(Date acctEntDate) {
		this.acctEntDate = acctEntDate;
	}

	/**
	 * @return the userId
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * @param userId the userId to set
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}

	/**
	 * @return the lastUpdate
	 */
	public Date getLastUpdate() {
		return lastUpdate;
	}

	/**
	 * @param lastUpdate the lastUpdate to set
	 */
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}

	/**
	 * @return the bookingMth
	 */
	public String getBookingMth() {
		return bookingMth;
	}

	/**
	 * @param bookingMth the bookingMth to set
	 */
	public void setBookingMth(String bookingMth) {
		this.bookingMth = bookingMth;
	}

	/**
	 * @return the bookingYear
	 */
	public Integer getBookingYear() {
		return bookingYear;
	}

	/**
	 * @param bookingYear the bookingYear to set
	 */
	public void setBookingYear(Integer bookingYear) {
		this.bookingYear = bookingYear;
	}

	/**
	 * @return the cancelDate
	 */
	public Date getCancelDate() {
		return cancelDate;
	}

	/**
	 * @param cancelDate the cancelDate to set
	 */
	public void setCancelDate(Date cancelDate) {
		this.cancelDate = cancelDate;
	}

	/**
	 * @return the revGaccTranId
	 */
	public Integer getRevGaccTranId() {
		return revGaccTranId;
	}

	/**
	 * @param revGaccTranId the revGaccTranId to set
	 */
	public void setRevGaccTranId(Integer revGaccTranId) {
		this.revGaccTranId = revGaccTranId;
	}

	/**
	 * @return the batchGaccTranId
	 */
	public Integer getBatchGaccTranId() {
		return batchGaccTranId;
	}

	/**
	 * @param batchGaccTranId the batchGaccTranId to set
	 */
	public void setBatchGaccTranId(Integer batchGaccTranId) {
		this.batchGaccTranId = batchGaccTranId;
	}

	/**
	 * @return the assdNo
	 */
	public Integer getAssdNo() {
		return assdNo;
	}

	/**
	 * @param assdNo the assdNo to set
	 */
	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}

}
