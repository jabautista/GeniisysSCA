package com.geniisys.gixx.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIXXClaims extends BaseEntity{

	private Integer extractId;
	private Integer claimId;
	private String lineCd;
	private String sublineCd;
	private Integer clmYy;
	private Integer clmSeqNo;
	private String issCd;
	private String clmStatCd;
	private Date claimSettlementDate;
	private Date claimFileDate;
	private Date lossDate;
	private BigDecimal lossPdAmt;
	private BigDecimal lossResAmt;
	private BigDecimal expPdAmt;
	private String riCd;
	private String userId;
	private Date entryDate;
	private String lossLoc1;
	private String lossLoc2;
	private String lossLoc3;
	private String inHouAdj;
	private String clmControl;
	private String clmCoop;
	private Integer assdNo;
	private Date polEffDate;
	private String recoverySw;
	private Integer csrNo;
	private String lossCatCd;
	private Integer intmNo;
	private BigDecimal clmAmt;
	private String lossDtls;
	private Integer obligeeNo;
	private BigDecimal expResAmt;
	private String assuredName;
	
	// additional for GIPIS101
	private String claimNumber;
	private BigDecimal claimAmount;
	private BigDecimal paidAmount;
	
	public Integer getExtractId() {
		return extractId;
	}
	public void setExtractId(Integer extractId) {
		this.extractId = extractId;
	}
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
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
	public Integer getClmYy() {
		return clmYy;
	}
	public void setClmYy(Integer clmYy) {
		this.clmYy = clmYy;
	}
	public Integer getClmSeqNo() {
		return clmSeqNo;
	}
	public void setClmSeqNo(Integer clmSeqNo) {
		this.clmSeqNo = clmSeqNo;
	}
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public String getClmStatCd() {
		return clmStatCd;
	}
	public void setClmStatCd(String clmStatCd) {
		this.clmStatCd = clmStatCd;
	}
	public Date getClaimSettlementDate() {
		return claimSettlementDate;
	}
	public void setClaimSettlementDate(Date claimSettlementDate) {
		this.claimSettlementDate = claimSettlementDate;
	}
	public Date getClaimFileDate() {
		return claimFileDate;
	}
	public void setClaimFileDate(Date claimFileDate) {
		this.claimFileDate = claimFileDate;
	}
	public Date getLossDate() {
		return lossDate;
	}
	public void setLossDate(Date lossDate) {
		this.lossDate = lossDate;
	}
	public BigDecimal getLossPdAmt() {
		return lossPdAmt;
	}
	public void setLossPdAmt(BigDecimal lossPdAmt) {
		this.lossPdAmt = lossPdAmt;
	}
	public BigDecimal getLossResAmt() {
		return lossResAmt;
	}
	public void setLossResAmt(BigDecimal lossResAmt) {
		this.lossResAmt = lossResAmt;
	}
	public BigDecimal getExpPdAmt() {
		return expPdAmt;
	}
	public void setExpPdAmt(BigDecimal expPdAmt) {
		this.expPdAmt = expPdAmt;
	}
	public String getRiCd() {
		return riCd;
	}
	public void setRiCd(String riCd) {
		this.riCd = riCd;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public Date getEntryDate() {
		return entryDate;
	}
	public void setEntryDate(Date entryDate) {
		this.entryDate = entryDate;
	}
	public String getLossLoc1() {
		return lossLoc1;
	}
	public void setLossLoc1(String lossLoc1) {
		this.lossLoc1 = lossLoc1;
	}
	public String getLossLoc2() {
		return lossLoc2;
	}
	public void setLossLoc2(String lossLoc2) {
		this.lossLoc2 = lossLoc2;
	}
	public String getLossLoc3() {
		return lossLoc3;
	}
	public void setLossLoc3(String lossLoc3) {
		this.lossLoc3 = lossLoc3;
	}
	public String getInHouAdj() {
		return inHouAdj;
	}
	public void setInHouAdj(String inHouAdj) {
		this.inHouAdj = inHouAdj;
	}
	public String getClmControl() {
		return clmControl;
	}
	public void setClmControl(String clmControl) {
		this.clmControl = clmControl;
	}
	public String getClmCoop() {
		return clmCoop;
	}
	public void setClmCoop(String clmCoop) {
		this.clmCoop = clmCoop;
	}
	public Integer getAssdNo() {
		return assdNo;
	}
	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}
	public Date getPolEffDate() {
		return polEffDate;
	}
	public void setPolEffDate(Date polEffDate) {
		this.polEffDate = polEffDate;
	}
	public String getRecoverySw() {
		return recoverySw;
	}
	public void setRecoverySw(String recoverySw) {
		this.recoverySw = recoverySw;
	}
	public Integer getCsrNo() {
		return csrNo;
	}
	public void setCsrNo(Integer csrNo) {
		this.csrNo = csrNo;
	}
	public String getLossCatCd() {
		return lossCatCd;
	}
	public void setLossCatCd(String lossCatCd) {
		this.lossCatCd = lossCatCd;
	}
	public Integer getIntmNo() {
		return intmNo;
	}
	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}
	public BigDecimal getClmAmt() {
		return clmAmt;
	}
	public void setClmAmt(BigDecimal clmAmt) {
		this.clmAmt = clmAmt;
	}
	public String getLossDtls() {
		return lossDtls;
	}
	public void setLossDtls(String lossDtls) {
		this.lossDtls = lossDtls;
	}
	public Integer getObligeeNo() {
		return obligeeNo;
	}
	public void setObligeeNo(Integer obligeeNo) {
		this.obligeeNo = obligeeNo;
	}
	public BigDecimal getExpResAmt() {
		return expResAmt;
	}
	public void setExpResAmt(BigDecimal expResAmt) {
		this.expResAmt = expResAmt;
	}
	public String getAssuredName() {
		return assuredName;
	}
	public void setAssuredName(String assuredName) {
		this.assuredName = assuredName;
	}
	public String getClaimNumber() {
		return claimNumber;
	}
	public void setClaimNumber(String claimNumber) {
		this.claimNumber = claimNumber;
	}
	public BigDecimal getClaimAmount() {
		return claimAmount;
	}
	public void setClaimAmount(BigDecimal claimAmount) {
		this.claimAmount = claimAmount;
	}
	public BigDecimal getPaidAmount() {
		return paidAmount;
	}
	public void setPaidAmount(BigDecimal paidAmount) {
		this.paidAmount = paidAmount;
	}
	
	
}
