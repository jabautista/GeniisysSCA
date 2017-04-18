package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISEventsColumn extends BaseEntity{
	
	private Integer eventColCd;
	private Integer eventCd;
	private String tableName;
	private String columnName;
	private String remarks;
	/**
	 * @return the eventColCd
	 */
	public Integer getEventColCd() {
		return eventColCd;
	}
	/**
	 * @param eventColCd the eventColCd to set
	 */
	public void setEventColCd(Integer eventColCd) {
		this.eventColCd = eventColCd;
	}
	/**
	 * @return the eventCd
	 */
	public Integer getEventCd() {
		return eventCd;
	}
	/**
	 * @param eventCd the eventCd to set
	 */
	public void setEventCd(Integer eventCd) {
		this.eventCd = eventCd;
	}
	/**
	 * @return the tableName
	 */
	public String getTableName() {
		return tableName;
	}
	/**
	 * @param tableName the tableName to set
	 */
	public void setTableName(String tableName) {
		this.tableName = tableName;
	}
	/**
	 * @return the columnName
	 */
	public String getColumnName() {
		return columnName;
	}
	/**
	 * @param columnName the columnName to set
	 */
	public void setColumnName(String columnName) {
		this.columnName = columnName;
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
	
	

}
