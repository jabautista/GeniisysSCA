package com.geniisys.quote.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIQuoteItem extends BaseEntity{
	
	private Integer quoteId;
	private Integer itemNo;
	private String itemTitle;
	private String itemDesc;
	private Integer currencyCd;
	private BigDecimal currencyRate;
	private String packLineCd;
	private String packSublineCd;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private Integer coverageCd;
	private String mcMotorNo;
	private String mcPlateNo;
	private String mcSerialNo;
	private Date dateFrom;
	private Date dateTo;
	private BigDecimal annPremAmt;
	private BigDecimal annTsiAmt;
	private String changedTag;
	private String compSw;
	private String discountSw;
	private Integer groupCd;
	private String itemDesc2;
	private Integer itemGrp;
	private String otherInfo;
	private Integer packBenCd;
	private String prorateFlag;
	private String recFlag;
	private Integer regionCd;
	private BigDecimal shortRtPercent;
	private String surchargeSw;
	
	private String coverageDesc;
	private String currencyDesc;
	
	private GIPIQuoteAVItem gipiQuoteAVItem;
	private GIPIQuoteCAItem gipiQuoteCAItem;
	private GIPIQuoteENItem gipiQuoteENItem;
	private GIPIQuoteACItem gipiQuoteACItem;
	private GIPIQuoteFIItem gipiQuoteFIItem;
	private GIPIQuoteMHItem gipiQuoteMHItem;
	private GIPIQuoteItemMC gipiQuoteItemMC;
	private GIPIQuoteCargo gipiQuoteCargo;
	
	public GIPIQuoteItem() {
		super();
	}

	public Integer getQuoteId() {
		return quoteId;
	}

	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	public String getItemTitle() {
		return itemTitle;
	}

	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}

	public String getItemDesc() {
		return itemDesc;
	}

	public void setItemDesc(String itemDesc) {
		this.itemDesc = itemDesc;
	}

	public Integer getCurrencyCd() {
		return currencyCd;
	}

	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}

	public BigDecimal getCurrencyRate() {
		return currencyRate;
	}

	public void setCurrencyRate(BigDecimal currencyRate) {
		this.currencyRate = currencyRate;
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

	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	public Integer getCoverageCd() {
		return coverageCd;
	}

	public void setCoverageCd(Integer coverageCd) {
		this.coverageCd = coverageCd;
	}

	public String getMcMotorNo() {
		return mcMotorNo;
	}

	public void setMcMotorNo(String mcMotorNo) {
		this.mcMotorNo = mcMotorNo;
	}

	public String getMcPlateNo() {
		return mcPlateNo;
	}

	public void setMcPlateNo(String mcPlateNo) {
		this.mcPlateNo = mcPlateNo;
	}

	public String getMcSerialNo() {
		return mcSerialNo;
	}

	public void setMcSerialNo(String mcSerialNo) {
		this.mcSerialNo = mcSerialNo;
	}

	public Date getDateFrom() {
		return dateFrom;
	}

	public void setDateFrom(Date dateFrom) {
		this.dateFrom = dateFrom;
	}
	
	public Object getStrDateFrom(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (dateFrom != null) {
			return df.format(dateFrom);
		} else {
			return null;
		}
	}

	public Date getDateTo() {
		return dateTo;
	}

	public void setDateTo(Date dateTo) {
		this.dateTo = dateTo;
	}
	
	public Object getStrDateTo(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (dateTo != null) {
			return df.format(dateTo);
		} else {
			return null;
		}
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

	public String getChangedTag() {
		return changedTag;
	}

	public void setChangedTag(String changedTag) {
		this.changedTag = changedTag;
	}

	public String getCompSw() {
		return compSw;
	}

	public void setCompSw(String compSw) {
		this.compSw = compSw;
	}

	public String getDiscountSw() {
		return discountSw;
	}

	public void setDiscountSw(String discountSw) {
		this.discountSw = discountSw;
	}

	public Integer getGroupCd() {
		return groupCd;
	}

	public void setGroupCd(Integer groupCd) {
		this.groupCd = groupCd;
	}

	public String getItemDesc2() {
		return itemDesc2;
	}

	public void setItemDesc2(String itemDesc2) {
		this.itemDesc2 = itemDesc2;
	}

	public Integer getItemGrp() {
		return itemGrp;
	}

	public void setItemGrp(Integer itemGrp) {
		this.itemGrp = itemGrp;
	}

	public String getOtherInfo() {
		return otherInfo;
	}

	public void setOtherInfo(String otherInfo) {
		this.otherInfo = otherInfo;
	}

	public Integer getPackBenCd() {
		return packBenCd;
	}

	public void setPackBenCd(Integer packBenCd) {
		this.packBenCd = packBenCd;
	}

	public String getProrateFlag() {
		return prorateFlag;
	}

	public void setProrateFlag(String prorateFlag) {
		this.prorateFlag = prorateFlag;
	}

	public String getRecFlag() {
		return recFlag;
	}

	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}

	public Integer getRegionCd() {
		return regionCd;
	}

	public void setRegionCd(Integer regionCd) {
		this.regionCd = regionCd;
	}

	public BigDecimal getShortRtPercent() {
		return shortRtPercent;
	}

	public void setShortRtPercent(BigDecimal shortRtPercent) {
		this.shortRtPercent = shortRtPercent;
	}

	public String getSurchargeSw() {
		return surchargeSw;
	}

	public void setSurchargeSw(String surchargeSw) {
		this.surchargeSw = surchargeSw;
	}

	public String getCoverageDesc() {
		return coverageDesc;
	}

	public void setCoverageDesc(String coverageDesc) {
		this.coverageDesc = coverageDesc;
	}

	public String getCurrencyDesc() {
		return currencyDesc;
	}

	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}

	public GIPIQuoteAVItem getGipiQuoteAVItem() {
		return gipiQuoteAVItem;
	}

	public void setGipiQuoteAVItem(GIPIQuoteAVItem gipiQuoteAVItem) {
		this.gipiQuoteAVItem = gipiQuoteAVItem;
	}

	public GIPIQuoteCAItem getGipiQuoteCAItem() {
		return gipiQuoteCAItem;
	}

	public void setGipiQuoteCAItem(GIPIQuoteCAItem gipiQuoteCAItem) {
		this.gipiQuoteCAItem = gipiQuoteCAItem;
	}

	public GIPIQuoteENItem getGipiQuoteENItem() {
		return gipiQuoteENItem;
	}

	public void setGipiQuoteENItem(GIPIQuoteENItem gipiQuoteENItem) {
		this.gipiQuoteENItem = gipiQuoteENItem;
	}

	public GIPIQuoteACItem getGipiQuoteACItem() {
		return gipiQuoteACItem;
	}

	public void setGipiQuoteACItem(GIPIQuoteACItem gipiQuoteACItem) {
		this.gipiQuoteACItem = gipiQuoteACItem;
	}

	public GIPIQuoteFIItem getGipiQuoteFIItem() {
		return gipiQuoteFIItem;
	}

	public void setGipiQuoteFIItem(GIPIQuoteFIItem gipiQuoteFIItem) {
		this.gipiQuoteFIItem = gipiQuoteFIItem;
	}

	public GIPIQuoteMHItem getGipiQuoteMHItem() {
		return gipiQuoteMHItem;
	}

	public void setGipiQuoteMHItem(GIPIQuoteMHItem gipiQuoteMHItem) {
		this.gipiQuoteMHItem = gipiQuoteMHItem;
	}

	public GIPIQuoteItemMC getGipiQuoteItemMC() {
		return gipiQuoteItemMC;
	}

	public void setGipiQuoteItemMC(GIPIQuoteItemMC gipiQuoteItemMC) {
		this.gipiQuoteItemMC = gipiQuoteItemMC;
	}

	public GIPIQuoteCargo getGipiQuoteCargo() {
		return gipiQuoteCargo;
	}

	public void setGipiQuoteCargo(GIPIQuoteCargo gipiQuoteCargo) {
		this.gipiQuoteCargo = gipiQuoteCargo;
	}
	
}
