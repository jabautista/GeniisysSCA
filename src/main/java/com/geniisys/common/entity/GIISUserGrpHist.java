package com.geniisys.common.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIISUserGrpHist extends BaseEntity {
	
	private Integer histId;
	private String 	userId;
	private Integer oldUserGrp;
	private String  oldUserDesc;
	private Integer newUserGrp;
	private String  newUserDesc;
	private String  userId2;
	private Date  lastUpdate;
	private String  lastUpdateChar;
	
	public GIISUserGrpHist(){
		
	}
	
	public GIISUserGrpHist(Integer histId, String userId, Integer oldUserGrp, Integer newUserGrp, String userId2, Date lastUpdate, String lastUpdateChar){
		this.histId = histId;
		this.userId = userId;
		this.oldUserGrp = oldUserGrp;
		this.newUserGrp = newUserGrp;
		this.userId2 = userId2;
		this.lastUpdate = lastUpdate;
		this.lastUpdateChar = lastUpdateChar;
	}
	
	public Integer getHistId() {
		return histId;
	}
	public void setHistId(Integer histId) {
		this.histId = histId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public Integer getOldUserGrp() {
		return oldUserGrp;
	}
	public void setOldUserGrp(Integer oldUserGrp) {
		this.oldUserGrp = oldUserGrp;
	}
	
	public String getOldUserDesc(){
		return oldUserDesc;
	}
	
	public void setOldUserDesc(String oldUserDesc){
		this.oldUserDesc = oldUserDesc;
	}
	
	public Integer getNewUserGrp() {
		return newUserGrp;
	}
	public void setNewUserGrp(Integer newUserGrp) {
		this.newUserGrp = newUserGrp;
	}
	
	public String getNewUserDesc(){
		return newUserDesc;
	}
	
	public void setNewUserDesc(String newUserDesc){
		this.newUserDesc = newUserDesc;
	}
	
	public String getUserId2() {
		return userId2;
	}
	public void setUserId2(String userId2) {
		this.userId2 = userId2;
	}
	public Date getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(Date lastUpdate){
		this.lastUpdate = lastUpdate;
	}

	public String getLastUpdateChar() {
		return lastUpdateChar;
	}

	public void setLastUpdateChar(String lastUpdateChar) {
		this.lastUpdateChar = lastUpdateChar;
	}
	
}
