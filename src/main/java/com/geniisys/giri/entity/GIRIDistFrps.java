package com.geniisys.giri.entity;

import java.math.BigDecimal;
import java.sql.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIRIDistFrps extends BaseEntity {

	private String lineCd;
	private Integer frpsYy;
	private Integer frpsSeqNo;
	private Integer distNo;
	private Integer distSeqNo;
	private BigDecimal tsiAmt;
	private BigDecimal totFacSpct;
	private BigDecimal totFacTsi;
	private BigDecimal premAmt;
	private BigDecimal totFacPrem;
	private String riFlag;
	private Integer currencyCd;
	private BigDecimal currencyRt;
	private String premWarrSw;
	private String claimsCoopSw;
	private String claimsControlSw;
	private String locVoyUnit;
	private String opSw;
	private Integer opGroupNo;
	private Integer opFrpsYy;
	private Integer opFrpsSeqNo;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private BigDecimal totFacSpct2;
	private String arcExtData;

	private Integer parId;
	private String frpsNo;
	private String issCd;
	private Integer parYy;
	private Integer parSeqNo;
	private Integer quoteSeqNo;
	private String parNo;
	private String parType;
	private String policyNo;
	private String endtIssCd;
	private Integer endtYy;
	private Integer endtSeqNo;
	private String endtNo;
	private String assdName;
	private String packPolNo;
	private Date effDate;
	private Date expiryDate;
	private String refPolNo;
	private String currDesc;
	private Integer distFlag;
	private String distDesc;
	private String regPolSw;
	private Integer spclPolTag;
	private Integer distSpct1;
	private Integer distByTsiPrem;
	private String sublineCd;
	private Integer issueYy;
	private Integer polSeqNo;
	private Integer renewNo;

	public String getSublineCd() {
		return sublineCd;
	}

	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	public Integer getIssueYy() {
		return issueYy;
	}

	public void setIssueYy(Integer issueYy) {
		this.issueYy = issueYy;
	}

	public Integer getPolSeqNo() {
		return polSeqNo;
	}

	public void setPolSeqNo(Integer polSeqNo) {
		this.polSeqNo = polSeqNo;
	}

	public Integer getDistSpct1() {
		return distSpct1;
	}

	public void setDistSpct1(Integer distSpct1) {
		this.distSpct1 = distSpct1;
	}

	public Integer getDistByTsiPrem() {
		return distByTsiPrem;
	}

	public void setDistByTsiPrem(Integer distByTsiPrem) {
		this.distByTsiPrem = distByTsiPrem;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public String getRegPolSw() {
		return regPolSw;
	}

	public void setRegPolSw(String regPolSw) {
		this.regPolSw = regPolSw;
	}

	public Integer getParYy() {
		return parYy;
	}

	public void setParYy(Integer parYy) {
		this.parYy = parYy;
	}

	public Integer getParSeqNo() {
		return parSeqNo;
	}

	public void setParSeqNo(Integer parSeqNo) {
		this.parSeqNo = parSeqNo;
	}

	public Integer getQuoteSeqNo() {
		return quoteSeqNo;
	}

	public void setQuoteSeqNo(Integer quoteSeqNo) {
		this.quoteSeqNo = quoteSeqNo;
	}

	public String getEndtIssCd() {
		return endtIssCd;
	}

	public void setEndtIssCd(String endtIssCd) {
		this.endtIssCd = endtIssCd;
	}

	public Integer getEndtYy() {
		return endtYy;
	}

	public void setEndtYy(Integer endtYy) {
		this.endtYy = endtYy;
	}

	public Integer getEndtSeqNo() {
		return endtSeqNo;
	}

	public void setEndtSeqNo(Integer endtSeqNo) {
		this.endtSeqNo = endtSeqNo;
	}

	public String getParNo() {
		return parNo;
	}

	public void setParNo(String parNo) {
		this.parNo = parNo;
	}

	public Integer getParId() {
		return parId;
	}

	public void setParId(Integer parId) {
		this.parId = parId;
	}

	public String getFrpsNo() {
		return frpsNo;
	}

	public void setFrpsNo(String frpsNo) {
		this.frpsNo = frpsNo;
	}

	public String getParType() {
		return parType;
	}

	public void setParType(String parType) {
		this.parType = parType;
	}

	public String getPolicyNo() {
		return policyNo;
	}

	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}

	public String getEndtNo() {
		return endtNo;
	}

	public void setEndtNo(String endtNo) {
		this.endtNo = endtNo;
	}

	public String getAssdName() {
		return assdName;
	}

	public void setAssdName(String assdName) {
		this.assdName = assdName;
	}

	public String getPackPolNo() {
		return packPolNo;
	}

	public void setPackPolNo(String packPolNo) {
		this.packPolNo = packPolNo;
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

	public String getRefPolNo() {
		return refPolNo;
	}

	public void setRefPolNo(String refPolNo) {
		this.refPolNo = refPolNo;
	}

	public String getCurrDesc() {
		return currDesc;
	}

	public void setCurrDesc(String currDesc) {
		this.currDesc = currDesc;
	}

	public Integer getDistFlag() {
		return distFlag;
	}

	public void setDistFlag(Integer distFlag) {
		this.distFlag = distFlag;
	}

	public String getDistDesc() {
		return distDesc;
	}

	public void setDistDesc(String distDesc) {
		this.distDesc = distDesc;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public Integer getFrpsYy() {
		return frpsYy;
	}

	public void setFrpsYy(Integer frpsYy) {
		this.frpsYy = frpsYy;
	}

	public Integer getFrpsSeqNo() {
		return frpsSeqNo;
	}

	public void setFrpsSeqNo(Integer frpsSeqNo) {
		this.frpsSeqNo = frpsSeqNo;
	}

	public Integer getDistNo() {
		return distNo;
	}

	public void setDistNo(Integer distNo) {
		this.distNo = distNo;
	}

	public Integer getDistSeqNo() {
		return distSeqNo;
	}

	public void setDistSeqNo(Integer distSeqNo) {
		this.distSeqNo = distSeqNo;
	}

	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}

	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}

	public BigDecimal getTotFacSpct() {
		return totFacSpct;
	}

	public void setTotFacSpct(BigDecimal totFacSpct) {
		this.totFacSpct = totFacSpct;
	}

	public BigDecimal getTotFacTsi() {
		return totFacTsi;
	}

	public void setTotFacTsi(BigDecimal totFacTsi) {
		this.totFacTsi = totFacTsi;
	}

	public BigDecimal getPremAmt() {
		return premAmt;
	}

	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}

	public BigDecimal getTotFacPrem() {
		return totFacPrem;
	}

	public void setTotFacPrem(BigDecimal totFacPrem) {
		this.totFacPrem = totFacPrem;
	}

	public String getRiFlag() {
		return riFlag;
	}

	public void setRiFlag(String riFlag) {
		this.riFlag = riFlag;
	}

	public Integer getCurrencyCd() {
		return currencyCd;
	}

	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}

	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}

	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}

	public String getPremWarrSw() {
		return premWarrSw;
	}

	public void setPremWarrSw(String premWarrSw) {
		this.premWarrSw = premWarrSw;
	}

	public String getClaimsCoopSw() {
		return claimsCoopSw;
	}

	public void setClaimsCoopSw(String claimsCoopSw) {
		this.claimsCoopSw = claimsCoopSw;
	}

	public String getClaimsControlSw() {
		return claimsControlSw;
	}

	public void setClaimsControlSw(String claimsControlSw) {
		this.claimsControlSw = claimsControlSw;
	}

	public String getLocVoyUnit() {
		return locVoyUnit;
	}

	public void setLocVoyUnit(String locVoyUnit) {
		this.locVoyUnit = locVoyUnit;
	}

	public String getOpSw() {
		return opSw;
	}

	public void setOpSw(String opSw) {
		this.opSw = opSw;
	}

	public Integer getOpGroupNo() {
		return opGroupNo;
	}

	public void setOpGroupNo(Integer opGroupNo) {
		this.opGroupNo = opGroupNo;
	}

	public Integer getOpFrpsYy() {
		return opFrpsYy;
	}

	public void setOpFrpsYy(Integer opFrpsYy) {
		this.opFrpsYy = opFrpsYy;
	}

	public Integer getOpFrpsSeqNo() {
		return opFrpsSeqNo;
	}

	public void setOpFrpsSeqNo(Integer opFrpsSeqNo) {
		this.opFrpsSeqNo = opFrpsSeqNo;
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

	public BigDecimal getTotFacSpct2() {
		return totFacSpct2;
	}

	public void setTotFacSpct2(BigDecimal totFacSpct2) {
		this.totFacSpct2 = totFacSpct2;
	}

	public String getArcExtData() {
		return arcExtData;
	}

	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}

	public void setSpclPolTag(Integer spclPolTag) {
		this.spclPolTag = spclPolTag;
	}

	public Integer getSpclPolTag() {
		return spclPolTag;
	}

	public Integer getRenewNo() {
		return renewNo;
	}

	public void setRenewNo(Integer renewNo) {
		this.renewNo = renewNo;
	}

}
