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
 * The Class GIPIQuoteItemPeril.
 */
@SuppressWarnings({ "unchecked", "rawtypes" })
public class GIPIQuoteItemPeril extends Entity{
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -5101969462884417448L;

	/** The quote id. */
	private Integer quoteId;
	
	/** The item no. */
	private Integer itemNo;
	
	/** The peril cd. */
	private Integer perilCd;
	
	/** The prem rt. */
	private BigDecimal premRt;
	
	/** The comp rem. */
	private String compRem;
	
	/** The tsi amt. */
	private BigDecimal tsiAmt;
	
	/** The prem amt. */
	private BigDecimal premAmt;   
	
	/** The cpi rec no. */
	private Integer cpiRecNo;  
	
	/** The cpi branch cd. */
	private String cpiBranchCd;
	
	/** The ann prem amt. */
	private BigDecimal annPremAmt; 
    
    /** The ann tsi amt. */
    private BigDecimal annTsiAmt;
    
    /** The as charged sw. */
    private String asChargedSw;       
    
    /** The discount sw. */
    private String discountSw;
    
    /** The line cd. */
    private String lineCd;
    
    /** The prt flag. */
    private String prtFlag;
    
    /** The rec flag. */
    private String recFlag;
    
    /** The ri comm amt. */
    private BigDecimal riCommAmt;
    
    /** The ri comm rt. */
    private BigDecimal riCommRt;
    
    /** The surcharge sw. */
    private String surchargeSw;
    
    /** The tarf cd. */
    private String tarfCd;
    
    /** The peril type. */
    private String perilType;
    
    /** The basic peril cd. */
    private Integer basicPerilCd;
    
    private Boolean premiumAmountIsZero = false;
    private Boolean premiumRateIsZero = false;
     
	/**
	 * Gets the peril type.
	 * 
	 * @return the peril type
	 */
	public String getPerilType() {
		return perilType;
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
	 * Gets the basic peril cd.
	 * 
	 * @return the basic peril cd
	 */
	public Integer getBasicPerilCd() {
		return basicPerilCd;
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
     * Instantiates a new gIPI quote item peril.
     */
    public GIPIQuoteItemPeril(){
    }
	
    /**
     * Instantiates a new gIPI quote item peril.
     * 
     * @param quoteId the quote id
     * @param lineCd the line cd
     * @param itemNo the item no
     * @param perilCd the peril cd
     * @param premRt the prem rt
     * @param tsiAmt the tsi amt
     * @param premAmt the prem amt
     * @param remarks the remarks
     */
    public GIPIQuoteItemPeril(Integer quoteId, String lineCd, Integer itemNo, Integer perilCd,
    		BigDecimal premRt, BigDecimal tsiAmt, BigDecimal premAmt, String remarks, String tarfCd)	{
    	
    	this.quoteId = quoteId;
    	this.lineCd = lineCd;
    	this.itemNo = itemNo;
    	this.perilCd = perilCd;
    	this.premRt = premRt;
    	this.tsiAmt = tsiAmt;
    	this.premAmt = premAmt;
    	this.compRem = remarks;
    	this.tarfCd = tarfCd;
    	// tarfCd added, 12-28-2010
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
	 * 
	 * @return the quote id
	 */
	public Integer getQuoteId() {
		return quoteId;
	}

	/**
	 * Sets the quote id.
	 * 
	 * @param quoteId the new quote id
	 */
	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}

	/**
	 * Gets the item no.
	 * 
	 * @return the item no
	 */
	public Integer getItemNo() {
		return itemNo;
	}

	/**
	 * Sets the item no.
	 * 
	 * @param itemNo the new item no
	 */
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	/**
	 * Gets the peril cd.
	 * 
	 * @return the peril cd
	 */
	public Integer getPerilCd() {
		return perilCd;
	}

	/**
	 * Sets the peril cd.
	 * 
	 * @param perilCd the new peril cd
	 */
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}

	/**
	 * Gets the prem rt.
	 * 
	 * @return the prem rt
	 */
	public BigDecimal getPremRt() {
		return premRt;
	}

	/**
	 * Sets the prem rt.
	 * 
	 * @param premRt the new prem rt
	 */
	public void setPremRt(BigDecimal premRt) {
		this.premRt = premRt;
	}

	/**
	 * Gets the comp rem.
	 * 
	 * @return the comp rem
	 */
	public String getCompRem() {
		return compRem;
	}

	/**
	 * Sets the comp rem.
	 * 
	 * @param compRem the new comp rem
	 */
	public void setCompRem(String compRem) {
		this.compRem = compRem;
	}

	/**
	 * Gets the tsi amt.
	 * 
	 * @return the tsi amt
	 */
	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}

	/**
	 * Sets the tsi amt.
	 * 
	 * @param tsiAmt the new tsi amt
	 */
	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
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
	 * Gets the cpi rec no.
	 * 
	 * @return the cpi rec no
	 */
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	/**
	 * Sets the cpi rec no.
	 * 
	 * @param cpiRecNo the new cpi rec no
	 */
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	/**
	 * Gets the cpi branch cd.
	 * 
	 * @return the cpi branch cd
	 */
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	/**
	 * Sets the cpi branch cd.
	 * 
	 * @param cpiBranchCd the new cpi branch cd
	 */
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	/**
	 * Gets the ann prem amt.
	 * 
	 * @return the ann prem amt
	 */
	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}

	/**
	 * Sets the ann prem amt.
	 * 
	 * @param annPremAmt the new ann prem amt
	 */
	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}

	/**
	 * Gets the ann tsi amt.
	 * 
	 * @return the ann tsi amt
	 */
	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}

	/**
	 * Sets the ann tsi amt.
	 * 
	 * @param annTsiAmt the new ann tsi amt
	 */
	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}

	/**
	 * Gets the as charged sw.
	 * 
	 * @return the as charged sw
	 */
	public String getAsChargedSw() {
		return asChargedSw;
	}

	/**
	 * Sets the as charged sw.
	 * 
	 * @param asChargedSw the new as charged sw
	 */
	public void setAsChargedSw(String asChargedSw) {
		this.asChargedSw = asChargedSw;
	}

	/**
	 * Gets the discount sw.
	 * 
	 * @return the discount sw
	 */
	public String getDiscountSw() {
		return discountSw;
	}

	/**
	 * Sets the discount sw.
	 * 
	 * @param discountSw the new discount sw
	 */
	public void setDiscountSw(String discountSw) {
		this.discountSw = discountSw;
	}

	/**
	 * Gets the line cd.
	 * 
	 * @return the line cd
	 */
	public String getLineCd() {
		return lineCd;
	}

	/**
	 * Sets the line cd.
	 * 
	 * @param lineCd the new line cd
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	/**
	 * Gets the prt flag.
	 * 
	 * @return the prt flag
	 */
	public String getPrtFlag() {
		return prtFlag;
	}

	/**
	 * Sets the prt flag.
	 * 
	 * @param prtFlag the new prt flag
	 */
	public void setPrtFlag(String prtFlag) {
		this.prtFlag = prtFlag;
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

	/**
	 * Gets the ri comm amt.
	 * 
	 * @return the ri comm amt
	 */
	public BigDecimal getRiCommAmt() {
		return riCommAmt;
	}

	/**
	 * Sets the ri comm amt.
	 * 
	 * @param riCommAmt the new ri comm amt
	 */
	public void setRiCommAmt(BigDecimal riCommAmt) {
		this.riCommAmt = riCommAmt;
	}

	/**
	 * Gets the ri comm rt.
	 * 
	 * @return the ri comm rt
	 */
	public BigDecimal getRiCommRt() {
		return riCommRt;
	}

	/**
	 * Sets the ri comm rt.
	 * 
	 * @param riCommRt the new ri comm rt
	 */
	public void setRiCommRt(BigDecimal riCommRt) {
		this.riCommRt = riCommRt;
	}

	/**
	 * Gets the surcharge sw.
	 * 
	 * @return the surcharge sw
	 */
	public String getSurchargeSw() {
		return surchargeSw;
	}

	/**
	 * Sets the surcharge sw.
	 * 
	 * @param surchargeSw the new surcharge sw
	 */
	public void setSurchargeSw(String surchargeSw) {
		this.surchargeSw = surchargeSw;
	}

	/**
	 * Gets the tarf cd.
	 * 
	 * @return the tarf cd
	 */
	public String getTarfCd() {
		return tarfCd;
	}

	/**
	 * Sets the tarf cd.
	 * 
	 * @param tarfCd the new tarf cd
	 */
	public void setTarfCd(String tarfCd) {
		this.tarfCd = tarfCd;
	}

	/**
	 * @param premiumAmountIsZero the premiumAmountIsZero to set
	 */
	public void setPremiumAmountIsZero(Boolean premiumAmountIsZero) {
		this.premiumAmountIsZero = premiumAmountIsZero;
	}

	/**
	 * @return the premiumAmountIsZero
	 */
	public Boolean getPremiumAmountIsZero() {
		return premiumAmountIsZero;
	}

	/**
	 * @param premiumRateIsZero the premiumRateIsZero to set
	 */
	public void setPremiumRateIsZero(Boolean premiumRateIsZero) {
		this.premiumRateIsZero = premiumRateIsZero;
	}

	/**
	 * @return the premiumRateIsZero
	 */
	public Boolean getPremiumRateIsZero() {
		return premiumRateIsZero;
	}

}
