package com.geniisys.quote.entity;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIQuoteAVItem extends BaseEntity{
	
	private Integer quoteId;
	private Integer itemNo;
	private String vesselCd;
	private Integer totalFlyTime;
	private String qualification;
	private String purpose;
	private String geogLimit;
	private String deductText;
	private String recFlag;
	private Integer fixedWing;
	private Integer rotor;
	private Integer prevUtilHrs;
	private Integer estUtilHrs;
	private String userId;
	private Date lastUpdate;
	
	private String dspVesselName;
	private String dspRpcNo;
	private String dspAirDesc;
	
	public GIPIQuoteAVItem() {
		super();
	}

	public Integer getQuoteId() {
		return quoteId;
	}

	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	public String getVesselCd() {
		return vesselCd;
	}

	public void setVesselCd(String vesselCd) {
		this.vesselCd = vesselCd;
	}

	public Integer getTotalFlyTime() {
		return totalFlyTime;
	}

	public void setTotalFlyTime(Integer totalFlyTime) {
		this.totalFlyTime = totalFlyTime;
	}

	public String getQualification() {
		return qualification;
	}

	public void setQualification(String qualification) {
		this.qualification = qualification;
	}

	public String getPurpose() {
		return purpose;
	}

	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}

	public String getGeogLimit() {
		return geogLimit;
	}

	public void setGeogLimit(String geogLimit) {
		this.geogLimit = geogLimit;
	}

	public String getDeductText() {
		return deductText;
	}

	public void setDeductText(String deductText) {
		this.deductText = deductText;
	}

	public String getRecFlag() {
		return recFlag;
	}

	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}

	public Integer getFixedWing() {
		return fixedWing;
	}

	public void setFixedWing(Integer fixedWing) {
		this.fixedWing = fixedWing;
	}

	public Integer getRotor() {
		return rotor;
	}

	public void setRotor(Integer rotor) {
		this.rotor = rotor;
	}

	public Integer getPrevUtilHrs() {
		return prevUtilHrs;
	}

	public void setPrevUtilHrs(Integer prevUtilHrs) {
		this.prevUtilHrs = prevUtilHrs;
	}

	public Integer getEstUtilHrs() {
		return estUtilHrs;
	}

	public void setEstUtilHrs(Integer estUtilHrs) {
		this.estUtilHrs = estUtilHrs;
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
	
	public Object getStrLastUpdate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (lastUpdate != null) {
			return df.format(lastUpdate);
		} else {
			return null;
		}
	}

	public String getDspVesselName() {
		return dspVesselName;
	}

	public void setDspVesselName(String dspVesselName) {
		this.dspVesselName = dspVesselName;
	}

	public String getDspRpcNo() {
		return dspRpcNo;
	}

	public void setDspRpcNo(String dspRpcNo) {
		this.dspRpcNo = dspRpcNo;
	}

	public String getDspAirDesc() {
		return dspAirDesc;
	}

	public void setDspAirDesc(String dspAirDesc) {
		this.dspAirDesc = dspAirDesc;
	}

}
