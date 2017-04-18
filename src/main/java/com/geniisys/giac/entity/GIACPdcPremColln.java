/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

/**
 * The Class GIACPdcPremColln.
 */
public class GIACPdcPremColln extends BaseEntity{

	/** The PDC ID. */
	private Integer pdcId;
	
	/** The transaction type. */
	private Integer tranType;
	
	/** The iss cd. */
	private String issCd;
	
	/** The prem seqno. */
	private Integer premSeqNo;
	
	/** The inst no. */
	private Integer instNo;
	
	/** The collection amount. */
	private BigDecimal collnAmt;
	
	/** The currency cd. */
	private Integer currCd;
	
	/** The currency rt. */
	private BigDecimal currRt;
	
	/** The fcurrency amt. */
	private BigDecimal fCurrAmt;
	
	/** The premium amt. */
	private BigDecimal premAmt;
	
	/** The tax amt. */
	private BigDecimal taxAmt;
	
	/** The insert tag. */
	private String insertTag;
	
	private Date lastUpdate;
	private String tranTypeDesc;
	private String assdName;
	private String policyNo;
	
	public String getTranTypeDesc() {
		return tranTypeDesc;
	}

	public void setTranTypeDesc(String tranTypeDesc) {
		this.tranTypeDesc = tranTypeDesc;
	}

	public String getAssdName() {
		return assdName;
	}

	public void setAssdName(String assdName) {
		this.assdName = assdName;
	}

	public String getPolicyNo() {
		return policyNo;
	}

	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}

	public Date getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}

	public GIACPdcPremColln(){
		
	}

	/**
	 * @return the pdcId
	 */
	public Integer getPdcId() {
		return pdcId;
	}

	/**
	 * @param pdcId the pdcId to set
	 */
	public void setPdcId(Integer pdcId) {
		this.pdcId = pdcId;
	}

	/**
	 * @return the tranType
	 */
	public Integer getTranType() {
		return tranType;
	}

	/**
	 * @param tranType the tranType to set
	 */
	public void setTranType(Integer tranType) {
		this.tranType = tranType;
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
	 * @return the collnAmt
	 */
	public BigDecimal getCollnAmt() {
		return collnAmt;
	}

	/**
	 * @param collnAmt the collnAmt to set
	 */
	public void setCollnAmt(BigDecimal collnAmt) {
		this.collnAmt = collnAmt;
	}

	/**
	 * @return the currCd
	 */
	public Integer getCurrCd() {
		return currCd;
	}

	/**
	 * @param currCd the currCd to set
	 */
	public void setCurrCd(Integer currCd) {
		this.currCd = currCd;
	}

	/**
	 * @return the currRt
	 */
	public BigDecimal getCurrRt() {
		return currRt;
	}

	/**
	 * @param currRt the currRt to set
	 */
	public void setCurrRt(BigDecimal currRt) {
		this.currRt = currRt;
	}

	/**
	 * @return the fCurrAmt
	 */
	public BigDecimal getfCurrAmt() {
		return fCurrAmt;
	}

	/**
	 * @param fCurrAmt the fCurrAmt to set
	 */
	public void setfCurrAmt(BigDecimal fCurrAmt) {
		this.fCurrAmt = fCurrAmt;
	}

	/**
	 * @return the premAmt
	 */
	public BigDecimal getPremAmt() {
		return premAmt;
	}

	/**
	 * @param premAmt the premAmt to set
	 */
	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
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
	 * @return the insertTag
	 */
	public String getInsertTag() {
		return insertTag;
	}

	/**
	 * @param insertTag the insertTag to set
	 */
	public void setInsertTag(String insertTag) {
		this.insertTag = insertTag;
	}
	
	
}
