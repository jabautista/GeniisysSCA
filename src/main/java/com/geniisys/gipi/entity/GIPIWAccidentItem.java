package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWAccidentItem extends BaseEntity{
	/** The par id. */
	private String parId;
	
	/** The item no. */
	private String itemNo;
	
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
	private Integer currencyCd;
	
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
	
	private Date dateOfBirth;
	private String age;
	private String civilStatus;
	private String positionCd; 
	private BigDecimal monthlySalary;
	private String salaryGrade;
	private String noOfPersons;
	private String destination;
	private String height;
	private String weight;
	private String sex;
	private String groupPrintSw;
	private String acClassCd;
	private String levelCd;	
	private String parentLevelCd;
	
	private String currencyDesc;
	private String coverageDesc;
	
	private String delGrpItemsInItems;
	private String itemWitmperlExist;
	private String itemWitmperlGroupedExist;
	private String populatePerils;
	private String itemWgroupedItemsExist;
	private String accidentDeleteBills;
	
	private String itmperlGroupedExists;
	private String restrictedCondition;
	private String restrictedCondition2;
	
	private String changeNOP;
	
	/**
	 * @param itmperlGroupedExists the itmperlGroupedExists to set
	 */
	public void setItmperlGroupedExists(String itmperlGroupedExists) {
		this.itmperlGroupedExists = itmperlGroupedExists;
	}

	public String getRestrictedCondition() {
		return restrictedCondition;
	}

	public void setRestrictedCondition(String restrictedCondition) {
		this.restrictedCondition = restrictedCondition;
	}

	/**
	 * @return the itmperlGroupedExists
	 */
	public String getItmperlGroupedExists() {
		return itmperlGroupedExists;
	}
	
	public GIPIWAccidentItem(){
		
	}
	
	public GIPIWAccidentItem(final String parId, final String itemNo,
			final String noOfPersons, final String destination,
			final BigDecimal monthlySalary, final String salaryGrade,
			final String positionCd, final String delGrpItemsInItems,
			final Date dateOfBirth, final String age, 
			final String civilStatus, final String height,
			final String weight, final String sex,
			final String groupPrintSw,final String acClassCd,
			final String levelCd, final String parentLevelCd,
			final String populatePerils, final String accidentDeleteBills
			){
		this.parId = parId;
		this.itemNo = itemNo;
		this.noOfPersons = noOfPersons;
		this.destination = destination;
		this.monthlySalary = monthlySalary;
		this.salaryGrade = salaryGrade;
		this.positionCd = positionCd;
		this.delGrpItemsInItems = delGrpItemsInItems;
		this.dateOfBirth = dateOfBirth;
		this.age = age;
		this.civilStatus = civilStatus;
		this.height = height;
		this.weight = weight;
		this.sex = sex;
		this.groupPrintSw = groupPrintSw;
		this.acClassCd = acClassCd;
		this.levelCd = levelCd;
		this.parentLevelCd = parentLevelCd;
		this.populatePerils = populatePerils;
		this.accidentDeleteBills = accidentDeleteBills;
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
	public String getItemTitle() {
		return itemTitle;
	}
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}
	public String getItemGrp() {
		return itemGrp;
	}
	public void setItemGrp(String itemGrp) {
		this.itemGrp = itemGrp;
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
	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}
	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}
	public BigDecimal getPremAmt() {
		return premAmt;
	}
	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}
	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}
	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}
	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}
	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}
	public String getRecFlag() {
		return recFlag;
	}
	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}
	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}
	public String getGroupCd() {
		return groupCd;
	}
	public void setGroupCd(String groupCd) {
		this.groupCd = groupCd;
	}
	public Date getFromDate() {
		return fromDate;
	}
	public void setFromDate(Date fromDate) {
		this.fromDate = fromDate;
	}
	public Date getToDate() {
		return toDate;
	}
	public void setToDate(Date toDate) {
		this.toDate = toDate;
	}
	public String getPackLineCd() {
		return packLineCd;
	}
	public void setPackLineCd(String packLineCd) {
		this.packLineCd = packLineCd;
	}
	public String getPackSublineCd() {
		return packSublineCd;
	}
	public void setPackSublineCd(String packSublineCd) {
		this.packSublineCd = packSublineCd;
	}
	public String getDiscountSw() {
		return discountSw;
	}
	public void setDiscountSw(String discountSw) {
		this.discountSw = discountSw;
	}
	public String getCoverageCd() {
		return coverageCd;
	}
	public void setCoverageCd(String coverageCd) {
		this.coverageCd = coverageCd;
	}
	public String getOtherInfo() {
		return otherInfo;
	}
	public void setOtherInfo(String otherInfo) {
		this.otherInfo = otherInfo;
	}
	public String getSurchargeSw() {
		return surchargeSw;
	}
	public void setSurchargeSw(String surchargeSw) {
		this.surchargeSw = surchargeSw;
	}
	public String getRegionCd() {
		return regionCd;
	}
	public void setRegionCd(String regionCd) {
		this.regionCd = regionCd;
	}
	public String getChangedTag() {
		return changedTag;
	}
	public void setChangedTag(String changedTag) {
		this.changedTag = changedTag;
	}
	public String getProrateFlag() {
		return prorateFlag;
	}
	public void setProrateFlag(String prorateFlag) {
		this.prorateFlag = prorateFlag;
	}
	public String getCompSw() {
		return compSw;
	}
	public void setCompSw(String compSw) {
		this.compSw = compSw;
	}
	public BigDecimal getShortRtPercent() {
		return shortRtPercent;
	}
	public void setShortRtPercent(BigDecimal shortRtPercent) {
		this.shortRtPercent = shortRtPercent;
	}
	public String getPackBenCd() {
		return packBenCd;
	}
	public void setPackBenCd(String packBenCd) {
		this.packBenCd = packBenCd;
	}
	public String getPaytTerms() {
		return paytTerms;
	}
	public void setPaytTerms(String paytTerms) {
		this.paytTerms = paytTerms;
	}
	public String getRiskNo() {
		return riskNo;
	}
	public void setRiskNo(String riskNo) {
		this.riskNo = riskNo;
	}
	public String getRiskItemNo() {
		return riskItemNo;
	}
	public void setRiskItemNo(String riskItemNo) {
		this.riskItemNo = riskItemNo;
	}
	public Date getDateOfBirth() {
		return dateOfBirth;
	}
	public void setDateOfBirth(Date dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}
	public String getAge() {
		return age;
	}
	public void setAge(String age) {
		this.age = age;
	}
	public String getCivilStatus() {
		return civilStatus;
	}
	public void setCivilStatus(String civilStatus) {
		this.civilStatus = civilStatus;
	}
	public String getPositionCd() {
		return positionCd;
	}
	public void setPositionCd(String positionCd) {
		this.positionCd = positionCd;
	}
	public BigDecimal getMonthlySalary() {
		return monthlySalary;
	}
	public void setMonthlySalary(BigDecimal monthlySalary) {
		this.monthlySalary = monthlySalary;
	}
	public String getSalaryGrade() {
		return salaryGrade;
	}
	public void setSalaryGrade(String salaryGrade) {
		this.salaryGrade = salaryGrade;
	}
	public String getNoOfPersons() {
		return noOfPersons;
	}
	public void setNoOfPersons(String noOfPersons) {
		this.noOfPersons = noOfPersons;
	}
	public String getDestination() {
		return destination;
	}
	public void setDestination(String destination) {
		this.destination = destination;
	}
	public String getHeight() {
		return height;
	}
	public void setHeight(String height) {
		this.height = height;
	}
	public String getWeight() {
		return weight;
	}
	public void setWeight(String weight) {
		this.weight = weight;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public String getGroupPrintSw() {
		return groupPrintSw;
	}
	public void setGroupPrintSw(String groupPrintSw) {
		this.groupPrintSw = groupPrintSw;
	}
	public String getAcClassCd() {
		return acClassCd;
	}
	public void setAcClassCd(String acClassCd) {
		this.acClassCd = acClassCd;
	}
	public String getLevelCd() {
		return levelCd;
	}
	public void setLevelCd(String levelCd) {
		this.levelCd = levelCd;
	}
	public String getParentLevelCd() {
		return parentLevelCd;
	}
	public void setParentLevelCd(String parentLevelCd) {
		this.parentLevelCd = parentLevelCd;
	}
	public String getCurrencyDesc() {
		return currencyDesc;
	}
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}
	public String getCoverageDesc() {
		return coverageDesc;
	}
	public void setCoverageDesc(String coverageDesc) {
		this.coverageDesc = coverageDesc;
	}
	public String getDelGrpItemsInItems() {
		return delGrpItemsInItems;
	}
	public void setDelGrpItemsInItems(String delGrpItemsInItems) {
		this.delGrpItemsInItems = delGrpItemsInItems;
	}
	public String getItemWitmperlGroupedExist() {
		return itemWitmperlGroupedExist;
	}
	public void setItemWitmperlGroupedExist(String itemWitmperlGroupedExist) {
		this.itemWitmperlGroupedExist = itemWitmperlGroupedExist;
	}
	public String getItemWitmperlExist() {
		return itemWitmperlExist;
	}
	public void setItemWitmperlExist(String itemWitmperlExist) {
		this.itemWitmperlExist = itemWitmperlExist;
	}
	public String getPopulatePerils() {
		return populatePerils;
	}
	public void setPopulatePerils(String populatePerils) {
		this.populatePerils = populatePerils;
	}
	public String getItemWgroupedItemsExist() {
		return itemWgroupedItemsExist;
	}
	public void setItemWgroupedItemsExist(String itemWgroupedItemsExist) {
		this.itemWgroupedItemsExist = itemWgroupedItemsExist;
	}
	public String getAccidentDeleteBills() {
		return accidentDeleteBills;
	}
	public void setAccidentDeleteBills(String accidentDeleteBills) {
		this.accidentDeleteBills = accidentDeleteBills;
	}

	public void setRestrictedCondition2(String restrictedCondition2) {
		this.restrictedCondition2 = restrictedCondition2;
	}

	public String getRestrictedCondition2() {
		return restrictedCondition2;
	}

	public String getChangeNOP() {
		return changeNOP;
	}

	public void setChangeNOP(String changeNOP) {
		this.changeNOP = changeNOP;
	}

}
