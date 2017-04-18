package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIItemPeril extends BaseEntity{

	private Integer policyId;
	private Integer itemNo;
	private String lineCd;
	private Integer perilCd;
	private String perilName;
	private BigDecimal premiumRate;
	private BigDecimal tsiAmount;
	private BigDecimal annTsiAmount;
	private BigDecimal premiumAmount;
	private BigDecimal annPremiumAmount;
	private BigDecimal riCommRate;
	private BigDecimal riCommAmount;
	private String compRem;
	private String recFlag;
	private Integer noOfDays;
	private BigDecimal baseAmount;
	private String tarfCd;
	private String discountSw;
	private String prtFlag;
	private String asChargeSw;
	private String surchargeSw;
	private String aggregateSw;
	private String bascPerlCd;
	private String perilType;
	
	public GIPIItemPeril(){
	
	}
		
	public GIPIItemPeril(Integer policyId, Integer itemNo, String lineCd,
			Integer perilCd, String perilName, BigDecimal premiumRate,
			BigDecimal tsiAmount, BigDecimal annTsiAmount,
			BigDecimal premiumAmount, BigDecimal annPremiumAmount,
			BigDecimal riCommRate, BigDecimal riCommAmount, String compRem,
			String recFlag, Integer noOfDays, BigDecimal baseAmount,
			String tarfCd, String discountSw, String prtFlag,
			String asChargeSw, String surchargeSw, String aggregateSw, String bascPerlCd, String perilType) {
		this.policyId = policyId;
		this.itemNo = itemNo;
		this.lineCd = lineCd;
		this.perilCd = perilCd;
		this.perilName = perilName;
		this.premiumRate = premiumRate;
		this.tsiAmount = tsiAmount;
		this.annTsiAmount = annTsiAmount;
		this.premiumAmount = premiumAmount;
		this.annPremiumAmount = annPremiumAmount;
		this.riCommRate = riCommRate;
		this.riCommAmount = riCommAmount;
		this.compRem = compRem;
		this.recFlag = recFlag;
		this.noOfDays = noOfDays;
		this.baseAmount = baseAmount;
		this.tarfCd = tarfCd;
		this.discountSw = discountSw;
		this.prtFlag = prtFlag;
		this.asChargeSw = asChargeSw;
		this.surchargeSw = surchargeSw;
		this.aggregateSw = aggregateSw;
		this.bascPerlCd = bascPerlCd;
		this.setPerilType(perilType);
	}
	
	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public Integer getPerilCd() {
		return perilCd;
	}

	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}

	public String getPerilName() {
		return perilName;
	}

	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}

	public BigDecimal getPremiumRate() {
		return premiumRate;
	}

	public void setPremiumRate(BigDecimal premiumRate) {
		this.premiumRate = premiumRate;
	}

	public BigDecimal getTsiAmount() {
		return tsiAmount;
	}

	public void setTsiAmount(BigDecimal tsiAmount) {
		this.tsiAmount = tsiAmount;
	}

	public BigDecimal getAnnTsiAmount() {
		return annTsiAmount;
	}

	public void setAnnTsiAmount(BigDecimal annTsiAmount) {
		this.annTsiAmount = annTsiAmount;
	}

	public BigDecimal getPremiumAmount() {
		return premiumAmount;
	}

	public void setPremiumAmount(BigDecimal premiumAmount) {
		this.premiumAmount = premiumAmount;
	}

	public BigDecimal getAnnPremiumAmount() {
		return annPremiumAmount;
	}

	public void setAnnPremiumAmount(BigDecimal annPremiumAmount) {
		this.annPremiumAmount = annPremiumAmount;
	}

	public BigDecimal getRiCommRate() {
		return riCommRate;
	}

	public void setRiCommRate(BigDecimal riCommRate) {
		this.riCommRate = riCommRate;
	}

	public BigDecimal getRiCommAmount() {
		return riCommAmount;
	}

	public void setRiCommAmount(BigDecimal riCommAmount) {
		this.riCommAmount = riCommAmount;
	}

	public String getCompRem() {
		return compRem;
	}

	public void setCompRem(String compRem) {
		this.compRem = compRem;
	}

	public String getRecFlag() {
		return recFlag;
	}

	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}

	public Integer getNoOfDays() {
		return noOfDays;
	}

	public void setNoOfDays(Integer noOfDays) {
		this.noOfDays = noOfDays;
	}

	public BigDecimal getBaseAmount() {
		return baseAmount;
	}

	public void setBaseAmount(BigDecimal baseAmount) {
		this.baseAmount = baseAmount;
	}

	public String getTarfCd() {
		return tarfCd;
	}

	public void setTarfCd(String tarfCd) {
		this.tarfCd = tarfCd;
	}

	public String getDiscountSw() {
		return discountSw;
	}

	public void setDiscountSw(String discountSw) {
		this.discountSw = discountSw;
	}

	public String getPrtFlag() {
		return prtFlag;
	}

	public void setPrtFlag(String prtFlag) {
		this.prtFlag = prtFlag;
	}

	public String getAsChargeSw() {
		return asChargeSw;
	}

	public void setAsChargeSw(String asChargeSw) {
		this.asChargeSw = asChargeSw;
	}

	public String getSurchargeSw() {
		return surchargeSw;
	}

	public void setSurchargeSw(String surchargeSw) {
		this.surchargeSw = surchargeSw;
	}

	public String getAggregateSw() {
		return aggregateSw;
	}

	public void setAggregateSw(String aggregateSw) {
		this.aggregateSw = aggregateSw;
	}

	public void setBascPerlCd(String bascPerlCd) {
		this.bascPerlCd = bascPerlCd;
	}

	public String getBascPerlCd() {
		return bascPerlCd;
	}

	public void setPerilType(String perilType) {
		this.perilType = perilType;
	}

	public String getPerilType() {
		return perilType;
	}
}
