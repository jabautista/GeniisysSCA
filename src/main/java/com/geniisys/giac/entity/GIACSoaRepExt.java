package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIACSoaRepExt extends BaseEntity {

	private Integer intmNo;
	private String intmName;
	private Integer assdNo;
	private String assdName;
	private String policyNo;
	private String billNo;
	private String issCd;
	private Integer premSeqNo;
	private Integer instNo;
	private Integer agingId;
	private String columnTitle;
	private BigDecimal balanceAmtDue;
	private BigDecimal totalAmtDue;
	
	//used by filterByAging
	private String fundCd;
	private String branchCd;
	private BigDecimal agingBalAmtDue;
	private BigDecimal agingPremBalDue;
	private BigDecimal agingTaxBalDue;
	private String ageLevel;	
	
	//for printing report
	private Integer collLetNo;
	private Integer collSeqNo;
	private Integer collYear;
	private String lastUpdate2;
	
	private String policyNo2;
	private String endtNo;
	
	public String getFundCd() {
		return fundCd;
	}
	public void setFundCd(String fundCd) {
		this.fundCd = fundCd;
	}
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	public BigDecimal getAgingBalAmtDue() {
		return agingBalAmtDue;
	}
	public void setAgingBalAmtDue(BigDecimal agingBalAmtDue) {
		this.agingBalAmtDue = agingBalAmtDue;
	}
	public BigDecimal getAgingPremBalDue() {
		return agingPremBalDue;
	}
	public void setAgingPremBalDue(BigDecimal agingPremBalDue) {
		this.agingPremBalDue = agingPremBalDue;
	}
	public BigDecimal getAgingTaxBalDue() {
		return agingTaxBalDue;
	}
	public void setAgingTaxBalDue(BigDecimal agingTaxBalDue) {
		this.agingTaxBalDue = agingTaxBalDue;
	}
	public String getAgeLevel() {
		return ageLevel;
	}
	public void setAgeLevel(String ageLevel) {
		this.ageLevel = ageLevel;
	}
	
	
	
	public Integer getIntmNo() {
		return intmNo;
	}
	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}
	public String getIntmName() {
		return intmName;
	}
	public void setIntmName(String intmName) {
		this.intmName = intmName;
	}
	public Integer getAssdNo() {
		return assdNo;
	}
	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}
	public String getAssdName() {
		return assdName;
	}
	public void setAssdName(String assdName) {
		this.assdName = assdName;
	}
	public String getPolicyNo() {
		return policyNo;
	}
	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}
	public String getBillNo() {
		return billNo;
	}
	public void setBillNo(String billNo) {
		this.billNo = billNo;
	}
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public Integer getPremSeqNo() {
		return premSeqNo;
	}
	public void setPremSeqNo(Integer premSeqNo) {
		this.premSeqNo = premSeqNo;
	}
	public Integer getInstNo() {
		return instNo;
	}
	public void setInstNo(Integer instNo) {
		this.instNo = instNo;
	}
	public Integer getAgingId() {
		return agingId;
	}
	public void setAgingId(Integer agingId) {
		this.agingId = agingId;
	}
	public String getColumnTitle() {
		return columnTitle;
	}
	public void setColumnTitle(String columnTitle) {
		this.columnTitle = columnTitle;
	}
	public BigDecimal getBalanceAmtDue() {
		return balanceAmtDue;
	}
	public void setBalanceAmtDue(BigDecimal balanceAmtDue) {
		this.balanceAmtDue = balanceAmtDue;
	}
	public BigDecimal getTotalAmtDue() {
		return totalAmtDue;
	}
	public void setTotalAmtDue(BigDecimal totalAmtDue) {
		this.totalAmtDue = totalAmtDue;
	}
	public Integer getCollLetNo() {
		return collLetNo;
	}
	public void setCollLetNo(Integer collLetNo) {
		this.collLetNo = collLetNo;
	}
	public Integer getCollSeqNo() {
		return collSeqNo;
	}
	public void setCollSeqNo(Integer collSeqNo) {
		this.collSeqNo = collSeqNo;
	}
	public Integer getCollYear() {
		return collYear;
	}
	public void setCollYear(Integer collYear) {
		this.collYear = collYear;
	}
	public String getLastUpdate2() {
		return lastUpdate2;
	}
	public void setLastUpdate2(String lastUpdate2) {
		this.lastUpdate2 = lastUpdate2;
	}
	public String getPolicyNo2() {
		return policyNo2;
	}
	public void setPolicyNo2(String policyNo2) {
		this.policyNo2 = policyNo2;
	}
	public String getEndtNo() {
		return endtNo;
	}
	public void setEndtNo(String endtNo) {
		this.endtNo = endtNo;
	}
	
	
}
