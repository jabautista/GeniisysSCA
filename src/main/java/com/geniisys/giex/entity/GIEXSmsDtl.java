package com.geniisys.giex.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIEXSmsDtl extends BaseEntity{
	private Integer policyId;
	private String cellphoneNo;
	private String message;
	private Date dateReceived;
	private Date dateSent;
	private Date dateCreated;
	private String userID;
	private Date lastUpdate;
	private String recipientSender;
	private Integer msgId;
	private Integer dtlId;
	private String messageType;
	
	private String messageStatus;
	private String dspDateCreated;
	private String dspDateSent;
	private String dspDateReceived;
	
	public Integer getPolicyId() {
		return policyId;
	}
	
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	
	public String getCellphoneNo() {
		return cellphoneNo;
	}
	
	public void setCellphoneNo(String cellphoneNo) {
		this.cellphoneNo = cellphoneNo;
	}
	
	public String getMessage() {
		return message;
	}
	
	public void setMessage(String message) {
		this.message = message;
	}
	
	public Date getDateReceived() {
		return dateReceived;
	}
	
	public void setDateReceived(Date dateReceived) {
		this.dateReceived = dateReceived;
	}
	
	public Date getDateSent() {
		return dateSent;
	}
	
	public void setDateSent(Date dateSent) {
		this.dateSent = dateSent;
	}
	
	public Date getDateCreated() {
		return dateCreated;
	}
	
	public void setDateCreated(Date dateCreated) {
		this.dateCreated = dateCreated;
	}
	
	public String getUserID() {
		return userID;
	}
	
	public void setUserID(String userID) {
		this.userID = userID;
	}
	
	public Date getLastUpdate() {
		return lastUpdate;
	}
	
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	
	public String getRecipientSender() {
		return recipientSender;
	}
	
	public void setRecipientSender(String recipientSender) {
		this.recipientSender = recipientSender;
	}
	
	public Integer getMsgId() {
		return msgId;
	}
	
	public void setMsgId(Integer msgId) {
		this.msgId = msgId;
	}
	
	public Integer getDtlId() {
		return dtlId;
	}
	
	public void setDtlId(Integer dtlId) {
		this.dtlId = dtlId;
	}
	
	public String getMessageType() {
		return messageType;
	}
	
	public void setMessageType(String messageType) {
		this.messageType = messageType;
	}

	public String getMessageStatus() {
		return messageStatus;
	}

	public void setMessageStatus(String messageStatus) {
		this.messageStatus = messageStatus;
	}

	public String getDspDateCreated() {
		return dspDateCreated;
	}

	public void setDspDateCreated(String dspDateCreated) {
		this.dspDateCreated = dspDateCreated;
	}

	public String getDspDateSent() {
		return dspDateSent;
	}

	public void setDspDateSent(String dspDateSent) {
		this.dspDateSent = dspDateSent;
	}

	public String getDspDateReceived() {
		return dspDateReceived;
	}

	public void setDspDateReceived(String dspDateReceived) {
		this.dspDateReceived = dspDateReceived;
	}
}
