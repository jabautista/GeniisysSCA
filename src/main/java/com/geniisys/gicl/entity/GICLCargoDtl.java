/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.entity
	File Name: GICLCargoDtl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Sep 29, 2011
	Description: 
*/


package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLCargoDtl extends BaseEntity{
	private Integer claimId;
	private Integer itemNo;
	private String itemTitle;
	private String lossDate;
	private Integer currencyCd;
	private String dspCurrencyDesc;
	private String itemDesc;
	private String itemDesc2;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private Integer geogCd;
	private Integer cargoClassCd;
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
	private BigDecimal currencyRate;
	private String vesselName;
	private String vesselCd;
	private String geogDesc;
	private String cargoClassDesc;
	private String cargoTypeDesc;
	private String giclItemPerilExist;
	private String giclMortgageeExist;
	private String giclItemPerilMsg;
	
	
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
	public String getCargoTypeDesc() {
		return cargoTypeDesc;
	}
	public void setCargoTypeDesc(String cargoTypeDesc) {
		this.cargoTypeDesc = cargoTypeDesc;
	}
	public String getGiclItemPerilExist() {
		return giclItemPerilExist;
	}
	public void setGiclItemPerilExist(String giclItemPerilExist) {
		this.giclItemPerilExist = giclItemPerilExist;
	}
	public String getGiclMortgageeExist() {
		return giclMortgageeExist;
	}
	public void setGiclMortgageeExist(String giclMortgageeExist) {
		this.giclMortgageeExist = giclMortgageeExist;
	}
	public String getGiclItemPerilMsg() {
		return giclItemPerilMsg;
	}
	public void setGiclItemPerilMsg(String giclItemPerilMsg) {
		this.giclItemPerilMsg = giclItemPerilMsg;
	}
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public String getItemTitle() {
		return itemTitle;
	}
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}
	public String getLossDate() {
		return lossDate;
	}
	public void setLossDate(String lossDate) {
		this.lossDate = lossDate;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public String getDspCurrencyDesc() {
		return dspCurrencyDesc;
	}
	public void setDspCurrencyDesc(String dspCurrencyDesc) {
		this.dspCurrencyDesc = dspCurrencyDesc;
	}
	public String getItemDesc() {
		return itemDesc;
	}
	public void setItemDesc(String itemDesc) {
		this.itemDesc = itemDesc;
	}
	public String getItemDesc2() {
		return itemDesc2;
	}
	public void setItemDesc2(String itemDesc2) {
		this.itemDesc2 = itemDesc2;
	}
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
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
	
	public Object getStrEtd(){
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(etd != null){
			return sdf.format(etd).toString();
		} else {
			return null;
		}
		
	}
	
	public Object getStrEta(){
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(eta != null){
			return sdf.format(eta).toString();
		} else {
			return null;
		}
		
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
	/**
	 * @param currencyRate the currencyRate to set
	 */
	public void setCurrencyRate(BigDecimal currencyRate) {
		this.currencyRate = currencyRate;
	}
	/**
	 * @return the currencyRate
	 */
	public BigDecimal getCurrencyRate() {
		return currencyRate;
	}
	
	
}
