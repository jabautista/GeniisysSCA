package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWEngineeringItem extends BaseEntity{
	/** The par id. */
	private String parId;
	
	/** The item no. */
	private String itemNo;
	
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
	private int currencyCd;
	
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
	private String itmperlGroupedExists;
	
	public GIPIWEngineeringItem() {
		
	}

/*	public GIPIWEngineeringItem(final String parId, final String itemNo, final String itemTitle, 
					final String itemGrp, final String itemDesc, final String itemDesc2, final BigDecimal tsiAmt,
					final BigDecimal premAmt, final BigDecimal annPremAmt, final BigDecimal annTsiAmt, 
					final String recFlag, final int currencyCd, final BigDecimal currencyRt, final String groupCd,
					final Date fromDate, final Date toDate, final String packLineCd, final String packSublineC, 
					final String discountSw, final String coverageCd, final String otherInfo, final String surchargeSw,
					final String regionCd, final String changedTag, final String prorateFlag, final String compSw,
					final BigDecimal shortRtPercent, final String packBenCd, final String paytTerms, 
					final String riskNo, final String riskItemNo) {
		
	}
	*/
	public GIPIWEngineeringItem(final String parId, final String itemNo) {
		this.parId = parId;
		this.itemNo = itemNo;
	}
	
	public String getParId() {
		return parId;
	}

	public void setParId(String parId) {
		this.parId = parId;
	}

	public String getItemNo() {
		return itemNo;
	}

	public void setItemNo(String itemNo) {
		this.itemNo = itemNo;
	}

	public String getItemTitle() {
		return itemTitle;
	}

	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}

	public String getItemGrp() {
		return itemGrp;
	}

	public void setItemGrp(String itemGrp) {
		this.itemGrp = itemGrp;
	}

	public String getItemDesc() {
		return itemDesc;
	}

	public void setItemDesc(String itemDesc) {
		this.itemDesc = itemDesc;
	}

	public String getItemDesc2() {
		return itemDesc2;
	}

	public void setItemDesc2(String itemDesc2) {
		this.itemDesc2 = itemDesc2;
	}

	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}

	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}

	public BigDecimal getPremAmt() {
		return premAmt;
	}

	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}

	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}

	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}

	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}

	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}

	public String getRecFlag() {
		return recFlag;
	}

	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}

	public int getCurrencyCd() {
		return currencyCd;
	}

	public void setCurrencyCd(int currencyCd) {
		this.currencyCd = currencyCd;
	}

	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}

	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}

	public String getGroupCd() {
		return groupCd;
	}

	public void setGroupCd(String groupCd) {
		this.groupCd = groupCd;
	}

	public Date getFromDate() {
		return fromDate;
	}

	public void setFromDate(Date fromDate) {
		this.fromDate = fromDate;
	}

	public Date getToDate() {
		return toDate;
	}

	public void setToDate(Date toDate) {
		this.toDate = toDate;
	}

	public String getPackLineCd() {
		return packLineCd;
	}

	public void setPackLineCd(String packLineCd) {
		this.packLineCd = packLineCd;
	}

	public String getPackSublineCd() {
		return packSublineCd;
	}

	public void setPackSublineCd(String packSublineCd) {
		this.packSublineCd = packSublineCd;
	}

	public String getDiscountSw() {
		return discountSw;
	}

	public void setDiscountSw(String discountSw) {
		this.discountSw = discountSw;
	}

	public String getCoverageCd() {
		return coverageCd;
	}

	public void setCoverageCd(String coverageCd) {
		this.coverageCd = coverageCd;
	}

	public String getOtherInfo() {
		return otherInfo;
	}

	public void setOtherInfo(String otherInfo) {
		this.otherInfo = otherInfo;
	}

	public String getSurchargeSw() {
		return surchargeSw;
	}

	public void setSurchargeSw(String surchargeSw) {
		this.surchargeSw = surchargeSw;
	}

	public String getRegionCd() {
		return regionCd;
	}

	public void setRegionCd(String regionCd) {
		this.regionCd = regionCd;
	}

	public String getChangedTag() {
		return changedTag;
	}

	public void setChangedTag(String changedTag) {
		this.changedTag = changedTag;
	}

	public String getProrateFlag() {
		return prorateFlag;
	}

	public void setProrateFlag(String prorateFlag) {
		this.prorateFlag = prorateFlag;
	}

	public String getCompSw() {
		return compSw;
	}

	public void setCompSw(String compSw) {
		this.compSw = compSw;
	}

	public BigDecimal getShortRtPercent() {
		return shortRtPercent;
	}

	public void setShortRtPercent(BigDecimal shortRtPercent) {
		this.shortRtPercent = shortRtPercent;
	}

	public String getPackBenCd() {
		return packBenCd;
	}

	public void setPackBenCd(String packBenCd) {
		this.packBenCd = packBenCd;
	}

	public String getPaytTerms() {
		return paytTerms;
	}

	public void setPaytTerms(String paytTerms) {
		this.paytTerms = paytTerms;
	}

	public String getRiskNo() {
		return riskNo;
	}

	public void setRiskNo(String riskNo) {
		this.riskNo = riskNo;
	}

	public String getRiskItemNo() {
		return riskItemNo;
	}

	public void setRiskItemNo(String riskItemNo) {
		this.riskItemNo = riskItemNo;
	}

	public void setItmperlGroupedExists(String itmperlGroupedExists) {
		this.itmperlGroupedExists = itmperlGroupedExists;
	}

	public String getItmperlGroupedExists() {
		return itmperlGroupedExists;
	}

	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}

	public String getCurrencyDesc() {
		return currencyDesc;
	}

	public void setCoverageDesc(String coverageDesc) {
		this.coverageDesc = coverageDesc;
	}

	public String getCoverageDesc() {
		return coverageDesc;
	}
	
	
}
