package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLLossExpDtl extends BaseEntity{
	
	private Integer claimId;
	private Integer clmLossId;
	private String lossExpCd;
	private String dspExpDesc;
	private Integer noOfUnits;
	private Integer nbtNoOfUnits;
	private BigDecimal dedBaseAmt;
	private BigDecimal dtlAmt;
	private String sublineCd;
	private String originalSw;
	private String withTax;
	private BigDecimal nbtNetAmt;
	private String lossExpType;
	private String lineCd;
	private String nbtCompSw;
	private String lossExpClass;
	
	private String dedLossExpCd;
	private BigDecimal dedRate;
	private String deductibleText;
	private String dspDedLeDesc;
	private String nbtDedType;
	private String nbtDeductibleType;
	private BigDecimal nbtMinAmt;
	private BigDecimal nbtMaxAmt;
	private String nbtRangeSw;
	private String aggregateSw;
	private String ceilingSw;
	private String strDedRate; //Kenneth : 07.10.2015 : SR 4204
	
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public Integer getClmLossId() {
		return clmLossId;
	}
	public void setClmLossId(Integer clmLossId) {
		this.clmLossId = clmLossId;
	}
	public String getLossExpCd() {
		return lossExpCd;
	}
	public void setLossExpCd(String lossExpCd) {
		this.lossExpCd = lossExpCd;
	}
	public String getDspExpDesc() {
		return dspExpDesc;
	}
	public void setDspExpDesc(String dspExpDesc) {
		this.dspExpDesc = dspExpDesc;
	}
	public Integer getNoOfUnits() {
		return noOfUnits;
	}
	public void setNoOfUnits(Integer noOfUnits) {
		this.noOfUnits = noOfUnits;
	}
	public Integer getNbtNoOfUnits() {
		return nbtNoOfUnits;
	}
	public void setNbtNoOfUnits(Integer nbtNoOfUnits) {
		this.nbtNoOfUnits = nbtNoOfUnits;
	}
	public BigDecimal getDedBaseAmt() {
		return dedBaseAmt;
	}
	public void setDedBaseAmt(BigDecimal dedBaseAmt) {
		this.dedBaseAmt = dedBaseAmt;
	}
	public BigDecimal getDtlAmt() {
		return dtlAmt;
	}
	public void setDtlAmt(BigDecimal dtlAmt) {
		this.dtlAmt = dtlAmt;
	}
	public String getSublineCd() {
		return sublineCd;
	}
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	public String getOriginalSw() {
		return originalSw;
	}
	public void setOriginalSw(String originalSw) {
		this.originalSw = originalSw;
	}
	
	public void setWithTax(String withTax) {
		this.withTax = withTax;
	}
	public String getWithTax() {
		return withTax;
	}
	public BigDecimal getNbtNetAmt() {
		return nbtNetAmt;
	}
	public void setNbtNetAmt(BigDecimal nbtNetAmt) {
		this.nbtNetAmt = nbtNetAmt;
	}
	public String getLossExpType() {
		return lossExpType;
	}
	public void setLossExpType(String lossExpType) {
		this.lossExpType = lossExpType;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getNbtCompSw() {
		return nbtCompSw;
	}
	public void setNbtCompSw(String nbtCompSw) {
		this.nbtCompSw = nbtCompSw;
	}
	public String getLossExpClass() {
		return lossExpClass;
	}
	public void setLossExpClass(String lossExpClass) {
		this.lossExpClass = lossExpClass;
	}
	public String getDedLossExpCd() {
		return dedLossExpCd;
	}
	public void setDedLossExpCd(String dedLossExpCd) {
		this.dedLossExpCd = dedLossExpCd;
	}
	public BigDecimal getDedRate() {
		return dedRate;
	}
	public void setDedRate(BigDecimal dedRate) {
		this.dedRate = dedRate;
	}
	public String getDeductibleText() {
		return deductibleText;
	}
	public void setDeductibleText(String deductibleText) {
		this.deductibleText = deductibleText;
	}
	public String getDspDedLeDesc() {
		return dspDedLeDesc;
	}
	public void setDspDedLeDesc(String dspDedLeDesc) {
		this.dspDedLeDesc = dspDedLeDesc;
	}
	public String getNbtDedType() {
		return nbtDedType;
	}
	public void setNbtDedType(String nbtDedType) {
		this.nbtDedType = nbtDedType;
	}
	public String getNbtDeductibleType() {
		return nbtDeductibleType;
	}
	public void setNbtDeductibleType(String nbtDeductibleType) {
		this.nbtDeductibleType = nbtDeductibleType;
	}
	public BigDecimal getNbtMinAmt() {
		return nbtMinAmt;
	}
	public void setNbtMinAmt(BigDecimal nbtMinAmt) {
		this.nbtMinAmt = nbtMinAmt;
	}
	public BigDecimal getNbtMaxAmt() {
		return nbtMaxAmt;
	}
	public void setNbtMaxAmt(BigDecimal nbtMaxAmt) {
		this.nbtMaxAmt = nbtMaxAmt;
	}
	public String getNbtRangeSw() {
		return nbtRangeSw;
	}
	public void setNbtRangeSw(String nbtRangeSw) {
		this.nbtRangeSw = nbtRangeSw;
	}
	public String getAggregateSw() {
		return aggregateSw;
	}
	public void setAggregateSw(String aggregateSw) {
		this.aggregateSw = aggregateSw;
	}
	public String getCeilingSw() {
		return ceilingSw;
	}
	public void setCeilingSw(String ceilingSw) {
		this.ceilingSw = ceilingSw;
	}
	public String getStrDedRate() {
		return strDedRate;
	}
	public void setStrDedRate(String strDedRate) {
		this.strDedRate = strDedRate;
	} 
	
	

}
