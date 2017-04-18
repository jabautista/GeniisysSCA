package com.geniisys.giis.entity;


public class GIISSignatoryNames extends BaseEntity{
	
	private Integer signatoryId;
	private String signatory;
	private String status;
	private String designation;
	private String resCertNo;
	private String resCertDate;
	private String resCertPlace;
	private String remarks;
	private String fileName;
	private String statusMean;
	private Integer recordStatus;
	
	public GIISSignatoryNames(){
		
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getDesignation() {
		return designation;
	}

	public void setDesignation(String designation) {
		this.designation = designation;
	}

	public String getResCertNo() {
		return resCertNo;
	}

	public void setResCertNo(String resCertNo) {
		this.resCertNo = resCertNo;
	}

	public String getResCertDate() {
		return resCertDate;
	}

	public void setResCertDate(String resCertDate) {
		this.resCertDate = resCertDate;
	}

	public String getResCertPlace() {
		return resCertPlace;
	}

	public void setResCertPlace(String resCertPlace) {
		this.resCertPlace = resCertPlace;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getStatusMean() {
		return statusMean;
	}

	public void setStatusMean(String statusMean) {
		this.statusMean = statusMean;
	}

	public Integer getRecordStatus() {
		return recordStatus;
	}

	public void setRecordStatus(Integer recordStatus) {
		this.recordStatus = recordStatus;
	}

}
