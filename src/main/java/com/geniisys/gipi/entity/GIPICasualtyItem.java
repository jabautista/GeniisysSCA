package com.geniisys.gipi.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIPICasualtyItem extends BaseEntity{
	
	public GIPICasualtyItem(){
		super();
	}
	
	private Integer policyId;
	private Integer itemNo;
	private String sectionLineCd;
	private String sectionSublineCd;
	private String sectionOrHazardCd;
	private Integer capacityCd;
	private String propertyNoType;
	private String propertyNo;
	private String location;
	private String conveyanceInfo;
	private String interestOnPremises;
	private String limitOfLiability;
	private String sectionOrHazardInfo;	
	private String arcExtData;
	private Integer locationCd;
	private String itemTitle;
	private String capacityName;
	private String sectionOrHazardTitle;
	private String property;
	private String locationDesc;
	
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
	public String getSectionLineCd() {
		return sectionLineCd;
	}
	public void setSectionLineCd(String sectionLineCd) {
		this.sectionLineCd = sectionLineCd;
	}
	public String getSectionSublineCd() {
		return sectionSublineCd;
	}
	public void setSectionSublineCd(String sectionSublineCd) {
		this.sectionSublineCd = sectionSublineCd;
	}
	public String getSectionOrHazardCd() {
		return sectionOrHazardCd;
	}
	public void setSectionOrHazardCd(String sectionOrHazardCd) {
		this.sectionOrHazardCd = sectionOrHazardCd;
	}
	public Integer getCapacityCd() {
		return capacityCd;
	}
	public void setCapacityCd(Integer capacityCd) {
		this.capacityCd = capacityCd;
	}
	public String getPropertyNoType() {
		return propertyNoType;
	}
	public void setPropertyNoType(String propertyNoType) {
		this.propertyNoType = propertyNoType;
	}
	public String getPropertyNo() {
		return propertyNo;
	}
	public void setPropertyNo(String propertyNo) {
		this.propertyNo = propertyNo;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getConveyanceInfo() {
		return conveyanceInfo;
	}
	public void setConveyanceInfo(String conveyanceInfo) {
		this.conveyanceInfo = conveyanceInfo;
	}
	public String getInterestOnPremises() {
		return interestOnPremises;
	}
	public void setInterestOnPremises(String interestOnPremises) {
		this.interestOnPremises = interestOnPremises;
	}
	public String getLimitOfLiability() {
		return limitOfLiability;
	}
	public void setLimitOfLiability(String limitOfLiability) {
		this.limitOfLiability = limitOfLiability;
	}
	public String getSectionOrHazardInfo() {
		return sectionOrHazardInfo;
	}
	public void setSectionOrHazardInfo(String sectionOrHazardInfo) {
		this.sectionOrHazardInfo = sectionOrHazardInfo;
	}	
	public String getArcExtData() {
		return arcExtData;
	}
	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}
	public Integer getLocationCd() {
		return locationCd;
	}
	public void setLocationCd(Integer locationCd) {
		this.locationCd = locationCd;
	}
	public String getItemTitle() {
		return itemTitle;
	}
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}
	public String getCapacityName() {
		return capacityName;
	}
	public void setCapacityName(String capacityName) {
		this.capacityName = capacityName;
	}
	public String getSectionOrHazardTitle() {
		return sectionOrHazardTitle;
	}
	public void setSectionOrHazardTitle(String sectionOrHazardTitle) {
		this.sectionOrHazardTitle = sectionOrHazardTitle;
	}
	public String getProperty() {
		return property;
	}
	public void setProperty(String property) {
		this.property = property;
	}
	public String getLocationDesc() {
		return locationDesc;
	}
	public void setLocationDesc(String locationDesc) {
		this.locationDesc = locationDesc;
	}
	
	
}
