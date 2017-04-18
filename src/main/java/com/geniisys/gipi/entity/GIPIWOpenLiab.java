/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.List;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIWOpenLiab.
 */
public class GIPIWOpenLiab extends BaseEntity{

	/** The par id. */
	private int parId;
	
	/** The geog cd. */
	private int geogCd;
	
	/** The currency cd. */
	private int currencyCd;
	
	/** The limit of liability. */
	private BigDecimal limitOfLiability;
	
	/** The currency rate. */
	private BigDecimal currencyRate;
	
	/** The voy limit. */
	private String voyLimit;
	
	/** The rec flag. */
	private String recFlag;
	private String withInvoiceTag;
	private String lineCd;
	private List<GIPIWOpenCargo> openCargos;
	private List<GIPIWOpenPeril> openPerils;

	/**
	 * Instantiates a new gIPIW open liab.
	 */
	public GIPIWOpenLiab() {
	}

	/**
	 * Instantiates a new gIPIW open liab.
	 * 
	 * @param parId the par id
	 * @param geogCd the geog cd
	 * @param currencyCd the currency cd
	 * @param limitOfLiability the limit of liability
	 * @param currencyRate the currency rate
	 * @param voyLimit the voy limit
	 * @param recFlag the rec flag
	 */
	public GIPIWOpenLiab(int parId, int geogCd, int currencyCd,
			BigDecimal limitOfLiability, BigDecimal currencyRate,
			String voyLimit, String recFlag, String withInvoiceTag, List<GIPIWOpenCargo> openCargos,
			List<GIPIWOpenPeril> openPerils) {
		this.parId = parId;
		this.geogCd = geogCd;
		this.currencyCd = currencyCd;
		this.limitOfLiability = limitOfLiability;
		this.currencyRate = currencyRate;
		this.voyLimit = voyLimit;
		this.recFlag = recFlag;
		this.withInvoiceTag = withInvoiceTag;
		this.openCargos = openCargos;
		this.openPerils = openPerils;
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
	 * Gets the geog cd.
	 * 
	 * @return the geog cd
	 */
	public int getGeogCd() {
		return geogCd;
	}

	/**
	 * Sets the geog cd.
	 * 
	 * @param geogCd the new geog cd
	 */
	public void setGeogCd(int geogCd) {
		this.geogCd = geogCd;
	}

	/**
	 * Gets the currency cd.
	 * 
	 * @return the currency cd
	 */
	public int getCurrencyCd() {
		return currencyCd;
	}

	/**
	 * Sets the currency cd.
	 * 
	 * @param currencyCd the new currency cd
	 */
	public void setCurrencyCd(int currencyCd) {
		this.currencyCd = currencyCd;
	}

	/**
	 * Gets the limit of liability.
	 * 
	 * @return the limit of liability
	 */
	public BigDecimal getLimitOfLiability() {
		return limitOfLiability;
	}

	/**
	 * Sets the limit of liability.
	 * 
	 * @param limitOfLiability the new limit of liability
	 */
	public void setLimitOfLiability(BigDecimal limitOfLiability) {
		this.limitOfLiability = limitOfLiability;
	}

	/**
	 * Gets the currency rate.
	 * 
	 * @return the currency rate
	 */
	public BigDecimal getCurrencyRate() {
		return currencyRate;
	}

	/**
	 * Sets the currency rate.
	 * 
	 * @param currencyRate the new currency rate
	 */
	public void setCurrencyRate(BigDecimal currencyRate) {
		this.currencyRate = currencyRate;
	}

	/**
	 * Gets the voy limit.
	 * 
	 * @return the voy limit
	 */
	public String getVoyLimit() {
		return voyLimit;
	}

	/**
	 * Sets the voy limit.
	 * 
	 * @param voyLimit the new voy limit
	 */
	public void setVoyLimit(String voyLimit) {
		this.voyLimit = voyLimit;
	}

	/**
	 * Gets the rec flag.
	 * 
	 * @return the rec flag
	 */
	public String getRecFlag() {
		return recFlag;
	}

	/**
	 * Sets the rec flag.
	 * 
	 * @param recFlag the new rec flag
	 */
	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}

	public void setWithInvoiceTag(String withInvoiceTag) {
		this.withInvoiceTag = withInvoiceTag;
	}

	public String getWithInvoiceTag() {
		return withInvoiceTag;
	}

	public void setOpenCargos(List<GIPIWOpenCargo> openCargos) {
		this.openCargos = openCargos;
	}

	public List<GIPIWOpenCargo> getOpenCargos() {
		return openCargos;
	}

	public void setOpenPerils(List<GIPIWOpenPeril> openPerils) {
		this.openPerils = openPerils;
	}

	public List<GIPIWOpenPeril> getOpenPerils() {
		return openPerils;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getLineCd() {
		return lineCd;
	}
	
}
