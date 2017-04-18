package com.geniisys.gixx.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIXXItemPeril extends BaseEntity{
	
	private Integer extractId;
	private Integer itemNo;
	private String lineCd;
	private Integer perilCd;
	private String tarfCd;
	private Float premiumRate;
	private BigDecimal tsiAmount;
	private BigDecimal premiumAmount;
	private String compRem;
	private String discountSw;
	private Float riCommRate;
	private Float riCommAmt;
	private String surchargeSw;
	private BigDecimal annTsiAmt;
	private BigDecimal annPremAmt;
	private String asChargeSw;
	private Integer parId;
	private Integer policyId;
	private String prtFlag;
	private String recFlag;
	private Integer noOfDays;
	private BigDecimal baseAmt;
	private String aggregateSw;
	
	// additional
	private String perilName;

	public Integer getExtractId() {
		return extractId;
	}

	public void setExtractId(Integer extractId) {
		this.extractId = extractId;
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

	public String getTarfCd() {
		return tarfCd;
	}

	public void setTarfCd(String tarfCd) {
		this.tarfCd = tarfCd;
	}

	public Float getPremiumRate() {
		return premiumRate;
	}

	public void setPremiumRate(Float premiumRate) {
		this.premiumRate = premiumRate;
	}

	public BigDecimal getTsiAmount() {
		return tsiAmount;
	}

	public void setTsiAmount(BigDecimal tsiAmount) {
		this.tsiAmount = tsiAmount;
	}

	public BigDecimal getPremiumAmount() {
		return premiumAmount;
	}

	public void setPremiumAmount(BigDecimal premiumAmount) {
		this.premiumAmount = premiumAmount;
	}

	public String getCompRem() {
		return compRem;
	}

	public void setCompRem(String compRem) {
		this.compRem = compRem;
	}

	public String getDiscountSw() {
		return discountSw;
	}

	public void setDiscountSw(String discountSw) {
		this.discountSw = discountSw;
	}

	public Float getRiCommRate() {
		return riCommRate;
	}

	public void setRiCommRate(Float riCommRate) {
		this.riCommRate = riCommRate;
	}

	public Float getRiCommAmt() {
		return riCommAmt;
	}

	public void setRiCommAmt(Float riCommAmt) {
		this.riCommAmt = riCommAmt;
	}

	public String getSurchargeSw() {
		return surchargeSw;
	}

	public void setSurchargeSw(String surchargeSw) {
		this.surchargeSw = surchargeSw;
	}

	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}

	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}

	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}

	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}

	public String getAsChargeSw() {
		return asChargeSw;
	}

	public void setAsChargeSw(String asChargeSw) {
		this.asChargeSw = asChargeSw;
	}

	public Integer getParId() {
		return parId;
	}

	public void setParId(Integer parId) {
		this.parId = parId;
	}

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	public String getPrtFlag() {
		return prtFlag;
	}

	public void setPrtFlag(String prtFlag) {
		this.prtFlag = prtFlag;
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

	public BigDecimal getBaseAmt() {
		return baseAmt;
	}

	public void setBaseAmt(BigDecimal baseAmt) {
		this.baseAmt = baseAmt;
	}

	public String getAggregateSw() {
		return aggregateSw;
	}

	public void setAggregateSw(String aggregateSw) {
		this.aggregateSw = aggregateSw;
	}

	public String getPerilName() {
		return perilName;
	}

	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}
	
	

}
