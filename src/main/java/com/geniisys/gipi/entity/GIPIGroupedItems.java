package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIGroupedItems extends BaseEntity{

	private Integer policyId;
	private Integer itemNo;
	private Integer groupedItemNo;
	private String groupedItemTitle;
	private String includeTag;
	private String sex;
	private Integer positionCd;
	private String civilStatus;
	private Date dateOfBirth;
	private Integer age;
	private BigDecimal salary;
	private String salaryGrade;
	private BigDecimal amountCoverage;
	private BigDecimal amountCovered;
	private String remarks;
	private String lineCd;
	private String sublineCd;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String deleteSw;
	private Integer groupCd;
	private String userId;
	private Date lastUpdate;
	private Date fromDate;
	private Date toDate;
	private String paytTerms;
	private Integer packBenCd;
	private BigDecimal annTsiAmt;
	private BigDecimal annPremAmt;
	private String controlCd;
	private Integer controlTypeCd;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private Integer principalCd;
	private String arcExtData;
	
	private String meanSex;
	private String meanCivilStatus;
	private BigDecimal sumAmt;
	private String controlTypeDesc;
	private String packageCd;
	private String paytTermsDesc;
	private String position;
	private String groupDesc;
	private String strDateOfBirth;
	private String strFromDate;
	private String strToDate;
	
	public GIPIGroupedItems() {
		
	}

	public GIPIGroupedItems(Integer policyId, Integer itemNo, Integer groupedItemNo,
			String groupedItemTitle, String includeTag, String sex,
			Integer positionCd, String civilStatus, Date dateOfBirth, Integer age,
			BigDecimal salary, String salaryGrade, BigDecimal amountCoverage,
			String remarks, String lineCd, String sublineCd, Integer cpiRecNo,
			String cpiBranchCd, String deleteSw, Integer groupCd, String userId,
			Date lastUpdate, Date fromDate, Date toDate, String paytTerms,
			Integer packBenCd, BigDecimal annTsiAmt, BigDecimal annPremAmt,
			String controlCd, Integer controlTypeCd, BigDecimal tsiAmt,
			BigDecimal premAmt, Integer principalCd, String arcExtData) {
		this.policyId = policyId;
		this.itemNo = itemNo;
		this.groupedItemNo = groupedItemNo;
		this.groupedItemTitle = groupedItemTitle;
		this.includeTag = includeTag;
		this.sex = sex;
		this.positionCd = positionCd;
		this.civilStatus = civilStatus;
		this.dateOfBirth = dateOfBirth;
		this.age = age;
		this.salary = salary;
		this.salaryGrade = salaryGrade;
		this.amountCoverage = amountCoverage;
		this.remarks = remarks;
		this.lineCd = lineCd;
		this.sublineCd = sublineCd;
		this.cpiRecNo = cpiRecNo;
		this.cpiBranchCd = cpiBranchCd;
		this.deleteSw = deleteSw;
		this.groupCd = groupCd;
		this.userId = userId;
		this.lastUpdate = lastUpdate;
		this.fromDate = fromDate;
		this.toDate = toDate;
		this.paytTerms = paytTerms;
		this.packBenCd = packBenCd;
		this.annTsiAmt = annTsiAmt;
		this.annPremAmt = annPremAmt;
		this.controlCd = controlCd;
		this.controlTypeCd = controlTypeCd;
		this.tsiAmt = tsiAmt;
		this.premAmt = premAmt;
		this.principalCd = principalCd;
		this.arcExtData = arcExtData;
	}

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	public Integer getGroupedItemNo() {
		return groupedItemNo;
	}

	public void setGroupedItemNo(Integer groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}

	public String getGroupedItemTitle() {
		return groupedItemTitle;
	}

	public void setGroupedItemTitle(String groupedItemTitle) {
		this.groupedItemTitle = groupedItemTitle;
	}

	public String getIncludeTag() {
		return includeTag;
	}

	public void setIncludeTag(String includeTag) {
		this.includeTag = includeTag;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public Integer getPositionCd() {
		return positionCd;
	}

	public void setPositionCd(Integer positionCd) {
		this.positionCd = positionCd;
	}

	public String getCivilStatus() {
		return civilStatus;
	}

	public void setCivilStatus(String civilStatus) {
		this.civilStatus = civilStatus;
	}

	public Date getDateOfBirth() {
		return dateOfBirth;
	}

	public void setDateOfBirth(Date dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}

	public Integer getAge() {
		return age;
	}

	public void setAge(Integer age) {
		this.age = age;
	}

	public BigDecimal getSalary() {
		return salary;
	}

	public void setSalary(BigDecimal salary) {
		this.salary = salary;
	}

	public String getSalaryGrade() {
		return salaryGrade;
	}

	public void setSalaryGrade(String salaryGrade) {
		this.salaryGrade = salaryGrade;
	}

	public BigDecimal getAmountCoverage() {
		return amountCoverage;
	}

	public void setAmountCoverage(BigDecimal amountCoverage) {
		this.amountCoverage = amountCoverage;
	}

	public BigDecimal getAmountCovered() {
		return amountCovered;
	}

	public void setAmountCovered(BigDecimal amountCovered) {
		this.amountCovered = amountCovered;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getSublineCd() {
		return sublineCd;
	}

	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
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

	public String getDeleteSw() {
		return deleteSw;
	}

	public void setDeleteSw(String deleteSw) {
		this.deleteSw = deleteSw;
	}

	public Integer getGroupCd() {
		return groupCd;
	}

	public void setGroupCd(Integer groupCd) {
		this.groupCd = groupCd;
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

	public String getPaytTerms() {
		return paytTerms;
	}

	public void setPaytTerms(String paytTerms) {
		this.paytTerms = paytTerms;
	}

	public Integer getPackBenCd() {
		return packBenCd;
	}

	public void setPackBenCd(Integer packBenCd) {
		this.packBenCd = packBenCd;
	}

	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}

	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}

	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}

	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}

	public String getControlCd() {
		return controlCd;
	}

	public void setControlCd(String controlCd) {
		this.controlCd = controlCd;
	}

	public Integer getControlTypeCd() {
		return controlTypeCd;
	}

	public void setControlTypeCd(Integer controlTypeCd) {
		this.controlTypeCd = controlTypeCd;
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

	public Integer getPrincipalCd() {
		return principalCd;
	}

	public void setPrincipalCd(Integer principalCd) {
		this.principalCd = principalCd;
	}

	public String getArcExtData() {
		return arcExtData;
	}

	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}

	public String getMeanSex() {
		return meanSex;
	}

	public void setMeanSex(String meanSex) {
		this.meanSex = meanSex;
	}

	public String getMeanCivilStatus() {
		return meanCivilStatus;
	}

	public void setMeanCivilStatus(String meanCivilStatus) {
		this.meanCivilStatus = meanCivilStatus;
	}

	public BigDecimal getSumAmt() {
		return sumAmt;
	}

	public void setSumAmt(BigDecimal sumAmt) {
		this.sumAmt = sumAmt;
	}

	public String getControlTypeDesc() {
		return controlTypeDesc;
	}

	public void setControlTypeDesc(String controlTypeDesc) {
		this.controlTypeDesc = controlTypeDesc;
	}

	public String getPackageCd() {
		return packageCd;
	}

	public void setPackageCd(String packageCd) {
		this.packageCd = packageCd;
	}

	public String getPaytTermsDesc() {
		return paytTermsDesc;
	}

	public void setPaytTermsDesc(String paytTermsDesc) {
		this.paytTermsDesc = paytTermsDesc;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getGroupDesc() {
		return groupDesc;
	}

	public void setGroupDesc(String groupDesc) {
		this.groupDesc = groupDesc;
	}

	/**
	 * @return the strDateOfBirth
	 */
	public String getStrDateOfBirth() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(this.dateOfBirth != null){
			return sdf.format(dateOfBirth);
		} else {
			return null;
		}
	}

	/**
	 * @param strDateOfBirth the strDateOfBirth to set
	 */
	public void setStrDateOfBirth(String strDateOfBirth) {		
		this.strDateOfBirth = strDateOfBirth;
	}

	/**
	 * @return the strFromDate
	 */
	public String getStrFromDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(this.fromDate != null){
			return sdf.format(fromDate);
		} else {
			return null;
		}
	}

	/**
	 * @param strFromDate the strFromDate to set
	 */
	public void setStrFromDate(String strFromDate) {
		this.strFromDate = strFromDate;
	}

	/**
	 * @return the strToDate
	 */
	public String getStrToDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(this.toDate != null){
			return sdf.format(toDate);
		} else {
			return null;
		}
	}

	/**
	 * @param strToDate the strToDate to set
	 */
	public void setStrToDate(String strToDate) {
		this.strToDate = strToDate;
	}	
	
	
}
