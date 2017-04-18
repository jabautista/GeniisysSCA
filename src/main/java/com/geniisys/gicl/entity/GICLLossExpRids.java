package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLLossExpRids extends BaseEntity {
	
	private Integer claimId;
	private Integer clmLossId;
	private Integer clmDistNo;
	private Integer distYear;
	private Integer itemNo;
	private Integer perilCd;
	private Integer payeeCd;
	private Integer grpSeqNo;
	private Integer riCd;
	private String dspRiName;
	private String lineCd;
	private Integer acctTrtyType;
	private BigDecimal shrLossExpRiPct;
	private BigDecimal shrLeRiPdAmt;
	private BigDecimal shrLeRiAdvAmt;
	private BigDecimal shrLeRiNetAmt;
	private String shareType;
	
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
	public Integer getClmDistNo() {
		return clmDistNo;
	}
	public void setClmDistNo(Integer clmDistNo) {
		this.clmDistNo = clmDistNo;
	}
	public Integer getDistYear() {
		return distYear;
	}
	public void setDistYear(Integer distYear) {
		this.distYear = distYear;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public Integer getPerilCd() {
		return perilCd;
	}
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	public Integer getPayeeCd() {
		return payeeCd;
	}
	public void setPayeeCd(Integer payeeCd) {
		this.payeeCd = payeeCd;
	}
	public Integer getGrpSeqNo() {
		return grpSeqNo;
	}
	public void setGrpSeqNo(Integer grpSeqNo) {
		this.grpSeqNo = grpSeqNo;
	}
	public Integer getRiCd() {
		return riCd;
	}
	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}
	public String getDspRiName() {
		return dspRiName;
	}
	public void setDspRiName(String dspRiName) {
		this.dspRiName = dspRiName;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public Integer getAcctTrtyType() {
		return acctTrtyType;
	}
	public void setAcctTrtyType(Integer acctTrtyType) {
		this.acctTrtyType = acctTrtyType;
	}
	public BigDecimal getShrLossExpRiPct() {
		return shrLossExpRiPct;
	}
	public void setShrLossExpRiPct(BigDecimal shrLossExpRiPct) {
		this.shrLossExpRiPct = shrLossExpRiPct;
	}
	public BigDecimal getShrLeRiPdAmt() {
		return shrLeRiPdAmt;
	}
	public void setShrLeRiPdAmt(BigDecimal shrLeRiPdAmt) {
		this.shrLeRiPdAmt = shrLeRiPdAmt;
	}
	public BigDecimal getShrLeRiAdvAmt() {
		return shrLeRiAdvAmt;
	}
	public void setShrLeRiAdvAmt(BigDecimal shrLeRiAdvAmt) {
		this.shrLeRiAdvAmt = shrLeRiAdvAmt;
	}
	public BigDecimal getShrLeRiNetAmt() {
		return shrLeRiNetAmt;
	}
	public void setShrLeRiNetAmt(BigDecimal shrLeRiNetAmt) {
		this.shrLeRiNetAmt = shrLeRiNetAmt;
	}
	public String getShareType() {
		return shareType;
	}
	public void setShareType(String shareType) {
		this.shareType = shareType;
	}
	
}
