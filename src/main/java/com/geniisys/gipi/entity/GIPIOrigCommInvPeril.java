package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIOrigCommInvPeril extends BaseEntity {
	
	private Integer parId;
	private Integer intrmdryNo;
	private Integer itemGrp;
	private Integer perilCd;
	private String perilName;
	private Integer policyId;
	private String issCd;
	private Integer premSeqNo;
	private BigDecimal premiumAmt;
	private BigDecimal commissionAmt;
	private BigDecimal commissionRt;
	private BigDecimal wholdingTax;
	private BigDecimal netCommission;
	private BigDecimal sharePremiumAmt;
	private BigDecimal shareCommissionAmt;
	private BigDecimal shareCommissionRt;
	private BigDecimal shareWholdingTax;
	private BigDecimal shareNetCommission;
	
	public Integer getParId() {
		return parId;
	}
	public void setParId(Integer parId) {
		this.parId = parId;
	}
	public Integer getIntrmdryNo() {
		return intrmdryNo;
	}
	public void setIntrmdryNo(Integer intrmdryNo) {
		this.intrmdryNo = intrmdryNo;
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
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public Integer getPremSeqNo() {
		return premSeqNo;
	}
	public void setPremSeqNo(Integer premSeqNo) {
		this.premSeqNo = premSeqNo;
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
	public BigDecimal getCommissionRt() {
		return commissionRt;
	}
	public void setCommissionRt(BigDecimal commissionRt) {
		this.commissionRt = commissionRt;
	}
	public BigDecimal getWholdingTax() {
		return wholdingTax;
	}
	public void setWholdingTax(BigDecimal wholdingTax) {
		this.wholdingTax = wholdingTax;
	}
	public void setNetCommission(BigDecimal netCommission) {
		this.netCommission = netCommission;
	}
	public BigDecimal getNetCommission() {
		return netCommission;
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
	public BigDecimal getShareCommissionRt() {
		return shareCommissionRt;
	}
	public void setShareCommissionRt(BigDecimal shareCommissionRt) {
		this.shareCommissionRt = shareCommissionRt;
	}
	public BigDecimal getShareWholdingTax() {
		return shareWholdingTax;
	}
	public void setShareWholdingTax(BigDecimal shareWholdingTax) {
		this.shareWholdingTax = shareWholdingTax;
	}
	public void setShareNetCommission(BigDecimal shareNetCommission) {
		this.shareNetCommission = shareNetCommission;
	}
	public BigDecimal getShareNetCommission() {
		return shareNetCommission;
	}

}
