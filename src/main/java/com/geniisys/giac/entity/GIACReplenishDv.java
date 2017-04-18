/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.entity
	File Name: GIACReplenishDv.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Nov 6, 2012
	Description: 
*/


package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;


import com.geniisys.framework.util.BaseEntity;

public class GIACReplenishDv  extends BaseEntity{
	private Integer replenishId;
	private String branchCd;
	private Integer replenishSeqNo;
	private BigDecimal revolvingFundAmt;
	private BigDecimal replenishmentAmt;
	private Integer replenishTranId;
	private String createBy;
	private Date createDate;
	private Integer replenishYear;
	
	// attributes that are not in the table;
	private String replenishNo;
	private String strCreateDate;
	
	//attributes for GIACS081 - added by Gzelle
	private String replenishSw;
	private String checkDate;
	private Integer dvTranId;
	private String dvNo;
	private String checkNo;
	private String requestNo;
	private Integer itemNo;
	private String payee;
	private String particulars;
	private BigDecimal amount;
	
	
	public String getReplenishSw() {
		return replenishSw;
	}
	public void setReplenishSw(String replenishSw) {
		this.replenishSw = replenishSw;
	}
	public String getCheckDate() {
		return checkDate;
	}
	public void setCheckDate(String checkDate) {
		this.checkDate = checkDate;
	}
	public Integer getDvTranId() {
		return dvTranId;
	}
	public void setDvTranId(Integer dvTranId) {
		this.dvTranId = dvTranId;
	}
	public String getDvNo() {
		return dvNo;
	}
	public void setDvNo(String dvNo) {
		this.dvNo = dvNo;
	}
	public String getCheckNo() {
		return checkNo;
	}
	public void setCheckNo(String checkNo) {
		this.checkNo = checkNo;
	}
	public String getRequestNo() {
		return requestNo;
	}
	public void setRequestNo(String requestNo) {
		this.requestNo = requestNo;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public String getPayee() {
		return payee;
	}
	public void setPayee(String payee) {
		this.payee = payee;
	}
	public String getParticulars() {
		return particulars;
	}
	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}
	public BigDecimal getAmount() {
		return amount;
	}
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	/**
	 * @return the replenishId
	 */
	public Integer getReplenishId() {
		return replenishId;
	}
	/**
	 * @param replenishId the replenishId to set
	 */
	public void setReplenishId(Integer replenishId) {
		this.replenishId = replenishId;
	}
	/**
	 * @return the branchCd
	 */
	public String getBranchCd() {
		return branchCd;
	}
	/**
	 * @param branchCd the branchCd to set
	 */
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	/**
	 * @return the replenishSeqNo
	 */
	public Integer getReplenishSeqNo() {
		return replenishSeqNo;
	}
	/**
	 * @param replenishSeqNo the replenishSeqNo to set
	 */
	public void setReplenishSeqNo(Integer replenishSeqNo) {
		this.replenishSeqNo = replenishSeqNo;
	}
	/**
	 * @return the revolvingFundAmt
	 */
	public BigDecimal getRevolvingFundAmt() {
		return revolvingFundAmt;
	}
	/**
	 * @param revolvingFundAmt the revolvingFundAmt to set
	 */
	public void setRevolvingFundAmt(BigDecimal revolvingFundAmt) {
		this.revolvingFundAmt = revolvingFundAmt;
	}
	/**
	 * @return the replenishmentAmt
	 */
	public BigDecimal getReplenishmentAmt() {
		return replenishmentAmt;
	}
	/**
	 * @param replenishmentAmt the replenishmentAmt to set
	 */
	public void setReplenishmentAmt(BigDecimal replenishmentAmt) {
		this.replenishmentAmt = replenishmentAmt;
	}
	/**
	 * @return the replenishTranId
	 */
	public Integer getReplenishTranId() {
		return replenishTranId;
	}
	/**
	 * @param replenishTranId the replenishTranId to set
	 */
	public void setReplenishTranId(Integer replenishTranId) {
		this.replenishTranId = replenishTranId;
	}
	/**
	 * @return the createBy
	 */
	public String getCreateBy() {
		return createBy;
	}
	/**
	 * @param createBy the createBy to set
	 */
	public void setCreateBy(String createBy) {
		this.createBy = createBy;
	}
	/**
	 * @return the createDate
	 */
	public Date getCreateDate() {
		return createDate;
	}
	/**
	 * @param createDate the createDate to set
	 */
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	/**
	 * @return the replenishYear
	 */
	public Integer getReplenishYear() {
		return replenishYear;
	}
	/**
	 * @param replenishYear the replenishYear to set
	 */
	public void setReplenishYear(Integer replenishYear) {
		this.replenishYear = replenishYear;
	}
	/**
	 * @return the replenishNo
	 */
	public String getReplenishNo() {
		return replenishNo;
	}
	/**
	 * @param replenishNo the replenishNo to set
	 */
	public void setReplenishNo(String replenishNo) {
		this.replenishNo = replenishNo;
	}
	/**
	 * @return the strCreateDate
	 */
	public String getStrCreateDate() {
		return strCreateDate;
	}
	/**
	 * @param strCreateDate the strCreateDate to set
	 */
	public void setStrCreateDate(String strCreateDate) {
		this.strCreateDate = strCreateDate;
	}
	

}
