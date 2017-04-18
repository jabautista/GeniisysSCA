package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

public class GIPICargo {

	private String policyId;
	private String itemNo;
	private String printTag;
	private String vesselCd;
	private String geogCd;
	private String cargoClassCd;
	private String cargoClassDesc;
	private String voyageNo;
	private String blAwb;
	private String origin;
	private String destn;
	private Date etd;
	private Date eta;
	private String cargoType;
	private String deductText;
	private String packMethod;
	private String transhipOrigin;
	private String transhipDestination;
	private String lcNo;
	private BigDecimal invoiceValue;
	private String invCurrCd;
	private String invCurrRt;
	private String markupRate;
	private String recFlagWCargo;
	private String cpiRecNo;
	private String cpiBranchCd;
	
	private String cargoTypeDesc;
	private String geogDesc;
	private String shortName;
	private String vesselName;
	private String printDesc;
	private String multiCarrier;
	private String itemTitle;
	
	public GIPICargo(){
		
	}

	public GIPICargo(String policyId, String itemNo, String printTag,
			String vesselCd, String geogCd, String cargoClassCd,
			String voyageNo, String blAwb, String origin, String destn,
			Date etd, Date eta, String cargoType, String deductText,
			String packMethod, String transhipOrigin,
			String transhipDestination, String lcNo, BigDecimal invoiceValue,
			String invCurrCd, String invCurrRt, String markupRate,
			String recFlagWCargo, String cpiRecNo, String cpiBranchCd) {
		super();
		this.policyId = policyId;
		this.itemNo = itemNo;
		this.printTag = printTag;
		this.vesselCd = vesselCd;
		this.geogCd = geogCd;
		this.cargoClassCd = cargoClassCd;
		this.voyageNo = voyageNo;
		this.blAwb = blAwb;
		this.origin = origin;
		this.destn = destn;
		this.etd = etd;
		this.eta = eta;
		this.cargoType = cargoType;
		this.deductText = deductText;
		this.packMethod = packMethod;
		this.transhipOrigin = transhipOrigin;
		this.transhipDestination = transhipDestination;
		this.lcNo = lcNo;
		this.invoiceValue = invoiceValue;
		this.invCurrCd = invCurrCd;
		this.invCurrRt = invCurrRt;
		this.markupRate = markupRate;
		this.recFlagWCargo = recFlagWCargo;
		this.cpiRecNo = cpiRecNo;
		this.cpiBranchCd = cpiBranchCd;
	}

	public String getPolicyId() {
		return policyId;
	}

	public void setPolicyId(String policyId) {
		this.policyId = policyId;
	}

	public String getItemNo() {
		return itemNo;
	}

	public void setItemNo(String itemNo) {
		this.itemNo = itemNo;
	}

	public String getPrintTag() {
		return printTag;
	}

	public void setPrintTag(String printTag) {
		this.printTag = printTag;
	}

	public String getVesselCd() {
		return vesselCd;
	}

	public void setVesselCd(String vesselCd) {
		this.vesselCd = vesselCd;
	}

	public String getGeogCd() {
		return geogCd;
	}

	public void setGeogCd(String geogCd) {
		this.geogCd = geogCd;
	}

	public String getCargoClassCd() {
		return cargoClassCd;
	}

	public void setCargoClassCd(String cargoClassCd) {
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

	public Date getEta() {
		return eta;
	}

	public void setEta(Date eta) {
		this.eta = eta;
	}

	public String getCargoType() {
		return cargoType;
	}

	public void setCargoType(String cargoType) {
		this.cargoType = cargoType;
	}

	public String getDeductText() {
		return deductText;
	}

	public void setDeductText(String deductText) {
		this.deductText = deductText;
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

	public BigDecimal getInvoiceValue() {
		return invoiceValue;
	}

	public void setInvoiceValue(BigDecimal invoiceValue) {
		this.invoiceValue = invoiceValue;
	}

	public String getInvCurrCd() {
		return invCurrCd;
	}

	public void setInvCurrCd(String invCurrCd) {
		this.invCurrCd = invCurrCd;
	}

	public String getInvCurrRt() {
		return invCurrRt;
	}

	public void setInvCurrRt(String invCurrRt) {
		this.invCurrRt = invCurrRt;
	}

	public String getMarkupRate() {
		return markupRate;
	}

	public void setMarkupRate(String markupRate) {
		this.markupRate = markupRate;
	}

	public String getRecFlagWCargo() {
		return recFlagWCargo;
	}

	public void setRecFlagWCargo(String recFlagWCargo) {
		this.recFlagWCargo = recFlagWCargo;
	}

	public String getCpiRecNo() {
		return cpiRecNo;
	}

	public void setCpiRecNo(String cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	public void setCargoClassDesc(String cargoClassDesc) {
		this.cargoClassDesc = cargoClassDesc;
	}

	public String getCargoClassDesc() {
		return cargoClassDesc;
	}

	public String getCargoTypeDesc() {
		return cargoTypeDesc;
	}

	public void setCargoTypeDesc(String cargoTypeDesc) {
		this.cargoTypeDesc = cargoTypeDesc;
	}

	public String getGeogDesc() {
		return geogDesc;
	}

	public void setGeogDesc(String geogDesc) {
		this.geogDesc = geogDesc;
	}

	public String getShortName() {
		return shortName;
	}

	public void setShortName(String shortName) {
		this.shortName = shortName;
	}

	public String getVesselName() {
		return vesselName;
	}

	public void setVesselName(String vesselName) {
		this.vesselName = vesselName;
	}

	public String getPrintDesc() {
		return printDesc;
	}

	public void setPrintDesc(String printDesc) {
		this.printDesc = printDesc;
	}

	public String getMultiCarrier() {
		return multiCarrier;
	}

	public void setMultiCarrier(String multiCarrier) {
		this.multiCarrier = multiCarrier;
	}

	public String getItemTitle() {
		return itemTitle;
	}

	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}
	
	
}
