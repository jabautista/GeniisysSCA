package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPICoInsurer extends BaseEntity {

	private Integer parId;

	private Integer coRiCd;

	private BigDecimal coRiShrPct;

	private BigDecimal coRiPremAmt;

	private BigDecimal coRiTsiAmt;

	private Integer policyId;

	private Integer cpiRecNo;

	private String cpiBranchCd;

	private String arcExtData;
	
	private String riName;
	
	private String riSname;
	
	private String isDefault;

	public Integer getParId() {
		return parId;
	}

	public void setParId(Integer parId) {
		this.parId = parId;
	}

	public Integer getCoRiCd() {
		return coRiCd;
	}

	public void setCoRiCd(Integer coRiCd) {
		this.coRiCd = coRiCd;
	}

	public BigDecimal getCoRiShrPct() {
		return coRiShrPct;
	}

	public void setCoRiShrPct(BigDecimal coRiShrPct) {
		this.coRiShrPct = coRiShrPct;
	}

	public BigDecimal getCoRiPremAmt() {
		return coRiPremAmt;
	}

	public void setCoRiPremAmt(BigDecimal coRiPremAmt) {
		this.coRiPremAmt = coRiPremAmt;
	}

	public BigDecimal getCoRiTsiAmt() {
		return coRiTsiAmt;
	}

	public void setCoRiTsiAmt(BigDecimal coRiTsiAmt) {
		this.coRiTsiAmt = coRiTsiAmt;
	}

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
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

	public String getArcExtData() {
		return arcExtData;
	}

	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}

	public String getRiName() {
		return riName;
	}

	public void setRiName(String riName) {
		this.riName = riName;
	}

	public String getRiSname() {
		return riSname;
	}

	public void setRiSname(String riSname) {
		this.riSname = riSname;
	}

	public String getIsDefault() {
		return isDefault;
	}

	public void setIsDefault(String isDefault) {
		this.isDefault = isDefault;
	}

}
