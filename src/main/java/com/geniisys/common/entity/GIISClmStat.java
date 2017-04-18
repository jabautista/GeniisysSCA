package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISClmStat extends BaseEntity{
	private String clmStatCd;
	private String clmStatDesc;
	private String clmStatType;
	private String remarks;
	
	public GIISClmStat(){
		
	}

	/**
	 * @return the clmStatCd
	 */
	public String getClmStatCd() {
		return clmStatCd;
	}

	/**
	 * @param clmStatCd the clmStatCd to set
	 */
	public void setClmStatCd(String clmStatCd) {
		this.clmStatCd = clmStatCd;
	}

	/**
	 * @return the clmStatDesc
	 */
	public String getClmStatDesc() {
		return clmStatDesc;
	}

	/**
	 * @param clmStatDesc the clmStatDesc to set
	 */
	public void setClmStatDesc(String clmStatDesc) {
		this.clmStatDesc = clmStatDesc;
	}

	/**
	 * @return the clmStatType
	 */
	public String getClmStatType() {
		return clmStatType;
	}

	/**
	 * @param clmStatType the clmStatType to set
	 */
	public void setClmStatType(String clmStatType) {
		this.clmStatType = clmStatType;
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
