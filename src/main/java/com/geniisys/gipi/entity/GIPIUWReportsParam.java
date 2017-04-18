package com.geniisys.gipi.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIUWReportsParam extends BaseEntity{
	
	private Integer tabNumber;
	private Integer scope;
	private Integer paramDate;
	private Date fromDate;
	private Date toDate;
	private String issCd;
	private String lineCd;
	private String sublineCd;
	private Integer issParam;
	private String specialPol;
	private Integer assdNo;
	private Integer intmNo;
	private String userId;
	private Date lastExtract;
	private Integer riCd;
	
	private String issName;
	private String lineName;
	private String sublineName;
	private String intmType;
	private String assdName;
	private String intmDesc;
	private String intmName;
	private String riName;
	
	public Integer getTabNumber() {
		return tabNumber;
	}
	
	public void setTabNumber(Integer tabNumber) {
		this.tabNumber = tabNumber;
	}
	
	public Integer getScope() {
		return scope;
	}
	
	public void setScope(Integer scope) {
		this.scope = scope;
	}
	
	public Integer getParamDate() {
		return paramDate;
	}
	
	public void setParamDate(Integer paramDate) {
		this.paramDate = paramDate;
	}
	
	public Date getFromDate() {
		return fromDate;
	}
	
	public void setFromDate(Date fromDate) {
		this.fromDate = fromDate;
	}
	
	public Date getToDate() {
		return toDate;
	}
	
	public void setToDate(Date toDate) {
		this.toDate = toDate;
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
	
	public String getSublineCd() {
		return sublineCd;
	}
	
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	
	public Integer getIssParam() {
		return issParam;
	}
	
	public void setIssParam(Integer issParam) {
		this.issParam = issParam;
	}
	
	public String getSpecialPol() {
		return specialPol;
	}
	
	public void setSpecialPol(String specialPol) {
		this.specialPol = specialPol;
	}
	
	public Integer getAssdNo() {
		return assdNo;
	}
	
	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}
	
	public Integer getIntmNo() {
		return intmNo;
	}
	
	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public Date getLastExtract() {
		return lastExtract;
	}
	
	public void setLastExtract(Date lastExtract) {
		this.lastExtract = lastExtract;
	}
	
	public Integer getRiCd() {
		return riCd;
	}
	
	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}

	public String getIssName() {
		return issName;
	}

	public void setIssName(String issName) {
		this.issName = issName;
	}

	public String getLineName() {
		return lineName;
	}

	public void setLineName(String lineName) {
		this.lineName = lineName;
	}

	public String getSublineName() {
		return sublineName;
	}

	public void setSublineName(String sublineName) {
		this.sublineName = sublineName;
	}

	public String getIntmType() {
		return intmType;
	}

	public void setIntmType(String intmType) {
		this.intmType = intmType;
	}

	public String getAssdName() {
		return assdName;
	}

	public void setAssdName(String assdName) {
		this.assdName = assdName;
	}

	public String getIntmDesc() {
		return intmDesc;
	}

	public void setIntmDesc(String intmDesc) {
		this.intmDesc = intmDesc;
	}

	public String getIntmName() {
		return intmName;
	}

	public void setIntmName(String intmName) {
		this.intmName = intmName;
	}

	public String getRiName() {
		return riName;
	}

	public void setRiName(String riName) {
		this.riName = riName;
	}

}
