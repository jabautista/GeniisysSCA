package com.geniisys.common.entity;

public class GIISPackageBenefitDtl {
	
	private String packBenCd;
	private String perilCd;
	private String perilName;
	private String benefit;
	private String premPct;
	private String remarks;
	private String userId;
	private String lastUpdate;
	private String premAmt;
	private String noOfDays;
	private String aggregateSw;
	private String perilType;
	private String packageCd;
	
	public String getPackBenCd() {
		return packBenCd;
	}
	public void setPackBenCd(String packBenCd) {
		this.packBenCd = packBenCd;
	}
	public String getPerilCd() {
		return perilCd;
	}
	public void setPerilCd(String perilCd) {
		this.perilCd = perilCd;
	}
	public String getBenefit() {
		return benefit;
	}
	public void setBenefit(String benefit) {
		this.benefit = benefit;
	}
	public String getPremPct() {
		return premPct;
	}
	public void setPremPct(String premPct) {
		this.premPct = premPct;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
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
	public String getPremAmt() {
		return premAmt;
	}
	public void setPremAmt(String premAmt) {
		this.premAmt = premAmt;
	}
	public String getNoOfDays() {
		return noOfDays;
	}
	public void setNoOfDays(String noOfDays) {
		this.noOfDays = noOfDays;
	}
	public String getAggregateSw() {
		return aggregateSw;
	}
	public void setAggregateSw(String aggregateSw) {
		this.aggregateSw = aggregateSw;
	}
	public String getPerilType() {
		return perilType;
	}
	public void setPerilType(String perilType) {
		this.perilType = perilType;
	}
	/**
	 * @param perilName the perilName to set
	 */
	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}
	/**
	 * @return the perilName
	 */
	public String getPerilName() {
		return perilName;
	}
	/**
	 * @return the packageCd
	 */
	public String getPackageCd() {
		return packageCd;
	}
	/**
	 * @param packageCd the packageCd to set
	 */
	public void setPackageCd(String packageCd) {
		this.packageCd = packageCd;
	}
}
