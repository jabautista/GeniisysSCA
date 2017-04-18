package com.geniisys.quote.entity;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIQuoteCargo extends BaseEntity{
	
	private Integer quoteId;
	private Integer itemNo;
	private String vesselCd;
	private Integer geogCd;
	private Integer cargoClassCd;
	private String voyageNo;
	private String blAwb;
	private String origin;
	private String destn;
	private Date etd;
	private Date eta;
	private String cargoType;
	private String packMethod;
	private String transhipOrigin;
	private String transhipDestination;
	private String lcNo;
	private String userId;
	private Date lastUpdate;
	private String deductText;
	private String recFlag;
	private Integer printTag;
	
	private String dspGeogDesc;
	private String dspVesselName;
	private String dspCargoClassDesc;
	private String dspCargoTypeDesc;
	private String dspPrintTagDesc;
	
	public GIPIQuoteCargo() {
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

	public String getVoyageNo() {
		return voyageNo;
	}

	public void setVoyageNo(String voyageNo) {
		this.voyageNo = voyageNo;
	}

	public String getBlAwb() {
		return blAwb;
	}

	public void setBlAwb(String blAwb) {
		this.blAwb = blAwb;
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

	public Date getEtd() {
		return etd;
	}

	public void setEtd(Date etd) {
		this.etd = etd;
	}
	
	public Object getStrEtd(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (etd != null) {
			return df.format(etd);
		} else {
			return null;
		}
	}

	public Date getEta() {
		return eta;
	}

	public void setEta(Date eta) {
		this.eta = eta;
	}
	
	public Object getStrEta(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (eta != null) {
			return df.format(eta);
		} else {
			return null;
		}
	}

	public String getCargoType() {
		return cargoType;
	}

	public void setCargoType(String cargoType) {
		this.cargoType = cargoType;
	}

	public String getPackMethod() {
		return packMethod;
	}

	public void setPackMethod(String packMethod) {
		this.packMethod = packMethod;
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

	public String getLcNo() {
		return lcNo;
	}

	public void setLcNo(String lcNo) {
		this.lcNo = lcNo;
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

	public String getDeductText() {
		return deductText;
	}

	public void setDeductText(String deductText) {
		this.deductText = deductText;
	}

	public String getRecFlag() {
		return recFlag;
	}

	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}

	public Integer getPrintTag() {
		return printTag;
	}

	public void setPrintTag(Integer printTag) {
		this.printTag = printTag;
	}

	public String getDspGeogDesc() {
		return dspGeogDesc;
	}

	public void setDspGeogDesc(String dspGeogDesc) {
		this.dspGeogDesc = dspGeogDesc;
	}

	public String getDspVesselName() {
		return dspVesselName;
	}

	public void setDspVesselName(String dspVesselName) {
		this.dspVesselName = dspVesselName;
	}

	public String getDspCargoClassDesc() {
		return dspCargoClassDesc;
	}

	public void setDspCargoClassDesc(String dspCargoClassDesc) {
		this.dspCargoClassDesc = dspCargoClassDesc;
	}

	public String getDspCargoTypeDesc() {
		return dspCargoTypeDesc;
	}

	public void setDspCargoTypeDesc(String dspCargoTypeDesc) {
		this.dspCargoTypeDesc = dspCargoTypeDesc;
	}

	public String getDspPrintTagDesc() {
		return dspPrintTagDesc;
	}

	public void setDspPrintTagDesc(String dspPrintTagDesc) {
		this.dspPrintTagDesc = dspPrintTagDesc;
	}
	
	
}
