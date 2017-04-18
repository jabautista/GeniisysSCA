package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPICasualtyPersonnel extends BaseEntity{

	private Integer policyId;		
	private Integer itemNo;		
	private Integer personnelNo;		
	private String name;		
	private String includeTag;		
	private Integer capacityCd;		
	private BigDecimal amountCovered;		
	private String remarks;		
	private Integer cpiRecNo;		
	private String cpiBranchCd;		
	private String deleteSw;		
	private String arcExtData;
	
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
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
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	public String getDeleteSw() {
		return deleteSw;
	}
	public void setDeleteSw(String deleteSw) {
		this.deleteSw = deleteSw;
	}
	public String getArcExtData() {
		return arcExtData;
	}
	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}		
	
	

}
