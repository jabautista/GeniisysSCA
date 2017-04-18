package com.geniisys.common.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIISEventModule extends BaseEntity {

	private String eventModCd;
	private String eventCd;
	private String moduleId;
	private String userId;
	private Date lastUpdate;
	private String accptModId;

	public String getEventModCd() {
		return eventModCd;
	}

	public void setEventModCd(String eventModCd) {
		this.eventModCd = eventModCd;
	}

	public String getEventCd() {
		return eventCd;
	}

	public void setEventCd(String eventCd) {
		this.eventCd = eventCd;
	}

	public String getModuleId() {
		return moduleId;
	}

	public void setModuleId(String moduleId) {
		this.moduleId = moduleId;
	}

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

	public String getAccptModId() {
		return accptModId;
	}

	public void setAccptModId(String accptModId) {
		this.accptModId = accptModId;
	}

}
