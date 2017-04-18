package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWCargoCarrier extends BaseEntity{

	private String vesselCd;
	private String vesselName;
	private String motorNo;
	private String serialNo;
	private String plateNo;
	private String parId;
	private String itemNo;
	private BigDecimal vesselLimitOfLiab;
	private Date eta;
	private Date etd;
	private String origin;
	private String destn;
	private String deleteSw;
	private String voyLimit;
	private String userId;
	
	public GIPIWCargoCarrier(){
		
	}
	
	public GIPIWCargoCarrier(final String parId, final String itemNo,final String vesselCd,
			final BigDecimal vesselLimitOfLiab, final Date eta, final Date etd,
			final String origin, final String destn, final String deleteSw,
			final String voyLimit,final String userId){
	 	this.parId = parId;
	 	this.itemNo = itemNo;
	 	this.vesselCd = vesselCd;
	 	this.vesselLimitOfLiab = vesselLimitOfLiab;
	 	this.eta = eta;
	 	this.etd = etd;
	 	this.origin = origin;
	 	this.destn = destn;
	 	this.deleteSw = deleteSw;
	 	this.voyLimit = voyLimit;
	 	this.userId = userId;
	}
	
	public String getVesselCd() {
		return vesselCd;
	}
	public void setVesselCd(String vesselCd) {
		this.vesselCd = vesselCd;
	}
	public String getVesselName() {
		return vesselName;
	}
	public void setVesselName(String vesselName) {
		this.vesselName = vesselName;
	}
	public String getMotorNo() {
		return motorNo;
	}
	public void setMotorNo(String motorNo) {
		this.motorNo = motorNo;
	}
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	public String getPlateNo() {
		return plateNo;
	}
	public void setPlateNo(String plateNo) {
		this.plateNo = plateNo;
	}
	public String getParId() {
		return parId;
	}
	public void setParId(String parId) {
		this.parId = parId;
	}
	public String getItemNo() {
		return itemNo;
	}
	public void setItemNo(String itemNo) {
		this.itemNo = itemNo;
	}
	public BigDecimal getVesselLimitOfLiab() {
		return vesselLimitOfLiab;
	}
	public void setVesselLimitOfLiab(BigDecimal vesselLimitOfLiab) {
		this.vesselLimitOfLiab = vesselLimitOfLiab;
	}
	public Date getEta() {
		return eta;
	}
	public void setEta(Date eta) {
		this.eta = eta;
	}
	public Date getEtd() {
		return etd;
	}
	public void setEtd(Date etd) {
		this.etd = etd;
	}
	public String getOrigin() {
		return origin;
	}
	public void setOrigin(String origin) {
		this.origin = origin;
	}
	public String getDestn() {
		return destn;
	}
	public void setDestn(String destn) {
		this.destn = destn;
	}
	public String getDeleteSw() {
		return deleteSw;
	}
	public void setDeleteSw(String deleteSw) {
		this.deleteSw = deleteSw;
	}
	public String getVoyLimit() {
		return voyLimit;
	}
	public void setVoyLimit(String voyLimit) {
		this.voyLimit = voyLimit;
	}
	@Override
	public String getUserId() {
		return userId;
	}
	@Override
	public void setUserId(String userId) {
		this.userId = userId;
	}
}
