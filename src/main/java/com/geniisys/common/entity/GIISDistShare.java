package com.geniisys.common.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIISDistShare extends BaseEntity{
    
	private String lineCd;
	private Integer shareCd;
	private Integer trtyYy;
	private String trtySw;
	private String shareType;
	private Integer oldTrtySeqNo;
	private BigDecimal ccallLimit;
	private BigDecimal inxsAmt;
	private BigDecimal estPremInc;
	private BigDecimal underlying;
	private BigDecimal depPrem;
	private Integer profcompType;
	private BigDecimal excLossRt;
	private String uwTrtyType;
	private Integer trtyCd;
	private String prtfolioSw;
	private Integer acctTrtyType;
	private Date effDate;
	private Date expiryDate;
	private Integer noOfLines;
	private BigDecimal totShrPct;
	private String trtyName;
	private BigDecimal trtyLimit;
	private BigDecimal qsShrPct;
	private BigDecimal premAdjRt;
	private String reinstatement;
	private String shareTrtyType;
	private BigDecimal fundsHeldPct;
	private String remarks;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private BigDecimal lossPrtfolioPct;
	private BigDecimal premPrtfolioPct;
	private Integer xolId;
	private Integer reinstatementLimit;
	private BigDecimal xolAllowedAmount;
	private BigDecimal xolBaseAmount;
	private BigDecimal xolReserveAmount;
	private BigDecimal xolAllocatedAmount;
	private Integer layerNo;
	private BigDecimal xolAggregateSum;
	private BigDecimal xolPremMindep;
	private BigDecimal xolPremRate;
	private BigDecimal xolDed;
	private String userId;
	private Date lastUpdate;
	
	private Integer treatyYy;
	private Integer riCd;
	private Integer year;
	private Integer qtr;
	
	
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public Integer getShareCd() {
		return shareCd;
	}
	public void setShareCd(Integer shareCd) {
		this.shareCd = shareCd;
	}
	public Integer getTrtyYy() {
		return trtyYy;
	}
	public void setTrtyYy(Integer trtyYy) {
		this.trtyYy = trtyYy;
	}
	public String getTrtySw() {
		return trtySw;
	}
	public void setTrtySw(String trtySw) {
		this.trtySw = trtySw;
	}
	public String getShareType() {
		return shareType;
	}
	public void setShareType(String shareType) {
		this.shareType = shareType;
	}
	public Integer getOldTrtySeqNo() {
		return oldTrtySeqNo;
	}
	public void setOldTrtySeqNo(Integer oldTrtySeqNo) {
		this.oldTrtySeqNo = oldTrtySeqNo;
	}
	public BigDecimal getCcallLimit() {
		return ccallLimit;
	}
	public void setCcallLimit(BigDecimal ccallLimit) {
		this.ccallLimit = ccallLimit;
	}
	public BigDecimal getInxsAmt() {
		return inxsAmt;
	}
	public void setInxsAmt(BigDecimal inxsAmt) {
		this.inxsAmt = inxsAmt;
	}
	public BigDecimal getEstPremInc() {
		return estPremInc;
	}
	public void setEstPremInc(BigDecimal estPremInc) {
		this.estPremInc = estPremInc;
	}
	public BigDecimal getUnderlying() {
		return underlying;
	}
	public void setUnderlying(BigDecimal underlying) {
		this.underlying = underlying;
	}
	public BigDecimal getDepPrem() {
		return depPrem;
	}
	public void setDepPrem(BigDecimal depPrem) {
		this.depPrem = depPrem;
	}
	public Integer getProfcompType() {
		return profcompType;
	}
	public void setProfcompType(Integer profcompType) {
		this.profcompType = profcompType;
	}
	public BigDecimal getExcLossRt() {
		return excLossRt;
	}
	public void setExcLossRt(BigDecimal excLossRt) {
		this.excLossRt = excLossRt;
	}
	public String getUwTrtyType() {
		return uwTrtyType;
	}
	public void setUwTrtyType(String uwTrtyType) {
		this.uwTrtyType = uwTrtyType;
	}
	public Integer getTrtyCd() {
		return trtyCd;
	}
	public void setTrtyCd(Integer trtyCd) {
		this.trtyCd = trtyCd;
	}
	public String getPrtfolioSw() {
		return prtfolioSw;
	}
	public void setPrtfolioSw(String prtfolioSw) {
		this.prtfolioSw = prtfolioSw;
	}
	public Integer getAcctTrtyType() {
		return acctTrtyType;
	}
	public void setAcctTrtyType(Integer acctTrtyType) {
		this.acctTrtyType = acctTrtyType;
	}
	public Date getEffDate() {
		return effDate;
	}
	public void setEffDate(Date effDate) {
		this.effDate = effDate;
	}
	public Date getExpiryDate() {
		return expiryDate;
	}
	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}
	public Integer getNoOfLines() {
		return noOfLines;
	}
	public void setNoOfLines(Integer noOfLines) {
		this.noOfLines = noOfLines;
	}
	public BigDecimal getTotShrPct() {
		return totShrPct;
	}
	public void setTotShrPct(BigDecimal totShrPct) {
		this.totShrPct = totShrPct;
	}
	public String getTrtyName() {
		return trtyName;
	}
	public void setTrtyName(String trtyName) {
		this.trtyName = trtyName;
	}
	public BigDecimal getTrtyLimit() {
		return trtyLimit;
	}
	public void setTrtyLimit(BigDecimal trtyLimit) {
		this.trtyLimit = trtyLimit;
	}
	public BigDecimal getQsShrPct() {
		return qsShrPct;
	}
	public void setQsShrPct(BigDecimal qsShrPct) {
		this.qsShrPct = qsShrPct;
	}
	public BigDecimal getPremAdjRt() {
		return premAdjRt;
	}
	public void setPremAdjRt(BigDecimal premAdjRt) {
		this.premAdjRt = premAdjRt;
	}
	public String getReinstatement() {
		return reinstatement;
	}
	public void setReinstatement(String reinstatement) {
		this.reinstatement = reinstatement;
	}
	public String getShareTrtyType() {
		return shareTrtyType;
	}
	public void setShareTrtyType(String shareTrtyType) {
		this.shareTrtyType = shareTrtyType;
	}
	public BigDecimal getFundsHeldPct() {
		return fundsHeldPct;
	}
	public void setFundsHeldPct(BigDecimal fundsHeldPct) {
		this.fundsHeldPct = fundsHeldPct;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	public BigDecimal getLossPrtfolioPct() {
		return lossPrtfolioPct;
	}
	public void setLossPrtfolioPct(BigDecimal lossPrtfolioPct) {
		this.lossPrtfolioPct = lossPrtfolioPct;
	}
	public BigDecimal getPremPrtfolioPct() {
		return premPrtfolioPct;
	}
	public void setPremPrtfolioPct(BigDecimal premPrtfolioPct) {
		this.premPrtfolioPct = premPrtfolioPct;
	}
	public Integer getXolId() {
		return xolId;
	}
	public void setXolId(Integer xolId) {
		this.xolId = xolId;
	}
	public Integer getReinstatementLimit() {
		return reinstatementLimit;
	}
	public void setReinstatementLimit(Integer reinstatementLimit) {
		this.reinstatementLimit = reinstatementLimit;
	}
	public BigDecimal getXolAllowedAmount() {
		return xolAllowedAmount;
	}
	public void setXolAllowedAmount(BigDecimal xolAllowedAmount) {
		this.xolAllowedAmount = xolAllowedAmount;
	}
	public BigDecimal getXolBaseAmount() {
		return xolBaseAmount;
	}
	public void setXolBaseAmount(BigDecimal xolBaseAmount) {
		this.xolBaseAmount = xolBaseAmount;
	}
	public BigDecimal getXolReserveAmount() {
		return xolReserveAmount;
	}
	public void setXolReserveAmount(BigDecimal xolReserveAmount) {
		this.xolReserveAmount = xolReserveAmount;
	}
	public BigDecimal getXolAllocatedAmount() {
		return xolAllocatedAmount;
	}
	public void setXolAllocatedAmount(BigDecimal xolAllocatedAmount) {
		this.xolAllocatedAmount = xolAllocatedAmount;
	}
	public Integer getLayerNo() {
		return layerNo;
	}
	public void setLayerNo(Integer layerNo) {
		this.layerNo = layerNo;
	}
	public BigDecimal getXolAggregateSum() {
		return xolAggregateSum;
	}
	public void setXolAggregateSum(BigDecimal xolAggregateSum) {
		this.xolAggregateSum = xolAggregateSum;
	}
	public BigDecimal getXolPremMindep() {
		return xolPremMindep;
	}
	public void setXolPremMindep(BigDecimal xolPremMindep) {
		this.xolPremMindep = xolPremMindep;
	}
	public BigDecimal getXolPremRate() {
		return xolPremRate;
	}
	public void setXolPremRate(BigDecimal xolPremRate) {
		this.xolPremRate = xolPremRate;
	}
	public BigDecimal getXolDed() {
		return xolDed;
	}
	public void setXolDed(BigDecimal xolDed) {
		this.xolDed = xolDed;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public Date getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	public Integer getTreatyYy() {
		return treatyYy;
	}
	public void setTreatyYy(Integer treatyYy) {
		this.treatyYy = treatyYy;
	}
	public Integer getRiCd() {
		return riCd;
	}
	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}
	public Integer getYear() {
		return year;
	}
	public void setYear(Integer year) {
		this.year = year;
	}
	public Integer getQtr() {
		return qtr;
	}
	public void setQtr(Integer qtr) {
		this.qtr = qtr;
	}
	
}
