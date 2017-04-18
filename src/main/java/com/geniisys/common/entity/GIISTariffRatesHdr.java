package com.geniisys.common.entity;


public class GIISTariffRatesHdr extends GIISTariffRatesDtl{
	
	private String premTag;
	private String tarfSw;
	private Integer tariffCd;
	
	//added by shan 01.06.2014
	private String lineCd;
	private String lineName;
	private String sublineCd;
	private String sublineName;
	private Integer perilCd;
	private String perilName;
	private String sublineTypeCd;
	private String sublineTypeDesc;
	private Integer motortypeCd;
	private String motortypeDesc;
	private String constructionCd;
	private String constructionDesc;
	private String tariffZone;
	private String tariffZoneDesc;
	private Integer coverageCd;
	private String coverageDesc;
	private String tarfCd;
	private String tarfDesc;
	private String defaultPremTag;
	private String remarks;
	private Object giisTariffRatesDtl;
	
	
	public String getPremTag() {
		return premTag;
	}
	
	public void setPremTag(String premTag) {
		this.premTag = premTag;
	}
	
	public String getTarfSw() {
		return tarfSw;
	}
	
	public void setTarfSw(String tarfSw) {
		this.tarfSw = tarfSw;
	}
	
	public Integer getTariffCd() {
		return tariffCd;
	}
	
	public void setTariffCd(Integer tariffCd) {
		this.tariffCd = tariffCd;
	}
	
	public String getLineCd() {
		return lineCd;
	}
	
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	
	public String getLineName() {
		return lineName;
	}
	
	public void setLineName(String lineName) {
		this.lineName = lineName;
	}
	
	public String getSublineCd() {
		return sublineCd;
	}
	
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	
	public String getSublineName() {
		return sublineName;
	}
	
	public void setSublineName(String sublineName) {
		this.sublineName = sublineName;
	}
	
	public Integer getPerilCd() {
		return perilCd;
	}
	
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	
	public String getPerilName() {
		return perilName;
	}
	
	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}
	
	public String getSublineTypeCd() {
		return sublineTypeCd;
	}
	
	public void setSublineTypeCd(String sublineTypeCd) {
		this.sublineTypeCd = sublineTypeCd;
	}
	
	public String getSublineTypeDesc() {
		return sublineTypeDesc;
	}
	
	public void setSublineTypeDesc(String sublineTypeDesc) {
		this.sublineTypeDesc = sublineTypeDesc;
	}
	
	public Integer getMotortypeCd() {
		return motortypeCd;
	}
	
	public void setMotortypeCd(Integer motortypeCd) {
		this.motortypeCd = motortypeCd;
	}
	
	public String getMotortypeDesc() {
		return motortypeDesc;
	}
	
	public void setMotortypeDesc(String motortypeDesc) {
		this.motortypeDesc = motortypeDesc;
	}
	
	public String getConstructionCd() {
		return constructionCd;
	}
	
	public void setConstructionCd(String constructionCd) {
		this.constructionCd = constructionCd;
	}
	
	public String getConstructionDesc() {
		return constructionDesc;
	}
	
	public void setConstructionDesc(String constructionDesc) {
		this.constructionDesc = constructionDesc;
	}
	
	public String getTariffZone() {
		return tariffZone;
	}
	
	public void setTariffZone(String tariffZone) {
		this.tariffZone = tariffZone;
	}
	
	public String getTariffZoneDesc() {
		return tariffZoneDesc;
	}
	
	public void setTariffZoneDesc(String tariffZoneDesc) {
		this.tariffZoneDesc = tariffZoneDesc;
	}
	
	public Integer getCoverageCd() {
		return coverageCd;
	}
	
	public void setCoverageCd(Integer coverageCd) {
		this.coverageCd = coverageCd;
	}
	
	public String getCoverageDesc() {
		return coverageDesc;
	}
	
	public void setCoverageDesc(String coverageDesc) {
		this.coverageDesc = coverageDesc;
	}
	
	public String getTarfCd() {
		return tarfCd;
	}
	
	public void setTarfCd(String tarfCd) {
		this.tarfCd = tarfCd;
	}
	
	public String getTarfDesc() {
		return tarfDesc;
	}
	
	public void setTarfDesc(String tarfDesc) {
		this.tarfDesc = tarfDesc;
	}
	
	public String getDefaultPremTag() {
		return defaultPremTag;
	}
	
	public void setDefaultPremTag(String defaultPremTag) {
		this.defaultPremTag = defaultPremTag;
	}
	
	public String getRemarks() {
		return remarks;
	}
	
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	/**
	 * @return the giisTariffRatesDtl
	 */
	public Object getGiisTariffRatesDtl() {
		return giisTariffRatesDtl;
	}

	/**
	 * @param giisTariffRatesDtl the giisTariffRatesDtl to set
	 */
	public void setGiisTariffRatesDtl(Object giisTariffRatesDtl) {
		this.giisTariffRatesDtl = giisTariffRatesDtl;
	}
}
