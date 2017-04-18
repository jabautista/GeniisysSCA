package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWCargo extends BaseEntity{

	/** The par id. */
	private String parId;
	
	/** The item no. */
	private String itemNo;
	
	private String printTag;
	private String vesselCd;
	private String geogCd;
	private String cargoClassCd;
	private String voyageNo;
	private String blAwb;
	private String origin;
	private String destn;
	private Date etd;
	private Date eta;
	private String cargoType;
	private String deductText;
	private String packMethod;
	private String transhipOrigin;
	private String transhipDestination;
	private String lcNo;
	private BigDecimal invoiceValue;
	private String invCurrCd;
	private String invCurrRt;
	private String markupRate;
	private String recFlagWCargo;
	private String cpiRecNo;
	private String cpiBranchCd;
	
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
	private String perilExist;
	private String deleteWVes;
	private String itmperlGroupedExists;
	private String cargoClassDesc;
	private String cargoTypeDesc;
	
	public String getCargoClassDesc() {
		return cargoClassDesc;
	}

	public void setCargoClassDesc(String cargoClassDesc) {
		this.cargoClassDesc = cargoClassDesc;
	}

	/**
	 * @param itmperlGroupedExists the itmperlGroupedExists to set
	 */
	public void setItmperlGroupedExists(String itmperlGroupedExists) {
		this.itmperlGroupedExists = itmperlGroupedExists;
	}

	/**
	 * @return the itmperlGroupedExists
	 */
	public String getItmperlGroupedExists() {
		return itmperlGroupedExists;
	}
	
	public GIPIWCargo(){
		
	}

	public GIPIWCargo(final String parId, final String itemNo,
			final String printTag, 		   final String vesselCd, 			final String geogCd,
			final String cargoClassCd, 	   final String voyageNo, 			final String blAwb,
			final String origin, 		   final String destn,    			final Date etd, 
			final Date eta , 			   final String cargoType, 			final String deductText,
			final String packMethod, 	   final String transhipOrigin, 	final String transhipDestination,
			final String lcNo, 			   final BigDecimal invoiceValue, 	final String invCurrCd,
			final String invCurrRt,    	   final String markupRate,		    final String recFlagWCargo,
			final String cpiRecNo,		   final String cpiBranchCd,		final String deleteWVes){
		this.parId = parId;
		this.itemNo = itemNo;
		this.printTag = printTag;
		this.vesselCd = vesselCd;
		this.geogCd = geogCd;
		this.cargoClassCd = cargoClassCd;
		this.voyageNo = voyageNo;
		this.blAwb = blAwb;
		this.origin = origin;
		this.destn = destn;
		this.etd = etd;
		this.eta = eta;
		this.cargoType = cargoType;
		this.deductText = deductText;
		this.packMethod = packMethod;
		this.transhipOrigin = transhipOrigin;
		this.transhipDestination = transhipDestination;
		this.lcNo = lcNo;
		this.invoiceValue = invoiceValue;
		this.invCurrCd = invCurrCd;
		this.invCurrRt = invCurrRt;
		this.markupRate = markupRate;
		this.recFlagWCargo = recFlagWCargo;
		this.cpiRecNo = cpiRecNo;
		this.cpiBranchCd = cpiBranchCd;
		this.deleteWVes = deleteWVes;
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

	public String getPrintTag() {
		return printTag;
	}

	public void setPrintTag(String printTag) {
		this.printTag = printTag;
	}

	public String getVesselCd() {
		return vesselCd;
	}

	public void setVesselCd(String vesselCd) {
		this.vesselCd = vesselCd;
	}

	public String getGeogCd() {
		return geogCd;
	}

	public void setGeogCd(String geogCd) {
		this.geogCd = geogCd;
	}

	public String getCargoClassCd() {
		return cargoClassCd;
	}

	public void setCargoClassCd(String cargoClassCd) {
		this.cargoClassCd = cargoClassCd;
	}

	public String getVoyageNo() {
		return voyageNo;
	}

	public void setVoyageNo(String voyageNo) {
		this.voyageNo = voyageNo;
	}

	public String getBlAwb() {
		return blAwb;
	}

	public void setBlAwb(String blAwb) {
		this.blAwb = blAwb;
	}

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getDestn() {
		return destn;
	}

	public void setDestn(String destn) {
		this.destn = destn;
	}

	public Date getEtd() {
		return etd;
	}

	public void setEtd(Date etd) {
		this.etd = etd;
	}

	public Date getEta() {
		return eta;
	}

	public void setEta(Date eta) {
		this.eta = eta;
	}

	public String getCargoType() {
		return cargoType;
	}

	public void setCargoType(String cargoType) {
		this.cargoType = cargoType;
	}

	public String getDeductText() {
		return deductText;
	}

	public void setDeductText(String deductText) {
		this.deductText = deductText;
	}

	public String getPackMethod() {
		return packMethod;
	}

	public void setPackMethod(String packMethod) {
		this.packMethod = packMethod;
	}

	public String getTranshipOrigin() {
		return transhipOrigin;
	}

	public void setTranshipOrigin(String transhipOrigin) {
		this.transhipOrigin = transhipOrigin;
	}

	public String getTranshipDestination() {
		return transhipDestination;
	}

	public void setTranshipDestination(String transhipDestination) {
		this.transhipDestination = transhipDestination;
	}

	public String getLcNo() {
		return lcNo;
	}

	public void setLcNo(String lcNo) {
		this.lcNo = lcNo;
	}

	public BigDecimal getInvoiceValue() {
		return invoiceValue;
	}

	public void setInvoiceValue(BigDecimal invoiceValue) {
		this.invoiceValue = invoiceValue;
	}

	public String getInvCurrCd() {
		return invCurrCd;
	}

	public void setInvCurrCd(String invCurrCd) {
		this.invCurrCd = invCurrCd;
	}

	public String getInvCurrRt() {
		return invCurrRt;
	}

	public void setInvCurrRt(String invCurrRt) {
		this.invCurrRt = invCurrRt;
	}

	public String getMarkupRate() {
		return markupRate;
	}

	public void setMarkupRate(String markupRate) {
		this.markupRate = markupRate;
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

	public String getRecFlagWCargo() {
		return recFlagWCargo;
	}

	public void setRecFlagWCargo(String recFlagWCargo) {
		this.recFlagWCargo = recFlagWCargo;
	}

	public String getCpiRecNo() {
		return cpiRecNo;
	}

	public void setCpiRecNo(String cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	public String getPerilExist() {
		return perilExist;
	}

	public void setPerilExist(String perilExist) {
		this.perilExist = perilExist;
	}

	public String getDeleteWVes() {
		return deleteWVes;
	}

	public void setDeleteWVes(String deleteWVes) {
		this.deleteWVes = deleteWVes;
	}

	public String getCargoTypeDesc() {
		return cargoTypeDesc;
	}

	public void setCargoTypeDesc(String cargoTypeDesc) {
		this.cargoTypeDesc = cargoTypeDesc;
	}	
}
