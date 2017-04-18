package com.geniisys.giis.entity;

import com.geniisys.framework.util.BaseEntity;
public class GIISSignatory extends BaseEntity{
	
	private String reportId;
	private String reportTitle;
	private String issCd;
	private String issName;
	private String lineCd;
	private String lineName;
	private String currentSignatorySw;
	private Integer signatoryId;
	private String signatory;
	private String fileName;
	private String remarks;
	
	public GIISSignatory() {
		super();
	}
	
	public GIISSignatory(String reportId, String reportTitle, String issCd,
			String issName, String lineCd, String lineName,
			String currentSignatorySw, Integer signatoryId, String signatory,
			String fileName, String remarks) {
		super();
		this.reportId = reportId;
		this.reportTitle = reportTitle;
		this.issCd = issCd;
		this.issName = issName;
		this.lineCd = lineCd;
		this.lineName = lineName;
		this.currentSignatorySw = currentSignatorySw;
		this.signatoryId = signatoryId;
		this.signatory = signatory;
		this.fileName = fileName;
		this.remarks = remarks;
	}

	public String getReportId() {
		return reportId;
	}
	public void setReportId(String reportId) {
		this.reportId = reportId;
	}
	public String getReportTitle() {
		return reportTitle;
	}
	public void setReportTitle(String reportTitle) {
		this.reportTitle = reportTitle;
	}
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public String getIssName() {
		return issName;
	}
	public void setIssName(String issName) {
		this.issName = issName;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getLineName() {
		return lineName;
	}
	public void setLineName(String lineName) {
		this.lineName = lineName;
	}
	public String getCurrentSignatorySw() {
		return currentSignatorySw;
	}
	public void setCurrentSignatorySw(String currentSignatorySw) {
		this.currentSignatorySw = currentSignatorySw;
	}
	public Integer getSignatoryId() {
		return signatoryId;
	}
	public void setSignatoryId(Integer signatoryId) {
		this.signatoryId = signatoryId;
	}
	public String getSignatory() {
		return signatory;
	}
	public void setSignatory(String signatory) {
		this.signatory = signatory;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

}
