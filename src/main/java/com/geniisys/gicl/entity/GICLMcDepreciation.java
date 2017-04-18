package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;

public class GICLMcDepreciation extends BaseEntity{
	
	private String specialPartCd;
	private int origMcYearFr;
	private int mcYearFr;
	private BigDecimal rate;
	private String sublineCd;
	private String remarks;
	
	/**
	 * @return the specialPartCd
	 */
	public String getSpecialPartCd() {
		return specialPartCd;
	}
	/**
	 * @param specialPartCd the specialPartCd to set
	 */
	public void setSpecialPartCd(String specialPartCd) {
		this.specialPartCd = specialPartCd;
	}
	/**
	 * @return the origMcYearFr
	 */
	public int getOrigMcYearFr() {
		return origMcYearFr;
	}
	/**
	 * @param origMcYearFr the origMcYearFr to set
	 */
	public void setOrigMcYearFr(int origMcYearFr) {
		this.origMcYearFr = origMcYearFr;
	}
	/**
	 * @return the mcYearFr
	 */
	public int getMcYearFr() {
		return mcYearFr;
	}
	/**
	 * @param mcYearFr the mcYearFr to set
	 */
	public void setMcYearFr(int mcYearFr) {
		this.mcYearFr = mcYearFr;
	}
	/**
	 * @return the rate
	 */
	public BigDecimal getRate() {
		return rate;
	}
	/**
	 * @param rate the rate to set
	 */
	public void setRate(BigDecimal rate) {
		this.rate = rate;
	}
	/**
	 * @return the sublineCd
	 */
	public String getSublineCd() {
		return sublineCd;
	}
	/**
	 * @param sublineCd the sublineCd to set
	 */
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	/**
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}
	/**
	 * @param remarks the remarks to set
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
}
