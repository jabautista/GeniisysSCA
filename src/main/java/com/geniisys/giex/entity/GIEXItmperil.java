package com.geniisys.giex.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIEXItmperil extends BaseEntity{
	
	private Integer policyId;
	private Integer itemNo;
	private String lineCd;
	private Integer perilCd;
	private BigDecimal premRt;
	private BigDecimal premAmt;
	private BigDecimal tsiAmt;
	private String compRem;
	private String itemTitle;
	private BigDecimal annTsiAmt;
	private BigDecimal annPremAmt;
	private String sublineCd;
	private BigDecimal currencyRt;
	
	private BigDecimal nbtPremAmt;
	private BigDecimal nbtTsiAmt;
	private String nbtItemTitle;
	private String dspPerilName;
	private String dspPerilType;
	private Integer dspBascPerlCd;
	
	public GIEXItmperil() {
		super();
	}

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public Integer getPerilCd() {
		return perilCd;
	}

	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}

	public BigDecimal getPremRt() {
		return premRt;
	}

	public void setPremRt(BigDecimal premRt) {
		this.premRt = premRt;
	}

	public BigDecimal getPremAmt() {
		return premAmt;
	}

	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}

	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}

	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}

	public String getCompRem() {
		return compRem;
	}

	public void setCompRem(String compRem) {
		this.compRem = compRem;
	}

	public String getItemTitle() {
		return itemTitle;
	}

	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}

	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}

	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}

	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}

	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}

	public String getSublineCd() {
		return sublineCd;
	}

	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}

	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}

	public BigDecimal getNbtPremAmt() {
		return nbtPremAmt;
	}

	public void setNbtPremAmt(BigDecimal nbtPremAmt) {
		this.nbtPremAmt = nbtPremAmt;
	}

	public BigDecimal getNbtTsiAmt() {
		return nbtTsiAmt;
	}

	public void setNbtTsiAmt(BigDecimal nbtTsiAmt) {
		this.nbtTsiAmt = nbtTsiAmt;
	}

	public String getNbtItemTitle() {
		return nbtItemTitle;
	}

	public void setNbtItemTitle(String nbtItemTitle) {
		this.nbtItemTitle = nbtItemTitle;
	}

	public String getDspPerilName() {
		return dspPerilName;
	}

	public void setDspPerilName(String dspPerilName) {
		this.dspPerilName = dspPerilName;
	}

	public String getDspPerilType() {
		return dspPerilType;
	}

	public void setDspPerilType(String dspPerilType) {
		this.dspPerilType = dspPerilType;
	}

	public Integer getDspBascPerlCd() {
		return dspBascPerlCd;
	}

	public void setDspBascPerlCd(Integer dspBascPerlCd) {
		this.dspBascPerlCd = dspBascPerlCd;
	}
	
}
