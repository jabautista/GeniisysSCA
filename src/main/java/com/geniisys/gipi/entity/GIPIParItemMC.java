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
 * The Class GIPIParItemMC.
 */
public class GIPIParItemMC extends BaseEntity {	
	
	/** The par id. */
	private String parId;
	
	/** The item no. */
	private String itemNo;
	
	/** The plate no. */
	private String plateNo;
	
	/** The motor no. */
	private String motorNo;
	
	/** The serial no. */
	private String serialNo;
	
	/** The subline type cd. */
	private String sublineTypeCd;
	
	/** The mot type. */
	private String motType;
	
	/** The car company cd. */
	private String carCompanyCd;
	
	/** The coc yy. */
	private String cocYY;
	
	/** The coc seq no. */
	private String cocSeqNo;
	
	/** The coc serial no. */
	private String cocSerialNo;
	
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
	private String noOfPass;
	
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
	//private String typeOfBodyCd;
	/** The type of body cd. */
	private String typeOfBodyCd;
	
	/** The unladen wt. */
	private String unladenWt;
	
	/** The make cd. */
	private String makeCd;
	
	/** The series cd. */
	private String seriesCd;
	
	/** The basic color cd. */
	private String basicColorCd;
	
	/** The color cd. */
	private String colorCd;
	
	/** The origin. */
	private String origin;
	
	/** The destination. */
	private String destination;
	
	/** The coc atcn. */
	private String cocAtcn;	
	
	/** The subline cd. */
	private String sublineCd;	
	
	/** The motor coverage. */
	private String motorCoverage;
	
	/** The subline type desc. */
	private String sublineTypeDesc;	
	
	/** The car company. */
	private String carCompany;
	
	/** The basic color. */
	private String basicColor;	
	
	/** The type of body. */
	private String typeOfBody;
	
	/** The deductible amount. */
	private BigDecimal deductibleAmount;	
	
	/** The coc serial sw. */
	private String cocSerialSw;	
	
	/** The item title. */
	private String itemTitle;
	
	/** The item grp. */
	private String itemGrp;
	
	/** The item desc. */
	private String itemDesc;
	
	/** The item desc2. */
	private String itemDesc2;
	
	/** The tsi amt. */
	private BigDecimal tsiAmt;
	
	/** The prem amt. */
	private BigDecimal premAmt;
	
	/** The ann prem amt. */
	private BigDecimal annPremAmt;
	
	/** The ann tsi amt. */
	private BigDecimal annTsiAmt;
	
	/** The rec flag. */
	private String recFlag;
	
	/** The currency cd. */
	private int currencyCd;
	
	/** The currency rt. */
	private BigDecimal currencyRt;
	
	/** The group cd. */
	private String groupCd;
	
	/** The from date. */
	private Date fromDate;
	
	/** The to date. */
	private Date toDate;
	
	/** The pack line cd. */
	private String packLineCd;
	
	/** The pack subline cd. */
	private String packSublineCd;
	
	/** The discount sw. */
	private String discountSw;
	
	/** The coverage cd. */
	private String coverageCd;
	
	/** The other info. */
	private String otherInfo;
	
	/** The surcharge sw. */
	private String surchargeSw;
	
	/** The region cd. */
	private String regionCd;
	
	/** The changed tag. */
	private String changedTag;
	
	/** The prorate flag. */
	private String prorateFlag;
	
	/** The comp sw. */
	private String compSw;
	
	/** The short rt percent. */
	private BigDecimal shortRtPercent;
	
	/** The pack ben cd. */
	private String packBenCd;
	
	/** The payt terms. */
	private String paytTerms;
	
	/** The risk no. */
	private String riskNo;
	
	/** The risk item no. */
	private String riskItemNo;	
	
	/** The currency desc. */
	private String currencyDesc;	
	
	/** The coverage desc. */
	private String coverageDesc;	
	
	private String itmperlGroupedExists;
	
	/**
	 * @param itmperlGroupedExists the itmperlGroupedExists to set
	 */
	public void setItmperlGroupedExists(String itmperlGroupedExists) {
		this.itmperlGroupedExists = itmperlGroupedExists;
	}

	/**
	 * @return the itmperlGroupedExists
	 */
	public String getItmperlGroupedExists() {
		return itmperlGroupedExists;
	}
	
	/**
	 * Instantiates a new gIPI par item mc.
	 */
	public GIPIParItemMC(){
		
	}
	
	/**
	 * Instantiates a new gIPI par item mc.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @param assignee the assignee
	 * @param acquiredFrom the acquired from
	 * @param motorNo the motor no
	 * @param origin the origin
	 * @param destination the destination
	 * @param typeOfBodyCd the type of body cd
	 * @param plateNo the plate no
	 * @param modelYear the model year
	 * @param carCompanyCd the car company cd
	 * @param mvFileNo the mv file no
	 * @param noOfPass the no of pass
	 * @param makeCd the make cd
	 * @param basicColorCd the basic color cd
	 * @param colorCd the color cd
	 * @param seriesCd the series cd
	 * @param motType the mot type
	 * @param unladenWt the unladen wt
	 * @param towing the towing
	 * @param serialNo the serial no
	 * @param sublineTypeCd the subline type cd
	 * @param deductibleAmount the deductible amount
	 * @param cocSerialNo the coc serial no
	 * @param ctvTag the ctv tag
	 * @param repairLim the repair lim
	 * @param estValue the est value
	 * @param color the color
	 * @param cocSeqNo the coc seq no
	 * @param cocType the coc type
	 * @param cocIssueDate the coc issue date
	 * @param cocYY the coc yy
	 * @param cocSerialSw the coc serial sw
	 * @param cocAtcn the coc atcn
	 * @param sublineCd the subline cd
	 * @param tariffZone the tariff zone
	 * @param make the make
	 * @param motorCoverage the motor coverage
	 */
	public GIPIParItemMC(final String parId, final String itemNo,
			final String assignee, 		final String acquiredFrom, 	final String motorNo,
			final String origin, 		final String destination, 	final String typeOfBodyCd,
			final String plateNo, 		final String modelYear, 	final String carCompanyCd,
			final String mvFileNo, 		final String noOfPass, 		final String makeCd,
			final String basicColorCd, 	final String colorCd, 		final String seriesCd,
			final String motType, 		final String unladenWt, 	final BigDecimal towing,
			final String serialNo, 		final String sublineTypeCd, final BigDecimal deductibleAmount,
			final String cocSerialNo, 	final String ctvTag, 		final BigDecimal repairLim,
			final BigDecimal estValue, 	final String color, 		final String cocSeqNo,
			final String cocType, 		final Date cocIssueDate, 	final String cocYY,
			final String cocSerialSw, 	final String cocAtcn, 		final String sublineCd,
			final String tariffZone, 	final String make, 			final String motorCoverage){
		
		this.parId = parId;
		this.itemNo = itemNo;
		this.assignee = assignee;
		this.acquiredFrom = acquiredFrom;
		this.motorNo = motorNo;
		this.origin = origin;
		this.destination = destination;
		this.typeOfBodyCd = typeOfBodyCd;
		this.plateNo = plateNo;
		this.modelYear = modelYear;
		this.carCompanyCd = carCompanyCd;
		this.mvFileNo = mvFileNo;
		this.noOfPass = noOfPass;
		this.makeCd = makeCd;
		this.basicColorCd = basicColorCd;
		this.colorCd = colorCd;
		this.seriesCd = seriesCd;
		this.motType = motType;
		this.unladenWt = unladenWt;
		this.towing = towing;
		this.serialNo = serialNo;
		this.sublineTypeCd = sublineTypeCd;
		this.deductibleAmount = deductibleAmount;
		this.cocSerialNo = cocSerialNo;
		this.ctvTag = ctvTag;
		this.repairLim = repairLim;
		this.estValue = estValue;
		this.color = color;
		this.cocSeqNo = cocSeqNo;
		this.cocType = cocType;
		this.cocIssueDate = cocIssueDate;
		this.cocYY = cocYY;
		this.cocSerialSw = cocSerialSw;
		this.cocAtcn = cocAtcn;
		this.sublineCd = sublineCd;
		this.tariffZone = tariffZone;
		this.make = make;
		this.motorCoverage = motorCoverage;
		
	}

	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public String getParId() {
		return parId;
	}

	/**
	 * Sets the par id.
	 * 
	 * @param parId the new par id
	 */
	public void setParId(String parId) {
		this.parId = parId;
	}

	/**
	 * Gets the item no.
	 * 
	 * @return the item no
	 */
	public String getItemNo() {
		return itemNo;
	}

	/**
	 * Sets the item no.
	 * 
	 * @param itemNo the new item no
	 */
	public void setItemNo(String itemNo) {
		this.itemNo = itemNo;
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
	public String getMotType() {
		return motType;
	}

	/**
	 * Sets the mot type.
	 * 
	 * @param motType the new mot type
	 */
	public void setMotType(String motType) {
		this.motType = motType;
	}

	/**
	 * Gets the car company cd.
	 * 
	 * @return the car company cd
	 */
	public String getCarCompanyCd() {
		return carCompanyCd;
	}

	/**
	 * Sets the car company cd.
	 * 
	 * @param carCompanyCd the new car company cd
	 */
	public void setCarCompanyCd(String carCompanyCd) {		
		/*Integer carCompanyCode = this.carCompanyCd;
		try{
			if(carCompanyCode.toString().equals("")){
				carCompanyCode = 0;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			carCompanyCode = 0;
		} finally {
			this.carCompanyCd = carCompanyCode;
		}		*/
		this.carCompanyCd = carCompanyCd;
	}

	/**
	 * Gets the coc yy.
	 * 
	 * @return the coc yy
	 */
	public String getCocYY() {
		return cocYY;
	}

	/**
	 * Sets the coc yy.
	 * 
	 * @param cocYY the new coc yy
	 */
	public void setCocYY(String cocYY) {
		this.cocYY = cocYY;
	}

	/**
	 * Gets the coc seq no.
	 * 
	 * @return the coc seq no
	 */
	public String getCocSeqNo() {
		return cocSeqNo;
	}

	/**
	 * Sets the coc seq no.
	 * 
	 * @param cocSeqNo the new coc seq no
	 */
	public void setCocSeqNo(String cocSeqNo) {
		this.cocSeqNo = cocSeqNo;
	}

	/**
	 * Gets the coc serial no.
	 * 
	 * @return the coc serial no
	 */
	public String getCocSerialNo() {
		return cocSerialNo;
	}

	/**
	 * Sets the coc serial no.
	 * 
	 * @param cocSerialNo the new coc serial no
	 */
	public void setCocSerialNo(String cocSerialNo) {
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
	public String getNoOfPass() {
		return noOfPass;
	}

	/**
	 * Sets the no of pass.
	 * 
	 * @param noOfPass the new no of pass
	 */
	public void setNoOfPass(String noOfPass) {
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
	public String getTypeOfBodyCd() {
		return typeOfBodyCd;
	}

	/**
	 * Sets the type of body cd.
	 * 
	 * @param typeOfBodyCd the new type of body cd
	 */
	public void setTypeOfBodyCd(String typeOfBodyCd) {
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
	public String getMakeCd() {
		return makeCd;
	}

	/**
	 * Sets the make cd.
	 * 
	 * @param makeCd the new make cd
	 */
	public void setMakeCd(String makeCd) {
		this.makeCd = makeCd;
	}

	/**
	 * Gets the series cd.
	 * 
	 * @return the series cd
	 */
	public String getSeriesCd() {
		return seriesCd;
	}

	/**
	 * Sets the series cd.
	 * 
	 * @param seriesCd the new series cd
	 */
	public void setSeriesCd(String seriesCd) {
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
	public String getColorCd() {
		return colorCd;
	}

	/**
	 * Sets the color cd.
	 * 
	 * @param colorCd the new color cd
	 */
	public void setColorCd(String colorCd) {
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
	 * Gets the motor coverage.
	 * 
	 * @return the motor coverage
	 */
	public String getMotorCoverage() {
		return motorCoverage;
	}

	/**
	 * Sets the motor coverage.
	 * 
	 * @param motorCoverage the new motor coverage
	 */
	public void setMotorCoverage(String motorCoverage) {
		this.motorCoverage = motorCoverage;
	}

	/**
	 * Gets the subline type desc.
	 * 
	 * @return the subline type desc
	 */
	public String getSublineTypeDesc() {
		return sublineTypeDesc;
	}

	/**
	 * Sets the subline type desc.
	 * 
	 * @param sublineTypeDesc the new subline type desc
	 */
	public void setSublineTypeDesc(String sublineTypeDesc) {
		this.sublineTypeDesc = sublineTypeDesc;
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
	 * Gets the deductible amount.
	 * 
	 * @return the deductible amount
	 */
	public BigDecimal getDeductibleAmount() {
		return deductibleAmount;
	}

	/**
	 * Sets the deductible amount.
	 * 
	 * @param deductibleAmount the new deductible amount
	 */
	public void setDeductibleAmount(BigDecimal deductibleAmount) {
		this.deductibleAmount = deductibleAmount;
	}

	/**
	 * Gets the coc serial sw.
	 * 
	 * @return the coc serial sw
	 */
	public String getCocSerialSw() {
		return cocSerialSw;
	}

	/**
	 * Sets the coc serial sw.
	 * 
	 * @param cocSerialSw the new coc serial sw
	 */
	public void setCocSerialSw(String cocSerialSw) {
		this.cocSerialSw = cocSerialSw;
	}

	/**
	 * Gets the item title.
	 * 
	 * @return the item title
	 */
	public String getItemTitle() {
		return itemTitle;
	}

	/**
	 * Sets the item title.
	 * 
	 * @param itemTitle the new item title
	 */
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}

	/**
	 * Gets the item grp.
	 * 
	 * @return the item grp
	 */
	public String getItemGrp() {
		return itemGrp;
	}

	/**
	 * Sets the item grp.
	 * 
	 * @param itemGrp the new item grp
	 */
	public void setItemGrp(String itemGrp) {
		this.itemGrp = itemGrp;
	}

	/**
	 * Gets the item desc.
	 * 
	 * @return the item desc
	 */
	public String getItemDesc() {
		return itemDesc;
	}

	/**
	 * Sets the item desc.
	 * 
	 * @param itemDesc the new item desc
	 */
	public void setItemDesc(String itemDesc) {
		this.itemDesc = itemDesc;
	}

	/**
	 * Gets the item desc2.
	 * 
	 * @return the item desc2
	 */
	public String getItemDesc2() {
		return itemDesc2;
	}

	/**
	 * Sets the item desc2.
	 * 
	 * @param itemDesc2 the new item desc2
	 */
	public void setItemDesc2(String itemDesc2) {
		this.itemDesc2 = itemDesc2;
	}

	/**
	 * Gets the tsi amt.
	 * 
	 * @return the tsi amt
	 */
	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}

	/**
	 * Sets the tsi amt.
	 * 
	 * @param tsiAmt the new tsi amt
	 */
	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}

	/**
	 * Gets the prem amt.
	 * 
	 * @return the prem amt
	 */
	public BigDecimal getPremAmt() {
		return premAmt;
	}

	/**
	 * Sets the prem amt.
	 * 
	 * @param premAmt the new prem amt
	 */
	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}

	/**
	 * Gets the ann prem amt.
	 * 
	 * @return the ann prem amt
	 */
	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}

	/**
	 * Sets the ann prem amt.
	 * 
	 * @param annPremAmt the new ann prem amt
	 */
	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}

	/**
	 * Gets the ann tsi amt.
	 * 
	 * @return the ann tsi amt
	 */
	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}

	/**
	 * Sets the ann tsi amt.
	 * 
	 * @param annTsiAmt the new ann tsi amt
	 */
	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}

	/**
	 * Gets the rec flag.
	 * 
	 * @return the rec flag
	 */
	public String getRecFlag() {
		return recFlag;
	}

	/**
	 * Sets the rec flag.
	 * 
	 * @param recFlag the new rec flag
	 */
	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}

	/**
	 * Gets the currency cd.
	 * 
	 * @return the currency cd
	 */
	public int getCurrencyCd() {
		return currencyCd;
	}

	/**
	 * Sets the currency cd.
	 * 
	 * @param currencyCd the new currency cd
	 */
	public void setCurrencyCd(int currencyCd) {
		this.currencyCd = currencyCd;
	}

	/**
	 * Gets the currency rt.
	 * 
	 * @return the currency rt
	 */
	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}

	/**
	 * Sets the currency rt.
	 * 
	 * @param currencyRt the new currency rt
	 */
	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}

	/**
	 * Gets the group cd.
	 * 
	 * @return the group cd
	 */
	public String getGroupCd() {
		return groupCd;
	}

	/**
	 * Sets the group cd.
	 * 
	 * @param groupCd the new group cd
	 */
	public void setGroupCd(String groupCd) {
		this.groupCd = groupCd;
	}

	/**
	 * Gets the from date.
	 * 
	 * @return the from date
	 */
	public Date getFromDate() {
		return fromDate;
	}

	/**
	 * Sets the from date.
	 * 
	 * @param fromDate the new from date
	 */
	public void setFromDate(Date fromDate) {
		this.fromDate = fromDate;
	}

	/**
	 * Gets the to date.
	 * 
	 * @return the to date
	 */
	public Date getToDate() {
		return toDate;
	}

	/**
	 * Sets the to date.
	 * 
	 * @param toDate the new to date
	 */
	public void setToDate(Date toDate) {
		this.toDate = toDate;
	}

	/**
	 * Gets the pack line cd.
	 * 
	 * @return the pack line cd
	 */
	public String getPackLineCd() {
		return packLineCd;
	}

	/**
	 * Sets the pack line cd.
	 * 
	 * @param packLineCd the new pack line cd
	 */
	public void setPackLineCd(String packLineCd) {
		this.packLineCd = packLineCd;
	}

	/**
	 * Gets the pack subline cd.
	 * 
	 * @return the pack subline cd
	 */
	public String getPackSublineCd() {
		return packSublineCd;
	}

	/**
	 * Sets the pack subline cd.
	 * 
	 * @param packSublineCd the new pack subline cd
	 */
	public void setPackSublineCd(String packSublineCd) {
		this.packSublineCd = packSublineCd;
	}

	/**
	 * Gets the discount sw.
	 * 
	 * @return the discount sw
	 */
	public String getDiscountSw() {
		return discountSw;
	}

	/**
	 * Sets the discount sw.
	 * 
	 * @param discountSw the new discount sw
	 */
	public void setDiscountSw(String discountSw) {
		this.discountSw = discountSw;
	}

	/**
	 * Gets the coverage cd.
	 * 
	 * @return the coverage cd
	 */
	public String getCoverageCd() {
		return coverageCd;
	}

	/**
	 * Sets the coverage cd.
	 * 
	 * @param coverageCd the new coverage cd
	 */
	public void setCoverageCd(String coverageCd) {
		this.coverageCd = coverageCd;
	}

	/**
	 * Gets the other info.
	 * 
	 * @return the other info
	 */
	public String getOtherInfo() {
		return otherInfo;
	}

	/**
	 * Sets the other info.
	 * 
	 * @param otherInfo the new other info
	 */
	public void setOtherInfo(String otherInfo) {
		this.otherInfo = otherInfo;
	}

	/**
	 * Gets the surcharge sw.
	 * 
	 * @return the surcharge sw
	 */
	public String getSurchargeSw() {
		return surchargeSw;
	}

	/**
	 * Sets the surcharge sw.
	 * 
	 * @param surchargeSw the new surcharge sw
	 */
	public void setSurchargeSw(String surchargeSw) {
		this.surchargeSw = surchargeSw;
	}

	/**
	 * Gets the region cd.
	 * 
	 * @return the region cd
	 */
	public String getRegionCd() {
		return regionCd;
	}

	/**
	 * Sets the region cd.
	 * 
	 * @param regionCd the new region cd
	 */
	public void setRegionCd(String regionCd) {
		this.regionCd = regionCd;
	}

	/**
	 * Gets the changed tag.
	 * 
	 * @return the changed tag
	 */
	public String getChangedTag() {
		return changedTag;
	}

	/**
	 * Sets the changed tag.
	 * 
	 * @param changedTag the new changed tag
	 */
	public void setChangedTag(String changedTag) {
		this.changedTag = changedTag;
	}

	/**
	 * Gets the prorate flag.
	 * 
	 * @return the prorate flag
	 */
	public String getProrateFlag() {
		return prorateFlag;
	}

	/**
	 * Sets the prorate flag.
	 * 
	 * @param prorateFlag the new prorate flag
	 */
	public void setProrateFlag(String prorateFlag) {
		this.prorateFlag = prorateFlag;
	}

	/**
	 * Gets the comp sw.
	 * 
	 * @return the comp sw
	 */
	public String getCompSw() {
		return compSw;
	}

	/**
	 * Sets the comp sw.
	 * 
	 * @param compSw the new comp sw
	 */
	public void setCompSw(String compSw) {
		this.compSw = compSw;
	}

	/**
	 * Gets the short rt percent.
	 * 
	 * @return the short rt percent
	 */
	public BigDecimal getShortRtPercent() {
		return shortRtPercent;
	}

	/**
	 * Sets the short rt percent.
	 * 
	 * @param shortRtPercent the new short rt percent
	 */
	public void setShortRtPercent(BigDecimal shortRtPercent) {
		this.shortRtPercent = shortRtPercent;
	}

	/**
	 * Gets the pack ben cd.
	 * 
	 * @return the pack ben cd
	 */
	public String getPackBenCd() {
		return packBenCd;
	}

	/**
	 * Sets the pack ben cd.
	 * 
	 * @param packBenCd the new pack ben cd
	 */
	public void setPackBenCd(String packBenCd) {
		this.packBenCd = packBenCd;
	}

	/**
	 * Gets the payt terms.
	 * 
	 * @return the payt terms
	 */
	public String getPaytTerms() {
		return paytTerms;
	}

	/**
	 * Sets the payt terms.
	 * 
	 * @param paytTerms the new payt terms
	 */
	public void setPaytTerms(String paytTerms) {
		this.paytTerms = paytTerms;
	}

	/**
	 * Gets the risk no.
	 * 
	 * @return the risk no
	 */
	public String getRiskNo() {
		return riskNo;
	}

	/**
	 * Sets the risk no.
	 * 
	 * @param riskNo the new risk no
	 */
	public void setRiskNo(String riskNo) {
		this.riskNo = riskNo;
	}

	/**
	 * Gets the risk item no.
	 * 
	 * @return the risk item no
	 */
	public String getRiskItemNo() {
		return riskItemNo;
	}

	/**
	 * Sets the risk item no.
	 * 
	 * @param riskItemNo the new risk item no
	 */
	public void setRiskItemNo(String riskItemNo) {
		this.riskItemNo = riskItemNo;
	}

	/**
	 * Gets the currency desc.
	 * 
	 * @return the currency desc
	 */
	public String getCurrencyDesc() {
		return currencyDesc;
	}

	/**
	 * Sets the currency desc.
	 * 
	 * @param currencyDesc the new currency desc
	 */
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}

	/**
	 * Gets the coverage desc.
	 * 
	 * @return the coverage desc
	 */
	public String getCoverageDesc() {
		return coverageDesc;
	}

	/**
	 * Sets the coverage desc.
	 * 
	 * @param coverageDesc the new coverage desc
	 */
	public void setCoverageDesc(String coverageDesc) {
		this.coverageDesc = coverageDesc;
	}	
}
