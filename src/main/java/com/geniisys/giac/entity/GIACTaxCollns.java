/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIACTaxCollns extends BaseEntity {
	
	/** The gacc_tran_id. */
	private Integer gaccTranId;
	
	/** The transaction_type. */
	private Integer transactionType;
	
	/** The b160_iss_cd */ 
	private String b160IssCd;
	
	
	/** The b160_prem_seq_no. */
	private Integer b160PremSeqNo;
	
	/** The b160_tax_cd. */
	private Integer b160TaxCd;
	
	/** The tax_name. */
	private String taxName;
	
	/** The inst_no */
	private Integer instNo;
	
	/** The fund_cd */
	private String fundCd;
	
	/** The tax_amt */
	private BigDecimal taxAmt;
	
	public GIACTaxCollns() {
		
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
	 * @return the b160IssCd
	 */
	public String getB160IssCd() {
		return b160IssCd;
	}

	/**
	 * @param b160IssCd the b160IssCd to set
	 */
	public void setB160IssCd(String b160IssCd) {
		this.b160IssCd = b160IssCd;
	}

	/**
	 * @return the b160PremSeqNo
	 */
	public Integer getB160PremSeqNo() {
		return b160PremSeqNo;
	}

	/**
	 * @param b160PremSeqNo the b160PremSeqNo to set
	 */
	public void setB160PremSeqNo(Integer b160PremSeqNo) {
		this.b160PremSeqNo = b160PremSeqNo;
	}

	/**
	 * @return the b160TaxCd
	 */
	public Integer getB160TaxCd() {
		return b160TaxCd;
	}

	/**
	 * @param b160TaxCd the b160TaxCd to set
	 */
	public void setB160TaxCd(Integer b160TaxCd) {
		this.b160TaxCd = b160TaxCd;
	}

	/**
	 * @return the instNo
	 */
	public Integer getInstNo() {
		return instNo;
	}

	/**
	 * @return the taxName
	 */
	public String getTaxName() {
		return taxName;
	}

	/**
	 * @param taxName the taxName to set
	 */
	public void setTaxName(String taxName) {
		this.taxName = taxName;
	}

	/**
	 * @param instNo the instNo to set
	 */
	public void setInstNo(Integer instNo) {
		this.instNo = instNo;
	}

	/**
	 * @return the fundCd
	 */
	public String getFundCd() {
		return fundCd;
	}

	/**
	 * @param fundCd the fundCd to set
	 */
	public void setFundCd(String fundCd) {
		this.fundCd = fundCd;
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

	
}
