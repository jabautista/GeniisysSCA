package com.geniisys.gicl.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLCatDtl extends BaseEntity{
	
	private Integer catCd;
	private String catDesc;
	private String lineCd;
	private String lossCatCd;
	private Date   startDate;
	private Date   endDate;
	private String location;
	private String blockNo;
	private String districtNo;
	private String cityCd;
	private String provinceCd;
	private String remarks;
	
	public GICLCatDtl(){
		
	}

	/**
	 * @return the catCd
	 */
	public Integer getCatCd() {
		return catCd;
	}

	/**
	 * @param catCd the catCd to set
	 */
	public void setCatCd(Integer catCd) {
		this.catCd = catCd;
	}

	/**
	 * @return the catDesc
	 */
	public String getCatDesc() {
		return catDesc;
	}

	/**
	 * @param catDesc the catDesc to set
	 */
	public void setCatDesc(String catDesc) {
		this.catDesc = catDesc;
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
	 * @return the startDate
	 */
	public Date getStartDate() {
		return startDate;
	}

	/**
	 * @param startDate the startDate to set
	 */
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	/**
	 * @return the endDate
	 */
	public Date getEndDate() {
		return endDate;
	}

	/**
	 * @param endDate the endDate to set
	 */
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	/**
	 * @return the location
	 */
	public String getLocation() {
		return location;
	}

	/**
	 * @param location the location to set
	 */
	public void setLocation(String location) {
		this.location = location;
	}

	/**
	 * @return the blockNo
	 */
	public String getBlockNo() {
		return blockNo;
	}

	/**
	 * @param blockNo the blockNo to set
	 */
	public void setBlockNo(String blockNo) {
		this.blockNo = blockNo;
	}

	/**
	 * @return the districtNo
	 */
	public String getDistrictNo() {
		return districtNo;
	}

	/**
	 * @param districtNo the districtNo to set
	 */
	public void setDistrictNo(String districtNo) {
		this.districtNo = districtNo;
	}

	/**
	 * @return the cityCd
	 */
	public String getCityCd() {
		return cityCd;
	}

	/**
	 * @param cityCd the cityCd to set
	 */
	public void setCityCd(String cityCd) {
		this.cityCd = cityCd;
	}

	/**
	 * @return the provinceCd
	 */
	public String getProvinceCd() {
		return provinceCd;
	}

	/**
	 * @param provinceCd the provinceCd to set
	 */
	public void setProvinceCd(String provinceCd) {
		this.provinceCd = provinceCd;
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
