package com.geniisys.common.entity;

import com.geniisys.framework.util.BaseEntity;

public class BaseFile extends BaseEntity{

	private String fileName;
	private String filePath;
	private String fileSize;
	
	public BaseFile(){
		
	}

	public BaseFile(String fileName, String filePath, String fileSize) {
		super();
		this.fileName = fileName;
		this.filePath = filePath;
		this.setFileSize(fileSize);
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}

	public String getFileSize() {
		return fileSize;
	}		
	
}
