package com.geniisys.gipi.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIPIUserEventHist extends BaseEntity {

	private Integer userEventMod;
	private Integer eventColCd;
	private Integer tranId;
	private String colValue;
	private String dateReceived;
	private String oldUserId;
	private String newUserId;
	private String remarks;
	private String eventCd;
	
	public GIPIUserEventHist(){
		
	}

	public GIPIUserEventHist(Integer userEventMod, Integer eventColCd,
			Integer tranId, String colValue, String dateReceived,
			String oldUserId, String newUserId, String remarks, String eventCd) {
		super();
		this.userEventMod = userEventMod;
		this.eventColCd = eventColCd;
		this.tranId = tranId;
		this.colValue = colValue;
		this.dateReceived = dateReceived;
		this.oldUserId = oldUserId;
		this.newUserId = newUserId;
		this.remarks = remarks;
		this.eventCd = eventCd;
	}

	public Integer getUserEventMod() {
		return userEventMod;
	}

	public void setUserEventMod(Integer userEventMod) {
		this.userEventMod = userEventMod;
	}

	public Integer getEventColCd() {
		return eventColCd;
	}

	public void setEventColCd(Integer eventColCd) {
		this.eventColCd = eventColCd;
	}

	public Integer getTranId() {
		return tranId;
	}

	public void setTranId(Integer tranId) {
		this.tranId = tranId;
	}

	public String getColValue() {
		return colValue;
	}

	public void setColValue(String colValue) {
		this.colValue = colValue;
	}

	public String getDateReceived() {
		return dateReceived;
	}

	public void setDateReceived(String dateReceived) {
		this.dateReceived = dateReceived;
	}

	public String getOldUserId() {
		return oldUserId;
	}

	public void setOldUserId(String oldUserId) {
		this.oldUserId = oldUserId;
	}

	public String getNewUserId() {
		return newUserId;
	}

	public void setNewUserId(String newUserId) {
		this.newUserId = newUserId;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getEventCd() {
		return eventCd;
	}

	public void setEventCd(String eventCd) {
		this.eventCd = eventCd;
	}
	
}
