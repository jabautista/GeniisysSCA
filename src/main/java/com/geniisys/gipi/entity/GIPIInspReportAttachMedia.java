package com.geniisys.gipi.entity;

import com.geniisys.common.entity.BaseFile;

public class GIPIInspReportAttachMedia extends BaseFile {
	
	/** The id. */
	private int id;
	
	/** The item no. */
	private int itemNo;
	
	/** The file name. */
	private String fileName;
	
	/** The file type. */
	private String fileType;
	
	/** The file ext. */
	private String fileExt;
	
	/** The remarks. */
	private String remarks;
	
	/** The sketch tag. */
	private String sketchTag;

	public GIPIInspReportAttachMedia() {
		super();
	}

	/**
	 * @return the id
	 */
	public int getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(int id) {
		this.id = id;
	}

	/**
	 * @return the itemNo
	 */
	public int getItemNo() {
		return itemNo;
	}

	/**
	 * @param itemNo the itemNo to set
	 */
	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}

	/**
	 * @return the fileName
	 */
	public String getFileName() {
		return fileName;
	}

	/**
	 * @param fileName the fileName to set
	 */
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	/**
	 * @return the fileType
	 */
	public String getFileType() {
		return fileType;
	}

	/**
	 * @param fileType the fileType to set
	 */
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	/**
	 * @return the fileExt
	 */
	public String getFileExt() {
		return fileExt;
	}

	/**
	 * @param fileExt the fileExt to set
	 */
	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}

	/**
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * @param remarks the remarks to set
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	/**
	 * @return the sketchTag
	 */
	public String getSketchTag() {
		return sketchTag;
	}

	/**
	 * @param sketchTag the sketchTag to set
	 */
	public void setSketchTag(String sketchTag) {
		this.sketchTag = sketchTag;
	}
	
	

}
