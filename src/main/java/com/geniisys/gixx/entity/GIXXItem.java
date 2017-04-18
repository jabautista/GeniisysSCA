package com.geniisys.gixx.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIXXItem extends BaseEntity{
	
	private Integer extractId;
	private Integer itemGrp;
	private Integer itemNo;
	private String itemTitle;
	private String itemDesc;
	private String itemDesc2;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private Integer currencyCd;
	private Float currencyRt;
	private String groupCd;
	private Date fromDate;
	private Date toDate;
	private String packLineCd;
	private String packSublineCd;
	private String discountSw;
	private Integer coverageCd;
	private String otherInfo;
	private String surchargeSw;
	private BigDecimal annualTsiAmt;
	private BigDecimal annualPremAmt;
	private String changedTag;
	private String compSw;
	private Integer mcCocPrintedCnt;
	private Date mcCocPrintedDate;
	private String prorateFlag;
	private String recFLag;
	private Integer regionCd;
	private Date revrsBndrPrintDate;
	private Float shortRtPercent;
	private Integer riskNo;
	private Integer riskItemNo;
	private Integer policyId;
	private Integer packBenCd;
	private String paytTerms;
	
	// additional
	private String currencyDesc;
	private String coverageDesc;
	private String perilViewType;
	private String itemType;
	private String packPolFlag;
	
	public Integer getExtractId() {
		return extractId;
	}
	public void setExtractId(Integer extractId) {
		this.extractId = extractId;
	}
	public Integer getItemGrp() {
		return itemGrp;
	}
	public void setItemGrp(Integer itemGrp) {
		this.itemGrp = itemGrp;
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
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public Float getCurrencyRt() {
		return currencyRt;
	}
	public void setCurrencyRt(Float currencyRt) {
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
	public Integer getCoverageCd() {
		return coverageCd;
	}
	public void setCoverageCd(Integer coverageCd) {
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
	public BigDecimal getAnnualTsiAmt() {
		return annualTsiAmt;
	}
	public void setAnnualTsiAmt(BigDecimal annualTsiAmt) {
		this.annualTsiAmt = annualTsiAmt;
	}
	public BigDecimal getAnnualPremAmt() {
		return annualPremAmt;
	}
	public void setAnnualPremAmt(BigDecimal annualPremAmt) {
		this.annualPremAmt = annualPremAmt;
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
	public Integer getMcCocPrintedCnt() {
		return mcCocPrintedCnt;
	}
	public void setMcCocPrintedCnt(Integer mcCocPrintedCnt) {
		this.mcCocPrintedCnt = mcCocPrintedCnt;
	}
	public Date getMcCocPrintedDate() {
		return mcCocPrintedDate;
	}
	public void setMcCocPrintedDate(Date mcCocPrintedDate) {
		this.mcCocPrintedDate = mcCocPrintedDate;
	}
	public String getProrateFlag() {
		return prorateFlag;
	}
	public void setProrateFlag(String prorateFlag) {
		this.prorateFlag = prorateFlag;
	}
	public String getRecFLag() {
		return recFLag;
	}
	public void setRecFLag(String recFLag) {
		this.recFLag = recFLag;
	}
	public Integer getRegionCd() {
		return regionCd;
	}
	public void setRegionCd(Integer regionCd) {
		this.regionCd = regionCd;
	}
	public Date getRevrsBndrPrintDate() {
		return revrsBndrPrintDate;
	}
	public void setRevrsBndrPrintDate(Date revrsBndrPrintDate) {
		this.revrsBndrPrintDate = revrsBndrPrintDate;
	}
	public Float getShortRtPercent() {
		return shortRtPercent;
	}
	public void setShortRtPercent(Float shortRtPercent) {
		this.shortRtPercent = shortRtPercent;
	}
	public Integer getRiskNo() {
		return riskNo;
	}
	public void setRiskNo(Integer riskNo) {
		this.riskNo = riskNo;
	}
	public Integer getRiskItemNo() {
		return riskItemNo;
	}
	public void setRiskItemNo(Integer riskItemNo) {
		this.riskItemNo = riskItemNo;
	}
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public Integer getPackBenCd() {
		return packBenCd;
	}
	public void setPackBenCd(Integer packBenCd) {
		this.packBenCd = packBenCd;
	}
	public String getPaytTerms() {
		return paytTerms;
	}
	public void setPaytTerms(String paytTerms) {
		this.paytTerms = paytTerms;
	}
	public String getCurrencyDesc() {
		return currencyDesc;
	}
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}
	public String getCoverageDesc() {
		return coverageDesc;
	}
	public void setCoverageDesc(String coverageDesc) {
		this.coverageDesc = coverageDesc;
	}
	public String getPerilViewType() {
		return perilViewType;
	}
	public void setPerilViewType(String perilViewType) {
		this.perilViewType = perilViewType;
	}
	public String getItemType() {
		return itemType;
	}
	public void setItemType(String itemType) {
		this.itemType = itemType;
	}
	public String getPackPolFlag() {
		return packPolFlag;
	}
	public void setPackPolFlag(String packPolFlag) {
		this.packPolFlag = packPolFlag;
	}
	
	

}
