package com.geniisys.common.entity;

import java.util.Date;

import com.geniisys.giis.entity.BaseEntity;

public class GIISCollateralType extends BaseEntity{
	
	public String collType;
	private String collName;
	private String remarks;
	//private Date lastUpdate;		//commented out by shan 10.22.2013 : already included in BaseEntity
	private Integer recNo;
	private String branchCd;
	
	
	public String getCollType() {
		return collType;
	}
	public void setCollType(String collType) {
		this.collType = collType;
	}
	public String getCollName() {
		return collName;
	}
	public void setCollName(String collName) {
		this.collName = collName;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	/*public Date getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}*/
	public Integer getRecNo() {
		return recNo;
	}
	public void setRecNo(Integer recNo) {
		this.recNo = recNo;
	}
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	
	

}
