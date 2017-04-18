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
import java.util.List;

import com.seer.framework.util.Entity;


/**
 * The Class GIPIQuoteItemWithPeril.
 */
@SuppressWarnings("rawtypes")
public class GIPIQuoteItemWithPeril extends Entity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -8092763606687246923L;

	/** The quote id. */
	private int quoteId;
	
	/** The item no. */
	private int itemNo;
	
	/** The item title. */
	private String itemTitle;
	
	/** The item desc. */
	private String itemDesc;
	
	/** The currency cd. */
	private int currencyCd;
	
	/** The currency rate. */
	private BigDecimal currencyRate;
	
	/** The pack line cd. */
	private String packLineCd;
	
	/** The pack subline cd. */
	private String packSublineCd;
	
	/** The tsi amt. */
	private BigDecimal tsiAmt;
	
	/** The prem amt. */
	private BigDecimal premAmt;   
	
	/** The cpi rec no. */
	private Integer cpiRecNo;  
	
	/** The cpi branch cd. */
	private String cpiBranchCd;          
    
    /** The coverage cd. */
    private Integer coverageCd; 
    
    /** The mc motor no. */
    private String mcMotorNo;  
    
    /** The mc plate no. */
    private String mcPlateNo;  
    
    /** The mc serial no. */
    private String mcSerialNo;  
    
    /** The date from. */
    private Date dateFrom;        
    
    /** The date to. */
    private Date dateTo;                
    
    /** The ann prem amt. */
    private BigDecimal annPremAmt; 
    
    /** The ann tsi amt. */
    private BigDecimal annTsiAmt;    
    
    /** The changed tag. */
    private String changedTag;    
    
    /** The comp sw. */
    private String compSw;       
    
    /** The discount sw. */
    private String discountSw;     
    
    /** The group cd. */
    private Integer groupCd;               
    
    /** The item desc2. */
    private String itemDesc2;    
    
    /** The item grp. */
    private Integer itemGrp;     
    
    /** The other info. */
    private String otherInfo;    
    
    /** The pack ben cd. */
    private Integer packBenCd;    
    
    /** The prorate flag. */
    private String prorateFlag;    
    
    /** The rec flag. */
    private String recFlag;              
    
    /** The region cd. */
    private Integer regionCd;   
    
    /** The short rt percent. */
    private BigDecimal shortRtPercent; 
    
    /** The surcharge sw. */
    private String surchargeSw;
    
	/** The quote item perils. */
	private List<GIPIQuoteItemPeril> quoteItemPerils;
	
	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#getId()
	 */
	@Override
	public Object getId() {
		return null;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#setId(java.lang.Object)
	 */
	@Override
	public void setId(Object id) {
		
	}

	/**
	 * Gets the quote id.
	 * 
	 * @return the quote id
	 */
	public int getQuoteId() {
		return quoteId;
	}

	/**
	 * Sets the quote id.
	 * 
	 * @param quoteId the new quote id
	 */
	public void setQuoteId(int quoteId) {
		this.quoteId = quoteId;
	}

	/**
	 * Gets the item no.
	 * 
	 * @return the item no
	 */
	public int getItemNo() {
		return itemNo;
	}

	/**
	 * Sets the item no.
	 * 
	 * @param itemNo the new item no
	 */
	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}

	/**
	 * Gets the item title.
	 * 
	 * @return the item title
	 */
	public String getItemTitle() {
		return itemTitle;
	}

	/**
	 * Sets the item title.
	 * 
	 * @param itemTitle the new item title
	 */
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}

	/**
	 * Gets the item desc.
	 * 
	 * @return the item desc
	 */
	public String getItemDesc() {
		return itemDesc;
	}

	/**
	 * Sets the item desc.
	 * 
	 * @param itemDesc the new item desc
	 */
	public void setItemDesc(String itemDesc) {
		this.itemDesc = itemDesc;
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
	 * Gets the pack line cd.
	 * 
	 * @return the pack line cd
	 */
	public String getPackLineCd() {
		return packLineCd;
	}

	/**
	 * Sets the pack line cd.
	 * 
	 * @param packLineCd the new pack line cd
	 */
	public void setPackLineCd(String packLineCd) {
		this.packLineCd = packLineCd;
	}

	/**
	 * Gets the pack subline cd.
	 * 
	 * @return the pack subline cd
	 */
	public String getPackSublineCd() {
		return packSublineCd;
	}

	/**
	 * Sets the pack subline cd.
	 * 
	 * @param packSublineCd the new pack subline cd
	 */
	public void setPackSublineCd(String packSublineCd) {
		this.packSublineCd = packSublineCd;
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
	 * Gets the coverage cd.
	 * 
	 * @return the coverage cd
	 */
	public Integer getCoverageCd() {
		return coverageCd;
	}

	/**
	 * Sets the coverage cd.
	 * 
	 * @param coverageCd the new coverage cd
	 */
	public void setCoverageCd(Integer coverageCd) {
		this.coverageCd = coverageCd;
	}

	/**
	 * Gets the mc motor no.
	 * 
	 * @return the mc motor no
	 */
	public String getMcMotorNo() {
		return mcMotorNo;
	}

	/**
	 * Sets the mc motor no.
	 * 
	 * @param mcMotorNo the new mc motor no
	 */
	public void setMcMotorNo(String mcMotorNo) {
		this.mcMotorNo = mcMotorNo;
	}

	/**
	 * Gets the mc plate no.
	 * 
	 * @return the mc plate no
	 */
	public String getMcPlateNo() {
		return mcPlateNo;
	}

	/**
	 * Sets the mc plate no.
	 * 
	 * @param mcPlateNo the new mc plate no
	 */
	public void setMcPlateNo(String mcPlateNo) {
		this.mcPlateNo = mcPlateNo;
	}

	/**
	 * Gets the mc serial no.
	 * 
	 * @return the mc serial no
	 */
	public String getMcSerialNo() {
		return mcSerialNo;
	}

	/**
	 * Sets the mc serial no.
	 * 
	 * @param mcSerialNo the new mc serial no
	 */
	public void setMcSerialNo(String mcSerialNo) {
		this.mcSerialNo = mcSerialNo;
	}

	/**
	 * Gets the date from.
	 * 
	 * @return the date from
	 */
	public Date getDateFrom() {
		return dateFrom;
	}

	/**
	 * Sets the date from.
	 * 
	 * @param dateFrom the new date from
	 */
	public void setDateFrom(Date dateFrom) {
		this.dateFrom = dateFrom;
	}

	/**
	 * Gets the date to.
	 * 
	 * @return the date to
	 */
	public Date getDateTo() {
		return dateTo;
	}

	/**
	 * Sets the date to.
	 * 
	 * @param dateTo the new date to
	 */
	public void setDateTo(Date dateTo) {
		this.dateTo = dateTo;
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
	 * Gets the changed tag.
	 * 
	 * @return the changed tag
	 */
	public String getChangedTag() {
		return changedTag;
	}

	/**
	 * Sets the changed tag.
	 * 
	 * @param changedTag the new changed tag
	 */
	public void setChangedTag(String changedTag) {
		this.changedTag = changedTag;
	}

	/**
	 * Gets the comp sw.
	 * 
	 * @return the comp sw
	 */
	public String getCompSw() {
		return compSw;
	}

	/**
	 * Sets the comp sw.
	 * 
	 * @param compSw the new comp sw
	 */
	public void setCompSw(String compSw) {
		this.compSw = compSw;
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
	 * Gets the group cd.
	 * 
	 * @return the group cd
	 */
	public Integer getGroupCd() {
		return groupCd;
	}

	/**
	 * Sets the group cd.
	 * 
	 * @param groupCd the new group cd
	 */
	public void setGroupCd(Integer groupCd) {
		this.groupCd = groupCd;
	}

	/**
	 * Gets the item desc2.
	 * 
	 * @return the item desc2
	 */
	public String getItemDesc2() {
		return itemDesc2;
	}

	/**
	 * Sets the item desc2.
	 * 
	 * @param itemDesc2 the new item desc2
	 */
	public void setItemDesc2(String itemDesc2) {
		this.itemDesc2 = itemDesc2;
	}

	/**
	 * Gets the item grp.
	 * 
	 * @return the item grp
	 */
	public Integer getItemGrp() {
		return itemGrp;
	}

	/**
	 * Sets the item grp.
	 * 
	 * @param itemGrp the new item grp
	 */
	public void setItemGrp(Integer itemGrp) {
		this.itemGrp = itemGrp;
	}

	/**
	 * Gets the other info.
	 * 
	 * @return the other info
	 */
	public String getOtherInfo() {
		return otherInfo;
	}

	/**
	 * Sets the other info.
	 * 
	 * @param otherInfo the new other info
	 */
	public void setOtherInfo(String otherInfo) {
		this.otherInfo = otherInfo;
	}

	/**
	 * Gets the pack ben cd.
	 * 
	 * @return the pack ben cd
	 */
	public Integer getPackBenCd() {
		return packBenCd;
	}

	/**
	 * Sets the pack ben cd.
	 * 
	 * @param packBenCd the new pack ben cd
	 */
	public void setPackBenCd(Integer packBenCd) {
		this.packBenCd = packBenCd;
	}

	/**
	 * Gets the prorate flag.
	 * 
	 * @return the prorate flag
	 */
	public String getProrateFlag() {
		return prorateFlag;
	}

	/**
	 * Sets the prorate flag.
	 * 
	 * @param prorateFlag the new prorate flag
	 */
	public void setProrateFlag(String prorateFlag) {
		this.prorateFlag = prorateFlag;
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
	 * Gets the region cd.
	 * 
	 * @return the region cd
	 */
	public Integer getRegionCd() {
		return regionCd;
	}

	/**
	 * Sets the region cd.
	 * 
	 * @param regionCd the new region cd
	 */
	public void setRegionCd(Integer regionCd) {
		this.regionCd = regionCd;
	}

	/**
	 * Gets the short rt percent.
	 * 
	 * @return the short rt percent
	 */
	public BigDecimal getShortRtPercent() {
		return shortRtPercent;
	}

	/**
	 * Sets the short rt percent.
	 * 
	 * @param shortRtPercent the new short rt percent
	 */
	public void setShortRtPercent(BigDecimal shortRtPercent) {
		this.shortRtPercent = shortRtPercent;
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
	 * Gets the quote item perils.
	 * 
	 * @return the quote item perils
	 */
	public List<GIPIQuoteItemPeril> getQuoteItemPerils() {
		return quoteItemPerils;
	}

	/**
	 * Sets the quote item perils.
	 * 
	 * @param quoteItemPerils the new quote item perils
	 */
	public void setQuoteItemPerils(List<GIPIQuoteItemPeril> quoteItemPerils) {
		this.quoteItemPerils = quoteItemPerils;
	}

	/**
	 * Gets the serial version uid.
	 * 
	 * @return the serial version uid
	 */
	public static long getSerialVersionUID() {
		return serialVersionUID;
	}

	
	
}
