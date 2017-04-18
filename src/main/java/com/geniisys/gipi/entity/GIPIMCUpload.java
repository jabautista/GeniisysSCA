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
 * The Class GIPIMCUpload.
 */
public class GIPIMCUpload extends BaseEntity {

	/** The upload no. */
	private Integer uploadNo;
	
	/** The file name. */
	private String fileName;
	
	/** The upload date. */
	private Date uploadDate;
	
	/** The item no. */
	private Integer itemNo;
	
	/** The item title. */
	private String itemTitle;
	
	/** The motor no. */
	private String motorNo;
	
	/** The serial no. */
	private String serialNo;
	
	/** The plate no. */
	private String plateNo;
	
	/** The subline type cd. */
	private String sublineTypeCd;
	
	/**
	 * Gets the item title.
	 * 
	 * @return the item title
	 */
	public String getItemTitle() {
		return itemTitle;
	}
	
	/**
	 * Sets the item title.
	 * 
	 * @param itemTitle the new item title
	 */
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}
	
	/**
	 * Gets the subline type cd.
	 * 
	 * @return the subline type cd
	 */
	public String getSublineTypeCd() {
		return sublineTypeCd;
	}
	
	/**
	 * Sets the subline type cd.
	 * 
	 * @param sublineTypeCd the new subline type cd
	 */
	public void setSublineTypeCd(String sublineTypeCd) {
		this.sublineTypeCd = sublineTypeCd;
	}
	
	/**
	 * Gets the upload no.
	 * 
	 * @return the upload no
	 */
	public Integer getUploadNo() {
		return uploadNo;
	}
	
	/**
	 * Sets the upload no.
	 * 
	 * @param uploadNo the new upload no
	 */
	public void setUploadNo(Integer uploadNo) {
		this.uploadNo = uploadNo;
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
	 * Gets the upload date.
	 * 
	 * @return the upload date
	 */
	public Date getUploadDate() {
		return uploadDate;
	}
	
	/**
	 * Sets the upload date.
	 * 
	 * @param uploadDate the new upload date
	 */
	public void setUploadDate(Date uploadDate) {
		this.uploadDate = uploadDate;
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
	 * Gets the motor no.
	 * 
	 * @return the motor no
	 */
	public String getMotorNo() {
		return motorNo;
	}
	
	/**
	 * Sets the motor no.
	 * 
	 * @param motorNo the new motor no
	 */
	public void setMotorNo(String motorNo) {
		this.motorNo = motorNo;
	}
	
	/**
	 * Gets the serial no.
	 * 
	 * @return the serial no
	 */
	public String getSerialNo() {
		return serialNo;
	}
	
	/**
	 * Sets the serial no.
	 * 
	 * @param serialNo the new serial no
	 */
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	
	/**
	 * Gets the plate no.
	 * 
	 * @return the plate no
	 */
	public String getPlateNo() {
		return plateNo;
	}
	
	/**
	 * Sets the plate no.
	 * 
	 * @param plateNo the new plate no
	 */
	public void setPlateNo(String plateNo) {
		this.plateNo = plateNo;
	}
	
}
