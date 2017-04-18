package com.geniisys.giex.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIEXNewGroupTax extends BaseEntity{
	
	private Integer policyId;
	private String lineCd;
	private String issCd;
	private Integer taxCd;
	private Integer taxId;
	private String taxDesc;
	private BigDecimal taxAmt;
	private BigDecimal rate;
	private BigDecimal currencyTaxAmt;
	
	private String nbtPrimarySw;
	private String perilSw;
	private String allocationTag;
	
	private String noRateTag; //added by joanne 01.17.14
	
	public GIEXNewGroupTax() {
		super();
	}

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public Integer getTaxCd() {
		return taxCd;
	}

	public void setTaxCd(Integer taxCd) {
		this.taxCd = taxCd;
	}

	public Integer getTaxId() {
		return taxId;
	}

	public void setTaxId(Integer taxId) {
		this.taxId = taxId;
	}

	public String getTaxDesc() {
		return taxDesc;
	}

	public void setTaxDesc(String taxDesc) {
		this.taxDesc = taxDesc;
	}

	public BigDecimal getTaxAmt() {
		return taxAmt;
	}

	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}

	public BigDecimal getRate() {
		return rate;
	}

	public void setRate(BigDecimal rate) {
		this.rate = rate;
	}

	public BigDecimal getCurrencyTaxAmt() {
		return currencyTaxAmt;
	}

	public void setCurrencyTaxAmt(BigDecimal currencyTaxAmt) {
		this.currencyTaxAmt = currencyTaxAmt;
	}

	public String getNbtPrimarySw() {
		return nbtPrimarySw;
	}

	public void setNbtPrimarySw(String nbtPrimarySw) {
		this.nbtPrimarySw = nbtPrimarySw;
	}

	public String getPerilSw() {
		return perilSw;
	}

	public void setPerilSw(String perilSw) {
		this.perilSw = perilSw;
	}

	public String getAllocationTag() {
		return allocationTag;
	}

	public void setAllocationTag(String allocationTag) {
		this.allocationTag = allocationTag;
	}

	public String getNoRateTag() {
		return noRateTag;
	}

	public void setNoRateTag(String noRateTag) {
		this.noRateTag = noRateTag;
	}
	
}
