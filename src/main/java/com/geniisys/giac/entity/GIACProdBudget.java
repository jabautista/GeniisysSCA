package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;



public class GIACProdBudget extends BaseEntity {
	
	private Integer year;
	private String month;
	private String issCd;
	private String lineCd;
	private BigDecimal budget;
	private String dspIssName;
	private String dspLineName;
	
	public Integer getYear() {
		return year;
	}
	public void setYear(Integer year) {
		this.year = year;
	}
	public String getMonth() {
		return month;
	}
	public void setMonth(String month) {
		this.month = month;
	}
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public BigDecimal getBudget() {
		return budget;
	}
	public void setBudget(BigDecimal budget) {
		this.budget = budget;
	}
	public String getDspIssName() {
		return dspIssName;
	}
	public void setDspIssName(String dspIssName) {
		this.dspIssName = dspIssName;
	}
	public String getDspLineName() {
		return dspLineName;
	}
	public void setDspLineName(String dspLineName) {
		this.dspLineName = dspLineName;
	}
}
