package com.geniisys.giri.entity;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIRIEndttext extends BaseEntity{
	
	private Integer policyId;
	private Integer riCd;
	private Integer fnlBinderId;
	private String remarks;
	private String userId;
	private Date lastUpdate;
	private String arcExtData;
	
	private String dspRiName;
	private String dspEndtText;
	private Date dspBinderDate;
	private String dspBinderNo;
	
	private String lineCd;
	private String issCd;
	private Date effDate;
	private Date expiryDate;
	
	public GIRIEndttext() {
		
	}

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	public Integer getRiCd() {
		return riCd;
	}

	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}

	public Integer getFnlBinderId() {
		return fnlBinderId;
	}

	public void setFnlBinderId(Integer fnlBinderId) {
		this.fnlBinderId = fnlBinderId;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
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

	public String getArcExtData() {
		return arcExtData;
	}

	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}
	
	public String getDspRiName() {
		return dspRiName;
	}

	public void setDspRiName(String dspRiName) {
		this.dspRiName = dspRiName;
	}

	public String getDspEndtText() {
		return dspEndtText;
	}

	public void setDspEndtText(String dspEndtText) {
		this.dspEndtText = dspEndtText;
	}
	
	public Object getStrDspBinderDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (dspBinderDate != null) {
			return df.format(dspBinderDate);			
		} else {
			return null;
		}
	}

	public Date getDspBinderDate() {
		return dspBinderDate;
	}

	public void setDspBinderDate(Date dspBinderDate) {
		this.dspBinderDate = dspBinderDate;
	}

	public String getDspBinderNo() {
		return dspBinderNo;
	}

	public void setDspBinderNo(String dspBinderNo) {
		this.dspBinderNo = dspBinderNo;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public Date getEffDate() {
		return effDate;
	}

	public void setEffDate(Date effDate) {
		this.effDate = effDate;
	}

	public Date getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}
	
}
