package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIBondBasic extends BaseEntity{

	private Integer policyId;
	private String collFlag;
	private String clauseType;
	private Integer obligeeNo;
	private Integer prinId;
	private String valPeriodUnit;
	private Integer valPeriod;
	private Integer npNo;
	private String contractDtl;
	private Date contractDate;
	private String coPrinSw;
	private BigDecimal waiverLimit;
	private String indemnityText;
	private String bondDtl;
	private Date endtEffDate;
	private String witnessRi;
	private String witnessBond;
	private String witnessInd;
	private String remarks;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String arcExtData;
	
	private String nbtObligeeName;
	private String nbtPrinSignor;
	private String nbtDesignation;
	private String nbtNpName;
	private String nbtClauseDesc;
	private String nbtBondUnder;
	private BigDecimal nbtBondAmt;
	
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
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
	public Object getStrContractDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (contractDate != null) {
			return df.format(contractDate);			
		} else {
			return null;
		}
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
	public Object getStrEndtEffDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (endtEffDate != null) {
			return df.format(endtEffDate);			
		} else {
			return null;
		}
	}
	public Date getEndtEffDate() {
		return endtEffDate;
	}
	public void setEndtEffDate(Date endtEffDate) {
		this.endtEffDate = endtEffDate;
	}
	public String getWitnessRi() {
		return witnessRi;
	}
	public void setWitnessRi(String witnessRi) {
		this.witnessRi = witnessRi;
	}
	public String getWitnessBond() {
		return witnessBond;
	}
	public void setWitnessBond(String witnessBond) {
		this.witnessBond = witnessBond;
	}
	public String getWitnessInd() {
		return witnessInd;
	}
	public void setWitnessInd(String witnessInd) {
		this.witnessInd = witnessInd;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
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
	public String getArcExtData() {
		return arcExtData;
	}
	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}
	public String getNbtObligeeName() {
		return nbtObligeeName;
	}
	public void setNbtObligeeName(String nbtObligeeName) {
		this.nbtObligeeName = nbtObligeeName;
	}
	public String getNbtPrinSignor() {
		return nbtPrinSignor;
	}
	public void setNbtPrinSignor(String nbtPrinSignor) {
		this.nbtPrinSignor = nbtPrinSignor;
	}
	public String getNbtDesignation() {
		return nbtDesignation;
	}
	public void setNbtDesignation(String nbtDesignation) {
		this.nbtDesignation = nbtDesignation;
	}
	public String getNbtNpName() {
		return nbtNpName;
	}
	public void setNbtNpName(String nbtNpName) {
		this.nbtNpName = nbtNpName;
	}
	public String getNbtClauseDesc() {
		return nbtClauseDesc;
	}
	public void setNbtClauseDesc(String nbtClauseDesc) {
		this.nbtClauseDesc = nbtClauseDesc;
	}
	public String getNbtBondUnder() {
		return nbtBondUnder;
	}
	public void setNbtBondUnder(String nbtBondUnder) {
		this.nbtBondUnder = nbtBondUnder;
	}
	public BigDecimal getNbtBondAmt() {
		return nbtBondAmt;
	}
	public void setNbtBondAmt(BigDecimal nbtBondAmt) {
		this.nbtBondAmt = nbtBondAmt;
	}
	
}
