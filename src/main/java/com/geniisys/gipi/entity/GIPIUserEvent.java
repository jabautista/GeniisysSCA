package com.geniisys.gipi.entity;

import java.util.Date;
import java.util.List;

import com.geniisys.framework.util.BaseEntity;

public class GIPIUserEvent extends BaseEntity {
	
	private String tranDtl;
	private Integer eventUserMod;
	private Integer eventColCd;
	private Integer tranId;
	private String colValue;
	private String switchValue;
	private String remarks;
	private Integer eventModCd;
	private String userid;
	private String status;
	private Date dateDue;
	private String recipient;
	private Date dateReceived;	
	private String sender;
	private Integer eventCd;
	private String eventDesc;
	private Integer eventType;
	private String receiverTag;
	private String multipleAssignSw;
	private Integer tranCount;
	private Integer newTranCount;
	private String tranCountDisplay;
	private String statusDesc;
	private List<GUEAttach> gueAttachList;	
	
	public GIPIUserEvent(){
		
	}
	
	public GIPIUserEvent(String tranDtl, Integer eventUserMod, Integer eventColCd, Integer tranId,
			String colValue, String switchValue, String remarks,
			Integer eventModCd, String userid, String status, Date dateDue,
			Integer eventCd, String eventDesc, Integer eventType, String receiverTag,
			String multipleAssignSw, Integer tranCount, Integer newTranCount,
			String tranCountDisplay, String sender, Date dateReceived, String recipeint, String statusDesc) {
		super();
		this.setRecipient(recipeint);
		this.dateReceived = dateReceived;
		this.eventUserMod = eventUserMod;
		this.eventColCd = eventColCd;
		this.tranId = tranId;
		this.colValue = colValue;
		this.switchValue = switchValue;
		this.remarks = remarks;
		this.eventModCd = eventModCd;
		this.userid = userid;
		this.status = status;
		this.dateDue = dateDue;
		this.eventCd = eventCd;
		this.eventDesc = eventDesc;
		this.eventType = eventType;
		this.receiverTag = receiverTag;
		this.multipleAssignSw = multipleAssignSw;
		this.tranCount = tranCount;
		this.newTranCount = newTranCount;
		this.tranCountDisplay = tranCountDisplay;
		this.tranDtl = tranDtl;
		this.sender = sender;
		this.setStatusDesc(statusDesc);
	}

	public Integer getEventUserMod() {
		return eventUserMod;
	}

	public void setEventUserMod(Integer eventUserMod) {
		this.eventUserMod = eventUserMod;
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

	public String getSwitchValue() {
		return switchValue;
	}

	public void setSwitchValue(String switchValue) {
		this.switchValue = switchValue;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public Integer getEventModCd() {
		return eventModCd;
	}

	public void setEventModCd(Integer eventModCd) {
		this.eventModCd = eventModCd;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Date getDateDue() {
		return dateDue;
	}

	public void setDateDue(Date dateDue) {
		this.dateDue = dateDue;
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

	public Integer getTranCount() {
		return tranCount;
	}

	public void setTranCount(Integer tranCount) {
		this.tranCount = tranCount;
	}

	public Integer getNewTranCount() {
		return newTranCount;
	}

	public void setNewTranCount(Integer newTranCount) {
		this.newTranCount = newTranCount;
	}

	public String getTranCountDisplay() {
		return tranCountDisplay;
	}

	public void setTranCountDisplay(String tranCountDisplay) {
		this.tranCountDisplay = tranCountDisplay;
	}

	public void setTranDtl(String tranDtl) {
		this.tranDtl = tranDtl;
	}

	public String getTranDtl() {
		return tranDtl;
	}

	public void setSender(String sender) {
		this.sender = sender;
	}

	public String getSender() {
		return sender;
	}

	public void setDateReceived(Date dateReceived) {
		this.dateReceived = dateReceived;
	}

	public Date getDateReceived() {
		return this.dateReceived;			
	}

	public void setRecipient(String recipient) {
		this.recipient = recipient;
	}

	public String getRecipient() {
		return recipient;
	}

	public void setStatusDesc(String statusDesc) {
		this.statusDesc = statusDesc;
	}

	public String getStatusDesc() {
		return statusDesc;
	}

	public void setGueAttachList(List<GUEAttach> gueAttachList) {
		this.gueAttachList = gueAttachList;
	}

	public List<GUEAttach> getGueAttachList() {
		return gueAttachList;
	}
	
}
