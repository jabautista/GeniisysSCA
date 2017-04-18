/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import java.math.BigDecimal;
import com.geniisys.giis.entity.BaseEntity;


/**
 * The Class GIISBlock.
 */
public class GIISBlock extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 2431619808918459479L;

	/** The district no. */
	private String districtNo;
	
	/** The block no. */
	private String blockNo;
	
	/** The block desc. */
	private String blockDesc;
	
	/** The retn lim amt. */
	private BigDecimal retnLimAmt;
	
	/** The trty l im amt. */
	private BigDecimal trtyLimAmt;
	
	/** The eq zone. */
	private String eqZone;
	private String eqDesc;
	
	/** The flood zone. */
	private String floodZone;
	private String floodZoneDesc;
	
	/** The typhoon zone. */
	private String typhoonZone;
	private String typhoonZoneDesc;
	/** The sheet no. */
	private String sheetNo;
	
	/** The district desc. */
	private String districtDesc;
	
	/** The beg balance. */
	private BigDecimal begBalance;
	
	/** The netret beg balance. */
	private BigDecimal netretBegBal;
	
	/** The facul beg balance. */
	private BigDecimal faculBegBal;
	
	/** The trty beg balance. */
	private BigDecimal trtyBegBal;
	
	/** The remarks. */
	private String remarks;
	
	/** The cpi rec no. */
	private Integer cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;
	
	/** The city cd. */
	private String cityCd;
	
	/** The block id. */
	private Integer blockId;
	
	/** The province cd. */
	private String provinceCd;
	
	/** The city. */
	private String city;
	
	/** The province. */
	private String province;
	
	private String regionCd;
	
	private String activeTag;

	/**
	 * @return the activeTag
	 */
	public String getActiveTag() {
		return activeTag;
	}

	/**
	 * @param activeTag the activeTag to set
	 */
	public void setActiveTag(String activeTag) {
		this.activeTag = activeTag;
	}

	public String getRegionCd() {
		return regionCd;
	}

	public void setRegionCd(String regionCd) {
		this.regionCd = regionCd;
	}

	/**
	 * Gets the district no.
	 * 
	 * @return the district no
	 */
	public String getDistrictNo() {
		return districtNo;
	}

	/**
	 * Sets the district no.
	 * 
	 * @param districtNo the new district no
	 */
	public void setDistrictNo(String districtNo) {
		this.districtNo = districtNo;
	}

	/**
	 * Gets the block no.
	 * 
	 * @return the block no
	 */
	public String getBlockNo() {
		return blockNo;
	}

	/**
	 * Sets the block no.
	 * 
	 * @param blockNo the new block no
	 */
	public void setBlockNo(String blockNo) {
		this.blockNo = blockNo;
	}

	/**
	 * Gets the block desc.
	 * 
	 * @return the block desc
	 */
	public String getBlockDesc() {
		return blockDesc;
	}

	/**
	 * Sets the block desc.
	 * 
	 * @param blockDesc the new block desc
	 */
	public void setBlockDesc(String blockDesc) {
		this.blockDesc = blockDesc;
	}

	/**
	 * Gets the retn lim amt.
	 * 
	 * @return the retn lim amt
	 */
	public BigDecimal getRetnLimAmt() {
		return retnLimAmt;
	}

	/**
	 * Sets the retn lim amt.
	 * 
	 * @param retnLimAmt the new retn lim amt
	 */
	public void setRetnLimAmt(BigDecimal retnLimAmt) {
		this.retnLimAmt = retnLimAmt;
	}

	/**
	 * Gets the trty l im amt.
	 * 
	 * @return the trty l im amt
	 */
	public BigDecimal getTrtyLimAmt() {
		return trtyLimAmt;
	}

	/**
	 * Sets the trty l im amt.
	 * 
	 * @param trtyLImAmt the new trty l im amt
	 */
	public void setTrtyLimAmt(BigDecimal trtyLimAmt) {
		this.trtyLimAmt = trtyLimAmt;
	}

	/**
	 * Gets the eq zone.
	 * 
	 * @return the eq zone
	 */
	public String getEqZone() {
		return eqZone;
	}

	/**
	 * Sets the eq zone.
	 * 
	 * @param eqZone the new eq zone
	 */
	public void setEqZone(String eqZone) {
		this.eqZone = eqZone;
	}

	/**
	 * Gets the flood zone.
	 * 
	 * @return the flood zone
	 */
	public String getFloodZone() {
		return floodZone;
	}

	/**
	 * Sets the flood zone.
	 * 
	 * @param floodZone the new flood zone
	 */
	public void setFloodZone(String floodZone) {
		this.floodZone = floodZone;
	}

	/**
	 * Gets the typhoon zone.
	 * 
	 * @return the typhoon zone
	 */
	public String getTyphoonZone() {
		return typhoonZone;
	}

	/**
	 * Sets the typhoon zone.
	 * 
	 * @param typhoonZone the new typhoon zone
	 */
	public void setTyphoonZone(String typhoonZone) {
		this.typhoonZone = typhoonZone;
	}

	/**
	 * Gets the sheet no.
	 * 
	 * @return the sheet no
	 */
	public String getSheetNo() {
		return sheetNo;
	}

	/**
	 * Sets the sheet no.
	 * 
	 * @param sheetNo the new sheet no
	 */
	public void setSheetNo(String sheetNo) {
		this.sheetNo = sheetNo;
	}

	/**
	 * Gets the district desc.
	 * 
	 * @return the district desc
	 */
	public String getDistrictDesc() {
		return districtDesc;
	}

	/**
	 * Sets the district desc.
	 * 
	 * @param districtDesc the new district desc
	 */
	public void setDistrictDesc(String districtDesc) {
		this.districtDesc = districtDesc;
	}

	/**
	 * Gets the beg bal.
	 * 
	 * @return the beg bal
	 */
	public BigDecimal getBegBalance() {
		return begBalance;
	}

	/**
	 * Sets the beg bal.
	 * 
	 * @param begBalance the new beg bal
	 */
	public void setBegBalance(BigDecimal begBalance) {
		this.begBalance = begBalance;
	}

	/**
	 * Gets the netret beg bal.
	 * 
	 * @return the netret beg bal
	 */
	public BigDecimal getNetretBegBal() {
		return netretBegBal;
	}

	/**
	 * Sets the netret beg bal.
	 * 
	 * @param netretBegBal the new netret beg bal
	 */
	public void setNetretBegBal(BigDecimal netretBegBal) {
		this.netretBegBal = netretBegBal;
	}

	/**
	 * Gets the facul beg bal.
	 * 
	 * @return the facul beg bal
	 */
	public BigDecimal getFaculBegBal() {
		return faculBegBal;
	}

	/**
	 * Sets the facul beg bal.
	 * 
	 * @param faculBegBal the new facul beg bal
	 */
	public void setFaculBegBal(BigDecimal faculBegBal) {
		this.faculBegBal = faculBegBal;
	}

	/**
	 * Gets the trty beg bal.
	 * 
	 * @return the trty beg bal
	 */
	public BigDecimal getTrtyBegBal() {
		return trtyBegBal;
	}

	/**
	 * Sets the trty beg balance.
	 * 
	 * @param trtyBegBa the new trty beg bal
	 */
	public void setTrtyBegBal(BigDecimal trtyBegBal) {
		this.trtyBegBal = trtyBegBal;
	}

	/**
	 * Gets the remarks.
	 * 
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * Sets the remarks.
	 * 
	 * @param remarks the new remarks
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	/**
	 * Gets the cpi rec no.
	 * 
	 * @return the cpi rec no
	 */
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	/**
	 * Sets the cpi rec no.
	 * 
	 * @param cpiRecNo the new cpi rec no
	 */
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	/**
	 * Gets the cpi branch cd.
	 * 
	 * @return the cpi branch cd
	 */
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	/**
	 * Sets the cpi branch cd.
	 * 
	 * @param cpiBranchCd the new cpi branch cd
	 */
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	/**
	 * Gets the city cd.
	 * 
	 * @return the city cd
	 */
	public String getCityCd() {
		return cityCd;
	}

	/**
	 * Sets the city cd.
	 * 
	 * @param cityCd the new city cd
	 */
	public void setCityCd(String cityCd) {
		this.cityCd = cityCd;
	}

	/**
	 * Gets the block id.
	 * 
	 * @return the block id
	 */
	public Integer getBlockId() {
		return blockId;
	}

	/**
	 * Sets the block id.
	 * 
	 * @param blockId the new block id
	 */
	public void setBlockId(Integer blockId) {
		this.blockId = blockId;
	}

	/**
	 * Gets the province cd.
	 * 
	 * @return the province cd
	 */
	public String getProvinceCd() {
		return provinceCd;
	}

	/**
	 * Sets the province cd.
	 * 
	 * @param provinceCd the new province cd
	 */
	public void setProvinceCd(String provinceCd) {
		this.provinceCd = provinceCd;
	}

	/**
	 * Gets the city.
	 * 
	 * @return the city
	 */
	public String getCity() {
		return city;
	}

	/**
	 * Sets the city.
	 * 
	 * @param city the new city
	 */
	public void setCity(String city) {
		this.city = city;
	}

	/**
	 * Gets the province.
	 * 
	 * @return the province
	 */
	public String getProvince() {
		return province;
	}

	/**
	 * Sets the province.
	 * 
	 * @param province the new province
	 */
	public void setProvince(String province) {
		this.province = province;
	}

	public void setEqDesc(String eqDesc) {
		this.eqDesc = eqDesc;
	}

	public String getEqDesc() {
		return eqDesc;
	}

	public void setFloodZoneDesc(String floodZoneDesc) {
		this.floodZoneDesc = floodZoneDesc;
	}

	public String getFloodZoneDesc() {
		return floodZoneDesc;
	}

	public void setTyphoonZoneDesc(String typhoonZoneDesc) {
		this.typhoonZoneDesc = typhoonZoneDesc;
	}

	public String getTyphoonZoneDesc() {
		return typhoonZoneDesc;
	}

}
