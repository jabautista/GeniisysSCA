package com.geniisys.gixx.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIXXCargo extends BaseEntity{

	private Integer extractId;
	private Integer itemNo;
	private String vesselCd;
	private Integer geogCd;
	private Integer cargoClassCd;
	private String packMethod;
	private String blAwb;
	private String transhipOrigin;
	private String transhipDestination;
	private String deductText;
	private String cargoType;
	private String lcNo;
	private Date etd;
	private Date eta;
	private String origin;
	private String destn;
	private Integer printTag;
	
	private String geogDesc;
	private String cargoClassDesc;
	private String vesselName;
	private String cargoTypeDesc;
	private String multiCarrier;
	private String printDesc;
	private String voyageNo;
	public Integer getExtractId() {
		return extractId;
	}
	public void setExtractId(Integer extractId) {
		this.extractId = extractId;
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
	public Integer getGeogCd() {
		return geogCd;
	}
	public void setGeogCd(Integer geogCd) {
		this.geogCd = geogCd;
	}
	public Integer getCargoClassCd() {
		return cargoClassCd;
	}
	public void setCargoClassCd(Integer cargoClassCd) {
		this.cargoClassCd = cargoClassCd;
	}
	public String getPackMethod() {
		return packMethod;
	}
	public void setPackMethod(String packMethod) {
		this.packMethod = packMethod;
	}
	public String getBlAwb() {
		return blAwb;
	}
	public void setBlAwb(String blAwb) {
		this.blAwb = blAwb;
	}
	public String getTranshipOrigin() {
		return transhipOrigin;
	}
	public void setTranshipOrigin(String transhipOrigin) {
		this.transhipOrigin = transhipOrigin;
	}
	public String getTranshipDestination() {
		return transhipDestination;
	}
	public void setTranshipDestination(String transhipDestination) {
		this.transhipDestination = transhipDestination;
	}
	public String getDeductText() {
		return deductText;
	}
	public void setDeductText(String deductText) {
		this.deductText = deductText;
	}
	public String getCargoType() {
		return cargoType;
	}
	public void setCargoType(String cargoType) {
		this.cargoType = cargoType;
	}
	public String getLcNo() {
		return lcNo;
	}
	public void setLcNo(String lcNo) {
		this.lcNo = lcNo;
	}
	public Date getEtd() {
		return etd;
	}
	public void setEtd(Date etd) {
		this.etd = etd;
	}
	public Date getEta() {
		return eta;
	}
	public void setEta(Date eta) {
		this.eta = eta;
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
	public Integer getPrintTag() {
		return printTag;
	}
	public void setPrintTag(Integer printTag) {
		this.printTag = printTag;
	}
	public String getGeogDesc() {
		return geogDesc;
	}
	public void setGeogDesc(String geogDesc) {
		this.geogDesc = geogDesc;
	}
	public String getCargoClassDesc() {
		return cargoClassDesc;
	}
	public void setCargoClassDesc(String cargoClassDesc) {
		this.cargoClassDesc = cargoClassDesc;
	}
	public String getVesselName() {
		return vesselName;
	}
	public void setVesselName(String vesselName) {
		this.vesselName = vesselName;
	}
	public String getCargoTypeDesc() {
		return cargoTypeDesc;
	}
	public void setCargoTypeDesc(String cargoTypeDesc) {
		this.cargoTypeDesc = cargoTypeDesc;
	}
	public String getMultiCarrier() {
		return multiCarrier;
	}
	public void setMultiCarrier(String multiCarrier) {
		this.multiCarrier = multiCarrier;
	}
	public String getPrintDesc() {
		return printDesc;
	}
	public void setPrintDesc(String printDesc) {
		this.printDesc = printDesc;
	}
	public String getVoyageNo() {
		return voyageNo;
	}
	public void setVoyageNo(String voyageNo) {
		this.voyageNo = voyageNo;
	}
	
	
}
