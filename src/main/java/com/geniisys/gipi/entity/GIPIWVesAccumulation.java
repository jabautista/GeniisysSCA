package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWVesAccumulation extends BaseEntity{
	private String vesselCd;
	private Integer parId;
	private Integer itemNo;
	private String eta;
	private String etd;
	private BigDecimal tsiAmt;
	private String recFlag;
	private String effDate;
	
	public String getVesselCd() {
		return vesselCd;
	}
	public void setVesselCd(String vesselCd) {
		this.vesselCd = vesselCd;
	}
	public Integer getParId() {
		return parId;
	}
	public void setParId(Integer parId) {
		this.parId = parId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public String getEta() {
		return eta;
	}
	public void setEta(String eta) {
		this.eta = eta;
	}
	public String getEtd() {
		return etd;
	}
	public void setEtd(String etd) {
		this.etd = etd;
	}
	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}
	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}
	public String getRecFlag() {
		return recFlag;
	}
	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}
	public String getEffDate() {
		return effDate;
	}
	public void setEffDate(String effDate) {
		this.effDate = effDate;
	}	
}
