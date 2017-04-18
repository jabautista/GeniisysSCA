package com.geniisys.common.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;

public class GIISLossExp extends BaseEntity{
	
	private String lineCd;
	private String menuLineCd;
	private String lossExpCd;
	private String lossExpDesc;
	private String lossExpType;
	private String lossExpTypeSp;
	private String oldLossExpType;
	private String remarks;
	private String sublineCd;
	private String compSw;
	private BigDecimal deductibleRate;
	private String partSw;
	private Integer perilCd;
	private String perilName;
	private String lpsSw;
	private BigDecimal sumDedAmt;
	
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getMenuLineCd() {
		return menuLineCd;
	}
	public void setMenuLineCd(String menuLineCd) {
		this.menuLineCd = menuLineCd;
	}
	public String getLossExpCd() {
		return lossExpCd;
	}
	public void setLossExpCd(String lossExpCd) {
		this.lossExpCd = lossExpCd;
	}
	public String getLossExpDesc() {
		return lossExpDesc;
	}
	public void setLossExpDesc(String lossExpDesc) {
		this.lossExpDesc = lossExpDesc;
	}
	public String getLossExpType() {
		return lossExpType;
	}
	public void setLossExpType(String lossExpType) {
		this.lossExpType = lossExpType;
	}
	public String getLossExpTypeSp() {
		return lossExpTypeSp;
	}
	public void setLossExpTypeSp(String lossExpTypeSp) {
		this.lossExpTypeSp = lossExpTypeSp;
	}
	public String getOldLossExpType() {
		return oldLossExpType;
	}
	public void setOldLossExpType(String oldLossExpType) {
		this.oldLossExpType = oldLossExpType;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getSublineCd() {
		return sublineCd;
	}
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	public String getCompSw() {
		return compSw;
	}
	public void setCompSw(String compSw) {
		this.compSw = compSw;
	}
	public BigDecimal getDeductibleRate() {
		return deductibleRate;
	}
	public void setDeductibleRate(BigDecimal deductibleRate) {
		this.deductibleRate = deductibleRate;
	}
	public String getPartSw() {
		return partSw;
	}
	public void setPartSw(String partSw) {
		this.partSw = partSw;
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
	public String getLpsSw() {
		return lpsSw;
	}
	public void setLpsSw(String lpsSw) {
		this.lpsSw = lpsSw;
	}
	public BigDecimal getSumDedAmt() {
		return sumDedAmt;
	}
	public void setSumDedAmt(BigDecimal sumDedAmt) {
		this.sumDedAmt = sumDedAmt;
	}
	
}
