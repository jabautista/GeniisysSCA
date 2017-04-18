package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACAgingParameters extends BaseEntity{
	
	private Integer agingId;
	private String gibrGfunFundCd;
	private String fundDesc;
	private String gibrBranchCd;
	private String branchName;
	private Integer columnNo;
	private String columnHeading;
	private Integer minNoDays;
	private Integer maxNoDays;
	private String overDueTag;
	private Integer repColNo;
	private String usedId;
	private String lastUpdate;
	private String remarks;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	
	public Integer getAgingId() {
		return agingId;
	}
	public void setAgingId(Integer agingId) {
		this.agingId = agingId;
	}
	public String getGibrGfunFundCd() {
		return gibrGfunFundCd;
	}
	public void setGibrGfunFundCd(String gibrGfunFundCd) {
		this.gibrGfunFundCd = gibrGfunFundCd;
	}
	public String getGibrBranchCd() {
		return gibrBranchCd;
	}
	public void setGibrBranchCd(String gibrBranchCd) {
		this.gibrBranchCd = gibrBranchCd;
	}
	public Integer getColumnNo() {
		return columnNo;
	}
	public void setColumnNo(Integer columnNo) {
		this.columnNo = columnNo;
	}
	public String getColumnHeading() {
		return columnHeading;
	}
	public void setColumnHeading(String columnHeading) {
		this.columnHeading = columnHeading;
	}
	public Integer getMinNoDays() {
		return minNoDays;
	}
	public void setMinNoDays(Integer minNoDays) {
		this.minNoDays = minNoDays;
	}
	public Integer getMaxNoDays() {
		return maxNoDays;
	}
	public void setMaxNoDays(Integer maxNoDays) {
		this.maxNoDays = maxNoDays;
	}
	public String getOverDueTag() {
		return overDueTag;
	}
	public void setOverDueTag(String overDueTag) {
		this.overDueTag = overDueTag;
	}
	public Integer getRepColNo() {
		return repColNo;
	}
	public void setRepColNo(Integer repColNo) {
		this.repColNo = repColNo;
	}
	public String getUsedId() {
		return usedId;
	}
	public void setUsedId(String usedId) {
		this.usedId = usedId;
	}
	public String getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(String lastUpdate) {
		this.lastUpdate = lastUpdate;
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
	public String getFundDesc() {
		return fundDesc;
	}
	public void setFundDesc(String fundDesc) {
		this.fundDesc = fundDesc;
	}
	public String getBranchName() {
		return branchName;
	}
	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}
}
