package com.geniisys.common.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;


public class GIISTariffRatesDtl extends BaseEntity{
	
	private Integer tariffCd;
	private Integer tariffDtlCd;
	private BigDecimal fixedSI;
	private BigDecimal fixedPremium;
	private BigDecimal higherRange;
	private BigDecimal lowerRange;
	private BigDecimal siDeductible;
	private BigDecimal excessRate;
	private BigDecimal loadingRate;
	private BigDecimal discountRate;
	private BigDecimal tariffRate;
	private BigDecimal additionalPremium;
	private String remarks;
	private String remarks2;
	
	public Integer getTariffCd() {
		return tariffCd;
	}
	public void setTariffCd(Integer tariffCd) {
		this.tariffCd = tariffCd;
	}
	public Integer getTariffDtlCd() {
		return tariffDtlCd;
	}
	public void setTariffDtlCd(Integer tariffDtlCd) {
		this.tariffDtlCd = tariffDtlCd;
	}
	public BigDecimal getFixedSI() {
		return fixedSI;
	}
	public void setFixedSI(BigDecimal fixedSI) {
		this.fixedSI = fixedSI;
	}
	public BigDecimal getFixedPremium() {
		return fixedPremium;
	}
	public void setFixedPremium(BigDecimal fixedPremium) {
		this.fixedPremium = fixedPremium;
	}
	public BigDecimal getHigherRange() {
		return higherRange;
	}
	public void setHigherRange(BigDecimal higherRange) {
		this.higherRange = higherRange;
	}
	public BigDecimal getLowerRange() {
		return lowerRange;
	}
	public void setLowerRange(BigDecimal lowerRange) {
		this.lowerRange = lowerRange;
	}
	public BigDecimal getSiDeductible() {
		return siDeductible;
	}
	public void setSiDeductible(BigDecimal siDeductible) {
		this.siDeductible = siDeductible;
	}
	public BigDecimal getExcessRate() {
		return excessRate;
	}
	public void setExcessRate(BigDecimal excessRate) {
		this.excessRate = excessRate;
	}
	public BigDecimal getLoadingRate() {
		return loadingRate;
	}
	public void setLoadingRate(BigDecimal loadingRate) {
		this.loadingRate = loadingRate;
	}
	public BigDecimal getDiscountRate() {
		return discountRate;
	}
	public void setDiscountRate(BigDecimal discountRate) {
		this.discountRate = discountRate;
	}
	public BigDecimal getTariffRate() {
		return tariffRate;
	}
	public void setTariffRate(BigDecimal tariffRate) {
		this.tariffRate = tariffRate;
	}
	public BigDecimal getAdditionalPremium() {
		return additionalPremium;
	}
	public void setAdditionalPremium(BigDecimal additionalPremium) {
		this.additionalPremium = additionalPremium;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	/**
	 * @return the remarks2
	 */
	public String getRemarks2() {
		return remarks2;
	}
	/**
	 * @param remarks2 the remarks2 to set
	 */
	public void setRemarks2(String remarks2) {
		this.remarks2 = remarks2;
	}
}
