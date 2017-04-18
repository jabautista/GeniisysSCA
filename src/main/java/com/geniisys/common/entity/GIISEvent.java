package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;


public class GIISEvent extends BaseEntity{

	private Integer eventCd;
	private String eventDesc;
	private Integer eventType;
	private String eventTypeDesc;
	private String receiverTag;
	private String receiverTagDesc;
	private String multipleAssignSw;
	private String remarks;
		
	public GIISEvent(){
		
	}

	public GIISEvent(Integer eventCd, String eventDesc, Integer eventType,
			String receiverTag, String multipleAssignSw, String remarks) {
		this.eventCd = eventCd;
		this.eventDesc = eventDesc;
		this.eventType = eventType;
		this.receiverTag = receiverTag;
		this.multipleAssignSw = multipleAssignSw;
		this.setRemarks(remarks);
	}

	public Integer getEventCd() {
		return eventCd;
	}

	public void setEventCd(Integer eventCd) {
		this.eventCd = eventCd;
	}

	public String getEventDesc() {
		return eventDesc;
	}

	public void setEventDesc(String eventDesc) {
		this.eventDesc = eventDesc;
	}

	public Integer getEventType() {
		return eventType;
	}

	public void setEventType(Integer eventType) {
		this.eventType = eventType;
	}

	public String getReceiverTag() {
		return receiverTag;
	}

	public void setReceiverTag(String receiverTag) {
		this.receiverTag = receiverTag;
	}

	public String getMultipleAssignSw() {
		return multipleAssignSw;
	}

	public void setMultipleAssignSw(String multipleAssignSw) {
		this.multipleAssignSw = multipleAssignSw;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setEventTypeDesc(String eventTypeDesc) {
		this.eventTypeDesc = eventTypeDesc;
	}

	public String getEventTypeDesc() {
		return eventTypeDesc;
	}

	public void setReceiverTagDesc(String receiverTagDesc) {
		this.receiverTagDesc = receiverTagDesc;
	}

	public String getReceiverTagDesc() {
		return receiverTagDesc;
	}
		
}
