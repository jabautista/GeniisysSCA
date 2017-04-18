package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIACBudget extends BaseEntity{
	
	/* Author : J. Diago
	 * Date Created : 09.24.2013
	 * Description : Table Entity for GIAC_BUDGET and GIAC_BUDGET_DTL
	 * 
	 * */
	
	/* GIAC_BUDGET */
	private Integer year;
	private Integer glAcctId;
	private BigDecimal budget;
	private String remarks;
	
	/* GIAC_BUDGET_DTL */
	private Integer dtlAcctId;
	
	public GIACBudget(){
		
	}
	
	public GIACBudget(Integer year, Integer glAcctId, BigDecimal budget, String remarks, Integer dtlAcctId){
		super();
		this.year = year;
		this.glAcctId = glAcctId;
		this.budget = budget;
		this.remarks = remarks;
		this.dtlAcctId = dtlAcctId;
	}

	public Integer getYear() {
		return year;
	}

	public void setYear(Integer year) {
		this.year = year;
	}

	public Integer getGlAcctId() {
		return glAcctId;
	}

	public void setGlAcctId(Integer glAcctId) {
		this.glAcctId = glAcctId;
	}

	public BigDecimal getBudget() {
		return budget;
	}

	public void setBudget(BigDecimal budget) {
		this.budget = budget;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public Integer getDtlAcctId() {
		return dtlAcctId;
	}

	public void setDtlAcctId(Integer dtlAcctId) {
		this.dtlAcctId = dtlAcctId;
	}
	
}
