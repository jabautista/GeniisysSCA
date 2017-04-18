package com.geniisys.gicl.entity;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLClmAdjHist extends BaseEntity{

	private Integer adjHistNo;
	private Integer clmAdjId;
	private Integer claimId;
	private Integer adjCompanyCd;
	private Integer privAdjCd;
	private Date assignDate;
	private Date cancelDate;
	private Date compltDate;
	private Date deleteDate;
	private Date lastUpdate;
	private String  dspAdjCoName;
	private String  dspPrivAdjName;
	
	public Integer getAdjHistNo() {
		return adjHistNo;
	}
	public void setAdjHistNo(Integer adjHistNo) {
		this.adjHistNo = adjHistNo;
	}
	public Integer getClmAdjId() {
		return clmAdjId;
	}
	public void setClmAdjId(Integer clmAdjId) {
		this.clmAdjId = clmAdjId;
	}
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public Integer getAdjCompanyCd() {
		return adjCompanyCd;
	}
	public void setAdjCompanyCd(Integer adjCompanyCd) {
		this.adjCompanyCd = adjCompanyCd;
	}
	public Integer getPrivAdjCd() {
		return privAdjCd;
	}
	public void setPrivAdjCd(Integer privAdjCd) {
		this.privAdjCd = privAdjCd;
	}
	public Object getStrAssignDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (assignDate != null) {
			return df.format(assignDate);			
		} else {
			return null;
		}
	}
	public Date getAssignDate() {
		return assignDate;
	}
	public void setAssignDate(Date assignDate) {
		this.assignDate = assignDate;
	}
	public Object getStrCancelDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (cancelDate != null) {
			return df.format(cancelDate);			
		} else {
			return null;
		}
	}
	public Date getCancelDate() {
		return cancelDate;
	}
	public void setCancelDate(Date cancelDate) {
		this.cancelDate = cancelDate;
	}
	public Object getStrCompltDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (compltDate != null) {
			return df.format(compltDate);			
		} else {
			return null;
		}
	}
	public Date getCompltDate() {
		return compltDate;
	}
	public void setCompltDate(Date compltDate) {
		this.compltDate = compltDate;
	}
	public Object getStrDeleteDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (deleteDate != null) {
			return df.format(deleteDate);			
		} else {
			return null;
		}
	}
	public Date getDeleteDate() {
		return deleteDate;
	}
	public void setDeleteDate(Date deleteDate) {
		this.deleteDate = deleteDate;
	}
	public String getDspAdjCoName() {
		return dspAdjCoName;
	}
	public void setDspAdjCoName(String dspAdjCoName) {
		this.dspAdjCoName = dspAdjCoName;
	}
	public String getDspPrivAdjName() {
		return dspPrivAdjName;
	}
	public void setDspPrivAdjName(String dspPrivAdjName) {
		this.dspPrivAdjName = dspPrivAdjName;
	}
	public Object getStrLastUpdate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (lastUpdate != null) {
			return df.format(lastUpdate);			
		} else {
			return null;
		}
	}
	public Date getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	
}
