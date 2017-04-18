/**
 * Created by tonio Feb 14, 2011
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;
/**
 * The Class GIACOutFaculPremPaymt
 */
public class GIACOutFaculPremPaymt extends BaseEntity{

	/** The GACC Tran ID. */
	private Integer gaccTranId;
	
	/** The fnl binder ID. */
	private Integer binderId;
	
	/** The RI cd. */
	private Integer riCd;
	
	/** The transaction type. */
	private Integer tranType;
	
	/** The Disbursement Amt. */
	private BigDecimal disbursementAmt;
	
	/** The request no. */
	private Integer requestNo;
	
	/** The currency cd. */
	private Integer currencyCd;
	
	/** The convert rate. */
	private BigDecimal convertRate;
	
	/** The Foreign currency Amt. */
	private BigDecimal foreignCurrAmt;
	
	/** The OR print tag. */
	private String orPrintTag;
	
	/** The Remarks. */
	private String remarks;
	
	/** The premAmt. */
	private BigDecimal premAmt;
	
	/** The prem vat. */
	private BigDecimal premVat;
	
	/** The comm amt. */
	private BigDecimal commAmt;
	
	/** The comm vat. */
	private BigDecimal commVat;
	
	/** The wholding tax. */
	private BigDecimal wholdingTax;
	
	private String cmTag;
	
	private Integer recordNo;	// SR-19631 : shan 08.17.2015
	
	private Integer paytGaccTranId;		// SR-19631 : shan 08.17.2015
	
	private Integer revRecordNo;		// SR-19631 : shan 08.17.2015
	
	public GIACOutFaculPremPaymt(){
		
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
	 * @return the fnlBinderId
	 */
	public Integer getBinderId() {
		return binderId;
	}

	/**
	 * @param fnlBinderId the fnlBinderId to set
	 */
	public void setBinderId(Integer binderId) {
		this.binderId = binderId;
	}

	/**
	 * @return the riCd
	 */
	public Integer getRiCd() {
		return riCd;
	}

	/**
	 * @param riCd the riCd to set
	 */
	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
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
	 * @return the disbursementAmt
	 */
	public BigDecimal getDisbursementAmt() {
		return disbursementAmt;
	}

	/**
	 * @param disbursementAmt the disbursementAmt to set
	 */
	public void setDisbursementAmt(BigDecimal disbursementAmt) {
		this.disbursementAmt = disbursementAmt;
	}

	/**
	 * @return the requestNo
	 */
	public Integer getRequestNo() {
		return requestNo;
	}

	/**
	 * @param requestNo the requestNo to set
	 */
	public void setRequestNo(Integer requestNo) {
		this.requestNo = requestNo;
	}

	/**
	 * @return the currencyCd
	 */
	public Integer getCurrencyCd() {
		return currencyCd;
	}

	/**
	 * @param currencyCd the currencyCd to set
	 */
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}

	/**
	 * @return the convertRate
	 */
	public BigDecimal getConvertRate() {
		return convertRate;
	}

	/**
	 * @param convertRate the convertRate to set
	 */
	public void setConvertRate(BigDecimal convertRate) {
		this.convertRate = convertRate;
	}

	/**
	 * @return the foreignCurrAmt
	 */
	public BigDecimal getForeignCurrAmt() {
		return foreignCurrAmt;
	}

	/**
	 * @param foreignCurrAmt the foreignCurrAmt to set
	 */
	public void setForeignCurrAmt(BigDecimal foreignCurrAmt) {
		this.foreignCurrAmt = foreignCurrAmt;
	}

	/**
	 * @return the orPrintTag
	 */
	public String getOrPrintTag() {
		return orPrintTag;
	}

	/**
	 * @param orPrintTag the orPrintTag to set
	 */
	public void setOrPrintTag(String orPrintTag) {
		this.orPrintTag = orPrintTag;
	}

	/**
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * @param remarks the remarks to set
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
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
	 * @return the premVat
	 */
	public BigDecimal getPremVat() {
		return premVat;
	}

	/**
	 * @param premVat the premVat to set
	 */
	public void setPremVat(BigDecimal premVat) {
		this.premVat = premVat;
	}

	/**
	 * @return the commAmt
	 */
	public BigDecimal getCommAmt() {
		return commAmt;
	}

	/**
	 * @param commAmt the commAmt to set
	 */
	public void setCommAmt(BigDecimal commAmt) {
		this.commAmt = commAmt;
	}

	/**
	 * @return the commVat
	 */
	public BigDecimal getCommVat() {
		return commVat;
	}

	/**
	 * @param commVat the commVat to set
	 */
	public void setCommVat(BigDecimal commVat) {
		this.commVat = commVat;
	}

	/**
	 * @return the wholdingTax
	 */
	public BigDecimal getWholdingTax() {
		return wholdingTax;
	}

	/**
	 * @param wholdingTax the wholdingTax to set
	 */
	public void setWholdingTax(BigDecimal wholdingTax) {
		this.wholdingTax = wholdingTax;
	}

	public String getCmTag() {
		return cmTag;
	}

	public void setCmTag(String cmTag) {
		this.cmTag = cmTag;
	}

	public Integer getRecordNo() {
		return recordNo;
	}

	public void setRecordNo(Integer recordNo) {
		this.recordNo = recordNo;
	}

	public Integer getPaytGaccTranId() {
		return paytGaccTranId;
	}

	public void setPaytGaccTranId(Integer paytGaccTranId) {
		this.paytGaccTranId = paytGaccTranId;
	}

	public Integer getRevRecordNo() {
		return revRecordNo;
	}

	public void setRevRecordNo(Integer revRecordNo) {
		this.revRecordNo = revRecordNo;
	}
	
}
