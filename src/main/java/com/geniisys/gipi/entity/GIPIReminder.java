package com.geniisys.gipi.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIReminder extends BaseEntity {

	private Integer parId;
	private Integer claimId;
	private Integer item;
	private String noteType;
	private String noteSubject;
	private String noteText;
	private String alarmUser;
	private String alarmFlag;
	private Date alarmDate;	
	private String renewFlag;
	
	public GIPIReminder(){

	}

	public GIPIReminder(Integer parId, Integer claimId, Integer item,
			String noteType, String noteSubject, String noteText,
			String alarmUser, String alarmFlag, Date alarmDate, String renewFlag) {
		super();
		this.parId = parId;
		this.claimId = claimId;
		this.item = item;
		this.noteType = noteType;
		this.noteSubject = noteSubject;
		this.noteText = noteText;
		this.alarmUser = alarmUser;
		this.alarmFlag = alarmFlag;
		this.alarmDate = alarmDate;
		this.renewFlag = renewFlag;
	}

	public Integer getParId() {
		return parId;
	}

	public void setParId(Integer parId) {
		this.parId = parId;
	}

	public Integer getClaimId() {
		return claimId;
	}

	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}

	public Integer getItem() {
		return item;
	}

	public void setItem(Integer item) {
		this.item = item;
	}

	public String getNoteType() {
		return noteType;
	}

	public void setNoteType(String noteType) {
		this.noteType = noteType;
	}

	public String getNoteSubject() {
		return noteSubject;
	}

	public void setNoteSubject(String noteSubject) {
		this.noteSubject = noteSubject;
	}

	public String getNoteText() {
		return noteText;
	}

	public void setNoteText(String noteText) {
		this.noteText = noteText;
	}

	public String getAlarmUser() {
		return alarmUser;
	}

	public void setAlarmUser(String alarmUser) {
		this.alarmUser = alarmUser;
	}

	public String getAlarmFlag() {
		return alarmFlag;
	}

	public void setAlarmFlag(String alarmFlag) {
		this.alarmFlag = alarmFlag;
	}

	public Date getAlarmDate() {
		return alarmDate;
	}

	public void setAlarmDate(Date alarmDate) {
		this.alarmDate = alarmDate;
	}

	public String getRenewFlag() {
		return renewFlag;
	}

	public void setRenewFlag(String renewFlag) {
		this.renewFlag = renewFlag;
	}
		
}
