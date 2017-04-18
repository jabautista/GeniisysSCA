/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Oct 14, 2010
 ***************************************************/
package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLClaimLossExpense extends BaseEntity{
	
	private Integer 	adviceId;
	private BigDecimal	adviceAmount;
	private String		cancelSw;
	private Integer		claimId;
	private Integer		claimClmntNo;
	private Integer 	claimLossId;
	private String		cpiBranchCode;
	private Integer		cpiRecNo;
	private Integer 	currencyCode;
	private BigDecimal	currencyRate;
	private String		distSw;
	private Integer 	distributionType;
	private String		exGratiaSw;
	private String		finalTag;
	private Integer		groupedItemNo;
	private String		historySequenceNumber;
	private Integer		itemNo;
	private String		itemStatusCd;
	private BigDecimal	netAmount;
	private BigDecimal 	paidAmount;
	private String		payeeCode;
	private String		payeeClassCode;
	private	String		payeeType;
	private Integer		perilCode;
	private String		remarks;
	private Date		tranDate;
	private Integer 	tranId;
	
	// the following fields are not included in the Table Columns - they are only added for reusability
	private String 	payeeTypeDescription;
	private String 	payee;
	private String 	perilSname;
	private BigDecimal disbursementAmount;
	private String clmLossExpStatDesc;
	
	private String 	payeeClassDesc;
	private String  payeeLastName;
	private String  checkNo;
	private Date 	checkDate;
	private String  csrNo;		
	private String  withLossExpDtl;
	private String  withLossExpTax;
	private String  withLossExpDs;
	private String  withLossExpDsNotNegated;
	private String  withGiclAdvice;
	private String  withEvalPayment;
	private String  withDepreciation;
	
	private BigDecimal whTax;
	private BigDecimal evat;
	
	public String getPayee(){
		return payee;
	}
	
	public void setPayee(String payee){
		this.payee = payee;
	}

	public Integer getAdviceId(){
		return adviceId;
	}

	public void setAdviceId(Integer adviceId){
		this.adviceId = adviceId;
	}

	public BigDecimal getAdviceAmount(){
		return adviceAmount;
	}

	public void setAdviceAmount(BigDecimal adviceAmount){
		this.adviceAmount = adviceAmount;
	}

	public String getCancelSw(){
		return cancelSw;
	}

	public void setCancelSw(String cancelSwitch){
		this.cancelSw = cancelSwitch;
	}

	public Integer getClaimId(){
		return claimId;
	}

	public void setClaimId(Integer claimId){
		this.claimId = claimId;
	}

	public Integer getClaimClmntNo(){
		return claimClmntNo;
	}

	public void setClaimClmntNo(Integer claimClmntNo){
		this.claimClmntNo = claimClmntNo;
	}

	public String getPayeeTypeDescription(){
		return payeeTypeDescription;
	}

	public void setPayeeTypeDescription(String payeeTypeDescription){
		this.payeeTypeDescription = payeeTypeDescription;
	}
	
	public GICLClaimLossExpense(){
		currencyRate = new BigDecimal(0);
		netAmount = new BigDecimal(0);
		paidAmount = new BigDecimal(0);
	}
	
	public Integer getClaimLossId(){
		return claimLossId;
	}
	
	public void setClaimLossId(Integer claimLossId){
		this.claimLossId = claimLossId;
	}
	
	public String getCpiBranchCode(){
		return cpiBranchCode;
	}
	
	public void setCpiBranchCode(String cpiBranchCode){
		this.cpiBranchCode = cpiBranchCode;
	}
	
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	
	public void setCpiRecNo(Integer cpiRecNo){
		this.cpiRecNo = cpiRecNo;
	}
	
	public Integer getCurrencyCode(){
		return currencyCode;
	}
	
	public void setCurrencyCode(Integer currencyCode){
		this.currencyCode = currencyCode;
	}
	
	public BigDecimal getCurrencyRate(){
		return currencyRate;
	}
	
	public void setCurrencyRate(BigDecimal currencyRate){
		this.currencyRate = currencyRate;
	}
	
	public String getDistSw(){
		return distSw;
	}
	
	public void setDistSw(String distSw){
		this.distSw = distSw;
	}
	
	public Integer getDistributionType(){
		return distributionType;
	}
	
	public void setDistributionType(Integer distType) {
		this.distributionType = distType;
	}
	
	public String getExGratiaSw() {
		return exGratiaSw;
	}
	
	public void setExGratiaSw(String exGratiaSw) {
		this.exGratiaSw = exGratiaSw;
	}
	
	public String getFinalTag() {
		return finalTag;
	}
	
	public void setFinalTag(String finalTag) {
		this.finalTag = finalTag;
	}
	
	public Integer getGroupedItemNo() {
		return groupedItemNo;
	}
	
	public void setGroupedItemNo(Integer groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}
	
	public String getHistorySequenceNumber() {
		return historySequenceNumber;
	}
	
	public void setHistorySequenceNumber(String historySequenceNumber) {
		this.historySequenceNumber = historySequenceNumber;
	}
	
	public Integer getItemNo() {
		return itemNo;
	}
	
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	
	public String getItemStatusCd() {
		return itemStatusCd;
	}
	
	public void setItemStatusCd(String itemStatusCd) {
		this.itemStatusCd = itemStatusCd;
	}
	
	public BigDecimal getNetAmount() {
		return netAmount;
	}
	
	public void setNetAmount(BigDecimal netAmount) {
		this.netAmount = netAmount;
	}
	
	public BigDecimal getPaidAmount() {
		return paidAmount;
	}
	
	public void setPaidAmount(BigDecimal paidAmount) {
		this.paidAmount = paidAmount;
	}
	
	public String getPayeeCode() {
		return payeeCode;
	}
	
	public void setPayeeCode(String payeeCode) {
		this.payeeCode = payeeCode;
	}
	
	public String getPayeeClassCode() {
		return payeeClassCode;
	}
	
	public void setPayeeClassCode(String payeeClassCode) {
		this.payeeClassCode = payeeClassCode;
	}
	
	public String getPayeeType() {
		return payeeType;
	}
	
	public void setPayeeType(String payeeType) {
		this.payeeType = payeeType;
	}
	
	public Integer getPerilCode() {
		return perilCode;
	}
	
	public void setPerilCode(Integer perilCode) {
		this.perilCode = perilCode;
	}
	
	public String getRemarks() {
		return remarks;
	}
	
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	public Date getTranDate() {
		return tranDate;
	}
	
	public void setTranDate(Date tranDate) {
		this.tranDate = tranDate;
	}
	
	public Integer getTranId() {
		return tranId;
	}
	
	public void setTranId(Integer tranId) {
		this.tranId = tranId;
	}

	/**
	 * @param perilSname the perilSname to set
	 */
	public void setPerilSname(String perilSname) {
		this.perilSname = perilSname;
	}

	/**
	 * @return the perilSname
	 */
	public String getPerilSname() {
		return perilSname;
	}

	/**
	 * @param disbursementAmount the disbursementAmount to set
	 */
	public void setDisbusementAmount(BigDecimal disbursementAmount) {
		this.disbursementAmount = disbursementAmount;
	}

	/**
	 * @return the disbursementAmount
	 */
	public BigDecimal getDisbusementAmount() {
		return disbursementAmount;
	}
	
	public void setClmLossExpStatDesc(String clmLossExpStatDesc) {
		this.clmLossExpStatDesc = clmLossExpStatDesc;
	}

	public String getClmLossExpStatDesc() {
		return clmLossExpStatDesc;
	}

	public void setPayeeClassDesc(String payeeClassDesc) {
		this.payeeClassDesc = payeeClassDesc;
	}

	public String getPayeeClassDesc() {
		return payeeClassDesc;
	}

	public String getCheckNo() {
		return checkNo;
	}

	public void setCheckNo(String checkNo) {
		this.checkNo = checkNo;
	}

	public Date getCheckDate() {
		return checkDate;
	}

	public void setCheckDate(Date checkDate) {
		this.checkDate = checkDate;
	}

	public String getCsrNo() {
		return csrNo;
	}

	public void setCsrNo(String csrNo) {
		this.csrNo = csrNo;
	}

	public void setPayeeLastName(String payeeLastName) {
		this.payeeLastName = payeeLastName;
	}

	public String getPayeeLastName() {
		return payeeLastName;
	}

	public void setWithLossExpDtl(String withLossExpDtl) {
		this.withLossExpDtl = withLossExpDtl;
	}

	public String getWithLossExpDtl() {
		return withLossExpDtl;
	}

	public BigDecimal getDisbursementAmount() {
		return disbursementAmount;
	}

	public void setDisbursementAmount(BigDecimal disbursementAmount) {
		this.disbursementAmount = disbursementAmount;
	}

	public String getWithLossExpTax() {
		return withLossExpTax;
	}

	public void setWithLossExpTax(String withLossExpTax) {
		this.withLossExpTax = withLossExpTax;
	}

	public String getWithLossExpDs() {
		return withLossExpDs;
	}

	public void setWithLossExpDs(String withLossExpDs) {
		this.withLossExpDs = withLossExpDs;
	}

	public void setWithLossExpDsNotNegated(String withLossExpDsNotNegated) {
		this.withLossExpDsNotNegated = withLossExpDsNotNegated;
	}

	public String getWithLossExpDsNotNegated() {
		return withLossExpDsNotNegated;
	}

	public String getWithGiclAdvice() {
		return withGiclAdvice;
	}

	public void setWithGiclAdvice(String withGiclAdvice) {
		this.withGiclAdvice = withGiclAdvice;
	}

	public void setWithEvalPayment(String withEvalPayment) {
		this.withEvalPayment = withEvalPayment;
	}

	public String getWithEvalPayment() {
		return withEvalPayment;
	}

	public void setWithDepreciation(String withDepreciation) {
		this.withDepreciation = withDepreciation;
	}

	public String getWithDepreciation() {
		return withDepreciation;
	}

	public BigDecimal getWhTax() {
		return whTax;
	}

	public void setWhTax(BigDecimal whTax) {
		this.whTax = whTax;
	}

	public BigDecimal getEvat() {
		return evat;
	}

	public void setEvat(BigDecimal evat) {
		this.evat = evat;
	}

}