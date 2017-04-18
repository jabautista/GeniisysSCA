package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

/**
 * Entity that represents clm_loss_id_type in giac_direct_claim_payts_pkg
 * MODULE:			GIACS017
 * DATE_CREATED:	09/30/2010
 * @author rencela
 */
public class GIACClaimLoss extends BaseEntity{
	
	private Integer claimLossId;
	private String payeeType;
	private String payeeDescription;
	private String payeeClassCd;
	private String payeeName;
	private Integer perilCd;
	private String perilSName;
	private BigDecimal netAmount;
	private BigDecimal paidAmount;
	private BigDecimal adviceAmount;
	
	public Integer getClaimLossId() {
		return claimLossId;
	}
	public void setClaimLossId(Integer claimLossId) {
		this.claimLossId = claimLossId;
	}
	public String getPayeeType() {
		return payeeType;
	}
	public void setPayeeType(String payeeType) {
		this.payeeType = payeeType;
	}
	public String getPayeeDescription() {
		return payeeDescription;
	}
	public void setPayeeDescription(String payeeDescription) {
		this.payeeDescription = payeeDescription;
	}
	public String getPayeeClassCd() {
		return payeeClassCd;
	}
	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
	}
	public String getPayeeName() {
		return payeeName;
	}
	public void setPayeeName(String payeeName) {
		this.payeeName = payeeName;
	}
	public Integer getPerilCd() {
		return perilCd;
	}
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	public String getPerilSName() {
		return perilSName;
	}
	public void setPerilSName(String perilSName) {
		this.perilSName = perilSName;
	}
	public BigDecimal getNetAmount() {
		return netAmount;
	}
	public void setNetAmount(BigDecimal netAmount) {
		this.netAmount = netAmount;
	}
	public BigDecimal getPaidAmount() {
		return paidAmount;
	}
	public void setPaidAmount(BigDecimal paidAmount) {
		this.paidAmount = paidAmount;
	}
	public BigDecimal getAdviceAmount() {
		return adviceAmount;
	}
	public void setAdviceAmount(BigDecimal adviceAmount) {
		this.adviceAmount = adviceAmount;
	}
	
}
