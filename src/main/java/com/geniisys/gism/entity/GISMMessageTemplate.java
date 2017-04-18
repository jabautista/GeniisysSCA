package com.geniisys.gism.entity;


import com.geniisys.giis.entity.BaseEntity;



public class GISMMessageTemplate extends BaseEntity {
	
	private String messageCd;
	private String message;
	private String messageType;
	private String dspMessageType;
	private String keyWord;
	private String remarks;
	
	public String getMessageCd() {
		return messageCd;
	}
	public void setMessageCd(String messageCd) {
		this.messageCd = messageCd;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getMessageType() {
		return messageType;
	}
	public void setMessageType(String messageType) {
		this.messageType = messageType;
	}
	public String getKeyWord() {
		return keyWord;
	}
	public void setKeyWord(String keyWord) {
		this.keyWord = keyWord;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getDspMessageType() {
		return dspMessageType;
	}
	public void setDspMessageType(String dspMessageType) {
		this.dspMessageType = dspMessageType;
	}
	
}
