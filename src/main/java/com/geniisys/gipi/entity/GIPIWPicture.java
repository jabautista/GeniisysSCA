/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import com.geniisys.framework.util.BaseEntity;

/**
 * The Class GIPIWPicture.
 */
public class GIPIWPicture extends BaseEntity {
	
	/** The PAR id. */
	private Integer parId;
	
	/** The item no. */
	private Integer itemNo;
	
	/** The file name. */
	private String fileName;
	
	/** The file type. */
	private String fileType;
	
	/** The file ext. */
	private String fileExt;
	
	/** The remarks. */
	private String remarks;
	
	/**
	 * Instantiates a new GIPIWPicture.
	 */
	public GIPIWPicture() {

	}
	
	/**
	 * Gets the PAR id.
	 * 
	 * @return the PAR id
	 */
	public Integer getParId() {
		return parId;
	}

	/**
	 * Sets the PAR id.
	 * 
	 * @param parId the new PAR id
	 */
	public void setParId(Integer parId) {
		this.parId = parId;
	}

	/**
	 * Gets the item no.
	 * 
	 * @return the item no
	 */
	public Integer getItemNo() {
		return itemNo;
	}

	/**
	 * Sets the item no.
	 * 
	 * @param itemNo the new item no
	 */
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	/**
	 * Gets the file name.
	 * 
	 * @return the file name
	 */
	public String getFileName() {
		return fileName;
	}

	/**
	 * Sets the file name.
	 * 
	 * @param fileName the new file name
	 */
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	/**
	 * Gets the file type.
	 * 
	 * @return the file type
	 */
	public String getFileType() {
		return fileType;
	}

	/**
	 * Sets the file type.
	 * 
	 * @param fileType the new file type
	 */
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	/**
	 * Gets the file ext.
	 * 
	 * @return the file ext
	 */
	public String getFileExt() {
		return fileExt;
	}

	/**
	 * Sets the file ext.
	 * 
	 * @param fileExt the new file ext
	 */
	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}

	/**
	 * Gets the remarks.
	 * 
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * Sets the remarks.
	 * 
	 * @param remarks the new remarks
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
}
