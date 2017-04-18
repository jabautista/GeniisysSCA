/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.entity
	File Name: GICLAviationDtl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Oct 5, 2011
	Description: 
*/


package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLAviationDtl extends BaseEntity{
	private Integer claimId;
	private Integer itemNo;
	private Integer currencyCd;
	private String itemTitle;
	private String vesselCd;
	private Integer totalFlyTime;
	private String qualification;
	private String purpose;
	private String geogLimit;
	private String deductText;
	private String recFlag;
	private Integer fixedWing;
	private Integer rotor;
	private Integer prevUtilHrs;
	private Integer estUtilHrs;
	private String dspRpcNo; //benjo 09.08.2015 GENQA-SR-4874 dspRcpNo -> dspRpcNo
	private String dspVesselName;
	private String dspAirType;
	private String lossDate;
	private BigDecimal currencyRate;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	
	private String itemDesc;
	private String itemDesc2;
	private String dspCurrencyDesc;
	private String giclItemPerilExist;
	private String giclMortgageeExist;
	private String giclItemPerilMsg;
	
	
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
	public String getLossDate() {
		return lossDate;
	}
	public void setLossDate(String lossDate) {
		this.lossDate = lossDate;
	}
	/*benjo 09.07.2015 GENQA-SR-4874 dspRcpNo->dspRpcNo*/
	public String getDspRpcNo() {
		return dspRpcNo;
	}
	public void setDspRpcNo(String dspRcpNo) {
		this.dspRpcNo = dspRcpNo;
	}
	public String getDspVesselName() {
		return dspVesselName;
	}
	public void setDspVesselName(String dspVesselName) {
		this.dspVesselName = dspVesselName;
	}
	public String getDspAirType() {
		return dspAirType;
	}
	public void setDspAirType(String dspAirType) {
		this.dspAirType = dspAirType;
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
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public String getItemTitle() {
		return itemTitle;
	}
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}
	public String getVesselCd() {
		return vesselCd;
	}
	public void setVesselCd(String vesselCd) {
		this.vesselCd = vesselCd;
	}
	public Integer getTotalFlyTime() {
		return totalFlyTime;
	}
	public void setTotalFlyTime(Integer totalFlyTime) {
		this.totalFlyTime = totalFlyTime;
	}
	public String getQualification() {
		return qualification;
	}
	public void setQualification(String qualification) {
		this.qualification = qualification;
	}
	public String getPurpose() {
		return purpose;
	}
	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}
	public String getGeogLimit() {
		return geogLimit;
	}
	public void setGeogLimit(String geogLimit) {
		this.geogLimit = geogLimit;
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
	public Integer getFixedWing() {
		return fixedWing;
	}
	public void setFixedWing(Integer fixedWing) {
		this.fixedWing = fixedWing;
	}
	public Integer getRotor() {
		return rotor;
	}
	public void setRotor(Integer rotor) {
		this.rotor = rotor;
	}
	public Integer getPrevUtilHrs() {
		return prevUtilHrs;
	}
	public void setPrevUtilHrs(Integer prevUtilHrs) {
		this.prevUtilHrs = prevUtilHrs;
	}
	public Integer getEstUtilHrs() {
		return estUtilHrs;
	}
	public void setEstUtilHrs(Integer estUtilHrs) {
		this.estUtilHrs = estUtilHrs;
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
	public String getDspCurrencyDesc() {
		return dspCurrencyDesc;
	}
	public void setDspCurrencyDesc(String dspCurrencyDesc) {
		this.dspCurrencyDesc = dspCurrencyDesc;
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
