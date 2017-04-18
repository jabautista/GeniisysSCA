package com.geniisys.gipi.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIPIVesAir extends BaseEntity{
	
	private Integer policyId;		
	private String vesselCd;		
	private String recFlag;		
	private String vescon;		
	private String voyLimit;		
	private Integer cpiRecNo;		
	private String cpiBranchCd;		
	private String arcExtData;
	
	private String vesselName;
	private String vesselFlag;
	
	public GIPIVesAir() {
		super();
	}

	public GIPIVesAir(Integer policyId, String vesselCd, String recFlag,
			String vescon, String voyLimit, Integer cpiRecNo,
			String cpiBranchCd, String arcExtData) {
		super();
		this.policyId = policyId;
		this.vesselCd = vesselCd;
		this.recFlag = recFlag;
		this.vescon = vescon;
		this.voyLimit = voyLimit;
		this.cpiRecNo = cpiRecNo;
		this.cpiBranchCd = cpiBranchCd;
		this.arcExtData = arcExtData;
	}

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	public String getVesselCd() {
		return vesselCd;
	}

	public void setVesselCd(String vesselCd) {
		this.vesselCd = vesselCd;
	}

	public String getRecFlag() {
		return recFlag;
	}

	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}

	public String getVescon() {
		return vescon;
	}

	public void setVescon(String vescon) {
		this.vescon = vescon;
	}

	public String getVoyLimit() {
		return voyLimit;
	}

	public void setVoyLimit(String voyLimit) {
		this.voyLimit = voyLimit;
	}

	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	public String getArcExtData() {
		return arcExtData;
	}

	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}

	public String getVesselName() {
		return vesselName;
	}

	public void setVesselName(String vesselName) {
		this.vesselName = vesselName;
	}

	public String getVesselFlag() {
		return vesselFlag;
	}

	public void setVesselFlag(String vesselFlag) {
		this.vesselFlag = vesselFlag;
	}
	
	

}
