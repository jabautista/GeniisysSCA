package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;


public class GIISXol extends BaseEntity {

	private Integer xolId;
	private String lineCd;
	private Integer xolYy;
	private Integer xolSeqNo;
	private String xolTrtyName;
	private String remarks;
		
	/*private String userId;
	private Date lastUpdate;*/
	/**
	 * @return the xolId
	 */
	public Integer getXolId() {
		return xolId;
	}
	/**
	 * @param xolId the xolId to set
	 */
	public void setXolId(Integer xolId) {
		this.xolId = xolId;
	}
	/**
	 * @return the lineCd
	 */
	public String getLineCd() {
		return lineCd;
	}
	/**
	 * @param lineCd the lineCd to set
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	/**
	 * @return the xolYy
	 */
	public Integer getXolYy() {
		return xolYy;
	}
	/**
	 * @param xolYy the xolYy to set
	 */
	public void setXolYy(Integer xolYy) {
		this.xolYy = xolYy;
	}
	/**
	 * @return the xolSeqNo
	 */
	public Integer getXolSeqNo() {
		return xolSeqNo;
	}
	/**
	 * @param xolSeqNo the xolSeqNo to set
	 */
	public void setXolSeqNo(Integer xolSeqNo) {
		this.xolSeqNo = xolSeqNo;
	}
	/**
	 * @return the xolTrtyName
	 */
	public String getXolTrtyName() {
		return xolTrtyName;
	}
	/**
	 * @param xolTrtyName the xolTrtyName to set
	 */
	public void setXolTrtyName(String xolTrtyName) {
		this.xolTrtyName = xolTrtyName;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
}
