package com.geniisys.gipi.entity;

import java.math.BigDecimal;

public class GIPIUploadItmperil {

	private String uploadNo;
	private String filename;
	private String controlTypeCd;
	private String controlCd;
	private String perilCd;
	private BigDecimal premRt;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private String aggregateSw;
	private BigDecimal baseAmount;
	private BigDecimal riCommRate;
	private BigDecimal riCommAmt;
	private String userId;
	private String lastUpdate;
	private String noOfDays;
	
	public String getUploadNo() {
		return uploadNo;
	}
	public void setUploadNo(String uploadNo) {
		this.uploadNo = uploadNo;
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public String getControlTypeCd() {
		return controlTypeCd;
	}
	public void setControlTypeCd(String controlTypeCd) {
		this.controlTypeCd = controlTypeCd;
	}
	public String getControlCd() {
		return controlCd;
	}
	public void setControlCd(String controlCd) {
		this.controlCd = controlCd;
	}
	public String getPerilCd() {
		return perilCd;
	}
	public void setPerilCd(String perilCd) {
		this.perilCd = perilCd;
	}
	public BigDecimal getPremRt() {
		return premRt;
	}
	public String getStrPremRt(){
		if(premRt != null){
			return premRt.toPlainString();
		} else {
			return null;
		}
	}
	public void setPremRt(BigDecimal premRt) {
		this.premRt = premRt;
	}
	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}
	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}
	public BigDecimal getPremAmt() {
		return premAmt;
	}
	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}
	public BigDecimal getBaseAmount() {
		return baseAmount;
	}
	public void setBaseAmount(BigDecimal baseAmount) {
		this.baseAmount = baseAmount;
	}
	public String getAggregateSw() {
		return aggregateSw;
	}
	public void setAggregateSw(String aggregateSw) {
		this.aggregateSw = aggregateSw;
	}
	public BigDecimal getRiCommRate() {
		return riCommRate;
	}
	public void setRiCommRate(BigDecimal riCommRate) {
		this.riCommRate = riCommRate;
	}
	public BigDecimal getRiCommAmt() {
		return riCommAmt;
	}
	public void setRiCommAmt(BigDecimal riCommAmt) {
		this.riCommAmt = riCommAmt;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(String lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	public String getNoOfDays() {
		return noOfDays;
	}
	public void setNoOfDays(String noOfDays) {
		this.noOfDays = noOfDays;
	}
	
}
