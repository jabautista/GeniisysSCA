package com.geniisys.csv.entity;

public class MainParam {

	private String statement;
	private String fileName;
	private boolean isPS;

	public boolean isPS() {
		return isPS;
	}

	public void setPS(boolean isPS) {
		this.isPS = isPS;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getStatement() {
		return statement;
	}

	public void setStatement(String statement) {
		this.statement = statement;
	}

}
