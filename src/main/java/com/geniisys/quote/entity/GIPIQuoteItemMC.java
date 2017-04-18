package com.geniisys.quote.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIQuoteItemMC extends BaseEntity{
	
	private Integer quoteId;
	private Integer itemNo;
	private String plateNo;
	private String motorNo;
	private String serialNo;
	private String sublineTypeCd;
	private Integer motType;
	private Integer carCompanyCd;
	private Integer cocYy;
	private Integer cocSeqNo;
	private Integer cocSerialNo;
	private String cocType;
	private Integer repairLim;
	private String color;
	private String modelYear;
	private String make;
	private BigDecimal estValue;
	private BigDecimal towing;
	private String assignee;
	private Integer noOfPass;
	private String tariffZone;
	private Date cocIssueDate;
	private String mvFileNo;
	private String acquiredFrom;
	private String ctvTag;
	private Integer typeOfBodyCd;
	private String unladenWt;
	private Integer makeCd;
	private Integer seriesCd;
	private String basicColorCd;
	private Integer colorCd;
	private String origin;
	private String destination;
	private String cocAtcn;
	private String userId;
	private Date lastUpdate;
	private String sublineCd;
	
	private String dspBasicColor;
	private BigDecimal dspDeductibles;
	private BigDecimal dspRepairLim;
	private String dspTypeOfBodyCd;
	private String dspCarCompanyCd;
	private String dspEngineSeries;
	private String dspMotType;
	private String dspSublineTypeCd;
	
	public GIPIQuoteItemMC() {
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

	public String getPlateNo() {
		return plateNo;
	}

	public void setPlateNo(String plateNo) {
		this.plateNo = plateNo;
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

	public String getSublineTypeCd() {
		return sublineTypeCd;
	}

	public void setSublineTypeCd(String sublineTypeCd) {
		this.sublineTypeCd = sublineTypeCd;
	}

	public Integer getMotType() {
		return motType;
	}

	public void setMotType(Integer motType) {
		this.motType = motType;
	}

	public Integer getCarCompanyCd() {
		return carCompanyCd;
	}

	public void setCarCompanyCd(Integer carCompanyCd) {
		this.carCompanyCd = carCompanyCd;
	}

	public Integer getCocYy() {
		return cocYy;
	}

	public void setCocYy(Integer cocYy) {
		this.cocYy = cocYy;
	}

	public Integer getCocSeqNo() {
		return cocSeqNo;
	}

	public void setCocSeqNo(Integer cocSeqNo) {
		this.cocSeqNo = cocSeqNo;
	}

	public Integer getCocSerialNo() {
		return cocSerialNo;
	}

	public void setCocSerialNo(Integer cocSerialNo) {
		this.cocSerialNo = cocSerialNo;
	}

	public String getCocType() {
		return cocType;
	}

	public void setCocType(String cocType) {
		this.cocType = cocType;
	}

	public Integer getRepairLim() {
		return repairLim;
	}

	public void setRepairLim(Integer repairLim) {
		this.repairLim = repairLim;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public String getModelYear() {
		return modelYear;
	}

	public void setModelYear(String modelYear) {
		this.modelYear = modelYear;
	}

	public String getMake() {
		return make;
	}

	public void setMake(String make) {
		this.make = make;
	}

	public BigDecimal getEstValue() {
		return estValue;
	}

	public void setEstValue(BigDecimal estValue) {
		this.estValue = estValue;
	}

	public BigDecimal getTowing() {
		return towing;
	}

	public void setTowing(BigDecimal towing) {
		this.towing = towing;
	}

	public String getAssignee() {
		return assignee;
	}

	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}

	public Integer getNoOfPass() {
		return noOfPass;
	}

	public void setNoOfPass(Integer noOfPass) {
		this.noOfPass = noOfPass;
	}

	public String getTariffZone() {
		return tariffZone;
	}

	public void setTariffZone(String tariffZone) {
		this.tariffZone = tariffZone;
	}

	public Date getCocIssueDate() {
		return cocIssueDate;
	}

	public void setCocIssueDate(Date cocIssueDate) {
		this.cocIssueDate = cocIssueDate;
	}
	
	public Object getStrCocIssueDate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (cocIssueDate != null) {
			return df.format(cocIssueDate);
		} else {
			return null;
		}
	}

	public String getMvFileNo() {
		return mvFileNo;
	}

	public void setMvFileNo(String mvFileNo) {
		this.mvFileNo = mvFileNo;
	}

	public String getAcquiredFrom() {
		return acquiredFrom;
	}

	public void setAcquiredFrom(String acquiredFrom) {
		this.acquiredFrom = acquiredFrom;
	}

	public String getCtvTag() {
		return ctvTag;
	}

	public void setCtvTag(String ctvTag) {
		this.ctvTag = ctvTag;
	}

	public Integer getTypeOfBodyCd() {
		return typeOfBodyCd;
	}

	public void setTypeOfBodyCd(Integer typeOfBodyCd) {
		this.typeOfBodyCd = typeOfBodyCd;
	}

	public String getUnladenWt() {
		return unladenWt;
	}

	public void setUnladenWt(String unladenWt) {
		this.unladenWt = unladenWt;
	}

	public Integer getMakeCd() {
		return makeCd;
	}

	public void setMakeCd(Integer makeCd) {
		this.makeCd = makeCd;
	}

	public Integer getSeriesCd() {
		return seriesCd;
	}

	public void setSeriesCd(Integer seriesCd) {
		this.seriesCd = seriesCd;
	}

	public String getBasicColorCd() {
		return basicColorCd;
	}

	public void setBasicColorCd(String basicColorCd) {
		this.basicColorCd = basicColorCd;
	}

	public Integer getColorCd() {
		return colorCd;
	}

	public void setColorCd(Integer colorCd) {
		this.colorCd = colorCd;
	}

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getDestination() {
		return destination;
	}

	public void setDestination(String destination) {
		this.destination = destination;
	}

	public String getCocAtcn() {
		return cocAtcn;
	}

	public void setCocAtcn(String cocAtcn) {
		this.cocAtcn = cocAtcn;
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

	public String getSublineCd() {
		return sublineCd;
	}

	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	public String getDspBasicColor() {
		return dspBasicColor;
	}

	public void setDspBasicColor(String dspBasicColor) {
		this.dspBasicColor = dspBasicColor;
	}

	public BigDecimal getDspDeductibles() {
		return dspDeductibles;
	}

	public void setDspDeductibles(BigDecimal dspDeductibles) {
		this.dspDeductibles = dspDeductibles;
	}

	public BigDecimal getDspRepairLim() {
		return dspRepairLim;
	}

	public void setDspRepairLim(BigDecimal dspRepairLim) {
		this.dspRepairLim = dspRepairLim;
	}

	public String getDspTypeOfBodyCd() {
		return dspTypeOfBodyCd;
	}

	public void setDspTypeOfBodyCd(String dspTypeOfBodyCd) {
		this.dspTypeOfBodyCd = dspTypeOfBodyCd;
	}

	public String getDspCarCompanyCd() {
		return dspCarCompanyCd;
	}

	public void setDspCarCompanyCd(String dspCarCompanyCd) {
		this.dspCarCompanyCd = dspCarCompanyCd;
	}

	public String getDspEngineSeries() {
		return dspEngineSeries;
	}

	public void setDspEngineSeries(String dspEngineSeries) {
		this.dspEngineSeries = dspEngineSeries;
	}

	public String getDspMotType() {
		return dspMotType;
	}

	public void setDspMotType(String dspMotType) {
		this.dspMotType = dspMotType;
	}

	public String getDspSublineTypeCd() {
		return dspSublineTypeCd;
	}

	public void setDspSublineTypeCd(String dspSublineTypeCd) {
		this.dspSublineTypeCd = dspSublineTypeCd;
	}
	
}
