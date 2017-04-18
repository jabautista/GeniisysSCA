package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWBondBasic extends BaseEntity {
	
	private Integer parId;
	private Integer obligeeNo;
	private Integer prinId;
	private String valPeriodUnit;
	private Integer valPeriod;
	private String collFlag;
	private String clauseType;
	private Integer npNo;
	private String contractDtl;
	private Date contractDate;
	private String coPrinSw;
	private BigDecimal waiverLimit;
	private String indemnityText;
	private String bondDtl;
	private Date endtEffDate;
	private String remarks;
	private String obligeeName;
	private String prinSignor;
	private String designation;
	private String npName;
	private String plaintiffDtl;
	private String defendantDtl;
	private String civilCaseNo;
	
	public Integer getParId() {
		return parId;
	}
	public void setParId(Integer parId) {
		this.parId = parId;
	}
	public Integer getObligeeNo() {
		return obligeeNo;
	}
	public void setObligeeNo(Integer obligeeNo) {
		this.obligeeNo = obligeeNo;
	}
	public Integer getPrinId() {
		return prinId;
	}
	public void setPrinId(Integer prinId) {
		this.prinId = prinId;
	}
	public String getValPeriodUnit() {
		return valPeriodUnit;
	}
	public void setValPeriodUnit(String valPeriodUnit) {
		this.valPeriodUnit = valPeriodUnit;
	}
	public Integer getValPeriod() {
		return valPeriod;
	}
	public void setValPeriod(Integer valPeriod) {
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
	public Integer getNpNo() {
		return npNo;
	}
	public void setNpNo(Integer npNo) {
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
	public String getObligeeName() {
		return obligeeName;
	}
	public void setObligeeName(String obligeeName) {
		this.obligeeName = obligeeName;
	}
	public String getPrinSignor() {
		return prinSignor;
	}
	public void setPrinSignor(String prinSignor) {
		this.prinSignor = prinSignor;
	}
	public String getDesignation() {
		return designation;
	}
	public void setDesignation(String designation) {
		this.designation = designation;
	}
	public String getNpName() {
		return npName;
	}
	public void setNpName(String npName) {
		this.npName = npName;
	}
	public String getPlaintiffDtl() {
		return plaintiffDtl;
	}
	public void setPlaintiffDtl(String plaintiffDtl) {
		this.plaintiffDtl = plaintiffDtl;
	}
	public String getDefendantDtl() {
		return defendantDtl;
	}
	public void setDefendantDtl(String defendantDtl) {
		this.defendantDtl = defendantDtl;
	}
	public String getCivilCaseNo() {
		return civilCaseNo;
	}
	public void setCivilCaseNo(String civilCaseNo) {
		this.civilCaseNo = civilCaseNo;
	}
	
}
