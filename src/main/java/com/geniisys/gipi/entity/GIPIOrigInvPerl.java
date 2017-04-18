package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIOrigInvPerl extends BaseEntity {
	
	private Integer parId;
	private Integer itemGrp;
	private Integer perilCd;
	private String perilName;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private BigDecimal shareTsiAmt;
	private BigDecimal sharePremAmt;
	private Integer policyId;
	private BigDecimal riCommAmt;
	private BigDecimal riCommRt;
	
	public Integer getParId() {
		return parId;
	}
	public void setParId(Integer parId) {
		this.parId = parId;
	}
	public Integer getItemGrp() {
		return itemGrp;
	}
	public void setItemGrp(Integer itemGrp) {
		this.itemGrp = itemGrp;
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
	public void setShareTsiAmt(BigDecimal shareTsiAmt) {
		this.shareTsiAmt = shareTsiAmt;
	}
	public BigDecimal getShareTsiAmt() {
		return shareTsiAmt;
	}
	public void setSharePremAmt(BigDecimal sharePremAmt) {
		this.sharePremAmt = sharePremAmt;
	}
	public BigDecimal getSharePremAmt() {
		return sharePremAmt;
	}
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public BigDecimal getRiCommAmt() {
		return riCommAmt;
	}
	public void setRiCommAmt(BigDecimal riCommAmt) {
		this.riCommAmt = riCommAmt;
	}
	public BigDecimal getRiCommRt() {
		return riCommRt;
	}
	public void setRiCommRt(BigDecimal riCommRt) {
		this.riCommRt = riCommRt;
	}

}
