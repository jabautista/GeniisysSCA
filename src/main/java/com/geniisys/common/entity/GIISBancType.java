package com.geniisys.common.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIISBancType extends BaseEntity{

	private String bancTypeCd;
	private String bancTypeDesc;
	private String rate;
	private String userId;
	private Date   lastUpdate;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public Date getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	public String getBancTypeCd() {
		return bancTypeCd;
	}
	public void setBancTypeCd(String bancTypeCd) {
		this.bancTypeCd = bancTypeCd;
	}
	public String getBancTypeDesc() {
		return bancTypeDesc;
	}
	public void setBancTypeDesc(String bancTypeDesc) {
		this.bancTypeDesc = bancTypeDesc;
	}
	public String getRate() {
		return rate;
	}
	public void setRate(String rate) {
		this.rate = rate;
	}
	
}
