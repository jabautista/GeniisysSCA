package com.geniisys.gipi.entity;


public class GIPIAviationItem {

	private Integer policyId;
	private Integer itemNo;
	private String vesselCd;
	private String totalFlyTime;
	private String qualification;
	private String purpose;
	private String geogLimit;
	private String deductText;
	private String recFlagAv;
	private String fixedWing;
	private String rotor;
	private String prevUtilHrs;
	private String estUtilHrs;

	private String vesselName;
	private String airDesc;
	private String itemTitle;
	private String rpcNo;
	
	public GIPIAviationItem(){
		
	}
	
	public GIPIAviationItem(Integer policyId, Integer itemNo, String vesselCd,
			String totalFlyTime, String qualification, String purpose,
			String geogLimit, String deductText, String recFlagAv,
			String fixedWing, String rotor, String prevUtilHrs,
			String estUtilHrs) {
		super();
		this.policyId = policyId;
		this.itemNo = itemNo;
		this.vesselCd = vesselCd;
		this.totalFlyTime = totalFlyTime;
		this.qualification = qualification;
		this.purpose = purpose;
		this.geogLimit = geogLimit;
		this.deductText = deductText;
		this.recFlagAv = recFlagAv;
		this.fixedWing = fixedWing;
		this.rotor = rotor;
		this.prevUtilHrs = prevUtilHrs;
		this.estUtilHrs = estUtilHrs;
	}
	
	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
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

	public String getTotalFlyTime() {
		return totalFlyTime;
	}

	public void setTotalFlyTime(String totalFlyTime) {
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

	public String getRecFlagAv() {
		return recFlagAv;
	}

	public void setRecFlagAv(String recFlagAv) {
		this.recFlagAv = recFlagAv;
	}

	public String getFixedWing() {
		return fixedWing;
	}

	public void setFixedWing(String fixedWing) {
		this.fixedWing = fixedWing;
	}

	public String getRotor() {
		return rotor;
	}

	public void setRotor(String rotor) {
		this.rotor = rotor;
	}

	public String getPrevUtilHrs() {
		return prevUtilHrs;
	}

	public void setPrevUtilHrs(String prevUtilHrs) {
		this.prevUtilHrs = prevUtilHrs;
	}

	public String getEstUtilHrs() {
		return estUtilHrs;
	}

	public void setEstUtilHrs(String estUtilHrs) {
		this.estUtilHrs = estUtilHrs;
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

	public String getItemTitle() {
		return itemTitle;
	}

	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}
	
	
}
