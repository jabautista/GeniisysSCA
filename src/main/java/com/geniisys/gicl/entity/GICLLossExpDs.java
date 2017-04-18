package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLLossExpDs extends BaseEntity{
	
	private Integer claimId;
	private Integer clmLossId;
	private Integer clmDistNo;
	private Integer distYear;
	private Integer itemNo;
	private Integer perilCd;
	private Integer payeeCd;
	private Integer grpSeqNo;
	private String lineCd;
	private Integer acctTrtyType;
	private BigDecimal shrLossExpPct;
	private BigDecimal shrLePdAmt;
	private BigDecimal shrLeAdvAmt;
	private BigDecimal shrLeNetAmt;
	private String shareType;
	private String negateTag;
	private Date distributionDate;
	private Integer groupedItemNo;
	private BigDecimal xolDed;
	private String treatyName;
	
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
	public BigDecimal getShrLossExpPct() {
		return shrLossExpPct;
	}
	public void setShrLossExpPct(BigDecimal shrLossExpPct) {
		this.shrLossExpPct = shrLossExpPct;
	}
	public BigDecimal getShrLePdAmt() {
		return shrLePdAmt;
	}
	public void setShrLePdAmt(BigDecimal shrLePdAmt) {
		this.shrLePdAmt = shrLePdAmt;
	}
	public BigDecimal getShrLeAdvAmt() {
		return shrLeAdvAmt;
	}
	public void setShrLeAdvAmt(BigDecimal shrLeAdvAmt) {
		this.shrLeAdvAmt = shrLeAdvAmt;
	}
	public BigDecimal getShrLeNetAmt() {
		return shrLeNetAmt;
	}
	public void setShrLeNetAmt(BigDecimal shrLeNetAmt) {
		this.shrLeNetAmt = shrLeNetAmt;
	}
	public String getShareType() {
		return shareType;
	}
	public void setShareType(String shareType) {
		this.shareType = shareType;
	}
	public String getNegateTag() {
		return negateTag;
	}
	public void setNegateTag(String negateTag) {
		this.negateTag = negateTag;
	}
	public Date getDistributionDate() {
		return distributionDate;
	}
	public void setDistributionDate(Date distributionDate) {
		this.distributionDate = distributionDate;
	}
	public Integer getGroupedItemNo() {
		return groupedItemNo;
	}
	public void setGroupedItemNo(Integer groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}
	public BigDecimal getXolDed() {
		return xolDed;
	}
	public void setXolDed(BigDecimal xolDed) {
		this.xolDed = xolDed;
	}
	public String getTreatyName() {
		return treatyName;
	}
	public void setTreatyName(String treatyName) {
		this.treatyName = treatyName;
	}
	
	
}
