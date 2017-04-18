package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIOrigItmPeril extends BaseEntity{
	
	private Integer parId;
	private Integer itemNo;
	private String lineCd;
	private Integer perilCd;
	private String perilName;
	private String perilSname;
	private String recFlag;
	private Integer policyId;
	private BigDecimal premiumRate;
	private BigDecimal premiumAmount;
	private BigDecimal tsiAmount;
	private BigDecimal annPremiumAmount;
	private BigDecimal annTsiAmount;
	private BigDecimal riCommRate;
	private BigDecimal riCommAmount;
	private String compRem;
	private String discountSw;
	private String surchargeSw;
	private BigDecimal sharePremiumRate;
	private BigDecimal sharePremiumAmount;
	private BigDecimal shareTsiAmount;
	
	public Integer getParId() {
		return parId;
	}
	public void setParId(Integer parId) {
		this.parId = parId;
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
	public String getPerilSname() {
		return perilSname;
	}
	public void setPerilSname(String perilSname) {
		this.perilSname = perilSname;
	}
	public String getRecFlag() {
		return recFlag;
	}
	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public BigDecimal getPremiumRate() {
		return premiumRate;
	}
	public void setPremiumRate(BigDecimal premiumRate) {
		this.premiumRate = premiumRate;
	}
	public BigDecimal getPremiumAmount() {
		return premiumAmount;
	}
	public void setPremiumAmount(BigDecimal premiumAmount) {
		this.premiumAmount = premiumAmount;
	}
	public BigDecimal getTsiAmount() {
		return tsiAmount;
	}
	public void setTsiAmount(BigDecimal tsiAmount) {
		this.tsiAmount = tsiAmount;
	}
	public BigDecimal getAnnPremiumAmount() {
		return annPremiumAmount;
	}
	public void setAnnPremiumAmount(BigDecimal annPremiumAmount) {
		this.annPremiumAmount = annPremiumAmount;
	}
	public BigDecimal getAnnTsiAmount() {
		return annTsiAmount;
	}
	public void setAnnTsiAmount(BigDecimal annTsiAmount) {
		this.annTsiAmount = annTsiAmount;
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
	public String getDiscountSw() {
		return discountSw;
	}
	public void setDiscountSw(String discountSw) {
		this.discountSw = discountSw;
	}
	public String getSurchargeSw() {
		return surchargeSw;
	}
	public void setSurchargeSw(String surchargeSw) {
		this.surchargeSw = surchargeSw;
	}
	public void setSharePremiumRate(BigDecimal sharePremiumRate) {
		this.sharePremiumRate = sharePremiumRate;
	}
	public BigDecimal getSharePremiumRate() {
		return sharePremiumRate;
	}
	public void setSharePremiumAmount(BigDecimal sharePremiumAmount) {
		this.sharePremiumAmount = sharePremiumAmount;
	}
	public BigDecimal getSharePremiumAmount() {
		return sharePremiumAmount;
	}
	public void setShareTsiAmount(BigDecimal shareTsiAmount) {
		this.shareTsiAmount = shareTsiAmount;
	}
	public BigDecimal getShareTsiAmount() {
		return shareTsiAmount;
	}

}
