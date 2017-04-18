/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;
/**
 * The Class GIACDirectPremCollns.
 */
public class GIACDirectPremCollns extends BaseEntity{
	
	/** The iss cd. */
	private String issCd;
	
	/** The prem seq no. */
	private Integer premSeqNo;
	
	/** The tran id. */
	private Integer gaccTranId;
	
	/** The instNo. */
	private Integer instNo;
	
	/** The tran type. */
	private Integer tranType;
	
	/** The collection amt. */
	private BigDecimal collAmt;
	
	/** The prem amt. */
	private BigDecimal premAmt;
	
	/** The tax amt. */
	private BigDecimal taxAmt;
	
	/** The or print tag. */
	private String orPrintTag;
	
	/** The particulars. */
	private Integer currCd;
	
	/** The convert rate. */
	private BigDecimal convRate;
	
	/** The foreign curr amt. */
	private BigDecimal forCurrAmt;
	
	/** The doc no. */
	private String docNo;
	
	/** The coll date. */
	private Date collnDate;
	
	/** The acct ent date. */
	private Date acctEntDate;
	
	/** The pdc tag. */
	private String pdcTag;
	
	/** The particulars. */
	private String particulars;
	
	private String incTag;
	
	private Date lastUpdate;
	
	private String userId;
	
	//added 06-15-2012
	private BigDecimal premVatable;
	private BigDecimal premVatExempt;
	private BigDecimal premZeroRated;
	private Integer revGaccTranId;
	
	private String isSaved;
	
	public Date getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	
//Gzelle 06.27.2013
	public String getStrLastUpdate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss a");
		if(lastUpdate != null){
			return sdf.format(lastUpdate).toString();
		} else {
			return null;
		}
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	private String refNo;
	
	private Date tranDate;
		
	private BigDecimal totalPrem;
	
	private BigDecimal totalTax;
	
	private BigDecimal totalCollection;
	
	public BigDecimal getTotalPrem() {
		return totalPrem;
	}

	public void setTotalPrem(BigDecimal totalPrem) {
		this.totalPrem = totalPrem;
	}

	public BigDecimal getTotalTax() {
		return totalTax;
	}

	public void setTotalTax(BigDecimal totalTax) {
		this.totalTax = totalTax;
	}

	public BigDecimal getTotalCollection() {
		return totalCollection;
	}

	public void setTotalCollection(BigDecimal totalCollection) {
		this.totalCollection = totalCollection;
	}

	public GIACDirectPremCollns(){
		
	}
		
	public GIACDirectPremCollns(Integer gaccTranId, Integer tranType, String issCd, Integer premSeqNo, Integer instNo, 
			BigDecimal collAmt, BigDecimal premAmt, BigDecimal taxAmt, String orPrintTag, String particulars, Integer currCd, 
			BigDecimal convRate, BigDecimal forCurrAmt){
		this.gaccTranId = gaccTranId;
		this.tranType = tranType;
		this.issCd = issCd;
		this.premSeqNo = premSeqNo;
		this.instNo = instNo;
		this.collAmt = collAmt;
		this.premAmt = premAmt;
		this.taxAmt = taxAmt;
		this.orPrintTag = orPrintTag;
		this.particulars = particulars;
		this.currCd = currCd;
		this.convRate = convRate;
		this.forCurrAmt = forCurrAmt;
	}
	
	public GIACDirectPremCollns(Integer gaccTranId, Integer tranType, String issCd, Integer premSeqNo, Integer instNo){
		this.gaccTranId = gaccTranId;
		this.tranType = tranType;
		this.issCd = issCd;
		this.premSeqNo = premSeqNo;
		this.instNo = instNo;	
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
	 * @return the collAmt
	 */
	public BigDecimal getCollAmt() {
		return collAmt;
	}

	/**
	 * @param collAmt the collAmt to set
	 */
	public void setCollAmt(BigDecimal collAmt) {
		this.collAmt = collAmt;
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
	 * @return the convRate
	 */
	public BigDecimal getConvRate() {
		return convRate;
	}

	/**
	 * @param convRate the convRate to set
	 */
	public void setConvRate(BigDecimal convRate) {
		this.convRate = convRate;
	}

	/**
	 * @return the forCurrAmt
	 */
	public BigDecimal getForCurrAmt() {
		return forCurrAmt;
	}

	/**
	 * @param forCurrAmt the forCurrAmt to set
	 */
	public void setForCurrAmt(BigDecimal forCurrAmt) {
		this.forCurrAmt = forCurrAmt;
	}

	/**
	 * @return the docNo
	 */
	public String getDocNo() {
		return docNo;
	}

	/**
	 * @param docNo the docNo to set
	 */
	public void setDocNo(String docNo) {
		this.docNo = docNo;
	}

	/**
	 * @return the collnDate
	 */
	public Date getCollnDate() {
		return collnDate;
	}

	/**
	 * @param collnDate the collnDate to set
	 */
	public void setCollnDate(Date collnDate) {
		this.collnDate = collnDate;
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
	 * @return the pdcTag
	 */
	public String getPdcTag() {
		return pdcTag;
	}

	/**
	 * @param pdcTag the pdcTag to set
	 */
	public void setPdcTag(String pdcTag) {
		this.pdcTag = pdcTag;
	}

	/**
	 * @return the particulars
	 */
	public String getParticulars() {
		return particulars;
	}

	/**
	 * @param particulars the particulars to set
	 */
	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}

	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}

	public String getRefNo() {
		return refNo;
	}

	public void setTranDate(Date tranDate) {
		this.tranDate = tranDate;
	}

	public Date getTranDate() {
		return tranDate;
	}
	
	public String getStrTranDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(tranDate != null){
			return sdf.format(tranDate).toString();
		} else {
			return null;
		}
	}

	public String getIncTag() {
		return incTag;
	}

	public void setIncTag(String incTag) {
		this.incTag = incTag;
	}

	public BigDecimal getPremVatable() {
		return premVatable;
	}

	public void setPremVatable(BigDecimal premVatable) {
		this.premVatable = premVatable;
	}

	public BigDecimal getPremVatExempt() {
		return premVatExempt;
	}

	public void setPremVatExempt(BigDecimal premVatExempt) {
		this.premVatExempt = premVatExempt;
	}

	public BigDecimal getPremZeroRated() {
		return premZeroRated;
	}

	public void setPremZeroRated(BigDecimal premZeroRated) {
		this.premZeroRated = premZeroRated;
	}

	public Integer getRevGaccTranId() {
		return revGaccTranId;
	}

	public void setRevGaccTranId(Integer revGaccTranId) {
		this.revGaccTranId = revGaccTranId;
	}

	public String getIsSaved() {
		return isSaved;
	}

	public void setIsSaved(String isSaved) {
		this.isSaved = isSaved;
	}
}
