/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIQuotePictures.
 */
public class GIPIQuotePictures extends BaseEntity {

	/** The quote id. */
	private int quoteId;
	
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
	 * Instantiates a new gIPI quote pictures.
	 */
	public GIPIQuotePictures() {

	}

	/**
	 * Instantiates a new gIPI quote pictures.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 */
	public GIPIQuotePictures(int quoteId, Integer itemNo) {
		this.quoteId = quoteId;
		this.itemNo = itemNo;
	}

	/**
	 * Instantiates a new gIPI quote pictures.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @param fileName the file name
	 */
	public GIPIQuotePictures(int quoteId, Integer itemNo, String fileName) {
		this.quoteId = quoteId;
		this.itemNo = itemNo;
		this.fileName = fileName;
	}

	/**
	 * Instantiates a new gIPI quote pictures.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @param fileName the file name
	 * @param fileType the file type
	 * @param fileExt the file ext
	 * @param remarks the remarks
	 * @param userId the user id
	 */
	public GIPIQuotePictures(int quoteId, Integer itemNo, String fileName,
			String fileType, String fileExt, String remarks, String userId) {
		this.quoteId = quoteId;
		this.itemNo = itemNo;
		this.fileName = fileName;
		this.fileType = fileType;
		this.fileExt = fileExt;
		this.remarks = remarks;
		super.setUserId(userId);
		super.setLastUpdate(new Date());
	}

	/**
	 * Gets the quote id.
	 * 
	 * @return the quote id
	 */
	public int getQuoteId() {
		return quoteId;
	}

	/**
	 * Sets the quote id.
	 * 
	 * @param quoteId the new quote id
	 */
	public void setQuoteId(int quoteId) {
		this.quoteId = quoteId;
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
