package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIQuoteBondBasic extends BaseEntity{

	private Integer quoteId;
	private String obligeeNo;
	private String prinId;
	private String valPeriodUnit;
	private String valPeriod;
	private String collFlag;
	private String clauseType;
	private String npNo;
	private String contractDtl;
	private Date contractDate;
	private String coPrinSw;
	private BigDecimal waiverLimit;
	private String indemnityText;
	private String bondDtl;
	private Date endtEffDate;
	private String remarks;
	
	public Integer getQuoteId() {
		return quoteId;
	}
	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}
	public String getObligeeNo() {
		return obligeeNo;
	}
	public void setObligeeNo(String obligeeNo) {
		this.obligeeNo = obligeeNo;
	}
	public String getPrinId() {
		return prinId;
	}
	public void setPrinId(String prinId) {
		this.prinId = prinId;
	}
	public String getValPeriodUnit() {
		return valPeriodUnit;
	}
	public void setValPeriodUnit(String valPeriodUnit) {
		this.valPeriodUnit = valPeriodUnit;
	}
	public String getValPeriod() {
		return valPeriod;
	}
	public void setValPeriod(String valPeriod) {
		this.valPeriod = valPeriod;
	}
	public String getCollFlag() {
		return collFlag;
	}
	public void setCollFlag(String collFlag) {
		this.collFlag = collFlag;
	}
	public String getClauseType() {
		return clauseType;
	}
	public void setClauseType(String clauseType) {
		this.clauseType = clauseType;
	}
	public String getNpNo() {
		return npNo;
	}
	public void setNpNo(String npNo) {
		this.npNo = npNo;
	}
	public String getContractDtl() {
		return contractDtl;
	}
	public void setContractDtl(String contractDtl) {
		this.contractDtl = contractDtl;
	}
	public Date getContractDate() {
		return contractDate;
	}
	public void setContractDate(Date contractDate) {
		this.contractDate = contractDate;
	}
	public String getCoPrinSw() {
		return coPrinSw;
	}
	public void setCoPrinSw(String coPrinSw) {
		this.coPrinSw = coPrinSw;
	}
	public BigDecimal getWaiverLimit() {
		return waiverLimit;
	}
	public void setWaiverLimit(BigDecimal waiverLimit) {
		this.waiverLimit = waiverLimit;
	}
	public String getIndemnityText() {
		return indemnityText;
	}
	public void setIndemnityText(String indemnityText) {
		this.indemnityText = indemnityText;
	}
	public String getBondDtl() {
		return bondDtl;
	}
	public void setBondDtl(String bondDtl) {
		this.bondDtl = bondDtl;
	}
	public Date getEndtEffDate() {
		return endtEffDate;
	}
	public void setEndtEffDate(Date endtEffDate) {
		this.endtEffDate = endtEffDate;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
}
