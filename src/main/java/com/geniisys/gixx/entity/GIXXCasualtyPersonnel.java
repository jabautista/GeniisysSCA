package com.geniisys.gixx.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIXXCasualtyPersonnel extends BaseEntity{

	private Integer extractId;
	private Integer itemNo;
	private Integer policyId;
	private Integer personnelNo;
	private String name;
	private String includeTag;
	private Integer capacityCd;
	private BigDecimal amountCovered;
	private String remarks;
	private String deleteSw;
	
	
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
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public Integer getPersonnelNo() {
		return personnelNo;
	}
	public void setPersonnelNo(Integer personnelNo) {
		this.personnelNo = personnelNo;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getIncludeTag() {
		return includeTag;
	}
	public void setIncludeTag(String includeTag) {
		this.includeTag = includeTag;
	}
	public Integer getCapacityCd() {
		return capacityCd;
	}
	public void setCapacityCd(Integer capacityCd) {
		this.capacityCd = capacityCd;
	}
	public BigDecimal getAmountCovered() {
		return amountCovered;
	}
	public void setAmountCovered(BigDecimal amountCovered) {
		this.amountCovered = amountCovered;
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
	
	
}
