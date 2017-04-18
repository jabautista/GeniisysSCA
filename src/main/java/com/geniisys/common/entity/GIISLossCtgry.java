package com.geniisys.common.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIISLossCtgry extends BaseEntity{
	private String lineCd;
	private String lossCatCd;
	private String lossCatDesc;
	private String lossCatGrp;
	private String remarks;
	private String totalTag;
	private Integer perilCd;
	
	public GIISLossCtgry(){
		
	}

	/**
	 * @return the lineCd
	 */
	public String getLineCd() {
		return lineCd;
	}

	/**
	 * @param lineCd the lineCd to set
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	/**
	 * @return the lossCatCd
	 */
	public String getLossCatCd() {
		return lossCatCd;
	}

	/**
	 * @param lossCatCd the lossCatCd to set
	 */
	public void setLossCatCd(String lossCatCd) {
		this.lossCatCd = lossCatCd;
	}

	/**
	 * @return the lossCatDesc
	 */
	public String getLossCatDesc() {
		return lossCatDesc;
	}

	/**
	 * @param lossCatDesc the lossCatDesc to set
	 */
	public void setLossCatDesc(String lossCatDesc) {
		this.lossCatDesc = lossCatDesc;
	}

	/**
	 * @return the lossCatGrp
	 */
	public String getLossCatGrp() {
		return lossCatGrp;
	}

	/**
	 * @param lossCatGrp the lossCatGrp to set
	 */
	public void setLossCatGrp(String lossCatGrp) {
		this.lossCatGrp = lossCatGrp;
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

	/**
	 * @return the totalTag
	 */
	public String getTotalTag() {
		return totalTag;
	}

	/**
	 * @param totalTag the totalTag to set
	 */
	public void setTotalTag(String totalTag) {
		this.totalTag = totalTag;
	}

	/**
	 * @return the perilCd
	 */
	public Integer getPerilCd() {
		return perilCd;
	}

	/**
	 * @param perilCd the perilCd to set
	 */
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	
}
