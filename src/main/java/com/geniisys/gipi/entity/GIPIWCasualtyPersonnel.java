package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWCasualtyPersonnel extends BaseEntity{

	private String parId;
	private String itemNo;
	private String personnelNo;
	private String personnelName;
	private String includeTag;
	private String capacityCd;
	private BigDecimal amountCovered;
	private String remarks;
	private String deleteSw;
	private String capacityDesc;
	
	public GIPIWCasualtyPersonnel(){
		
	}
	
	public GIPIWCasualtyPersonnel(final String parId, final String itemNo,
			final String personnelNo, final String personnelName,
			final String includeTag, final String capacityCd,
			final BigDecimal amountCovered, final String remarks){
		this.parId = parId;
		this.itemNo = itemNo;
		this.personnelNo = personnelNo;
		this.personnelName = personnelName;
		this.includeTag = includeTag;
		this.capacityCd = capacityCd;
		this.amountCovered = amountCovered;
		this.remarks = remarks;
	}
	
	public String getParId() {
		return parId;
	}
	public void setParId(String parId) {
		this.parId = parId;
	}
	public String getItemNo() {
		return itemNo;
	}
	public void setItemNo(String itemNo) {
		this.itemNo = itemNo;
	}
	public String getPersonnelNo() {
		return personnelNo;
	}
	public void setPersonnelNo(String personnelNo) {
		this.personnelNo = personnelNo;
	}
	public String getPersonnelName() {
		return personnelName;
	}
	public void setPersonnelName(String personnelName) {
		this.personnelName = personnelName;
	}
	public String getIncludeTag() {
		return includeTag;
	}
	public void setIncludeTag(String includeTag) {
		this.includeTag = includeTag;
	}
	public String getCapacityCd() {
		return capacityCd;
	}
	public void setCapacityCd(String capacityCd) {
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
	public String getCapacityDesc() {
		return capacityDesc;
	}
	public void setCapacityDesc(String capacityDesc) {
		this.capacityDesc = capacityDesc;
	}
}
