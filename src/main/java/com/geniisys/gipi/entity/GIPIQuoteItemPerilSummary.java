/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import com.seer.framework.util.Entity;

/**
 * The Class GIPIQuoteItemPerilSummary.
 */
@SuppressWarnings({ "unchecked", "rawtypes" })
public class GIPIQuoteItemPerilSummary extends Entity{

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -7761410812356209651L;

	/** The quote id. */
	private Integer quoteId;
	
	/** The item no. */
	private Integer itemNo;	
	
	/** The item title. */
	private String itemTitle;
	
	/** The item desc. */
	private String itemDesc;
	
	/** The currency cd. */
	private Integer currencyCd;
	
	/** The currency desc. */
	private String currencyDesc;
	
	/** The currency rate. */
	private BigDecimal currencyRate;
	
	/** The coverage cd. */
	private Integer coverageCd;
	
	/** The coverage desc. */
	private String coverageDesc;
	
	/** The peril cd. */
	private Integer perilCd;
	
	/** The peril name. */
	private String perilName;
	
	/** The peril type. */
	private String perilType;
	
	/** The basic peril cd. */
	private Integer basicPerilCd;
	
	/** The prem rt. */
	private BigDecimal premiumRate;	
	
	/**
	 * 'Synonym' of peril rate: this value is defined as premium 
	 * rate in database but is displayed as perilRate in forms interface
	 * the setters of perilRate and premiumRate will save to both variables
	 * */
	private BigDecimal perilRate;
	
	/** The tsi amt. */
	private BigDecimal tsiAmount;
	
	/** The prem amt. */
	private BigDecimal premiumAmount;
	
	/** The ann prem amt. */
	private BigDecimal annPremAmt;
	
	/** The comp rem. */
	private String compRem;
	
	/** Warranties and Clauses Switch */
	private String wcSw; //added by D.Alcantara, used to identify if a peril in LOV has an attached warranty
	
	/**
	 * Condition variable: Check if will Warranties and clauses will be attached
	 */
	private Boolean attachWc;
	
	private String lineCd;
	
	/**
	 * Instantiates a new gIPI quote item peril summary.
	 */
	public GIPIQuoteItemPerilSummary(){
    }
	
	/**
	 * Create a gipiQuoteItemPeril version of this object
	 * @return gipiQuoteItemPeril
	 */
	public GIPIQuoteItemPeril toGipiItemPeril(){
		GIPIQuoteItemPeril itemPeril = new GIPIQuoteItemPeril();
		itemPeril.setAnnPremAmt(this.annPremAmt);
		itemPeril.setBasicPerilCd(this.basicPerilCd);
		itemPeril.setCompRem(this.compRem);
//		this.coverageCd;
		//this.coverageDesc;
//		itemPeril.setAnnPremAmt(annPremAmt)itemPeril.set this.currencyCd;
//		itemPeril.set this.currencyDesc;
//		itemPeril.set currencyRate;
//		this.itemDesc;
		itemPeril.setItemNo(this.itemNo);
//		this.itemTitle;
		itemPeril.setPerilCd(this.perilCd);
//		itemPeril.setpe this.perilName;
		itemPeril.setPremRt(this.perilRate); // same as perilRate
		itemPeril.setPremAmt(this.premiumAmount);
		itemPeril.setPerilType(this.perilType);
		itemPeril.setPremRt(this.premiumRate);
		itemPeril.setQuoteId(this.quoteId);
		itemPeril.setTsiAmt(this.tsiAmount);
		itemPeril.setLineCd(this.lineCd);
//		itemPeril.;
		
		return itemPeril;
	}
	
	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#getId()
	 */
	@Override
	public Object getId() {
		Map<String, Integer> map = new HashMap<String, Integer>();
    	map.put("quoteId", this.quoteId);
    	map.put("itemNo", this.itemNo);
    	map.put("perilCd", this.perilCd);
		return map;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#setId(java.lang.Object)
	 */
	@Override
	public void setId(Object id) {
		Map<String, Integer> map = (Map<String, Integer>) id;
		this.quoteId = map.get("quoteId");
		this.itemNo = map.get("itemNo");
		this.perilCd = map.get("perilCd");
	}

	/**
	 * Gets the quote id.
	 * @return the quote id
	 */
	public Integer getQuoteId() {
		return quoteId;
	}

	/**
	 * Sets the quote id.
	 * @param quoteId the new quote id
	 */
	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}

	/**
	 * Gets the item no.
	 * @return the item no
	 */
	public Integer getItemNo() {
		return itemNo;
	}

	/**
	 * Sets the item no.
	 * @param itemNo the new item no
	 */
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	/**
	 * Gets the item title.
	 * @return the item title
	 */
	public String getItemTitle() {
		return itemTitle;
	}

	/**
	 * Sets the item title.
	 * @param itemTitle the new item title
	 */
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}

	/**
	 * Gets the item desc.
	 * @return the item desc
	 */
	public String getItemDesc() {
		return itemDesc;
	}

	/**
	 * Sets the item desc.
	 * @param itemDesc the new item desc
	 */
	public void setItemDesc(String itemDesc) {
		this.itemDesc = itemDesc;
	}

	/**
	 * Gets the currency cd.
	 * @return the currency cd
	 */
	public Integer getCurrencyCd() {
		return currencyCd;
	}

	/**
	 * Sets the currency cd.
	 * @param currencyCd the new currency cd
	 */
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}

	/**
	 * Gets the currency desc.
	 * @return the currency desc
	 */
	public String getCurrencyDesc() {
		return currencyDesc;
	}

	/**
	 * Sets the currency desc.
	 * @param currencyDesc the new currency desc
	 */
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}

	/**
	 * Gets the currency rate.
	 * @return the currency rate
	 */
	public BigDecimal getCurrencyRate() {
		return currencyRate;
	}

	/**
	 * Sets the currency rate.
	 * @param currencyRate the new currency rate
	 */
	public void setCurrencyRate(BigDecimal currencyRate) {
		this.currencyRate = currencyRate;
	}

	/**
	 * Gets the coverage cd.
	 * @return the coverage cd
	 */
	public Integer getCoverageCd() {
		return coverageCd;
	}

	/**
	 * Sets the coverage cd.
	 * @param coverageCd the new coverage cd
	 */
	public void setCoverageCd(Integer coverageCd){
		this.coverageCd = coverageCd;
	}

	/**
	 * Gets the coverage desc.
	 * @return the coverage desc
	 */
	public String getCoverageDesc(){
		return coverageDesc;
	}

	/**
	 * Sets the coverage desc.
	 * @param coverageDesc the new coverage desc
	 */
	public void setCoverageDesc(String coverageDesc){
		this.coverageDesc = coverageDesc;
	}

	/**
	 * Gets the peril cd.
	 * @return the peril cd
	 */
	public Integer getPerilCd() {
		return perilCd;
	}

	/**
	 * Sets the peril cd.
	 * @param perilCd the new peril cd
	 */
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}

	/**
	 * Gets the peril name.
	 * 
	 * @return the peril name
	 */
	public String getPerilName() {
		return perilName;
	}

	/**
	 * Sets the peril name.
	 * @param perilName the new peril name
	 */
	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}

	/**
	 * Gets the prem rt.
	 * @return the prem rt
	 */
	public BigDecimal getPremiumRate() {
		return premiumRate;
	}

	/**
	 * Sets the prem rt.
	 * @param premiumRate the new prem rt
	 */
	public void setPremiumRate(BigDecimal premiumRate) {
		this.premiumRate = premiumRate;
		this.perilRate = premiumRate;
	}

	/**
	 * Gets the tsi amt.
	 * @return the tsi amt
	 */
	public BigDecimal getTsiAmount() {
		return tsiAmount;
	}

	/**
	 * Sets the tsi amt.
	 * @param tsiAmt the new tsi amt
	 */
	public void setTsiAmount(BigDecimal tsiAmount) {
		this.tsiAmount = tsiAmount;
	}

	/**
	 * Gets the prem amt.
	 * @return the prem amt
	 */
	public BigDecimal getPremiumAmount() {
		return premiumAmount;
	}

	/**
	 * Sets the prem amt.
	 * @param premAmt the new prem amt
	 */
	public void setPremiumAmount(BigDecimal premiumAmount) {
		this.premiumAmount = premiumAmount;
	}

	/**
	 * Gets the comp rem.
	 * @return the comp rem
	 */
	public String getCompRem() {
		return compRem;
	}

	/**
	 * Sets the comp rem.
	 * @param compRem the new comp rem
	 */
	public void setCompRem(String compRem) {
		this.compRem = compRem;
	}

	/**
	 * Sets the peril type.
	 * 
	 * @param perilType the new peril type
	 */
	public void setPerilType(String perilType) {
		this.perilType = perilType;
	}

	/**
	 * Gets the peril type.
	 * 
	 * @return the peril type
	 */
	public String getPerilType() {
		return perilType;
	}

	/**
	 * Sets the basic peril cd.
	 * 
	 * @param basicPerilCd the new basic peril cd
	 */
	public void setBasicPerilCd(Integer basicPerilCd) {
		this.basicPerilCd = basicPerilCd;
	}

	/**
	 * Gets the basic peril cd.
	 * 
	 * @return the basic peril cd
	 */
	public Integer getBasicPerilCd() {
		return basicPerilCd;
	}
	
	/**
	 * Gets the annual premium amt.
	 * 
	 * @return the annual premium amt
	 */
	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}

	/**
	 * Sets the annual premium amt.
	 * 
	 * @param annPremAmt the new annual premium amt
	 */
	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}

	/**
	 * Alternative to getWcSw
	 * @return
	 */
	public String getWarrantiesAndClausesSwitch(){
		return this.getWcSw();
	}
	
	/**
	 * Alternative to setWcSw
	 * @param warrantiesAndClausesSwitch
	 */
	public void setWarrantiesAndClausesSwitch(String warrantiesAndClausesSwitch){
		this.setWcSw(warrantiesAndClausesSwitch);
	}
	
	/**
	 * Get Warranty and Clauses Switch
	 * @return
	 */
	public String getWcSw() {
		return wcSw;
	}

	/**
	 * Set Warranty and Clauses Switch
	 * @param wcSw
	 */
	public void setWcSw(String wcSw) {
		this.wcSw = wcSw;
	}

	/**
	 * Similar to setPremiumRate
	 * @param perilRate the perilRate to set
	 */
	public void setPerilRate(BigDecimal perilRate) {
		this.perilRate = perilRate;
		this.premiumRate = perilRate;
	}

	/**
	 * @return the perilRate
	 */
	public BigDecimal getPerilRate() {
		return perilRate;
	}

	/**
	 * @param attachWc the attachWc to set
	 */
	public void setAttachWc(Boolean attachWc) {
		this.attachWc = attachWc;
	}

	/**
	 * @return the attachWc
	 */
	public Boolean getAttachWc() {
		return attachWc;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getLineCd() {
		return lineCd;
	}
}