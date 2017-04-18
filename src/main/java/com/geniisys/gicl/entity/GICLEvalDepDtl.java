/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.entity
	File Name: GICLEvalDepDtlController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Apr 10, 2012
	Description: 
*/


package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLEvalDepDtl extends BaseEntity{
	
	private Integer evalId;
	private String payeeTypeCd;
	private Integer payeeCd;
	private BigDecimal dedAmt;
	private BigDecimal dedRt;
	private String lossExpCd;
	private Integer itemNo;
	private String remarks;
	
	// attributes not found in the table
	private String partType;
	private BigDecimal partAmt;
	private String partDesc;
	
	/**
	 * @return the partType
	 */
	public String getPartType() {
		return partType;
	}
	/**
	 * @param partType the partType to set
	 */
	public void setPartType(String partType) {
		this.partType = partType;
	}
	/**
	 * @return the partAmt
	 */
	public BigDecimal getPartAmt() {
		return partAmt;
	}
	/**
	 * @param partAmt the partAmt to set
	 */
	public void setPartAmt(BigDecimal partAmt) {
		this.partAmt = partAmt;
	}
	/**
	 * @return the partDesc
	 */
	public String getPartDesc() {
		return partDesc;
	}
	/**
	 * @param partDesc the partDesc to set
	 */
	public void setPartDesc(String partDesc) {
		this.partDesc = partDesc;
	}
	/**
	 * @return the evalId
	 */
	public Integer getEvalId() {
		return evalId;
	}
	/**
	 * @param evalId the evalId to set
	 */
	public void setEvalId(Integer evalId) {
		this.evalId = evalId;
	}
	/**
	 * @return the payeeTypeCd
	 */
	public String getPayeeTypeCd() {
		return payeeTypeCd;
	}
	/**
	 * @param payeeTypeCd the payeeTypeCd to set
	 */
	public void setPayeeTypeCd(String payeeTypeCd) {
		this.payeeTypeCd = payeeTypeCd;
	}
	/**
	 * @return the payeeCd
	 */
	public Integer getPayeeCd() {
		return payeeCd;
	}
	/**
	 * @param payeeCd the payeeCd to set
	 */
	public void setPayeeCd(Integer payeeCd) {
		this.payeeCd = payeeCd;
	}
	/**
	 * @return the dedAmt
	 */
	public BigDecimal getDedAmt() {
		return dedAmt;
	}
	/**
	 * @param dedAmt the dedAmt to set
	 */
	public void setDedAmt(BigDecimal dedAmt) {
		this.dedAmt = dedAmt;
	}
	/**
	 * @return the dedRt
	 */
	public BigDecimal getDedRt() {
		return dedRt;
	}
	/**
	 * @param dedRt the dedRt to set
	 */
	public void setDedRt(BigDecimal dedRt) {
		this.dedRt = dedRt;
	}
	/**
	 * @return the lossExpCd
	 */
	public String getLossExpCd() {
		return lossExpCd;
	}
	/**
	 * @param lossExpCd the lossExpCd to set
	 */
	public void setLossExpCd(String lossExpCd) {
		this.lossExpCd = lossExpCd;
	}
	/**
	 * @return the itemNo
	 */
	public Integer getItemNo() {
		return itemNo;
	}
	/**
	 * @param itemNo the itemNo to set
	 */
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	/**
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}
	/**
	 * @param remarks the remarks to set
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	
}