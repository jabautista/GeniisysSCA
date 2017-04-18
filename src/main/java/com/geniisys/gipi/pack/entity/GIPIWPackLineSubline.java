/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gipi.pack.entity
	File Name: GIPIWPackLineSubline.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 10, 2011
	Description: 
*/


package com.geniisys.gipi.pack.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWPackLineSubline extends BaseEntity{
	private Integer parId;
	private String packLineCd;
	private String packSublineCd;
	private String packLineName;
	private String packSublineName;
	private String lineCd;
	private String itemTag;
	private String remarks;
	private Integer packParId;
	private String dspTag;
	private String recordStatus;
	private String hasPerils;
	private String hasItems;
	private String opFlag;
	private String menuLineCd;
	
	public String getHasPerils() {
		return hasPerils;
	}
	public void setHasPerils(String hasPerils) {
		this.hasPerils = hasPerils;
	}
	public String getHasItems() {
		return hasItems;
	}
	public void setHasItems(String hasItems) {
		this.hasItems = hasItems;
	}
	public Integer getParId() {
		return parId;
	}
	public void setParId(Integer parId) {
		this.parId = parId;
	}
	public String getPackLineCd() {
		return packLineCd;
	}
	public void setPackLineCd(String packLineCd) {
		this.packLineCd = packLineCd;
	}
	public String getPackSublineCd() {
		return packSublineCd;
	}
	public void setPackSublineCd(String packSublineCd) {
		this.packSublineCd = packSublineCd;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getItemTag() {
		return itemTag;
	}
	public void setItemTag(String itemTag) {
		this.itemTag = itemTag;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public Integer getPackParId() {
		return packParId;
	}
	public void setPackParId(Integer packParId) {
		this.packParId = packParId;
	}
	/**
	 * @param packLineName the packLineName to set
	 */
	public void setPackLineName(String packLineName) {
		this.packLineName = packLineName;
	}
	/**
	 * @return the packLineName
	 */
	public String getPackLineName() {
		return packLineName;
	}
	/**
	 * @param packSublineName the packSublineName to set
	 */
	public void setPackSublineName(String packSublineName) {
		this.packSublineName = packSublineName;
	}
	/**
	 * @return the packSublineName
	 */
	public String getPackSublineName() {
		return packSublineName;
	}
	/**
	 * @param dspTag the dspTag to set
	 */
	public void setDspTag(String dspTag) {
		this.dspTag = dspTag;
	}
	/**
	 * @return the dspTag
	 */
	public String getDspTag() {
		return dspTag;
	}
	/**
	 * @param recordStatus the recordStatus to set
	 */
	public void setRecordStatus(String recordStatus) {
		this.recordStatus = recordStatus;
	}
	/**
	 * @return the recordStatus
	 */
	public String getRecordStatus() {
		return recordStatus;
	}
	public void setOpFlag(String opFlag) {
		this.opFlag = opFlag;
	}
	public String getOpFlag() {
		return opFlag;
	}
	public String getMenuLineCd() {
		return menuLineCd;
	}
	public void setMenuLineCd(String menuLineCd) {
		this.menuLineCd = menuLineCd;
	}	
}
