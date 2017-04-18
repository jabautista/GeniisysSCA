package com.geniisys.giis.entity;

public class GIISDspColumn extends BaseEntity{

	private Integer dspColId;
	private String tableName;
	private String oldTableName;
	private String columnName;
	private String oldColumnName;
	private String databaseTag;
	
	public GIISDspColumn(){
		
	}
	
	public Integer getDspColId() {
		return dspColId;
	}
	
	public void setDspColId(Integer dspColId) {
		this.dspColId = dspColId;
	}
	
	public String getTableName() {
		return tableName;
	}
	
	public void setTableName(String tableName) {
		this.tableName = tableName;
	}
	
	public String getColumnName() {
		return columnName;
	}
	
	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}

	public String getOldTableName() {
		return oldTableName;
	}

	public void setOldTableName(String oldTableName) {
		this.oldTableName = oldTableName;
	}

	public String getOldColumnName() {
		return oldColumnName;
	}

	public void setOldColumnName(String oldColumnName) {
		this.oldColumnName = oldColumnName;
	}

	public String getDatabaseTag() {
		return databaseTag;
	}

	public void setDatabaseTag(String databaseTag) {
		this.databaseTag = databaseTag;
	}
	
}
