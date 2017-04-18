package com.geniisys.common.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;



public class GIISBondClassClause extends BaseEntity {
	
	private String clauseType;
	private String clauseDesc;
	private BigDecimal waiverLimit;
	private String remarks;
	
	public String getClauseType() {
		return clauseType;
	}
	public void setClauseType(String clauseType) {
		this.clauseType = clauseType;
	}
	public String getClauseDesc() {
		return clauseDesc;
	}
	public void setClauseDesc(String clauseDesc) {
		this.clauseDesc = clauseDesc;
	}
	public void setWaiverLimit(BigDecimal waiverLimit) {
		this.waiverLimit = waiverLimit;
	}
	public BigDecimal getWaiverLimit() {
		return waiverLimit;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

}
