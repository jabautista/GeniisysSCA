package com.geniisys.gixx.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIXXMortgagee extends BaseEntity{

	private Integer extractId;
	private Integer itemNo;
	private String issCd;
	private String mortgCd;
	private String mortgName;
	private BigDecimal amount;
	private BigDecimal totalAmount;
	private String remarks;
	private String deleteSw;
	private Integer policyId;
	private Integer dspItemNo;
	
	
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
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public String getMortgCd() {
		return mortgCd;
	}
	public void setMortgCd(String mortgCd) {
		this.mortgCd = mortgCd;
	}
	public String getMortgName() {
		return mortgName;
	}
	public void setMortgName(String mortgName) {
		this.mortgName = mortgName;
	}
	public BigDecimal getAmount() {
		return amount;
	}
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	public BigDecimal getTotalAmount() {
		return totalAmount;
	}
	public void setTotalAmount(BigDecimal totalAmount) {
		this.totalAmount = totalAmount;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getDeleteSw() {
		return deleteSw;
	}
	public void setDeleteSw(String deleteSw) {
		this.deleteSw = deleteSw;
	}
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public Integer getDspItemNo() {
		return dspItemNo;
	}
	public void setDspItemNo(Integer dspItemNo) {
		this.dspItemNo = dspItemNo;
	}
	
	
}
