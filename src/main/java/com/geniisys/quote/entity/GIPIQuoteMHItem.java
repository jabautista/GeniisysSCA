package com.geniisys.quote.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIQuoteMHItem extends BaseEntity{
	
	private Integer quoteId;
	private Integer itemNo;
	private String vesselCd;
	private String geogLimit;
	private String recFlag;
	private String deductText;
	private Date dryDate;
	private String dryPlace;
	private String userId;
	private Date lastUpdate;
	
	private String dspVesselName;
	private String dspVestypeDesc;
	private String dspVessClassDesc;
	private String dspRegOwner;
	private BigDecimal dspGrossTon;
	private BigDecimal dspNetTon;
	private Integer dspDeadWeight;
	private BigDecimal dspVesselLength;
	private BigDecimal dspVesselBreadth;
	private BigDecimal dspVesselDepth;
	private String dspVesselOldName;
	private String dspPropelSw;
	private String dspHullDesc;
	private String dspRegPlace;
	private Integer dspYearBuilt;
	private Integer dspNoCrew;
	private String dspCrewNat;
	
	public GIPIQuoteMHItem() {
		super();
	}

	public Integer getQuoteId() {
		return quoteId;
	}

	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	public String getVesselCd() {
		return vesselCd;
	}

	public void setVesselCd(String vesselCd) {
		this.vesselCd = vesselCd;
	}

	public String getGeogLimit() {
		return geogLimit;
	}

	public void setGeogLimit(String geogLimit) {
		this.geogLimit = geogLimit;
	}

	public String getRecFlag() {
		return recFlag;
	}

	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}

	public String getDeductText() {
		return deductText;
	}

	public void setDeductText(String deductText) {
		this.deductText = deductText;
	}

	public Date getDryDate() {
		return dryDate;
	}

	public void setDryDate(Date dryDate) {
		this.dryDate = dryDate;
	}
	
	public Object getStrDryDate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (dryDate != null) {
			return df.format(dryDate);
		} else {
			return null;
		}
	}

	public String getDryPlace() {
		return dryPlace;
	}

	public void setDryPlace(String dryPlace) {
		this.dryPlace = dryPlace;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Date getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	
	public Object getStrLastUpdate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (lastUpdate != null) {
			return df.format(lastUpdate);
		} else {
			return null;
		}
	}

	public String getDspVesselName() {
		return dspVesselName;
	}

	public void setDspVesselName(String dspVesselName) {
		this.dspVesselName = dspVesselName;
	}

	public String getDspVestypeDesc() {
		return dspVestypeDesc;
	}

	public void setDspVestypeDesc(String dspVestypeDesc) {
		this.dspVestypeDesc = dspVestypeDesc;
	}

	public String getDspVessClassDesc() {
		return dspVessClassDesc;
	}

	public void setDspVessClassDesc(String dspVessClassDesc) {
		this.dspVessClassDesc = dspVessClassDesc;
	}

	public String getDspRegOwner() {
		return dspRegOwner;
	}

	public void setDspRegOwner(String dspRegOwner) {
		this.dspRegOwner = dspRegOwner;
	}

	public BigDecimal getDspGrossTon() {
		return dspGrossTon;
	}

	public void setDspGrossTon(BigDecimal dspGrossTon) {
		this.dspGrossTon = dspGrossTon;
	}

	public BigDecimal getDspNetTon() {
		return dspNetTon;
	}

	public void setDspNetTon(BigDecimal dspNetTon) {
		this.dspNetTon = dspNetTon;
	}

	public Integer getDspDeadWeight() {
		return dspDeadWeight;
	}

	public void setDspDeadWeight(Integer dspDeadWeight) {
		this.dspDeadWeight = dspDeadWeight;
	}

	public BigDecimal getDspVesselLength() {
		return dspVesselLength;
	}

	public void setDspVesselLength(BigDecimal dspVesselLength) {
		this.dspVesselLength = dspVesselLength;
	}

	public BigDecimal getDspVesselBreadth() {
		return dspVesselBreadth;
	}

	public void setDspVesselBreadth(BigDecimal dspVesselBreadth) {
		this.dspVesselBreadth = dspVesselBreadth;
	}

	public BigDecimal getDspVesselDepth() {
		return dspVesselDepth;
	}

	public void setDspVesselDepth(BigDecimal dspVesselDepth) {
		this.dspVesselDepth = dspVesselDepth;
	}

	public String getDspVesselOldName() {
		return dspVesselOldName;
	}

	public void setDspVesselOldName(String dspVesselOldName) {
		this.dspVesselOldName = dspVesselOldName;
	}

	public String getDspPropelSw() {
		return dspPropelSw;
	}

	public void setDspPropelSw(String dspPropelSw) {
		this.dspPropelSw = dspPropelSw;
	}

	public String getDspHullDesc() {
		return dspHullDesc;
	}

	public void setDspHullDesc(String dspHullDesc) {
		this.dspHullDesc = dspHullDesc;
	}

	public String getDspRegPlace() {
		return dspRegPlace;
	}

	public void setDspRegPlace(String dspRegPlace) {
		this.dspRegPlace = dspRegPlace;
	}

	public Integer getDspYearBuilt() {
		return dspYearBuilt;
	}

	public void setDspYearBuilt(Integer dspYearBuilt) {
		this.dspYearBuilt = dspYearBuilt;
	}

	public Integer getDspNoCrew() {
		return dspNoCrew;
	}

	public void setDspNoCrew(Integer dspNoCrew) {
		this.dspNoCrew = dspNoCrew;
	}

	public String getDspCrewNat() {
		return dspCrewNat;
	}

	public void setDspCrewNat(String dspCrewNat) {
		this.dspCrewNat = dspCrewNat;
	}
	
}
