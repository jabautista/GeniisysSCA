package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLLossExpDedDtl extends BaseEntity{
	
	private Integer claimId;
	private Integer clmLossId;
	private String lineCd;
	private String sublineCd;
	private String lossExpType;
	private String lossExpCd;
	private String dspExpDesc;
	private BigDecimal lossAmt;
	private String dedCd;
	private String dspDedDesc;
	private BigDecimal dedAmt;
	private BigDecimal dedRate;
	private String aggregateSw;
	private String ceilingSw;
	private BigDecimal minAmt;
	private BigDecimal maxAmt;
	private String rangeSw;
	
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
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getSublineCd() {
		return sublineCd;
	}
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	public String getLossExpType() {
		return lossExpType;
	}
	public void setLossExpType(String lossExpType) {
		this.lossExpType = lossExpType;
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
	public BigDecimal getLossAmt() {
		return lossAmt;
	}
	public void setLossAmt(BigDecimal lossAmt) {
		this.lossAmt = lossAmt;
	}
	public String getDedCd() {
		return dedCd;
	}
	public void setDedCd(String dedCd) {
		this.dedCd = dedCd;
	}
	public String getDspDedDesc() {
		return dspDedDesc;
	}
	public void setDspDedDesc(String dspDedDesc) {
		this.dspDedDesc = dspDedDesc;
	}
	public BigDecimal getDedAmt() {
		return dedAmt;
	}
	public void setDedAmt(BigDecimal dedAmt) {
		this.dedAmt = dedAmt;
	}
	public BigDecimal getDedRate() {
		return dedRate;
	}
	public void setDedRate(BigDecimal dedRate) {
		this.dedRate = dedRate;
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
	public BigDecimal getMinAmt() {
		return minAmt;
	}
	public void setMinAmt(BigDecimal minAmt) {
		this.minAmt = minAmt;
	}
	public BigDecimal getMaxAmt() {
		return maxAmt;
	}
	public void setMaxAmt(BigDecimal maxAmt) {
		this.maxAmt = maxAmt;
	}
	public String getRangeSw() {
		return rangeSw;
	}
	public void setRangeSw(String rangeSw) {
		this.rangeSw = rangeSw;
	}
	
}
