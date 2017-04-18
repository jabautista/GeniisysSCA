package com.geniisys.gixx.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIXXOpenCargo extends BaseEntity{

	private Integer extractId;
	private Integer geogCd;
	private Integer cargoClassCd;
	private String recFlag;
	private Integer policyId;
	private String cargoClassDesc;
	
	public Integer getExtractId() {
		return extractId;
	}
	public void setExtractId(Integer extractId) {
		this.extractId = extractId;
	}
	public Integer getGeogCd() {
		return geogCd;
	}
	public void setGeogCd(Integer geogCd) {
		this.geogCd = geogCd;
	}
	public Integer getCargoClassCd() {
		return cargoClassCd;
	}
	public void setCargoClassCd(Integer cargoClassCd) {
		this.cargoClassCd = cargoClassCd;
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
	public String getCargoClassDesc() {
		return cargoClassDesc;
	}
	public void setCargoClassDesc(String cargoClassDesc) {
		this.cargoClassDesc = cargoClassDesc;
	}
	
	
}
