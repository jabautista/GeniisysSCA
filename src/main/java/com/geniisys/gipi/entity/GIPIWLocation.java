package com.geniisys.gipi.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWLocation extends BaseEntity {

	public int parId;
	public int itemNo;
	public String regionCd;
	public String provinceCd;
	
	public GIPIWLocation() {
		
	}
	
	public GIPIWLocation(int parId, int itemNo, String regionCd, String provinceCd) {
		this.parId = parId;
		this.itemNo = itemNo;
		this.regionCd = regionCd;
		this.provinceCd = provinceCd;
	}

	public int getParId() {
		return parId;
	}

	public void setParId(int parId) {
		this.parId = parId;
	}

	public int getItemNo() {
		return itemNo;
	}

	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}

	public String getRegionCd() {
		return regionCd;
	}

	public void setRegionCd(String regionCd) {
		this.regionCd = regionCd;
	}

	public String getProvinceCd() {
		return provinceCd;
	}

	public void setProvinceCd(String provinceCd) {
		this.provinceCd = provinceCd;
	}

}
