package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISReportsAging extends BaseEntity {
	
	private String reportId;
	private String branchCd;
	private Integer columnNo;
	private String columnTitle;
	private Integer minDays;
	private Integer maxDays;
	private String branchName;
	
	public String getReportId() {
		return reportId;
	}
	public void setReportId(String reportId) {
		this.reportId = reportId;
	}
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	public Integer getColumnNo() {
		return columnNo;
	}
	public void setColumnNo(Integer columnNo) {
		this.columnNo = columnNo;
	}
	public String getColumnTitle() {
		return columnTitle;
	}
	public void setColumnTitle(String columnTitle) {
		this.columnTitle = columnTitle;
	}
	public Integer getMinDays() {
		return minDays;
	}
	public void setMinDays(Integer minDays) {
		this.minDays = minDays;
	}
	public Integer getMaxDays() {
		return maxDays;
	}
	public void setMaxDays(Integer maxDays) {
		this.maxDays = maxDays;
	}
	public String getBranchName() {
		return branchName;
	}
	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}

}
