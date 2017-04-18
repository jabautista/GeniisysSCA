package com.geniisys.gixx.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIXXAviationItem extends BaseEntity{
	
	private Integer extractId;
	private Integer itemNo;
	private String itemTitle;
	private String vesselCd;
	private Integer totalFlyTime;
	private String qualification;
	private String purpose;
	private String geogLimit;
	private String deductText;
	private Integer fixedWing;
	private Integer rotor;
	private Integer prevUtilHrs;
	private Integer estUtilHrs;
	private String recFlag;
	private Integer policyId;
	
	private String vesselName;
	private String airDesc;
	private String rpcNo;
	
	
	public Integer getExtractId() {
		return extractId;
	}
	public void setExtractId(Integer extractId) {
		this.extractId = extractId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public String getItemTitle() {
		return itemTitle;
	}
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
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
	public String getRecFlag() {
		return recFlag;
	}
	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public String getVesselName() {
		return vesselName;
	}
	public void setVesselName(String vesselName) {
		this.vesselName = vesselName;
	}
	public String getAirDesc() {
		return airDesc;
	}
	public void setAirDesc(String airDesc) {
		this.airDesc = airDesc;
	}
	public String getRpcNo() {
		return rpcNo;
	}
	public void setRpcNo(String rpcNo) {
		this.rpcNo = rpcNo;
	}
	
	

}
