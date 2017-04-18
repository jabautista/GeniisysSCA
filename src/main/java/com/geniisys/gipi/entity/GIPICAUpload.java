package com.geniisys.gipi.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPICAUpload extends BaseEntity{
	
	private Integer uploadNo;
	private String fileName;
	private Date uploadDate;
	
	public Integer getUploadNo() {
		return uploadNo;
	}
	
	public void setUploadNo(Integer uploadNo) {
		this.uploadNo = uploadNo;
	}
	
	public String getFileName() {
		return fileName;
	}
	
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	public Date getUploadDate() {
		return uploadDate;
	}
	
	public void setUploadDate(Date uploadDate) {
		this.uploadDate = uploadDate;
	}
}