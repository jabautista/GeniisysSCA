package com.geniisys.gicl.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GICLRepSignatory extends BaseEntity{

	private String reportId;
	private Integer itemNo;
	private String label;
	private Integer signatoryId;
	private String remarks;
	private String userId;
	private String lastUpdate;
	private String snameFlag;
	private Integer reportNo;
	
	public String getReportId() {
		return reportId;
	}
	public void setReportId(String reportId) {
		this.reportId = reportId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public String getLabel() {
		return label;
	}
	public void setLabel(String label) {
		this.label = label;
	}
	public Integer getSignatoryId() {
		return signatoryId;
	}
	public void setSignatoryId(Integer signatoryId) {
		this.signatoryId = signatoryId;
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
	public String getSnameFlag() {
		return snameFlag;
	}
	public void setSnameFlag(String snameFlag) {
		this.snameFlag = snameFlag;
	}
	public Integer getReportNo() {
		return reportNo;
	}
	public void setReportNo(Integer reportNo) {
		this.reportNo = reportNo;
	}
}
