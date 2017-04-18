/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIQuoteItemMC.
 */
public class GIPIQuoteItemMC extends BaseEntity {

	/** The quote id. */
	private Integer quoteId;
 	
	 /** The item no. */
	 private Integer itemNo;
 	
	 /** The plate no. */
	 private String plateNo;
	
	/** The motor no. */
	private String motorNo;
	
	/** The serial no. */
	private String serialNo;
	
	/** The subline type cd. */
	private String sublineTypeCd;
 	
	 /** The mot type. */
	 private Integer motType;
 	
	 /** The car company cd. */
	 private Integer carCompanyCd;
	
	/** The coc yy. */
	private Integer cocYy;
  	
	  /** The coc seq no. */
	  private Integer cocSeqNo;          
 	
	 /** The coc serial no. */
	 private Integer cocSerialNo;
 	
	 /** The coc type. */
	 private String cocType;
 	
	 /** The repair lim. */
	 private BigDecimal repairLim;
 	
	 /** The color. */
	 private String color;
 	
	 /** The model year. */
	 private String modelYear;            
 	
	 /** The make. */
	 private String make;
 	
	 /** The est value. */
	 private BigDecimal estValue;
 	
	 /** The towing. */
	 private BigDecimal towing;
 	
	 /** The assignee. */
	 private String assignee;
 	
	 /** The no of pass. */
	 private Integer noOfPass;      
	
	/** The tariff zone. */
	private String tariffZone;
 	
	 /** The coc issue date. */
	 private Date cocIssueDate;
 	
	 /** The mv file no. */
	 private String mvFileNo;
 	
	 /** The acquired from. */
	 private String acquiredFrom;
 	
	 /** The ctv tag. */
	 private String ctvTag;
 	
	 /** The type of body cd. */
	 private Integer typeOfBodyCd;
 	
	 /** The unladen wt. */
	 private String unladenWt;
 	
	 /** The make cd. */
	 private Integer makeCd;
 	
	 /** The series cd. */
	 private Integer seriesCd;
 	
	 /** The basic color cd. */
	 private String basicColorCd;      
 	
	 /** The color cd. */
	 private Integer colorCd;
 	
	 /** The origin. */
	 private String origin;
 	
	 /** The destination. */
	 private String destination;
 	
	 /** The coc atcn. */
	 private String cocAtcn;
 	
	 /** The subline cd. */
	 private String sublineCd;
 	
	 /** The sub type desc. */
	 private String subTypeDesc;
 	
	 /** The car company. */
	 private String carCompany;
 	
	 /** The basic color. */
	 private String basicColor;
 	
	 /** The type of body. */
	 private String typeOfBody;
 	
	 /** The engine series. */
	 private String engineSeries;
 	
	 /** The deductible amt. */
	 private BigDecimal deductibleAmt;

	/**
	 * Gets the quote id.
	 * 
	 * @return the quote id
	 */
	public Integer getQuoteId() {
		return quoteId;
	}

	/**
	 * Sets the quote id.
	 * 
	 * @param quoteId the new quote id
	 */
	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}

	/**
	 * Gets the item no.
	 * 
	 * @return the item no
	 */
	public Integer getItemNo() {
		return itemNo;
	}

	/**
	 * Sets the item no.
	 * 
	 * @param itemNo the new item no
	 */
	public void setItemNo(Integer itemNo) {
		if (itemNo == 0) {
			this.itemNo = null;
		} else {
			this.itemNo = itemNo;
		}
	}

	/**
	 * Gets the plate no.
	 * 
	 * @return the plate no
	 */
	public String getPlateNo() {
		return plateNo;
	}

	/**
	 * Sets the plate no.
	 * 
	 * @param plateNo the new plate no
	 */
	public void setPlateNo(String plateNo) {
		this.plateNo = plateNo;
	}

	/**
	 * Gets the motor no.
	 * 
	 * @return the motor no
	 */
	public String getMotorNo() {
		return motorNo;
	}

	/**
	 * Sets the motor no.
	 * 
	 * @param motorNo the new motor no
	 */
	public void setMotorNo(String motorNo) {
		this.motorNo = motorNo;
	}

	/**
	 * Gets the serial no.
	 * 
	 * @return the serial no
	 */
	public String getSerialNo() {
		return serialNo;
	}

	/**
	 * Sets the serial no.
	 * 
	 * @param serialNo the new serial no
	 */
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	/**
	 * Gets the subline type cd.
	 * 
	 * @return the subline type cd
	 */
	public String getSublineTypeCd() {
		return sublineTypeCd;
	}

	/**
	 * Sets the subline type cd.
	 * 
	 * @param sublineTypeCd the new subline type cd
	 */
	public void setSublineTypeCd(String sublineTypeCd) {
		this.sublineTypeCd = sublineTypeCd;
	}

	/**
	 * Gets the mot type.
	 * 
	 * @return the mot type
	 */
	public Integer getMotType() {
		return motType;
	}

	/**
	 * Sets the mot type.
	 * 
	 * @param motType the new mot type
	 */
	public void setMotType(Integer motType) {
		if (motType == null) {
			this.motType = null;
		} else {
			this.motType = motType;
		}
	}

	/**
	 * Gets the car company cd.
	 * 
	 * @return the car company cd
	 */
	public Integer getCarCompanyCd() {
		return carCompanyCd;
	}

	/**
	 * Sets the car company cd.
	 * 
	 * @param carCompanyCd the new car company cd
	 */
	public void setCarCompanyCd(Integer carCompanyCd) {
		this.carCompanyCd = carCompanyCd;
	}

	/**
	 * Gets the coc yy.
	 * 
	 * @return the coc yy
	 */
	public Integer getCocYy() {
		return cocYy;
	}

	/**
	 * Sets the coc yy.
	 * 
	 * @param cocYy the new coc yy
	 */
	public void setCocYy(Integer cocYy) {
		this.cocYy = cocYy;
	}

	/**
	 * Gets the coc seq no.
	 * 
	 * @return the coc seq no
	 */
	public Integer getCocSeqNo() {
		return cocSeqNo;
	}

	/**
	 * Sets the coc seq no.
	 * 
	 * @param cocSeqNo the new coc seq no
	 */
	public void setCocSeqNo(Integer cocSeqNo) {
		this.cocSeqNo = cocSeqNo;
	}

	/**
	 * Gets the coc serial no.
	 * 
	 * @return the coc serial no
	 */
	public Integer getCocSerialNo() {
		return cocSerialNo;
	}

	/**
	 * Sets the coc serial no.
	 * 
	 * @param cocSerialNo the new coc serial no
	 */
	public void setCocSerialNo(Integer cocSerialNo) {
		this.cocSerialNo = cocSerialNo;
	}

	/**
	 * Gets the coc type.
	 * 
	 * @return the coc type
	 */
	public String getCocType() {
		return cocType;
	}

	/**
	 * Sets the coc type.
	 * 
	 * @param cocType the new coc type
	 */
	public void setCocType(String cocType) {
		this.cocType = cocType;
	}

	/**
	 * Gets the repair lim.
	 * 
	 * @return the repair lim
	 */
	public BigDecimal getRepairLim() {
		return repairLim;
	}

	/**
	 * Sets the repair lim.
	 * 
	 * @param repairLim the new repair lim
	 */
	public void setRepairLim(BigDecimal repairLim) {
		this.repairLim = repairLim;
	}

	/**
	 * Gets the color.
	 * 
	 * @return the color
	 */
	public String getColor() {
		return color;
	}

	/**
	 * Sets the color.
	 * 
	 * @param color the new color
	 */
	public void setColor(String color) {
		this.color = color;
	}

	/**
	 * Gets the model year.
	 * 
	 * @return the model year
	 */
	public String getModelYear() {
		return modelYear;
	}

	/**
	 * Sets the model year.
	 * 
	 * @param modelYear the new model year
	 */
	public void setModelYear(String modelYear) {
		this.modelYear = modelYear;
	}

	/**
	 * Gets the make.
	 * 
	 * @return the make
	 */
	public String getMake() {
		return make;
	}

	/**
	 * Sets the make.
	 * 
	 * @param make the new make
	 */
	public void setMake(String make) {
		this.make = make;
	}

	/**
	 * Gets the est value.
	 * 
	 * @return the est value
	 */
	public BigDecimal getEstValue() {
		return estValue;
	}

	/**
	 * Sets the est value.
	 * 
	 * @param estValue the new est value
	 */
	public void setEstValue(BigDecimal estValue) {
		this.estValue = estValue;
	}

	/**
	 * Gets the towing.
	 * 
	 * @return the towing
	 */
	public BigDecimal getTowing() {
		return towing;
	}

	/**
	 * Sets the towing.
	 * 
	 * @param towing the new towing
	 */
	public void setTowing(BigDecimal towing) {
		this.towing = towing;
	}

	/**
	 * Gets the assignee.
	 * 
	 * @return the assignee
	 */
	public String getAssignee() {
		return assignee;
	}

	/**
	 * Sets the assignee.
	 * 
	 * @param assignee the new assignee
	 */
	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}

	/**
	 * Gets the no of pass.
	 * 
	 * @return the no of pass
	 */
	public Integer getNoOfPass() {
		return noOfPass;
	}

	/**
	 * Sets the no of pass.
	 * 
	 * @param noOfPass the new no of pass
	 */
	public void setNoOfPass(Integer noOfPass) {
		this.noOfPass = noOfPass;
	}

	/**
	 * Gets the tariff zone.
	 * 
	 * @return the tariff zone
	 */
	public String getTariffZone() {
		return tariffZone;
	}

	/**
	 * Sets the tariff zone.
	 * 
	 * @param tariffZone the new tariff zone
	 */
	public void setTariffZone(String tariffZone) {
		this.tariffZone = tariffZone;
	}

	/**
	 * Gets the coc issue date.
	 * 
	 * @return the coc issue date
	 */
	public Date getCocIssueDate() {
		return cocIssueDate;
	}

	/**
	 * Sets the coc issue date.
	 * 
	 * @param cocIssueDate the new coc issue date
	 */
	public void setCocIssueDate(Date cocIssueDate) {
		this.cocIssueDate = cocIssueDate;
	}

	/**
	 * Gets the mv file no.
	 * 
	 * @return the mv file no
	 */
	public String getMvFileNo() {
		return mvFileNo;
	}

	/**
	 * Sets the mv file no.
	 * 
	 * @param mvFileNo the new mv file no
	 */
	public void setMvFileNo(String mvFileNo) {
		this.mvFileNo = mvFileNo;
	}

	/**
	 * Gets the acquired from.
	 * 
	 * @return the acquired from
	 */
	public String getAcquiredFrom() {
		return acquiredFrom;
	}

	/**
	 * Sets the acquired from.
	 * 
	 * @param acquiredFrom the new acquired from
	 */
	public void setAcquiredFrom(String acquiredFrom) {
		this.acquiredFrom = acquiredFrom;
	}

	/**
	 * Gets the ctv tag.
	 * 
	 * @return the ctv tag
	 */
	public String getCtvTag() {
		return ctvTag;
	}

	/**
	 * Sets the ctv tag.
	 * 
	 * @param ctvTag the new ctv tag
	 */
	public void setCtvTag(String ctvTag) {
		this.ctvTag = ctvTag;
	}

	/**
	 * Gets the type of body cd.
	 * 
	 * @return the type of body cd
	 */
	public Integer getTypeOfBodyCd() {
		return typeOfBodyCd;
	}

	/**
	 * Sets the type of body cd.
	 * 
	 * @param typeOfBodyCd the new type of body cd
	 */
	public void setTypeOfBodyCd(Integer typeOfBodyCd) {
		this.typeOfBodyCd = typeOfBodyCd;
	}

	/**
	 * Gets the unladen wt.
	 * 
	 * @return the unladen wt
	 */
	public String getUnladenWt() {
		return unladenWt;
	}

	/**
	 * Sets the unladen wt.
	 * 
	 * @param unladenWt the new unladen wt
	 */
	public void setUnladenWt(String unladenWt) {
		this.unladenWt = unladenWt;
	}

	/**
	 * Gets the make cd.
	 * 
	 * @return the make cd
	 */
	public Integer getMakeCd() {
		return makeCd;
	}

	/**
	 * Sets the make cd.
	 * 
	 * @param makeCd the new make cd
	 */
	public void setMakeCd(Integer makeCd) {
		this.makeCd = makeCd;
	}

	/**
	 * Gets the series cd.
	 * 
	 * @return the series cd
	 */
	public Integer getSeriesCd() {
		return seriesCd;
	}

	/**
	 * Sets the series cd.
	 * 
	 * @param seriesCd the new series cd
	 */
	public void setSeriesCd(Integer seriesCd) {
		this.seriesCd = seriesCd;
	}

	/**
	 * Gets the basic color cd.
	 * 
	 * @return the basic color cd
	 */
	public String getBasicColorCd() {
		return basicColorCd;
	}

	/**
	 * Sets the basic color cd.
	 * 
	 * @param basicColorCd the new basic color cd
	 */
	public void setBasicColorCd(String basicColorCd) {
		this.basicColorCd = basicColorCd;
	}

	/**
	 * Gets the color cd.
	 * 
	 * @return the color cd
	 */
	public Integer getColorCd() {
		return colorCd;
	}

	/**
	 * Sets the color cd.
	 * 
	 * @param colorCd the new color cd
	 */
	public void setColorCd(Integer colorCd) {
		this.colorCd = colorCd;
	}

	/**
	 * Gets the origin.
	 * 
	 * @return the origin
	 */
	public String getOrigin() {
		return origin;
	}

	/**
	 * Sets the origin.
	 * 
	 * @param origin the new origin
	 */
	public void setOrigin(String origin) {
		this.origin = origin;
	}

	/**
	 * Gets the destination.
	 * 
	 * @return the destination
	 */
	public String getDestination() {
		return destination;
	}

	/**
	 * Sets the destination.
	 * 
	 * @param destination the new destination
	 */
	public void setDestination(String destination) {
		this.destination = destination;
	}

	/**
	 * Gets the coc atcn.
	 * 
	 * @return the coc atcn
	 */
	public String getCocAtcn() {
		return cocAtcn;
	}

	/**
	 * Sets the coc atcn.
	 * 
	 * @param cocAtcn the new coc atcn
	 */
	public void setCocAtcn(String cocAtcn) {
		this.cocAtcn = cocAtcn;
	}

	/**
	 * Gets the subline cd.
	 * 
	 * @return the subline cd
	 */
	public String getSublineCd() {
		return sublineCd;
	}

	/**
	 * Sets the subline cd.
	 * 
	 * @param sublineCd the new subline cd
	 */
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	/**
	 * Gets the sub type desc.
	 * 
	 * @return the sub type desc
	 */
	public String getSubTypeDesc() {
		return subTypeDesc;
	}

	/**
	 * Sets the sub type desc.
	 * 
	 * @param subTypeDesc the new sub type desc
	 */
	public void setSubTypeDesc(String subTypeDesc) {
		this.subTypeDesc = subTypeDesc;
	}

	/**
	 * Gets the car company.
	 * 
	 * @return the car company
	 */
	public String getCarCompany() {
		return carCompany;
	}

	/**
	 * Sets the car company.
	 * 
	 * @param carCompany the new car company
	 */
	public void setCarCompany(String carCompany) {
		this.carCompany = carCompany;
	}

	/**
	 * Gets the basic color.
	 * 
	 * @return the basic color
	 */
	public String getBasicColor() {
		return basicColor;
	}

	/**
	 * Sets the basic color.
	 * 
	 * @param basicColor the new basic color
	 */
	public void setBasicColor(String basicColor) {
		this.basicColor = basicColor;
	}

	/**
	 * Gets the type of body.
	 * 
	 * @return the type of body
	 */
	public String getTypeOfBody() {
		return typeOfBody;
	}

	/**
	 * Sets the type of body.
	 * 
	 * @param typeOfBody the new type of body
	 */
	public void setTypeOfBody(String typeOfBody) {
		this.typeOfBody = typeOfBody;
	}

	/**
	 * Gets the engine series.
	 * 
	 * @return the engine series
	 */
	public String getEngineSeries() {
		return engineSeries;
	}

	/**
	 * Sets the engine series.
	 * 
	 * @param engineSeries the new engine series
	 */
	public void setEngineSeries(String engineSeries) {
		this.engineSeries = engineSeries;
	}

	/**
	 * Gets the deductible amt.
	 * 
	 * @return the deductible amt
	 */
	public BigDecimal getDeductibleAmt() {
		return deductibleAmt;
	}

	/**
	 * Sets the deductible amt.
	 * 
	 * @param deductibleAmt the new deductible amt
	 */
	public void setDeductibleAmt(BigDecimal deductibleAmt) {
		this.deductibleAmt = deductibleAmt;
	}

	/**
	 * Instantiates a new gIPI quote item mc.
	 */
	public GIPIQuoteItemMC()	{
 	}
 	
 	/**
	  * Instantiates a new gIPI quote item mc.
	  * 
	  * @param quoteId the quote id
	  * @param itemNo the item no
	  * @param plateNo the plate no
	  * @param motorNo the motor no
	  * @param serialNo the serial no
	  * @param sublineTypeCd the subline type cd
	  * @param motType the mot type
	  * @param carCompanyCd the car company cd
	  * @param cocYy the coc yy
	  * @param cocSeqNo the coc seq no
	  * @param cocSerialNo the coc serial no
	  * @param cocType the coc type
	  * @param repairLim the repair lim
	  * @param color the color
	  * @param modelYear the model year
	  * @param make the make
	  * @param estValue the est value
	  * @param towing the towing
	  * @param assignee the assignee
	  * @param noOfPass the no of pass
	  * @param tariffZone the tariff zone
	  * @param cocIssueDate the coc issue date
	  * @param mvFileNo the mv file no
	  * @param acquiredFrom the acquired from
	  * @param ctvTag the ctv tag
	  * @param typeOfBodyCd the type of body cd
	  * @param unladenWt the unladen wt
	  * @param makeCd the make cd
	  * @param seriesCd the series cd
	  * @param basicColorCd the basic color cd
	  * @param colorCd the color cd
	  * @param origin the origin
	  * @param destination the destination
	  * @param cocAtcn the coc atcn
	  * @param userId the user id
	  * @param lastUpdate the last update
	  * @param sublineCd the subline cd
	  */
	 public GIPIQuoteItemMC( 	final Integer quoteId, 		final Integer itemNo, 		final String plateNo,
 			 					final String motorNo, 		final String serialNo, 		final String sublineTypeCd,
 			 					final Integer motType, 		final Integer carCompanyCd, final Integer cocYy,
 			 					final Integer cocSeqNo, 	final Integer cocSerialNo, 	final String cocType,
 			 					final BigDecimal repairLim, final String color, 		final String modelYear, 
 			 					final String make,			final BigDecimal estValue, 	final BigDecimal towing, 	
 			 					final String assignee,		final Integer noOfPass, 	final String tariffZone, 	
					 			final Date cocIssueDate,	final String mvFileNo, 		final String acquiredFrom, 	
					 			final String ctvTag,		final Integer typeOfBodyCd, final String unladenWt, 	
					 			final Integer makeCd,		final Integer seriesCd,	 	final String basicColorCd,	
					 			final Integer colorCd,		final String origin, 		final String destination, 	
					 			final String cocAtcn,		final String userId, 		final Date lastUpdate, 		
					 			final String sublineCd)	{
 		
 		this.quoteId = quoteId;
 		this.itemNo = itemNo;
 		this.plateNo = plateNo;
 		this.motorNo = motorNo;
 		this.serialNo = serialNo;
 		this.sublineTypeCd = sublineTypeCd;
 		this.motType = motType;
 		this.carCompanyCd = carCompanyCd;
 		this.cocYy = cocYy;
 		this.cocSeqNo = cocSeqNo;
 		this.cocSerialNo = cocSerialNo;
 		this.cocType = cocType;
 		this.repairLim = repairLim;
 		this.color = color;
 		this.modelYear = modelYear;
 		this.make = make;
 		this.estValue = estValue;
 		this.towing = towing;
 		this.assignee = assignee;
 		this.noOfPass = noOfPass;
 		this.tariffZone = tariffZone;
 		this.cocIssueDate = cocIssueDate;
 		this.mvFileNo = mvFileNo;
 		this.acquiredFrom = acquiredFrom;
 		this.ctvTag = ctvTag;
 		this.typeOfBodyCd = typeOfBodyCd;
 		this.unladenWt = unladenWt;
 		this.makeCd = makeCd;
 		this.seriesCd = seriesCd;
 		this.basicColorCd = basicColorCd;
 		this.colorCd = colorCd;
 		this.origin = origin;
 		this.destination = destination;
 		this.cocAtcn = cocAtcn;
 		super.setUserId(userId);
 		super.setLastUpdate(lastUpdate);
 		this.sublineCd = sublineCd;
 		
 	}
	 
}
