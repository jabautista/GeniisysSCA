package com.geniisys.giis.entity;

import java.math.BigDecimal;

public class GIISIntreaty extends BaseEntity {
	private String lineCd;
	private Integer trtySeqNo;
	private Integer trtyYy;
	private String uwTrtyType;
	private String effDate;
	private String expiryDate;
	private String riCd;
	private String dspRiSname;
	private String acTrtyType;
	private String dspAcTypeSname;
	private String trtyName;
	private BigDecimal trtyLimit;
	private BigDecimal trtyShrPct;
	private BigDecimal trtyShrAmt;
	private BigDecimal estPremInc;
	private String prtfolioSw;
	private Integer noOfLines;
	private BigDecimal inxsAmt;
	private BigDecimal excLossRt;
	private BigDecimal ccallLimit;
	private BigDecimal depPrem;
	private String currencyCd;
	private String dspCurrencyName;
	private String remarks;
	
	public GIISIntreaty(){
		
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public Integer getTrtySeqNo() {
		return trtySeqNo;
	}

	public void setTrtySeqNo(Integer trtySeqNo) {
		this.trtySeqNo = trtySeqNo;
	}

	public Integer getTrtyYy() {
		return trtyYy;
	}

	public void setTrtyYy(Integer trtyYy) {
		this.trtyYy = trtyYy;
	}

	public String getUwTrtyType() {
		return uwTrtyType;
	}

	public void setUwTrtyType(String uwTrtyType) {
		this.uwTrtyType = uwTrtyType;
	}

	public String getEffDate() {
		return effDate;
	}

	public void setEffDate(String effDate) {
		this.effDate = effDate;
	}

	public String getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(String expiryDate) {
		this.expiryDate = expiryDate;
	}

	public String getRiCd() {
		return riCd;
	}

	public void setRiCd(String riCd) {
		this.riCd = riCd;
	}

	public String getAcTrtyType() {
		return acTrtyType;
	}

	public void setAcTrtyType(String acTrtyType) {
		this.acTrtyType = acTrtyType;
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

	public BigDecimal getTrtyShrPct() {
		return trtyShrPct;
	}

	public void setTrtyShrPct(BigDecimal trtyShrPct) {
		this.trtyShrPct = trtyShrPct;
	}

	public BigDecimal getTrtyShrAmt() {
		return trtyShrAmt;
	}

	public void setTrtyShrAmt(BigDecimal trtyShrAmt) {
		this.trtyShrAmt = trtyShrAmt;
	}

	public BigDecimal getEstPremInc() {
		return estPremInc;
	}

	public void setEstPremInc(BigDecimal estPremInc) {
		this.estPremInc = estPremInc;
	}

	public String getPrtfolioSw() {
		return prtfolioSw;
	}

	public void setPrtfolioSw(String prtfolioSw) {
		this.prtfolioSw = prtfolioSw;
	}

	public Integer getNoOfLines() {
		return noOfLines;
	}

	public void setNoOfLines(Integer noOfLines) {
		this.noOfLines = noOfLines;
	}

	public BigDecimal getInxsAmt() {
		return inxsAmt;
	}

	public void setInxsAmt(BigDecimal inxsAmt) {
		this.inxsAmt = inxsAmt;
	}

	public BigDecimal getExcLossRt() {
		return excLossRt;
	}

	public void setExcLossRt(BigDecimal excLossRt) {
		this.excLossRt = excLossRt;
	}

	public BigDecimal getCcallLimit() {
		return ccallLimit;
	}

	public void setCcallLimit(BigDecimal ccallLimit) {
		this.ccallLimit = ccallLimit;
	}

	public BigDecimal getDepPrem() {
		return depPrem;
	}

	public void setDepPrem(BigDecimal depPrem) {
		this.depPrem = depPrem;
	}

	public String getCurrencyCd() {
		return currencyCd;
	}

	public void setCurrencyCd(String currencyCd) {
		this.currencyCd = currencyCd;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getDspRiSname() {
		return dspRiSname;
	}

	public void setDspRiSname(String dspRiSname) {
		this.dspRiSname = dspRiSname;
	}

	public String getDspAcTypeSname() {
		return dspAcTypeSname;
	}

	public void setDspAcTypeSname(String dspAcTypeSname) {
		this.dspAcTypeSname = dspAcTypeSname;
	}

	public String getDspCurrencyName() {
		return dspCurrencyName;
	}

	public void setDspCurrencyName(String dspCurrencyName) {
		this.dspCurrencyName = dspCurrencyName;
	}
}
