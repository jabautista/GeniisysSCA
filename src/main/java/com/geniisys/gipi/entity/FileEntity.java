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
 * The Class FileEntity.
 */
public class FileEntity extends BaseEntity{

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
	
	/** The pol file name. */
	private String polFileName;
	
	/** The arc ext data. */
	private String arcExtData;
	
	/** Sketch tag */
	private String sketchTag;

	/**
	 * Instantiates a new file entity.
	 */
	public FileEntity() {
		
	}

	/**
	 * Instantiates a new file entity.
	 * 
	 * @param id the id
	 * @param itemNo the item no
	 * @param fileName the file name
	 * @param fileType the file type
	 * @param fileExt the file ext
	 * @param remarks the remarks
	 * @param polFileName the pol file name
	 * @param arcExtData the arc ext data
	 */
	public FileEntity(int id, int itemNo, String fileName, String fileType,
			String fileExt, String remarks, String polFileName, String arcExtData, String sketchTag) {
		super();
		this.setId(id);
		this.itemNo = itemNo;
		this.fileName = fileName;
		this.fileType = fileType;
		this.fileExt = fileExt;
		this.remarks = remarks;
		this.setPolFileName(polFileName);
		this.setArcExtData(arcExtData);
		this.sketchTag = sketchTag;
	}	
	
	/**
	 * Gets the item no.
	 * 
	 * @return the item no
	 */
	public int getItemNo() {
		return itemNo;
	}

	/**
	 * Sets the item no.
	 * 
	 * @param itemNo the new item no
	 */
	public void setItemNo(int itemNo) {
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

	/**
	 * Sets the id.
	 * 
	 * @param id the new id
	 */
	public void setId(int id) {
		this.id = id;
	}

	/**
	 * Gets the id.
	 * 
	 * @return the id
	 */
	public int getId() {
		return id;
	}

	/**
	 * Sets the pol file name.
	 * 
	 * @param polFileName the new pol file name
	 */
	public void setPolFileName(String polFileName) {
		this.polFileName = polFileName;
	}

	/**
	 * Gets the pol file name.
	 * 
	 * @return the pol file name
	 */
	public String getPolFileName() {
		return polFileName;
	}

	/**
	 * Sets the arc ext data.
	 * 
	 * @param arcExtData the new arc ext data
	 */
	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}

	/**
	 * Gets the arc ext data.
	 * 
	 * @return the arc ext data
	 */
	public String getArcExtData() {
		return arcExtData;
	}
	
	/**
	 * Sets sketchTag
	 * @param sketchTag : Y or N
	 */
	public void setSketchTag(String sketchTag) {
		this.sketchTag = sketchTag;
	}
	
	/**
	 * Returns sketchTag
	 */
	public String getSketchTag() {
		return this.sketchTag;
	}
	
}
