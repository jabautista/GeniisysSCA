package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;

public class GIACIntmPcommRt extends BaseEntity{
	private Integer intmNo;
	private String lineCd;
	private String lineName;
	private BigDecimal mgtExpRt;
	private BigDecimal premResRt;
	private BigDecimal lnCommRt;
	private BigDecimal profitCommRt;
	private String remarks;
	
	public GIACIntmPcommRt(){
		
	}

	public Integer getIntmNo() {
		return intmNo;
	}

	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public BigDecimal getMgtExpRt() {
		return mgtExpRt;
	}

	public void setMgtExpRt(BigDecimal mgtExpRt) {
		this.mgtExpRt = mgtExpRt;
	}

	public BigDecimal getPremResRt() {
		return premResRt;
	}

	public void setPremResRt(BigDecimal premResRt) {
		this.premResRt = premResRt;
	}

	public BigDecimal getLnCommRt() {
		return lnCommRt;
	}

	public void setLnCommRt(BigDecimal lnCommRt) {
		this.lnCommRt = lnCommRt;
	}

	public BigDecimal getProfitCommRt() {
		return profitCommRt;
	}

	public void setProfitCommRt(BigDecimal profitCommRt) {
		this.profitCommRt = profitCommRt;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getLineName() {
		return lineName;
	}

	public void setLineName(String lineName) {
		this.lineName = lineName;
	}
}
