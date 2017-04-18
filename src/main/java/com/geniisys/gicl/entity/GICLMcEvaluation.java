/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.entity
	File Name: GICLMcEvaluation.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jan 13, 2012
	Description: 
*/


package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLMcEvaluation extends BaseEntity{
	private Integer claimId;
	private Integer evalId;
	private Integer itemNo;
	private Integer perilCd;
	private String sublineCd;
	private String issCd;
	private Integer evalYy;
	private Integer evalSeqNo;
	private Integer evalVersion;
	private String reportType;
	private Integer evalMasterId;
	private Integer payeeNo;
	private String payeeClassCd;
	private String plateNo;
	private String tpSw;
	private String csoId;
	private String evalDate;
	private String inspectDate;
	private String inspectPlace;
	private Integer adjusterId;
	private BigDecimal replaceAmt;
	private BigDecimal vat;
	private BigDecimal depreciation;
	private String remarks;
	private Integer currencyCd;
	private BigDecimal currencyRate;
	private BigDecimal repairAmt;
	private String evalStatCd;
	
	//non-table properties
	private String dspAdjusterDesc;
	private String dspPayee;
	private String dspCurrShortname;
	private BigDecimal dspDiscount;
	private BigDecimal deductible;
	private BigDecimal totEstCos;
	private BigDecimal totErc;
	private BigDecimal totInp;
	private BigDecimal totInl;
	private String dspReportTypeDesc;
	private String dspEvalDesc;
	private BigDecimal replaceGross;
	private BigDecimal repairGross;
	private String evaluationNo;
	private Integer varPayeeCdGiclReplace;
	private String varPayeeTypeCdGiclReplace;
	private String masterFlag;
	private String cancelFlag;
	private Integer dedFlag;
	private Integer depFlag;
	private String inHouAdj;
	private String masterReportType;
	private String mainEvalVatExist; 
	
	public String getInHouAdj() {
		return inHouAdj;
	}
	public void setInHouAdj(String inHouAdj) {
		this.inHouAdj = inHouAdj;
	}
	public String getMasterFlag() {
		return masterFlag;
	}
	public void setMasterFlag(String masterFlag) {
		this.masterFlag = masterFlag;
	}
	public String getCancelFlag() {
		return cancelFlag;
	}
	public void setCancelFlag(String cancelFlag) {
		this.cancelFlag = cancelFlag;
	}
	public Integer getDedFlag() {
		return dedFlag;
	}
	public void setDedFlag(Integer dedFlag) {
		this.dedFlag = dedFlag;
	}
	public Integer getDepFlag() {
		return depFlag;
	}
	public void setDepFlag(Integer depFlag) {
		this.depFlag = depFlag;
	}
	public String getEvaluationNo() {
		return evaluationNo;
	}
	public void setEvaluationNo(String evaluationNo) {
		this.evaluationNo = evaluationNo;
	}
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public Integer getEvalId() {
		return evalId;
	}
	public void setEvalId(Integer evalId) {
		this.evalId = evalId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public Integer getPerilCd() {
		return perilCd;
	}
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	public String getSublineCd() {
		return sublineCd;
	}
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public Integer getEvalYy() {
		return evalYy;
	}
	public void setEvalYy(Integer evalYy) {
		this.evalYy = evalYy;
	}
	public Integer getEvalSeqNo() {
		return evalSeqNo;
	}
	public void setEvalSeqNo(Integer evalSeqNo) {
		this.evalSeqNo = evalSeqNo;
	}
	public Integer getEvalVersion() {
		return evalVersion;
	}
	public void setEvalVersion(Integer evalVersion) {
		this.evalVersion = evalVersion;
	}
	public String getReportType() {
		return reportType;
	}
	public void setReportType(String reportType) {
		this.reportType = reportType;
	}
	public Integer getEvalMasterId() {
		return evalMasterId;
	}
	public void setEvalMasterId(Integer evalMasterId) {
		this.evalMasterId = evalMasterId;
	}
	public Integer getPayeeNo() {
		return payeeNo;
	}
	public void setPayeeNo(Integer payeeNo) {
		this.payeeNo = payeeNo;
	}
	public String getPayeeClassCd() {
		return payeeClassCd;
	}
	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
	}
	public String getPlateNo() {
		return plateNo;
	}
	public void setPlateNo(String plateNo) {
		this.plateNo = plateNo;
	}
	public String getTpSw() {
		return tpSw;
	}
	public void setTpSw(String tpSw) {
		this.tpSw = tpSw;
	}
	public String getCsoId() {
		return csoId;
	}
	public void setCsoId(String csoId) {
		this.csoId = csoId;
	}
	public String getEvalDate() {
		return evalDate;
	}
	public void setEvalDate(String evalDate) {
		this.evalDate = evalDate;
	}
	public String getInspectDate() {
		return inspectDate;
	}
	public void setInspectDate(String inspectDate) {
		this.inspectDate = inspectDate;
	}
	public String getInspectPlace() {
		return inspectPlace;
	}
	public void setInspectPlace(String inspectPlace) {
		this.inspectPlace = inspectPlace;
	}
	public Integer getAdjusterId() {
		return adjusterId;
	}
	public void setAdjusterId(Integer adjusterId) {
		this.adjusterId = adjusterId;
	}
	public BigDecimal getReplaceAmt() {
		return replaceAmt;
	}
	public void setReplaceAmt(BigDecimal replaceAmt) {
		this.replaceAmt = replaceAmt;
	}
	public BigDecimal getVat() {
		return vat;
	}
	public void setVat(BigDecimal vat) {
		this.vat = vat;
	}
	public BigDecimal getDepreciation() {
		return depreciation;
	}
	public void setDepreciation(BigDecimal depreciation) {
		this.depreciation = depreciation;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public BigDecimal getCurrencyRate() {
		return currencyRate;
	}
	public void setCurrencyRate(BigDecimal currencyRate) {
		this.currencyRate = currencyRate;
	}
	public String getDspAdjusterDesc() {
		return dspAdjusterDesc;
	}
	public void setDspAdjusterDesc(String dspAdjusterDesc) {
		this.dspAdjusterDesc = dspAdjusterDesc;
	}
	public String getDspPayee() {
		return dspPayee;
	}
	public void setDspPayee(String dspPayee) {
		this.dspPayee = dspPayee;
	}
	public String getDspCurrShortname() {
		return dspCurrShortname;
	}
	public void setDspCurrShortname(String dspCurrShortname) {
		this.dspCurrShortname = dspCurrShortname;
	}
	public BigDecimal getDspDiscount() {
		return dspDiscount;
	}
	public void setDspDiscount(BigDecimal dspDiscount) {
		this.dspDiscount = dspDiscount;
	}
	public BigDecimal getDeductible() {
		return deductible;
	}
	public void setDeductible(BigDecimal deductible) {
		this.deductible = deductible;
	}
	public BigDecimal getTotEstCos() {
		return totEstCos;
	}
	public void setTotEstCos(BigDecimal totEstCos) {
		this.totEstCos = totEstCos;
	}
	public BigDecimal getTotErc() {
		return totErc;
	}
	public void setTotErc(BigDecimal totErc) {
		this.totErc = totErc;
	}
	
	public BigDecimal getTotInl() {
		return totInl;
	}
	public void setTotInl(BigDecimal totInl) {
		this.totInl = totInl;
	}
	public String getDspReportTypeDesc() {
		return dspReportTypeDesc;
	}
	public void setDspReportTypeDesc(String dspReportTypeDesc) {
		this.dspReportTypeDesc = dspReportTypeDesc;
	}
	public String getDspEvalDesc() {
		return dspEvalDesc;
	}
	public void setDspEvalDesc(String dspEvalDesc) {
		this.dspEvalDesc = dspEvalDesc;
	}
	public BigDecimal getReplaceGross() {
		return replaceGross;
	}
	public void setReplaceGross(BigDecimal replaceGross) {
		this.replaceGross = replaceGross;
	}
	public BigDecimal getRepairGross() {
		return repairGross;
	}
	public void setRepairGross(BigDecimal repairGross) {
		this.repairGross = repairGross;
	}
	/**
	 * @param totInp the totInp to set
	 */
	public void setTotInp(BigDecimal totInp) {
		this.totInp = totInp;
	}
	/**
	 * @return the totInp
	 */
	public BigDecimal getTotInp() {
		return totInp;
	}
	/**
	 * @param repairAmt the repairAmt to set
	 */
	public void setRepairAmt(BigDecimal repairAmt) {
		this.repairAmt = repairAmt;
	}
	/**
	 * @return the repairAmt
	 */
	public BigDecimal getRepairAmt() {
		return repairAmt;
	}
	/**
	 * @param evalStatCd the evalStatCd to set
	 */
	public void setEvalStatCd(String evalStatCd) {
		this.evalStatCd = evalStatCd;
	}
	/**
	 * @return the evalStatCd
	 */
	public String getEvalStatCd() {
		return evalStatCd;
	}
	/**
	 * @param varPayeeTypeCdGiclReplace the varPayeeTypeCdGiclReplace to set
	 */
	public void setVarPayeeTypeCdGiclReplace(String varPayeeTypeCdGiclReplace) {
		this.varPayeeTypeCdGiclReplace = varPayeeTypeCdGiclReplace;
	}
	/**
	 * @return the varPayeeTypeCdGiclReplace
	 */
	public String getVarPayeeTypeCdGiclReplace() {
		return varPayeeTypeCdGiclReplace;
	}
	/**
	 * @param varPayeeCdGiclReplace the varPayeeCdGiclReplace to set
	 */
	public void setVarPayeeCdGiclReplace(Integer varPayeeCdGiclReplace) {
		this.varPayeeCdGiclReplace = varPayeeCdGiclReplace;
	}
	/**
	 * @return the varPayeeCdGiclReplace
	 */
	public Integer getVarPayeeCdGiclReplace() {
		return varPayeeCdGiclReplace;
	}
	/**
	 * @param masterReportType the masterReportType to set
	 */
	public void setMasterReportType(String masterReportType) {
		this.masterReportType = masterReportType;
	}
	/**
	 * @return the masterReportType
	 */
	public String getMasterReportType() {
		return masterReportType;
	}
	/**
	 * @param mainEvalVatExist the mainEvalVatExist to set
	 */
	public void setMainEvalVatExist(String mainEvalVatExist) {
		this.mainEvalVatExist = mainEvalVatExist;
	}
	/**
	 * @return the mainEvalVatExist
	 */
	public String getMainEvalVatExist() {
		return mainEvalVatExist;
	}
	
	
	
	
	
}
