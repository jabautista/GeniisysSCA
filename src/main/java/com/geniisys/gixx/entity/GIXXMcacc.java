package com.geniisys.gixx.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIXXMcacc extends BaseEntity {
	
	private Integer extractId;
	private Integer itemNo;
	private Integer accessoryCd;
	private BigDecimal accAmt;
	private Integer policyId;
	private String accessoryDesc;
	private BigDecimal totalAccAmt;
	
	public Integer getExtractId() {
		return extractId;
	}
	public void setExtractId(Integer extractId) {
		this.extractId = extractId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public Integer getAccessoryCd() {
		return accessoryCd;
	}
	public void setAccessoryCd(Integer accessoryCd) {
		this.accessoryCd = accessoryCd;
	}
	public BigDecimal getAccAmt() {
		return accAmt;
	}
	public void setAccAmt(BigDecimal accAmt) {
		this.accAmt = accAmt;
	}
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public String getAccessoryDesc() {
		return accessoryDesc;
	}
	public void setAccessoryDesc(String accessoryDesc) {
		this.accessoryDesc = accessoryDesc;
	}
	public BigDecimal getTotalAccAmt() {
		return totalAccAmt;
	}
	public void setTotalAccAmt(BigDecimal totalAccAmt) {
		this.totalAccAmt = totalAccAmt;
	}
	
	

}
