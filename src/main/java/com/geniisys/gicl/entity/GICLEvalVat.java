/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.entity
	File Name: GICLEvalVat.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Apr 12, 2012
	Description: 
*/


package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLEvalVat extends BaseEntity{
	private Integer evalId;
	private String payeeTypeCd;
	private Integer payeeCd;
	private String applyTo;
	private BigDecimal vatAmt;
	private BigDecimal vatRate;
	private BigDecimal baseAmt;
	private String withVat;
	private String paytPayeeTypeCd;
	private Integer paytPayeeCd;
	private String netTag;
	private String lessDed;
	private String lessDep;
	 
	// attributes that are not in the table
	private String dspCompany;
	private String dspPartLabor;
	/**
	 * @return the evalId
	 */
	public Integer getEvalId() {
		return evalId;
	}
	/**
	 * @param evalId the evalId to set
	 */
	public void setEvalId(Integer evalId) {
		this.evalId = evalId;
	}
	/**
	 * @return the payeeTypeCd
	 */
	public String getPayeeTypeCd() {
		return payeeTypeCd;
	}
	/**
	 * @param payeeTypeCd the payeeTypeCd to set
	 */
	public void setPayeeTypeCd(String payeeTypeCd) {
		this.payeeTypeCd = payeeTypeCd;
	}
	/**
	 * @return the payeeCd
	 */
	public Integer getPayeeCd() {
		return payeeCd;
	}
	/**
	 * @param payeeCd the payeeCd to set
	 */
	public void setPayeeCd(Integer payeeCd) {
		this.payeeCd = payeeCd;
	}
	/**
	 * @return the applyTo
	 */
	public String getApplyTo() {
		return applyTo;
	}
	/**
	 * @param applyTo the applyTo to set
	 */
	public void setApplyTo(String applyTo) {
		this.applyTo = applyTo;
	}
	/**
	 * @return the vatAmt
	 */
	public BigDecimal getVatAmt() {
		return vatAmt;
	}
	/**
	 * @param vatAmt the vatAmt to set
	 */
	public void setVatAmt(BigDecimal vatAmt) {
		this.vatAmt = vatAmt;
	}
	/**
	 * @return the vatRate
	 */
	public BigDecimal getVatRate() {
		return vatRate;
	}
	/**
	 * @param vatRate the vatRate to set
	 */
	public void setVatRate(BigDecimal vatRate) {
		this.vatRate = vatRate;
	}
	/**
	 * @return the baseAmt
	 */
	public BigDecimal getBaseAmt() {
		return baseAmt;
	}
	/**
	 * @param baseAmt the baseAmt to set
	 */
	public void setBaseAmt(BigDecimal baseAmt) {
		this.baseAmt = baseAmt;
	}
	/**
	 * @return the withVat
	 */
	public String getWithVat() {
		return withVat;
	}
	/**
	 * @param withVat the withVat to set
	 */
	public void setWithVat(String withVat) {
		this.withVat = withVat;
	}
	/**
	 * @return the paytPayeeTypeCd
	 */
	public String getPaytPayeeTypeCd() {
		return paytPayeeTypeCd;
	}
	/**
	 * @param paytPayeeTypeCd the paytPayeeTypeCd to set
	 */
	public void setPaytPayeeTypeCd(String paytPayeeTypeCd) {
		this.paytPayeeTypeCd = paytPayeeTypeCd;
	}
	/**
	 * @return the paytPayeeCd
	 */
	public Integer getPaytPayeeCd() {
		return paytPayeeCd;
	}
	/**
	 * @param paytPayeeCd the paytPayeeCd to set
	 */
	public void setPaytPayeeCd(Integer paytPayeeCd) {
		this.paytPayeeCd = paytPayeeCd;
	}
	/**
	 * @return the netTag
	 */
	public String getNetTag() {
		return netTag;
	}
	/**
	 * @param netTag the netTag to set
	 */
	public void setNetTag(String netTag) {
		this.netTag = netTag;
	}
	/**
	 * @return the lessDed
	 */
	public String getLessDed() {
		return lessDed;
	}
	/**
	 * @param lessDed the lessDed to set
	 */
	public void setLessDed(String lessDed) {
		this.lessDed = lessDed;
	}
	/**
	 * @return the lessDep
	 */
	public String getLessDep() {
		return lessDep;
	}
	/**
	 * @param lessDep the lessDep to set
	 */
	public void setLessDep(String lessDep) {
		this.lessDep = lessDep;
	}
	/**
	 * @return the dspCompany
	 */
	public String getDspCompany() {
		return dspCompany;
	}
	/**
	 * @param dspCompany the dspCompany to set
	 */
	public void setDspCompany(String dspCompany) {
		this.dspCompany = dspCompany;
	}
	/**
	 * @return the dspPartLabor
	 */
	public String getDspPartLabor() {
		return dspPartLabor;
	}
	/**
	 * @param dspPartLabor the dspPartLabor to set
	 */
	public void setDspPartLabor(String dspPartLabor) {
		this.dspPartLabor = dspPartLabor;
	}
	
	
}
