package com.geniisys.giri.entity;

import java.math.BigDecimal;
import com.geniisys.framework.util.BaseEntity;

public class GIRIInchargesTax extends BaseEntity {
	private Integer intreatyId;
	private String taxType;
	private Integer taxCd;
	private Integer chargeCd;
	private BigDecimal chargeAmt;
	private String slTypeCd;
	private Integer slCd;
	private BigDecimal taxPct;
	private BigDecimal taxAmt;
	
	public Integer getIntreatyId() {
		return intreatyId;
	}
	public void setIntreatyId(Integer intreatyId) {
		this.intreatyId = intreatyId;
	}
	public String getTaxType() {
		return taxType;
	}
	public void setTaxType(String taxType) {
		this.taxType = taxType;
	}
	public Integer getTaxCd() {
		return taxCd;
	}
	public void setTaxCd(Integer taxCd) {
		this.taxCd = taxCd;
	}
	public Integer getChargeCd() {
		return chargeCd;
	}
	public void setChargeCd(Integer chargeCd) {
		this.chargeCd = chargeCd;
	}
	public BigDecimal getChargeAmt() {
		return chargeAmt;
	}
	public void setChargeAmt(BigDecimal chargeAmt) {
		this.chargeAmt = chargeAmt;
	}
	public String getSlTypeCd() {
		return slTypeCd;
	}
	public void setSlTypeCd(String slTypeCd) {
		this.slTypeCd = slTypeCd;
	}
	public Integer getSlCd() {
		return slCd;
	}
	public void setSlCd(Integer slCd) {
		this.slCd = slCd;
	}
	public BigDecimal getTaxPct() {
		return taxPct;
	}
	public void setTaxPct(BigDecimal taxPct) {
		this.taxPct = taxPct;
	}
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}
	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}
	
}
