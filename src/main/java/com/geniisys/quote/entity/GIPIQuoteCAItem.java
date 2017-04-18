package com.geniisys.quote.entity;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIQuoteCAItem extends BaseEntity{
	
	private Integer quoteId;
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
	private String userId;
	private Date lastUpdate;
	
	private String dspSectionOrHazardTitle;
	private String dspPosition;
	
	public GIPIQuoteCAItem() {
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

	public String getDspSectionOrHazardTitle() {
		return dspSectionOrHazardTitle;
	}

	public void setDspSectionOrHazardTitle(String dspSectionOrHazardTitle) {
		this.dspSectionOrHazardTitle = dspSectionOrHazardTitle;
	}

	public String getDspPosition() {
		return dspPosition;
	}

	public void setDspPosition(String dspPosition) {
		this.dspPosition = dspPosition;
	}

}
