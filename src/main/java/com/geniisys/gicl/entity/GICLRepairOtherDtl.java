/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.entity
	File Name: GICLRepairOtherDtl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Apr 3, 2012
	Description: 
*/


package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLRepairOtherDtl extends BaseEntity{
	private Integer evalId;
	private String repairCd;
	private BigDecimal amount;
	private String updateSw;
	private Integer itemNo;
	
	// attributes that are not in the table
	private String repairDesc;

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
	 * @return the repairCd
	 */
	public String getRepairCd() {
		return repairCd;
	}

	/**
	 * @param repairCd the repairCd to set
	 */
	public void setRepairCd(String repairCd) {
		this.repairCd = repairCd;
	}

	/**
	 * @return the amount
	 */
	public BigDecimal getAmount() {
		return amount;
	}

	/**
	 * @param amount the amount to set
	 */
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	/**
	 * @return the updateSw
	 */
	public String getUpdateSw() {
		return updateSw;
	}

	/**
	 * @param updateSw the updateSw to set
	 */
	public void setUpdateSw(String updateSw) {
		this.updateSw = updateSw;
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
	 * @return the repairDesc
	 */
	public String getRepairDesc() {
		return repairDesc;
	}

	/**
	 * @param repairDesc the repairDesc to set
	 */
	public void setRepairDesc(String repairDesc) {
		this.repairDesc = repairDesc;
	}
	
}
