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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seer.framework.util.Entity;


/**
 * The Class GIPIQuoteItem.
 */
@SuppressWarnings({ "unchecked", "rawtypes" })
public class GIPIQuoteItem extends Entity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -6157424448335155546L;

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
    
    /** The coverage desc. */
    private String coverageDesc;
    
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
    
    // used only in Controller and View -rencela
    private List<GIPIQuoteItemPerilSummary> perilList;
    private Integer recordStatus; //= 0;  default state - CREATE - remove default value 0 - nica 05.24.2011
    private GIPIQuoteItemFI gipiQuoteItemFI;
    private GIPIQuoteItemAC gipiQuoteItemAC;
    private GIPIQuoteItemMH gipiQuoteItemMH;
    private GIPIQuoteItemAV gipiQuoteItemAV;
    private GIPIQuoteItemCA gipiQuoteItemCA;
    private GIPIQuoteItemEN gipiQuoteItemEN;
    private GIPIQuoteItemMN gipiQuoteItemMN;
    private GIPIQuoteItemMC gipiQuoteItemMC;
    
	public Integer getRecordStatus(){
		return recordStatus;
	}

	public void setRecordStatus(Integer recordStatus){
		this.recordStatus = recordStatus;
	}

	public List<GIPIQuoteItemPerilSummary> getPerilList(){
		return perilList;
	}

	public void setPerilList(List<GIPIQuoteItemPerilSummary> perilList){
		this.perilList = perilList;
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
	 * Gets the coverage desc.
	 * @return the coverage desc
	 */
	public String getCoverageDesc() {
		return coverageDesc;
	}

	/**
	 * Sets the coverage desc.
	 * @param coverageDesc the new coverage desc
	 */
	public void setCoverageDesc(String coverageDesc) {
		this.coverageDesc = coverageDesc;
	}
	
    /**
     * Instantiates a new gIPI quote item.
     */
    public GIPIQuoteItem(){
    }
    
    /**
     * Instantiates a new gIPI quote item.
     * @param quoteId the quote id
     * @param itemNo the item no
     * @param itemTitle the item title
     * @param itemDesc the item desc
     * @param itemDesc2 the item desc2
     * @param currencyCd the currency cd
     * @param currencyRate the currency rate
     * @param coverageCd the coverage cd
     */
    public GIPIQuoteItem(Integer quoteId, Integer itemNo, String itemTitle, String itemDesc,
    		String itemDesc2, Integer currencyCd, BigDecimal currencyRate, Integer coverageCd)	{
    	this.quoteId = quoteId;
    	this.itemNo = itemNo;
    	this.itemTitle = itemTitle;
    	this.itemDesc = itemDesc;
    	this.itemDesc2 = itemDesc2;
    	this.currencyCd = currencyCd;
    	this.currencyRate = currencyRate;
    	this.coverageCd = coverageCd;
    }
    
    /* (non-Javadoc)
     * @see com.seer.framework.util.Entity#getId()
     */
    @Override
	public Object getId() {
    	Map<String, Integer> map = new HashMap<String, Integer>();
    	map.put("quoteId", this.quoteId);
    	map.put("itemNo", this.itemNo);
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
	 * Gets the pack line cd.
	 * @return the pack line cd
	 */
	public String getPackLineCd() {
		return packLineCd;
	}

	/**
	 * Sets the pack line cd.
	 * @param packLineCd the new pack line cd
	 */
	public void setPackLineCd(String packLineCd) {
		this.packLineCd = packLineCd;
	}

	/**
	 * Gets the pack subline cd.
	 * @return the pack subline cd
	 */
	public String getPackSublineCd() {
		return packSublineCd;
	}

	/**
	 * Sets the pack subline cd.
	 * @param packSublineCd the new pack subline cd
	 */
	public void setPackSublineCd(String packSublineCd) {
		this.packSublineCd = packSublineCd;
	}

	/**
	 * Gets the tsi amt.
	 * @return the tsi amt
	 */
	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}

	/**
	 * Sets the tsi amt.
	 * @param tsiAmt the new tsi amt
	 */
	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}

	/**
	 * Gets the prem amt.
	 * @return the prem amt
	 */
	public BigDecimal getPremAmt() {
		return premAmt;
	}

	/**
	 * Sets the prem amt.
	 * @param premAmt the new prem amt
	 */
	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}

	/**
	 * Gets the cpi rec no.
	 * @return the cpi rec no
	 */
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	/**
	 * Sets the cpi rec no.
	 * @param cpiRecNo the new cpi rec no
	 */
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	/**
	 * Gets the cpi branch cd.
	 * @return the cpi branch cd
	 */
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	/**
	 * Sets the cpi branch cd.
	 * @param cpiBranchCd the new cpi branch cd
	 */
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
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
	public void setCoverageCd(Integer coverageCd) {
		this.coverageCd = coverageCd;
	}

	/**
	 * Gets the mc motor no.
	 * @return the mc motor no
	 */
	public String getMcMotorNo() {
		return mcMotorNo;
	}

	/**
	 * Sets the mc motor no.
	 * @param mcMotorNo the new mc motor no
	 */
	public void setMcMotorNo(String mcMotorNo) {
		this.mcMotorNo = mcMotorNo;
	}

	/**
	 * Gets the mc plate no.
	 * @return the mc plate no
	 */
	public String getMcPlateNo() {
		return mcPlateNo;
	}

	/**
	 * Sets the mc plate no.
	 * @param mcPlateNo the new mc plate no
	 */
	public void setMcPlateNo(String mcPlateNo) {
		this.mcPlateNo = mcPlateNo;
	}

	/**
	 * Gets the mc serial no.
	 * @return the mc serial no
	 */
	public String getMcSerialNo() {
		return mcSerialNo;
	}

	/**
	 * Sets the mc serial no.
	 * @param mcSerialNo the new mc serial no
	 */
	public void setMcSerialNo(String mcSerialNo) {
		this.mcSerialNo = mcSerialNo;
	}

	/**
	 * Gets the date from.
	 * @return the date from
	 */
	public Date getDateFrom() {
		return dateFrom;
	}

	/**
	 * Sets the date from.
	 * @param dateFrom the new date from
	 */
	public void setDateFrom(Date dateFrom) {
		this.dateFrom = dateFrom;
	}

	/**
	 * Gets the date to.
	 * @return the date to
	 */
	public Date getDateTo() {
		return dateTo;
	}

	/**
	 * Sets the date to.
	 * @param dateTo the new date to
	 */
	public void setDateTo(Date dateTo) {
		this.dateTo = dateTo;
	}

	/**
	 * Gets the ann prem amt.
	 * @return the ann prem amt
	 */
	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}

	/**
	 * Sets the ann prem amt.
	 * @param annPremAmt the new ann prem amt
	 */
	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}

	/**
	 * Gets the ann tsi amt.
	 * @return the ann tsi amt
	 */
	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}

	/**
	 * Sets the ann tsi amt.
	 * @param annTsiAmt the new ann tsi amt
	 */
	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}

	/**
	 * Gets the changed tag.
	 * @return the changed tag
	 */
	public String getChangedTag() {
		return changedTag;
	}

	/**
	 * Sets the changed tag.
	 * @param changedTag the new changed tag
	 */
	public void setChangedTag(String changedTag) {
		this.changedTag = changedTag;
	}

	/**
	 * Gets the comp sw.
	 * @return the comp sw
	 */
	public String getCompSw() {
		return compSw;
	}

	/**
	 * Sets the comp sw.
	 * @param compSw the new comp sw
	 */
	public void setCompSw(String compSw) {
		this.compSw = compSw;
	}

	/**
	 * Gets the discount sw.
	 * @return the discount sw
	 */
	public String getDiscountSw() {
		return discountSw;
	}

	/**
	 * Sets the discount sw.
	 * @param discountSw the new discount sw
	 */
	public void setDiscountSw(String discountSw) {
		this.discountSw = discountSw;
	}

	/**
	 * Gets the group cd.
	 * @return the group cd
	 */
	public Integer getGroupCd() {
		return groupCd;
	}

	/**
	 * Sets the group cd.
	 * @param groupCd the new group cd
	 */
	public void setGroupCd(Integer groupCd) {
		this.groupCd = groupCd;
	}

	/**
	 * Gets the item desc2.
	 * @return the item desc2
	 */
	public String getItemDesc2() {
		return itemDesc2;
	}

	/**
	 * Sets the item desc2.
	 * @param itemDesc2 the new item desc2
	 */
	public void setItemDesc2(String itemDesc2) {
		this.itemDesc2 = itemDesc2;
	}

	/**
	 * Gets the item grp.
	 * @return the item grp
	 */
	public Integer getItemGrp() {
		return itemGrp;
	}

	/**
	 * Sets the item grp.
	 * @param itemGrp the new item grp
	 */
	public void setItemGrp(Integer itemGrp) {
		this.itemGrp = itemGrp;
	}

	/**
	 * Gets the other info.
	 * @return the other info
	 */
	public String getOtherInfo() {
		return otherInfo;
	}

	/**
	 * Sets the other info.
	 * @param otherInfo the new other info
	 */
	public void setOtherInfo(String otherInfo) {
		this.otherInfo = otherInfo;
	}

	/**
	 * Gets the pack ben cd.
	 * @return the pack ben cd
	 */
	public Integer getPackBenCd() {
		return packBenCd;
	}

	/**
	 * Sets the pack ben cd.
	 * @param packBenCd the new pack ben cd
	 */
	public void setPackBenCd(Integer packBenCd) {
		this.packBenCd = packBenCd;
	}

	/**
	 * Gets the prorate flag.
	 * @return the prorate flag
	 */
	public String getProrateFlag() {
		return prorateFlag;
	}

	/**
	 * Sets the prorate flag.
	 * @param prorateFlag the new prorate flag
	 */
	public void setProrateFlag(String prorateFlag) {
		this.prorateFlag = prorateFlag;
	}

	/**
	 * Gets the rec flag.
	 * @return the rec flag
	 */
	public String getRecFlag() {
		return recFlag;
	}

	/**
	 * Sets the rec flag.
	 * @param recFlag the new rec flag
	 */
	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}

	/**
	 * Gets the region cd.
	 * @return the region cd
	 */
	public Integer getRegionCd() {
		return regionCd;
	}

	/**
	 * Sets the region cd.
	 * @param regionCd the new region cd
	 */
	public void setRegionCd(Integer regionCd) {
		this.regionCd = regionCd;
	}

	/**
	 * Gets the short rt percent.
	 * @return the short rt percent
	 */
	public BigDecimal getShortRtPercent() {
		return shortRtPercent;
	}

	/**
	 * Sets the short rt percent.
	 * @param shortRtPercent the new short rt percent
	 */
	public void setShortRtPercent(BigDecimal shortRtPercent) {
		this.shortRtPercent = shortRtPercent;
	}

	/**
	 * Gets the surcharge sw.
	 * @return the surcharge sw
	 */
	public String getSurchargeSw() {
		return surchargeSw;
	}

	/**
	 * Sets the surcharge sw.
	 * @param surchargeSw the new surcharge sw
	 */
	public void setSurchargeSw(String surchargeSw) {
		this.surchargeSw = surchargeSw;
	}

	public void setGipiQuoteItemFI(GIPIQuoteItemFI gipiQuoteItemFI) {
		this.gipiQuoteItemFI = gipiQuoteItemFI;
	}

	public GIPIQuoteItemFI getGipiQuoteItemFI() {
		return gipiQuoteItemFI;
	}

	public GIPIQuoteItemAC getGipiQuoteItemAC() {
		return gipiQuoteItemAC;
	}

	public void setGipiQuoteItemAC(GIPIQuoteItemAC gipiQuoteItemAC) {
		this.gipiQuoteItemAC = gipiQuoteItemAC;
	}
	
	public void setGipiQuoteItemAV(GIPIQuoteItemAV gipiQuoteItemAV) {
		this.gipiQuoteItemAV = gipiQuoteItemAV;
	}

	public GIPIQuoteItemAV getGipiQuoteItemAV() {
		return gipiQuoteItemAV;
	}

	public void setGipiQuoteItemMH(GIPIQuoteItemMH gipiQuoteItemMH) {
		this.gipiQuoteItemMH = gipiQuoteItemMH;
	}

	public GIPIQuoteItemMH getGipiQuoteItemMH() {
		return gipiQuoteItemMH;
	}

	public void setGipiQuoteItemCA(GIPIQuoteItemCA gipiQuoteItemCA) {
		this.gipiQuoteItemCA = gipiQuoteItemCA;
	}

	public GIPIQuoteItemCA getGipiQuoteItemCA() {
		return gipiQuoteItemCA;
	}

	public GIPIQuoteItemEN getGipiQuoteItemEN() {
		return gipiQuoteItemEN;
	}

	public void setGipiQuoteItemEN(GIPIQuoteItemEN gipiQuoteItemEN) {
		this.gipiQuoteItemEN = gipiQuoteItemEN;
	}
	
	public GIPIQuoteItemMN getGipiQuoteItemMN() {
		return gipiQuoteItemMN;
	}

	public void setGipiQuoteItemMN(GIPIQuoteItemMN gipiQuoteItemMN) {
		this.gipiQuoteItemMN = gipiQuoteItemMN;
	}

	public void setGipiQuoteItemMC(GIPIQuoteItemMC gipiQuoteItemMC) {
		this.gipiQuoteItemMC = gipiQuoteItemMC;
	}

	public GIPIQuoteItemMC getGipiQuoteItemMC() {
		return gipiQuoteItemMC;
	}
}