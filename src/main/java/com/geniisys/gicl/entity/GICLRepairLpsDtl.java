/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.entity
	File Name: GICLRepairLpsDtl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 28, 2012
	Description: 
*/


package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLRepairLpsDtl extends BaseEntity{
	private Integer evalId;
	private String lossExpCd;
	private String tinsmithType;
	private Integer itemNo;
	private String updateSw;
	private String repairCd;
	private BigDecimal amount;
	
	// custom attributes
	private String tinsmithRepairCd;
	private BigDecimal tinsmithAmount;
	private String paintingsRepairCd;
	private BigDecimal paintingsAmount;
	private String dspLossDesc;
	private BigDecimal totalAmount;
	private String tinsmithTypeDesc;
	private Integer evalMasterId;
	private String masterReportType;
	
	
	
	/**
	 * @return the evalMasterId
	 */
	public Integer getEvalMasterId() {
		return evalMasterId;
	}
	/**
	 * @param evalMasterId the evalMasterId to set
	 */
	public void setEvalMasterId(Integer evalMasterId) {
		this.evalMasterId = evalMasterId;
	}
	/**
	 * @return the masterReportType
	 */
	public String getMasterReportType() {
		return masterReportType;
	}
	/**
	 * @param masterReportType the masterReportType to set
	 */
	public void setMasterReportType(String masterReportType) {
		this.masterReportType = masterReportType;
	}
	public Integer getEvalId() {
		return evalId;
	}
	public void setEvalId(Integer evalId) {
		this.evalId = evalId;
	}
	public String getLossExpCd() {
		return lossExpCd;
	}
	public void setLossExpCd(String lossExpCd) {
		this.lossExpCd = lossExpCd;
	}
	public String getTinsmithType() {
		return tinsmithType;
	}
	public void setTinsmithType(String tinsmithType) {
		this.tinsmithType = tinsmithType;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public String getUpdateSw() {
		return updateSw;
	}
	public void setUpdateSw(String updateSw) {
		this.updateSw = updateSw;
	}
	public String getRepairCd() {
		return repairCd;
	}
	public void setRepairCd(String repairCd) {
		this.repairCd = repairCd;
	}
	public BigDecimal getAmount() {
		return amount;
	}
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	public String getTinsmithRepairCd() {
		return tinsmithRepairCd;
	}
	public void setTinsmithRepairCd(String tinsmithRepairCd) {
		this.tinsmithRepairCd = tinsmithRepairCd;
	}
	public BigDecimal getTinsmithAmount() {
		return tinsmithAmount;
	}
	public void setTinsmithAmount(BigDecimal tinsmithAmount) {
		this.tinsmithAmount = tinsmithAmount;
	}
	
	public BigDecimal getPaintingsAmount() {
		return paintingsAmount;
	}
	public void setPaintingsAmount(BigDecimal paintingsAmount) {
		this.paintingsAmount = paintingsAmount;
	}
	/**
	 * @param lossExpDesc the lossExpDesc to set
	 */
	
	/**
	 * @param totalAmount the totalAmount to set
	 */
	public void setTotalAmount(BigDecimal totalAmount) {
		this.totalAmount = totalAmount;
	}
	public String getDspLossDesc() {
		return dspLossDesc;
	}
	public void setDspLossDesc(String dspLossDesc) {
		this.dspLossDesc = dspLossDesc;
	}
	/**
	 * @return the totalAmount
	 */
	public BigDecimal getTotalAmount() {
		return totalAmount;
	}
	/**
	 * @param tinsmithTypeDesc the tinsmithTypeDesc to set
	 */
	public void setTinsmithTypeDesc(String tinsmithTypeDesc) {
		this.tinsmithTypeDesc = tinsmithTypeDesc;
	}
	/**
	 * @return the tinsmithTypeDesc
	 */
	public String getTinsmithTypeDesc() {
		return tinsmithTypeDesc;
	}
	/**
	 * @param paintingsRepairCd the paintingsRepairCd to set
	 */
	public void setPaintingsRepairCd(String paintingsRepairCd) {
		this.paintingsRepairCd = paintingsRepairCd;
	}
	/**
	 * @return the paintingsRepairCd
	 */
	public String getPaintingsRepairCd() {
		return paintingsRepairCd;
	}
	
}


