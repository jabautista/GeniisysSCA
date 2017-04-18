package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACFunctionColumns extends BaseEntity {
	
	private Integer functionColCd;
	private Integer moduleId;
	private String functionCd;
	private String tableName;
	private String columnName;
	private String remarks;
	
	public GIACFunctionColumns() {
		
	}

	public GIACFunctionColumns(Integer functionColCd, Integer moduleId,
			String functionCd, String tableName, String columnName,
			String remarks) {
		super();
		this.functionColCd = functionColCd;
		this.moduleId = moduleId;
		this.functionCd = functionCd;
		this.tableName = tableName;
		this.columnName = columnName;
		this.remarks = remarks;
	}

	public Integer getFunctionColCd() {
		return functionColCd;
	}

	public void setFunctionColCd(Integer functionColCd) {
		this.functionColCd = functionColCd;
	}

	public Integer getModuleId() {
		return moduleId;
	}

	public void setModuleId(Integer moduleId) {
		this.moduleId = moduleId;
	}

	public String getFunctionCd() {
		return functionCd;
	}

	public void setFunctionCd(String functionCd) {
		this.functionCd = functionCd;
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

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

}
