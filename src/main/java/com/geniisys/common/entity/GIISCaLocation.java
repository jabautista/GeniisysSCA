package com.geniisys.common.entity;

import java.math.BigDecimal;
import com.geniisys.giis.entity.BaseEntity;

public class GIISCaLocation extends BaseEntity{

	private String 		locationCd;
	private String 		locationDesc;
	private String 		locAddr1;
	private String 		locAddr2;	
	private String 		locAddr3;
	private BigDecimal 	treatyLimit;
	private BigDecimal 	retLimit;
	private BigDecimal 	retBegBal;
	private BigDecimal 	treatyBegBal;
	private BigDecimal 	facBegBal;
	private String 		fromDate;
	private String 		toDate;
	private String 		remarks;
	
	public String getLocationCd() {
		return locationCd;
	}
	public void setLocationCd(String locationCd) {
		this.locationCd = locationCd;
	}
	public String getLocationDesc() {
		return locationDesc;
	}
	public void setLocationDesc(String locationDesc) {
		this.locationDesc = locationDesc;
	}
	public String getLocAddr1() {
		return locAddr1;
	}
	public void setLocAddr1(String locAddr1) {
		this.locAddr1 = locAddr1;
	}
	public String getLocAddr2() {
		return locAddr2;
	}
	public void setLocAddr2(String locAddr2) {
		this.locAddr2 = locAddr2;
	}
	public String getLocAddr3() {
		return locAddr3;
	}
	public void setLocAddr3(String locAddr3) {
		this.locAddr3 = locAddr3;
	}
	public BigDecimal getTreatyLimit() {
		return treatyLimit;
	}
	public void setTreatyLimit(BigDecimal treatyLimit) {
		this.treatyLimit = treatyLimit;
	}
	public BigDecimal getRetLimit() {
		return retLimit;
	}
	public void setRetLimit(BigDecimal retLimit) {
		this.retLimit = retLimit;
	}
	public BigDecimal getRetBegBal() {
		return retBegBal;
	}
	public void setRetBegBal(BigDecimal retBegBal) {
		this.retBegBal = retBegBal;
	}
	public BigDecimal getTreatyBegBal() {
		return treatyBegBal;
	}
	public void setTreatyBegBal(BigDecimal treatyBegBal) {
		this.treatyBegBal = treatyBegBal;
	}
	public BigDecimal getFacBegBal() {
		return facBegBal;
	}
	public void setFacBegBal(BigDecimal facBegBal) {
		this.facBegBal = facBegBal;
	}
	public String getFromDate() {
		return fromDate;
	}
	public void setFromDate(String fromDate) {
		this.fromDate = fromDate;
	}
	public String getToDate() {
		return toDate;
	}
	public void setToDate(String toDate) {
		this.toDate = toDate;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}	
}
