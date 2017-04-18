/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.geniisys.framework.util.BaseEntity;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIItem.
 */
public class GIPIItem extends BaseEntity {

	/** The par id. */
	private Integer parId;
	
	private int policyId;
	
	/** The item no. */
	private int itemNo;
	
	/** The item title. */
	private String itemTitle;
	
	/** The item grp. */
	private String itemGrp;
	
	/** The item desc. */
	private String itemDesc;
	
	/** The item desc2. */
	private String itemDesc2;
	
	/** The tsi amt. */
	private BigDecimal tsiAmt;
	
	/** The prem amt. */
	private BigDecimal premAmt;
	
	/** The ann prem amt. */
	private BigDecimal annPremAmt;
	
	/** The ann tsi amt. */
	private BigDecimal annTsiAmt;
	
	/** The rec flag. */
	private String recFlag;
	
	/** The currency cd. */
	private Integer currencyCd;
	
	/** The currency rt. */
	private BigDecimal currencyRt;
	
	/** The group cd. */
	private String groupCd;
	
	/** The from date. */
	private Date fromDate;
	
	/** The to date. */
	private Date toDate;
	
	/** The pack line cd. */
	private String packLineCd;
	
	/** The pack subline cd. */
	private String packSublineCd;
	
	/** The discount sw. */
	private String discountSw;
	
	/** The coverage cd. */
	private String coverageCd;
	
	/** The other info. */
	private String otherInfo;
	
	/** The surcharge sw. */
	private String surchargeSw;
	
	/** The region cd. */
	private String regionCd;
	
	/** The changed tag. */
	private String changedTag;
	
	/** The prorate flag. */
	private String prorateFlag;
	
	/** The comp sw. */
	private String compSw;
	
	/** The short rt percent. */
	private BigDecimal shortRtPercent;
	
	/** The pack ben cd. */
	private String packBenCd;
	
	/** The payt terms. */
	private String paytTerms;
	
	/** The risk no. */
	private String riskNo;
	
	/** The risk item no. */
	private String riskItemNo;
	
	private String currencyDesc;
	private String coverageDesc;
	
	private String strFromDate;	//added by steven 9/5/2012
	private String strToDate;	//added by steven 9/5/2012
	
	private GIPICargo gipiCargo;
	private GIPICasualtyItem gipiCasualtyItem;
	private List<GIPIItemPeril> gipiItemPerils;
	private String perilViewType;
	private String packPolFlag;
	private GIPIAccidentItem gipiAccidentItem;
	private GIPIFireItem gipiFireItem;
	private GIPIVehicle gipiVehicle;
	private GIPIAviationItem gipiAviationItem;	
	private GIPIItemVes gipiItemVes;
	
	private String itemType;
	/**
	 * Instantiates a new gIPI item.
	 */
	public GIPIItem() {

	}
	
	/**
	 * Instantiates a new gIPI item.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @param itemTitle the item title
	 * @param itemGrp the item grp
	 * @param itemDesc the item desc
	 * @param itemDesc2 the item desc2
	 * @param tsiAmt the tsi amt
	 * @param premAmt the prem amt
	 * @param annPremAmt the ann prem amt
	 * @param annTsiAmt the ann tsi amt
	 * @param recFlag the rec flag
	 * @param currencyCd the currency cd
	 * @param currencyRt the currency rt
	 * @param groupCd the group cd
	 * @param fromDate the from date
	 * @param toDate the to date
	 * @param packLineCd the pack line cd
	 * @param packSublineCd the pack subline cd
	 * @param discountSw the discount sw
	 * @param coverageCd the coverage cd
	 * @param otherInfo the other info
	 * @param surchargeSw the surcharge sw
	 * @param regionCd the region cd
	 * @param changedTag the changed tag
	 * @param prorateFlag the prorate flag
	 * @param compSw the comp sw
	 * @param shortRtPercent the short rt percent
	 * @param packBenCd the pack ben cd
	 * @param paytTerms the payt terms
	 * @param riskNo the risk no
	 * @param riskItemNo the risk item no
	 */
	public GIPIItem(final int parId, final int itemNo, final String itemTitle, final String itemGrp,
			final String itemDesc, final String itemDesc2, final BigDecimal tsiAmt, 	final BigDecimal premAmt,
			final BigDecimal annPremAmt, final BigDecimal annTsiAmt, final String recFlag, final int currencyCd,
			final BigDecimal currencyRt, final String groupCd, final Date fromDate, final Date toDate,
			final String packLineCd, final String packSublineCd, final String discountSw, final String coverageCd,
			final String otherInfo, final String surchargeSw, final String regionCd, final String changedTag,
			final String prorateFlag, final String compSw, final BigDecimal shortRtPercent,	final String packBenCd,
			final String paytTerms,	final String riskNo, final String riskItemNo) {
		this.parId = parId;
		this.itemNo = itemNo;
		this.itemTitle = itemTitle;
		this.itemGrp = itemGrp;
		this.itemDesc = itemDesc;
		this.itemDesc2 = itemDesc2;
		this.tsiAmt = tsiAmt;
		this.premAmt = premAmt;
		this.annPremAmt = annPremAmt;
		this.annTsiAmt = annTsiAmt;
		this.recFlag = recFlag;
		this.currencyCd = currencyCd;
		this.currencyRt = currencyRt;
		this.groupCd = groupCd;
		this.fromDate = fromDate;
		this.toDate = toDate;
		this.packLineCd = packLineCd;
		this.packSublineCd = packSublineCd;
		this.discountSw = discountSw;
		this.coverageCd = coverageCd;
		this.otherInfo = otherInfo;
		this.surchargeSw = surchargeSw;
		this.regionCd = regionCd;
		this.changedTag = changedTag;
		this.prorateFlag = prorateFlag;
		this.compSw = compSw;
		this.shortRtPercent = shortRtPercent;
		this.packBenCd = packBenCd;
		this.paytTerms = paytTerms;
		this.riskNo = riskNo;
		this.riskItemNo = riskItemNo;
	}

	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public Integer getParId() {
		return parId;
	}

	/**
	 * Sets the par id.
	 * 
	 * @param parId the new par id
	 */
	public void setParId(Integer parId) {
		this.parId = parId;
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
	 * Gets the item grp.
	 * 
	 * @return the item grp
	 */
	public String getItemGrp() {
		return itemGrp;
	}

	/**
	 * Sets the item grp.
	 * 
	 * @param itemGrp the new item grp
	 */
	public void setItemGrp(String itemGrp) {
		this.itemGrp = itemGrp;
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
	 * Gets the currency cd.
	 * 
	 * @return the currency cd
	 */
	public Integer getCurrencyCd() {
		return currencyCd;
	}

	/**
	 * Sets the currency cd.
	 * 
	 * @param currencyCd the new currency cd
	 */
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}

	/**
	 * Gets the currency rt.
	 * 
	 * @return the currency rt
	 */
	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}

	/**
	 * Sets the currency rt.
	 * 
	 * @param currencyRt the new currency rt
	 */
	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}

	/**
	 * Gets the group cd.
	 * 
	 * @return the group cd
	 */
	public String getGroupCd() {
		return groupCd;
	}

	/**
	 * Sets the group cd.
	 * 
	 * @param groupCd the new group cd
	 */
	public void setGroupCd(String groupCd) {
		this.groupCd = groupCd;
	}

	/**
	 * Gets the from date.
	 * 
	 * @return the from date
	 */
	public Date getFromDate() {
		return fromDate;
	}

	/**
	 * Sets the from date.
	 * 
	 * @param fromDate the new from date
	 */
	public void setFromDate(Date fromDate) {
		this.fromDate = fromDate;
	}

	/**
	 * Gets the to date.
	 * 
	 * @return the to date
	 */
	public Date getToDate() {
		return toDate;
	}

	/**
	 * Sets the to date.
	 * 
	 * @param toDate the new to date
	 */
	public void setToDate(Date toDate) {
		this.toDate = toDate;
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
	 * Gets the coverage cd.
	 * 
	 * @return the coverage cd
	 */
	public String getCoverageCd() {
		return coverageCd;
	}

	/**
	 * Sets the coverage cd.
	 * 
	 * @param coverageCd the new coverage cd
	 */
	public void setCoverageCd(String coverageCd) {
		this.coverageCd = coverageCd;
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
	 * Gets the region cd.
	 * 
	 * @return the region cd
	 */
	public String getRegionCd() {
		return regionCd;
	}

	/**
	 * Sets the region cd.
	 * 
	 * @param regionCd the new region cd
	 */
	public void setRegionCd(String regionCd) {
		this.regionCd = regionCd;
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
	 * Gets the pack ben cd.
	 * 
	 * @return the pack ben cd
	 */
	public String getPackBenCd() {
		return packBenCd;
	}

	/**
	 * Sets the pack ben cd.
	 * 
	 * @param packBenCd the new pack ben cd
	 */
	public void setPackBenCd(String packBenCd) {
		this.packBenCd = packBenCd;
	}

	/**
	 * Gets the payt terms.
	 * 
	 * @return the payt terms
	 */
	public String getPaytTerms() {
		return paytTerms;
	}

	/**
	 * Sets the payt terms.
	 * 
	 * @param paytTerms the new payt terms
	 */
	public void setPaytTerms(String paytTerms) {
		this.paytTerms = paytTerms;
	}

	/**
	 * Gets the risk no.
	 * 
	 * @return the risk no
	 */
	public String getRiskNo() {
		return riskNo;
	}

	/**
	 * Sets the risk no.
	 * 
	 * @param riskNo the new risk no
	 */
	public void setRiskNo(String riskNo) {
		this.riskNo = riskNo;
	}

	/**
	 * Gets the risk item no.
	 * 
	 * @return the risk item no
	 */
	public String getRiskItemNo() {
		return riskItemNo;
	}

	/**
	 * Sets the risk item no.
	 * 
	 * @param riskItemNo the new risk item no
	 */
	public void setRiskItemNo(String riskItemNo) {
		this.riskItemNo = riskItemNo;
	}

	public void setGipiCargo(GIPICargo gipiCargo) {
		this.gipiCargo = gipiCargo;
	}

	public GIPICargo getGipiCargo() {
		return gipiCargo;
	}

	public void setPolicyId(int policyId) {
		this.policyId = policyId;
	}

	public int getPolicyId() {
		return policyId;
	}

	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}

	public String getCurrencyDesc() {
		return currencyDesc;
	}

	public GIPICasualtyItem getGipiCasualtyItem() {
		return gipiCasualtyItem; // andrew - 07162015 - SR 19819/19452
	}

	public void setGipiCasualtyItem(GIPICasualtyItem gipiCasualtyItem) {
		this.gipiCasualtyItem = gipiCasualtyItem;
	}

	public void setGipiItemPerils(List<GIPIItemPeril> gipiItemPerils) {
		this.gipiItemPerils = gipiItemPerils;
	}

	public List<GIPIItemPeril> getGipiItemPerils() {
		return gipiItemPerils;
	}

	public String getPerilViewType() {
		return perilViewType;
	}

	public void setPerilViewType(String perilViewType) {
		this.perilViewType = perilViewType;
	}

	public String getPackPolFlag() {
		return packPolFlag;
	}

	public void setPackPolFlag(String packPolFlag) {
		this.packPolFlag = packPolFlag;
	}

	public String getCoverageDesc() {
		return coverageDesc;
	}

	public void setCoverageDesc(String coverageDesc) {
		this.coverageDesc = coverageDesc;
	}

	public GIPIAccidentItem getGipiAccidentItem() {
		return (GIPIAccidentItem) StringFormatter.replaceQuotesInObject(gipiAccidentItem); //added by steven 10/17/2012
	}

	public void setGipiAccidentItem(GIPIAccidentItem gipiAccidentItem) {
		this.gipiAccidentItem = gipiAccidentItem;
	}

	public void setGipiFireItem(GIPIFireItem gipiFireItem) {
		this.gipiFireItem = gipiFireItem;
	}

	public GIPIFireItem getGipiFireItem() {
		return gipiFireItem;	// andrew - 08062015 - KB 310
	}

	public void setGipiVehicle(GIPIVehicle gipiVehicle) {
		this.gipiVehicle = gipiVehicle;
	}

	public GIPIVehicle getGipiVehicle() {
		return gipiVehicle;
	}

	public void setGipiItemVes(GIPIItemVes gipiItemVes) {
		this.gipiItemVes = gipiItemVes;
	}

	public GIPIItemVes getGipiItemVes() {
		return gipiItemVes;
	}

	public void setGipiAviationItem(GIPIAviationItem gipiAviationItem) {
		this.gipiAviationItem = gipiAviationItem;
	}

	public GIPIAviationItem getGipiAviationItem() {
		return gipiAviationItem;
	}

	public String getItemType() {
		return itemType;
	}

	public void setItemType(String itemType) {
		this.itemType = itemType;
	}
	
	/**
	 * @return the strFromDate
	 */
	public String getStrFromDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(this.fromDate != null){
			return sdf.format(fromDate);
		} else {
			return null;
		}
	}

	/**
	 * @param strFromDate the strFromDate to set
	 */
	public void setStrFromDate(String strFromDate) {
		this.strFromDate = strFromDate;
	}

	/**
	 * @return the strToDate
	 */
	public String getStrToDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(this.toDate != null){
			return sdf.format(toDate);
		} else {
			return null;
		}
	}

	/**
	 * @param strToDate the strToDate to set
	 */
	public void setStrToDate(String strToDate) {
		this.strToDate = strToDate;
	}
}
