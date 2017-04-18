package com.geniisys.gicl.entity;

import com.geniisys.giis.entity.BaseEntity;



public class GICLReportDocument extends BaseEntity {
	
	private String reportId;
	private String reportName;
	private String remarks;
	private String userId;
	private Integer reportNo;
	private String lineCd;
	private String lineName;
	private String documentTag;
	private String branchCd;
	private String branchName;
	private String documentCd;
	private String documentName;
	
	public String getReportId() {
		return reportId;
	}
	public void setReportId(String reportId) {
		this.reportId = reportId;
	}
	public String getReportName() {
		return reportName;
	}
	public void setReportName(String reportName) {
		this.reportName = reportName;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public Integer getReportNo() {
		return reportNo;
	}
	public void setReportNo(Integer reportNo) {
		this.reportNo = reportNo;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getDocumentTag() {
		return documentTag;
	}
	public void setDocumentTag(String documentTag) {
		this.documentTag = documentTag;
	}
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	public String getDocumentCd() {
		return documentCd;
	}
	public void setDocumentCd(String documentCd) {
		this.documentCd = documentCd;
	}
	public String getLineName() {
		return lineName;
	}
	public void setLineName(String lineName) {
		this.lineName = lineName;
	}
	public String getBranchName() {
		return branchName;
	}
	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}
	public String getDocumentName() {
		return documentName;
	}
	public void setDocumentName(String documentName) {
		this.documentName = documentName;
	}
}
