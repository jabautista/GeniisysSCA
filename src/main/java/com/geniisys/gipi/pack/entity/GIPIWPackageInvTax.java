package com.geniisys.gipi.pack.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWPackageInvTax extends BaseEntity{
	private Integer parId;
	private Integer itemGrp;
	private String lineCd;
	private BigDecimal premAmt;
	private BigDecimal taxAmt;
	private Integer premSeqNo;
	private BigDecimal otherCharges;
	private Integer takeupSeqNo;
	
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
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public BigDecimal getPremAmt() {
		return premAmt;
	}
	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}
	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}
	public Integer getPremSeqNo() {
		return premSeqNo;
	}
	public void setPremSeqNo(Integer premSeqNo) {
		this.premSeqNo = premSeqNo;
	}
	public BigDecimal getOtherCharges() {
		return otherCharges;
	}
	public void setOtherCharges(BigDecimal otherCharges) {
		this.otherCharges = otherCharges;
	}
	public Integer getTakeupSeqNo() {
		return takeupSeqNo;
	}
	public void setTakeupSeqNo(Integer takeupSeqNo) {
		this.takeupSeqNo = takeupSeqNo;
	}	
}
