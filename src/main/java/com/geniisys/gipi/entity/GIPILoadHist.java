package com.geniisys.gipi.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPILoadHist extends BaseEntity{

	private String uploadNo;
	private String filename;
	private String parId;
	private Date dateLoaded;
	private String noOfRecords;
	private String userId;
	private Date lastUpdate;
	
	public String getUploadNo() {
		return uploadNo;
	}
	public void setUploadNo(String uploadNo) {
		this.uploadNo = uploadNo;
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public String getParId() {
		return parId;
	}
	public void setParId(String parId) {
		this.parId = parId;
	}
	public Date getDateLoaded() {
		return dateLoaded;
	}
	public void setDateLoaded(Date dateLoaded) {
		this.dateLoaded = dateLoaded;
	}
	public String getNoOfRecords() {
		return noOfRecords;
	}
	public void setNoOfRecords(String noOfRecords) {
		this.noOfRecords = noOfRecords;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public Date getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	
}
