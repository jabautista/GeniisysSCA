package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIACOpText extends BaseEntity{

	private Integer gaccTranId;
	private Integer itemSeqNo;
	private Integer printSeqNo;
	private BigDecimal itemAmt;
	private String itemGenType;
	private String itemText;
	private Integer currencyCd;
	private String line;
	private String billNo;
	private String orPrintTag;
	private BigDecimal foreignCurrAmt;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private Integer columnNo;
	private String dspCurrSname;
	private String dspOrTypes;
	private String vatNonvatSeries;
	private String issueNonvatOAR;
	private String premIncRelated;
	
	public Integer getGaccTranId() {
		return gaccTranId;
	}
	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}
	public Integer getItemSeqNo() {
		return itemSeqNo;
	}
	public void setItemSeqNo(Integer itemSeqNo) {
		this.itemSeqNo = itemSeqNo;
	}
	public Integer getPrintSeqNo() {
		return printSeqNo;
	}
	public void setPrintSeqNo(Integer printSeqNo) {
		this.printSeqNo = printSeqNo;
	}
	public BigDecimal getItemAmt() {
		return itemAmt;
	}
	public void setItemAmt(BigDecimal itemAmt) {
		this.itemAmt = itemAmt;
	}
	public String getItemGenType() {
		return itemGenType;
	}
	public void setItemGenType(String itemGenType) {
		this.itemGenType = itemGenType;
	}
	public String getItemText() {
		return itemText;
	}
	public void setItemText(String itemText) {
		this.itemText = itemText;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public String getLine() {
		return line;
	}
	public void setLine(String line) {
		this.line = line;
	}
	public String getBillNo() {
		return billNo;
	}
	public void setBillNo(String billNo) {
		this.billNo = billNo;
	}
	public String getOrPrintTag() {
		return orPrintTag;
	}
	public void setOrPrintTag(String orPrintTag) {
		this.orPrintTag = orPrintTag;
	}
	public BigDecimal getForeignCurrAmt() {
		return foreignCurrAmt;
	}
	public void setForeignCurrAmt(BigDecimal foreignCurrAmt) {
		this.foreignCurrAmt = foreignCurrAmt;
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
	public Integer getColumnNo() {
		return columnNo;
	}
	public void setColumnNo(Integer columnNo) {
		this.columnNo = columnNo;
	}
	public String getDspCurrSname() {
		return dspCurrSname;
	}
	public void setDspCurrSname(String dspCurrSname) {
		this.dspCurrSname = dspCurrSname;
	}
	public String getDspOrTypes() {
		return dspOrTypes;
	}
	public void setDspOrTypes(String dspOrTypes) {
		this.dspOrTypes = dspOrTypes;
	}
	public String getVatNonvatSeries() {
		return vatNonvatSeries;
	}
	public void setVatNonvatSeries(String vatNonvatSeries) {
		this.vatNonvatSeries = vatNonvatSeries;
	}
	public String getIssueNonvatOAR() {
		return issueNonvatOAR;
	}
	public void setIssueNonvatOAR(String issueNonvatOAR) {
		this.issueNonvatOAR = issueNonvatOAR;
	}
	public String getPremIncRelated() {
		return premIncRelated;
	}
	public void setPremIncRelated(String premIncRelated) {
		this.premIncRelated = premIncRelated;
	}
}
