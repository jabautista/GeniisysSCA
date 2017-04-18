package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIOrigCommInvoice extends BaseEntity {
	
	private Integer parId;
	private Integer itemGrp;
	private Integer intermediaryNo;
	private String intermediaryName;
	private Integer parentIntermediaryNo;
	private String parentIntermediaryName;
	private BigDecimal premiumAmt;
	private BigDecimal commissionAmt;
	private BigDecimal sharePercentage;
	private BigDecimal wholdingTax;
	private BigDecimal netComm;
	private BigDecimal sharePremiumAmt;
	private BigDecimal shareCommissionAmt;
	private BigDecimal shareSharePercentage;
	private BigDecimal shareWholdingTax;
	private BigDecimal shareNetComm;
	
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
	public Integer getIntermediaryNo() {
		return intermediaryNo;
	}
	public void setIntermediaryNo(Integer intermediaryNo) {
		this.intermediaryNo = intermediaryNo;
	}
	public String getIntermediaryName() {
		return intermediaryName;
	}
	public void setIntermediaryName(String intermediaryName) {
		this.intermediaryName = intermediaryName;
	}
	public Integer getParentIntermediaryNo() {
		return parentIntermediaryNo;
	}
	public void setParentIntermediaryNo(Integer parentIntermediaryNo) {
		this.parentIntermediaryNo = parentIntermediaryNo;
	}
	public String getParentIntermediaryName() {
		return parentIntermediaryName;
	}
	public void setParentIntermediaryName(String parentIntermediaryName) {
		this.parentIntermediaryName = parentIntermediaryName;
	}
	public BigDecimal getPremiumAmt() {
		return premiumAmt;
	}
	public void setPremiumAmt(BigDecimal premiumAmt) {
		this.premiumAmt = premiumAmt;
	}
	public BigDecimal getCommissionAmt() {
		return commissionAmt;
	}
	public void setCommissionAmt(BigDecimal commissionAmt) {
		this.commissionAmt = commissionAmt;
	}
	public BigDecimal getSharePercentage() {
		return sharePercentage;
	}
	public void setSharePercentage(BigDecimal sharePercentage) {
		this.sharePercentage = sharePercentage;
	}
	public BigDecimal getWholdingTax() {
		return wholdingTax;
	}
	public void setWholdingTax(BigDecimal wholdingTax) {
		this.wholdingTax = wholdingTax;
	}
	public BigDecimal getNetComm() {
		return netComm;
	}
	public void setNetComm(BigDecimal netComm) {
		this.netComm = netComm;
	}
	public BigDecimal getSharePremiumAmt() {
		return sharePremiumAmt;
	}
	public void setSharePremiumAmt(BigDecimal sharePremiumAmt) {
		this.sharePremiumAmt = sharePremiumAmt;
	}
	public BigDecimal getShareCommissionAmt() {
		return shareCommissionAmt;
	}
	public void setShareCommissionAmt(BigDecimal shareCommissionAmt) {
		this.shareCommissionAmt = shareCommissionAmt;
	}
	public BigDecimal getShareSharePercentage() {
		return shareSharePercentage;
	}
	public void setShareSharePercentage(BigDecimal shareSharePercentage) {
		this.shareSharePercentage = shareSharePercentage;
	}
	public BigDecimal getShareWholdingTax() {
		return shareWholdingTax;
	}
	public void setShareWholdingTax(BigDecimal shareWholdingTax) {
		this.shareWholdingTax = shareWholdingTax;
	}
	public BigDecimal getShareNetComm() {
		return shareNetComm;
	}
	public void setShareNetComm(BigDecimal shareNetComm) {
		this.shareNetComm = shareNetComm;
	}
	
	
}
