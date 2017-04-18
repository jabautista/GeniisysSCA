package com.geniisys.giac.entity;

import java.util.Date;

import com.geniisys.giis.entity.BaseEntity;

public class GIACOrRel extends BaseEntity{

	private Integer tranId;
	private Date newOrDate;
	private Integer oldTranId;
	private Integer oldOrNo;
	private Date oldOrDate;
	private String newOrPrefSuf;
	private Integer newOrNo;
	private String newOrTag;
	private String oldOrPrefSuf;
	private String oldOrTag;
	
	public GIACOrRel() {
		
	}

	public GIACOrRel(Integer tranId, Date newOrDate, Integer oldTranId,
			Integer oldOrNo, Date oldOrDate, String newOrPrefSuf, Integer newOrNo,
			String newOrTag, String oldPrefSuf, String oldOrTag) {
		super();
		this.tranId = tranId;
		this.newOrDate = newOrDate;
		this.oldTranId = oldTranId;
		this.oldOrNo = oldOrNo;
		this.oldOrDate = oldOrDate;
		this.newOrPrefSuf = newOrPrefSuf;
		this.newOrNo = newOrNo;
		this.newOrTag = newOrTag;
		this.oldOrPrefSuf = oldPrefSuf;
		this.oldOrTag = oldOrTag;
	}

	public Integer getTranId() {
		return tranId;
	}

	public void setTranId(Integer tranId) {
		this.tranId = tranId;
	}

	public Date getNewOrDate() {
		return newOrDate;
	}

	public void setNewOrDate(Date newOrDate) {
		this.newOrDate = newOrDate;
	}

	public Integer getOldTranId() {
		return oldTranId;
	}

	public void setOldTranId(Integer oldTranId) {
		this.oldTranId = oldTranId;
	}

	public Integer getOldOrNo() {
		return oldOrNo;
	}

	public void setOldOrNo(Integer oldOrNo) {
		this.oldOrNo = oldOrNo;
	}

	public Date getOldOrDate() {
		return oldOrDate;
	}

	public void setOldOrDate(Date oldOrDate) {
		this.oldOrDate = oldOrDate;
	}

	public String getNewOrPrefSuf() {
		return newOrPrefSuf;
	}

	public void setNewOrPrefSuf(String newOrPrefSuf) {
		this.newOrPrefSuf = newOrPrefSuf;
	}

	public Integer getNewOrNo() {
		return newOrNo;
	}

	public void setNewOrNo(Integer newOrNo) {
		this.newOrNo = newOrNo;
	}

	public String getNewOrTag() {
		return newOrTag;
	}

	public void setNewOrTag(String newOrTag) {
		this.newOrTag = newOrTag;
	}

	public String getOldOrTag() {
		return oldOrTag;
	}

	public void setOldOrTag(String oldOrTag) {
		this.oldOrTag = oldOrTag;
	}

	public String getOldOrPrefSuf() {
		return oldOrPrefSuf;
	}

	public void setOldOrPrefSuf(String oldOrPrefSuf) {
		this.oldOrPrefSuf = oldOrPrefSuf;
	}
	
}
