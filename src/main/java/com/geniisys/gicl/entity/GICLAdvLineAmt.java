package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;

public class GICLAdvLineAmt extends BaseEntity {

	private String advUser;
	private String issCd;
	private String lineCd;
	private BigDecimal rangeFrom;
	private BigDecimal rangeTo;
	private String allAmtSw;
	private BigDecimal resRangeTo;
	private String allResAmtSw;
		
	//shan 11.26.2013
	private String lineName;
	
	public GICLAdvLineAmt(String advUser, String issCd, String lineCd,
			BigDecimal rangeFrom, BigDecimal rangeTo, String allAmtSw,
			BigDecimal resRangeTo, String allResAmtSw) {
		super();
		this.advUser = advUser;
		this.issCd = issCd;
		this.lineCd = lineCd;
		this.rangeFrom = rangeFrom;
		this.rangeTo = rangeTo;
		this.allAmtSw = allAmtSw;
		this.resRangeTo = resRangeTo;
		this.allResAmtSw = allResAmtSw;
	}
	
	public GICLAdvLineAmt(){
		
	}
	
	public String getAdvUser() {
		return advUser;
	}
	public void setAdvUser(String advUser) {
		this.advUser = advUser;
	}
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public BigDecimal getRangeFrom() {
		return rangeFrom;
	}
	public void setRangeFrom(BigDecimal rangeFrom) {
		this.rangeFrom = rangeFrom;
	}
	public BigDecimal getRangeTo() {
		return rangeTo;
	}
	public void setRangeTo(BigDecimal rangeTo) {
		this.rangeTo = rangeTo;
	}
	public String getAllAmtSw() {
		return allAmtSw;
	}
	public void setAllAmtSw(String allAmtSw) {
		this.allAmtSw = allAmtSw;
	}
	public BigDecimal getResRangeTo() {
		return resRangeTo;
	}
	public void setResRangeTo(BigDecimal resRangeTo) {
		this.resRangeTo = resRangeTo;
	}
	public String getAllResAmtSw() {
		return allResAmtSw;
	}
	public void setAllResAmtSw(String allResAmtSw) {
		this.allResAmtSw = allResAmtSw;
	}

	public String getLineName() {
		return lineName;
	}

	public void setLineName(String lineName) {
		this.lineName = lineName;
	}
	
	
}
