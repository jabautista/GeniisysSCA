package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACFileSource extends BaseEntity{
	private String sourceCd;
	private String sourceName;
	private String orTag;
	private String orTagDesc;
	private String atmTag;
	private String address1;
	private String address2;
	private String address3;
	private String remarks;
	private String utilityTag;
	private String tin;
	private String originalSource;
	private String addUpdate;
	
	public String getSourceCd() {
		return sourceCd;
	}
	public void setSourceCd(String sourceCd) {
		this.sourceCd = sourceCd;
	}
	public String getSourceName() {
		return sourceName;
	}
	public void setSourceName(String sourceName) {
		this.sourceName = sourceName;
	}
	public String getOrTag() {
		return orTag;
	}
	public void setOrTag(String orTag) {
		this.orTag = orTag;
	}
	public void setOrTagDesc(String orTagDesc) {
		this.orTagDesc = orTagDesc;
	}
	public String getOrTagDesc() {
		return orTagDesc;
	}
	public String getAtmTag() {
		return atmTag;
	}
	public void setAtmTag(String atmTag) {
		this.atmTag = atmTag;
	}
	public String getAddress1() {
		return address1;
	}
	public void setAddress1(String address1) {
		this.address1 = address1;
	}
	public String getAddress2() {
		return address2;
	}
	public void setAddress2(String address2) {
		this.address2 = address2;
	}
	public String getAddress3() {
		return address3;
	}
	public void setAddress3(String address3) {
		this.address3 = address3;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getUtilityTag() {
		return utilityTag;
	}
	public void setUtilityTag(String utilityTag) {
		this.utilityTag = utilityTag;
	}
	public String getTin() {
		return tin;
	}
	public void setTin(String tin) {
		this.tin = tin;
	}
	public String getOriginalSource() {
		return originalSource;
	}
	public void setOriginalSource(String originalSource) {
		this.originalSource = originalSource;
	}
	public String getAddUpdate() {
		return addUpdate;
	}
	public void setAddUpdate(String addUpdate) {
		this.addUpdate = addUpdate;
	}
}
