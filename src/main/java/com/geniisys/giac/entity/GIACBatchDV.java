/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.giac.entity
	File Name: GIACBatchDV.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Dec 7, 2011
	Description: 
*/


package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIACBatchDV extends BaseEntity{
	private Integer batchDvId;
	private String funcCd;
	private String branchCd;
	private Integer batchYear;
	private Integer batchMM;
	private Integer batchSeqNo;
	private String batchDate;
	private String batchFlag;
	private String payeeClassCd;
	private Integer payeeCd;
	private String particulars;
	private Integer tranId;
	private BigDecimal paidAmt;
	private Integer fcurrAmt;
	private Integer currencyCd;
	private BigDecimal convertRate;
	private String payeeRemarks;
	
	// extra attributes
	private String dspPayee;
	private String dspCurrency;
	private String dspPayeeClass;
	private String batchNo;
	private BigDecimal totalPaidAmt;
	private BigDecimal totalFcurrAmt;
	private String printDetailsSw;
	
	
	public BigDecimal getTotalPaidAmt() {
		return totalPaidAmt;
	}
	public void setTotalPaidAmt(BigDecimal totalPaidAmt) {
		this.totalPaidAmt = totalPaidAmt;
	}
	public BigDecimal getTotalFcurrAmt() {
		return totalFcurrAmt;
	}
	public void setTotalFcurrAmt(BigDecimal totalFcurrAmt) {
		this.totalFcurrAmt = totalFcurrAmt;
	}
	public String getDspPayeeClass() {
		return dspPayeeClass;
	}
	public void setDspPayeeClass(String dspPayeeClass) {
		this.dspPayeeClass = dspPayeeClass;
	}
	public String getBatchNo() {
		return batchNo;
	}
	public void setBatchNo(String batchNo) {
		this.batchNo = batchNo;
	}
	public String getDspPayee() {
		return dspPayee;
	}
	public void setDspPayee(String dspPayee) {
		this.dspPayee = dspPayee;
	}
	public String getDspCurrency() {
		return dspCurrency;
	}
	public void setDspCurrency(String dspCurrency) {
		this.dspCurrency = dspCurrency;
	}
	public String getFuncCd() {
		return funcCd;
	}
	public void setFuncCd(String funcCd) {
		this.funcCd = funcCd;
	}
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	public Integer getBatchYear() {
		return batchYear;
	}
	public void setBatchYear(Integer batchYear) {
		this.batchYear = batchYear;
	}
	public Integer getBatchMM() {
		return batchMM;
	}
	public void setBatchMM(Integer batchMM) {
		this.batchMM = batchMM;
	}
	public Integer getBatchSeqNo() {
		return batchSeqNo;
	}
	public void setBatchSeqNo(Integer batchSeqNo) {
		this.batchSeqNo = batchSeqNo;
	}
	public String getBatchDate() {
		return batchDate;
	}
	public void setBatchDate(String batchDate) {
		this.batchDate = batchDate;
	}
	public String getBatchFlag() {
		return batchFlag;
	}
	public void setBatchFlag(String batchFlag) {
		this.batchFlag = batchFlag;
	}
	public String getPayeeClassCd() {
		return payeeClassCd;
	}
	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
	}
	public Integer getPayeeCd() {
		return payeeCd;
	}
	public void setPayeeCd(Integer payeeCd) {
		this.payeeCd = payeeCd;
	}
	public String getParticulars() {
		return particulars;
	}
	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}
	public Integer getTranId() {
		return tranId;
	}
	public void setTranId(Integer tranId) {
		this.tranId = tranId;
	}
	public BigDecimal getPaidAmt() {
		return paidAmt;
	}
	public void setPaidAmt(BigDecimal paidAmt) {
		this.paidAmt = paidAmt;
	}
	public Integer getFcurrAmt() {
		return fcurrAmt;
	}
	public void setFcurrAmt(Integer fcurrAmt) {
		this.fcurrAmt = fcurrAmt;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public BigDecimal getConvertRate() {
		return convertRate;
	}
	public void setConvertRate(BigDecimal convertRate) {
		this.convertRate = convertRate;
	}
	public Integer getBatchDvId() {
		return batchDvId;
	}
	public void setBatchDvId(Integer batchDvId) {
		this.batchDvId = batchDvId;
	}
	public String getPayeeRemarks() {
		return payeeRemarks;
	}
	public void setPayeeRemarks(String payeeRemarks) {
		this.payeeRemarks = payeeRemarks;
	}
	/**
	 * @param printDetailsSw the printDetailsSw to set
	 */
	public void setPrintDetailsSw(String printDetailsSw) {
		this.printDetailsSw = printDetailsSw;
	}
	/**
	 * @return the printDetailsSw
	 */
	public String getPrintDetailsSw() {
		return printDetailsSw;
	}
	
}
