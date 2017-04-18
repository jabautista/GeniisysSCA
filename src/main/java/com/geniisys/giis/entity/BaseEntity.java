package com.geniisys.giis.entity;


public class BaseEntity {

	private String userId;
	private String appUser;
	private String lastUpdate;
	private String createUser;
	private String createDate;
	private Integer rowNum;
	private Integer rowCount;
	
	public BaseEntity() {
		super();
	}

	public BaseEntity(String userId, String appUser, String lastUpdate,
			String createUser, String createDate, Integer rowNum,
			Integer rowCount) {
		super();
		this.userId = userId;
		this.appUser = appUser;
		this.lastUpdate = lastUpdate;
		this.createUser = createUser;
		this.createDate = createDate;
		this.rowNum = rowNum;
		this.rowCount = rowCount;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getAppUser() {
		return appUser;
	}

	public void setAppUser(String appUser) {
		this.appUser = appUser;
	}

	public String getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(String lastUpdate) {
		this.lastUpdate = lastUpdate;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public Integer getRowNum() {
		return rowNum;
	}

	public void setRowNum(Integer rowNum) {
		this.rowNum = rowNum;
	}

	public Integer getRowCount() {
		return rowCount;
	}

	public void setRowCount(Integer rowCount) {
		this.rowCount = rowCount;
	}
	
}
