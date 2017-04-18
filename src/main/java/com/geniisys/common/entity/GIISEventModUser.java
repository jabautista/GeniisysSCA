package com.geniisys.common.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIISEventModUser extends BaseEntity {

	private String eventModCd;
	private String userId;
	private String activeTag;
	private String eventUserMod;
	private String passingUserId;
	
	public GIISEventModUser(){
		
	}

	public GIISEventModUser(String eventModCd, String userId, String activeTag,
			String eventUserMod, String passingUserId) {
		super();
		this.eventModCd = eventModCd;
		this.userId = userId;
		this.activeTag = activeTag;
		this.eventUserMod = eventUserMod;
		this.passingUserId = passingUserId;
	}

	public String getEventModCd() {
		return eventModCd;
	}

	public void setEventModCd(String eventModCd) {
		this.eventModCd = eventModCd;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getActiveTag() {
		return activeTag;
	}

	public void setActiveTag(String activeTag) {
		this.activeTag = activeTag;
	}

	public String getEventUserMod() {
		return eventUserMod;
	}

	public void setEventUserMod(String eventUserMod) {
		this.eventUserMod = eventUserMod;
	}

	public String getPassingUserId() {
		return passingUserId;
	}

	public void setPassingUserId(String passingUserId) {
		this.passingUserId = passingUserId;
	}
		
}
