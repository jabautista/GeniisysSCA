package com.geniisys.common.entity;
	
public class GIISReportParameter{
	private String title;
	private String text;
	private String lineCd;
	private String remarks;
	private String userId;
	private String lastUpdate;
	private String reportId;
	private String cpiBranchCd;
	private Integer cpiRecNo;
	
	public GIISReportParameter(){
		super();
	}
	
	public GIISReportParameter(String title, String text, String lineCd,
			String remarks, String userId, String lastUpdate, String reportId,
			String cpiBranchCd, Integer cpiRecNo) {
		super();
		this.title = title;
		this.text = text;
		this.lineCd = lineCd;
		this.remarks = remarks;
		this.userId = userId;
		this.lastUpdate = lastUpdate;
		this.reportId = reportId;
		this.cpiBranchCd = cpiBranchCd;
		this.cpiRecNo = cpiRecNo;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
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
	public String getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(String lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	public String getReportId() {
		return reportId;
	}
	public void setReportId(String reportId) {
		this.reportId = reportId;
	}
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}	
}
