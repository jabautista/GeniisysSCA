package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWGroupedItems extends BaseEntity{
	
	private static Logger log = Logger.getLogger(GIPIWGroupedItems.class);

	private String parId;
	private String itemNo;
	private String groupedItemNo;
	private String includeTag;
	private String groupedItemTitle;
	private String groupCd;
	private String groupDesc;
	private BigDecimal amountCovered;
	private String remarks;
	private String lineCd;
	private String sublineCd;
	private String sex;
	private String positionCd;
	private String civilStatus;
	private Date dateOfBirth;
	private String age;
	private BigDecimal salary;
	private String salaryGrade;
	private String deleteSw;
	private Date fromDate;
	private Date toDate;
	private String paytTerms;
	private String packBenCd;
	private BigDecimal annTsiAmt;
	private BigDecimal annPremAmt;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private String controlCd;
	private String controlTypeCd;
	private String principalCd;
	private String packageCd;
	private String paytTermsDesc;
	private String overwriteBen;
	private String strDateOfBirth;
	private String strFromDate;
	private String strToDate;	
	
	private String controlTypeDesc;
	private String positionDesc;
	private String civilStatusDesc;
	private Integer policyId;
	private String issCd;
	private Integer issueYy;
	private Integer polSeqNo;
	private Integer renewNo;
	private String effDate;
	private Integer col1;
	
	public GIPIWGroupedItems(){
		
	}
	
	public GIPIWGroupedItems(final String parId, final String itemNo,
			final String groupedItemNo,final String includeTag,
			final String groupedItemTitle, final String groupCd,
			final BigDecimal amountCovered, final String remarks,
			final String lineCd, final String sublineCd
			){
		this.parId = parId;
		this.itemNo = itemNo;
		this.groupedItemNo = groupedItemNo;
		this.includeTag = includeTag;
		this.groupedItemTitle = groupedItemTitle;
		this.groupCd = groupCd;
		this.amountCovered = amountCovered;
		this.remarks = remarks;
		this.lineCd = lineCd;
		this.sublineCd = sublineCd;
	}
	
	public GIPIWGroupedItems(final String parId, final String itemNo,
			final String groupedItemNo,final String includeTag,
			final String groupedItemTitle, final String groupCd,
			final BigDecimal amountCovered, final String remarks,
			final String lineCd, final String sublineCd, final String sex,
			final String positionCd, final String civilStatus, final Date dateOfBirth,
			final String age, final BigDecimal salary, final String salaryGrade,
			final String deleteSw, final Date fromDate, final Date toDate,
			final String paytTerms, final String packBenCd, final BigDecimal annTsiAmt,
			final BigDecimal annPremAmt, final BigDecimal tsiAmt, final BigDecimal premAmt,
			final String controlCd, final String controlTypeCd, final String principalCd,
			final String overwriteBen
			){
		this.parId = parId;
		this.itemNo = itemNo;
		this.groupedItemNo = groupedItemNo;
		this.includeTag = includeTag;
		this.groupedItemTitle = groupedItemTitle;
		this.groupCd = groupCd;
		this.amountCovered = amountCovered;
		this.remarks = remarks;
		this.lineCd = lineCd;
		this.sublineCd = sublineCd;
		this.sex = sex;
		this.positionCd = positionCd;
		this.civilStatus = civilStatus;
		this.dateOfBirth = dateOfBirth;
		this.age = age;
		this.salary = salary;
		this.salaryGrade = salaryGrade;
		this.deleteSw = deleteSw;
		this.fromDate = fromDate;
		this.toDate = toDate;
		this.paytTerms = paytTerms;
		this.packBenCd = packBenCd;
		this.annTsiAmt = annTsiAmt;
		this.annPremAmt = annPremAmt;
		this.tsiAmt = tsiAmt;
		this.premAmt = premAmt;
		this.controlCd = controlCd;
		this.controlTypeCd = controlTypeCd;
		this.principalCd = principalCd;
		this.overwriteBen = overwriteBen;
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
	public String getGroupedItemNo() {
		return groupedItemNo;
	}
	public void setGroupedItemNo(String groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}
	public String getIncludeTag() {
		return includeTag;
	}
	public void setIncludeTag(String includeTag) {
		this.includeTag = includeTag;
	}
	public String getGroupedItemTitle() {
		return groupedItemTitle;
	}
	public void setGroupedItemTitle(String groupedItemTitle) {
		this.groupedItemTitle = groupedItemTitle;
	}
	public String getGroupCd() {
		return groupCd;
	}
	public void setGroupCd(String groupCd) {
		this.groupCd = groupCd;
	}
	public String getGroupDesc() {
		return groupDesc;
	}
	public void setGroupDesc(String groupDesc) {
		this.groupDesc = groupDesc;
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
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public String getPositionCd() {
		return positionCd;
	}
	public void setPositionCd(String positionCd) {
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
	public String getAge() {
		return age;
	}
	public void setAge(String age) {
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
	public String getDeleteSw() {
		return deleteSw;
	}
	public void setDeleteSw(String deleteSw) {
		this.deleteSw = deleteSw;
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
	public String getPackBenCd() {
		return packBenCd;
	}
	public void setPackBenCd(String packbenCd) {
		this.packBenCd = packbenCd;
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
	public String getControlCd() {
		return controlCd;
	}
	public void setControlCd(String controlCd) {
		this.controlCd = controlCd;
	}
	public String getControlTypeCd() {
		return controlTypeCd;
	}
	public void setControlTypeCd(String controlTypeCd) {
		this.controlTypeCd = controlTypeCd;
	}
	public String getPrincipalCd() {
		return principalCd;
	}
	public void setPrincipalCd(String principalCd) {
		this.principalCd = principalCd;
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
	public String getOverwriteBen() {
		return overwriteBen;
	}
	public void setOverwriteBen(String overwriteBen) {
		this.overwriteBen = overwriteBen;
	}
	
	public GIPIWGroupedItems(JSONObject obj){
		try{
			SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
			
			this.parId				= obj.isNull("parId") ? null : obj.getString("parId");
			this.itemNo				= obj.isNull("itemNo") ? null : obj.getString("itemNo");
			this.groupedItemNo		= obj.isNull("groupedItemNo") ? null : obj.getString("groupedItemNo");
			this.includeTag			= obj.isNull("includeTag") ? null : obj.getString("includeTag");
			this.groupedItemTitle	= obj.isNull("groupedItemTitle") ? null : obj.getString("groupedItemTitle");
			this.groupCd			= obj.isNull("groupCd") ? null : obj.getString("groupCd");
			this.groupDesc			= obj.isNull("groupDesc") ? null : obj.getString("groupDesc");
			this.amountCovered		= obj.isNull("amountCovered") ? null : new BigDecimal(obj.getString("amountCovered").replaceAll(",", ""));
			this.remarks			= obj.isNull("remarks") ? null : obj.getString("remarks");
			this.lineCd				= obj.isNull("lineCd") ? null : obj.getString("lineCd");
			this.sublineCd			= obj.isNull("sublineCd") ? null : obj.getString("sublineCd");
			this.sex				= obj.isNull("sex") ? null : obj.getString("sex");
			this.positionCd			= obj.isNull("positionCd") ? null : obj.getString("positionCd");
			this.civilStatus		= obj.isNull("civilStatus") ? null : obj.getString("civilStatus");
			this.dateOfBirth		= obj.isNull("dateOfBirth") ? null : sdf.parse(obj.getString("dateOfBirth"));
			this.age				= obj.isNull("age") ? null : obj.getString("age");
			this.salary				= obj.isNull("salary") ? null : new BigDecimal(obj.getString("salary").replaceAll(",", ""));
			this.salaryGrade		= obj.isNull("salaryGrade") ? null : obj.getString("salaryGrade");
			this.deleteSw			= obj.isNull("deleteSw") ? null : obj.getString("deleteSw");
			this.fromDate			= obj.isNull("fromDate") ? null : sdf.parse(obj.getString("fromDate"));
			this.toDate				= obj.isNull("toDate") ? null : sdf.parse(obj.getString("toDate"));
			this.paytTerms			= obj.isNull("paytTerms") ? null : obj.getString("paytTerms");
			this.packBenCd			= obj.isNull("packBenCd") ? null : obj.getString("packBenCd");
			this.annTsiAmt			= obj.isNull("annTsiAmt") ? null : new BigDecimal(obj.getString("annTsiAmt").replaceAll(",", ""));
			this.annPremAmt			= obj.isNull("annPremAmt") ? null : new BigDecimal(obj.getString("annPremAmt").replaceAll(",", ""));
			this.tsiAmt				= obj.isNull("tsiAmt") ? null : new BigDecimal(obj.getString("tsiAmt").replaceAll(",", ""));
			this.premAmt			= obj.isNull("premAmt") ? null : new BigDecimal(obj.getString("premAmt").replaceAll(",", ""));
			this.controlCd			= obj.isNull("controlCd") ? null : obj.getString("controlCd");
			this.controlTypeCd		= obj.isNull("controlTypeCd") ? null : obj.getString("controlTypeCd");
			this.principalCd		= obj.isNull("principalCd") ? null : obj.getString("principalCd");
			this.packageCd			= obj.isNull("packageCd") ? null : obj.getString("packageCd");
			this.paytTermsDesc		= obj.isNull("paytTermsDesc") ? null : obj.getString("paytTermsDesc");
			this.overwriteBen		= obj.isNull("overwriteBen") ? null : obj.getString("overwriteBen");
		}catch(JSONException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}catch(ParseException e) {			
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
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

	public void setStrDateOfBirth(String strDateOfBirth) {		
		this.strDateOfBirth = strDateOfBirth;
	}

	public String getStrFromDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(this.fromDate != null){
			return sdf.format(fromDate);
		} else {
			return null;
		}
	}

	public void setStrFromDate(String strFromDate) {
		this.strFromDate = strFromDate;
	}

	public String getStrToDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(this.toDate != null){
			return sdf.format(toDate);
		} else {
			return null;
		}
	}

	public void setStrToDate(String strToDate) {
		this.strToDate = strToDate;
	}

	public String getControlTypeDesc() {
		return controlTypeDesc;
	}

	public void setControlTypeDesc(String controlTypeDesc) {
		this.controlTypeDesc = controlTypeDesc;
	}

	public String getPositionDesc() {
		return positionDesc;
	}

	public void setPositionDesc(String positionDesc) {
		this.positionDesc = positionDesc;
	}

	public String getCivilStatusDesc() {
		return civilStatusDesc;
	}

	public void setCivilStatusDesc(String civilStatusDesc) {
		this.civilStatusDesc = civilStatusDesc;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public Integer getIssueYy() {
		return issueYy;
	}

	public void setIssueYy(Integer issueYy) {
		this.issueYy = issueYy;
	}

	public Integer getPolSeqNo() {
		return polSeqNo;
	}

	public void setPolSeqNo(Integer polSeqNo) {
		this.polSeqNo = polSeqNo;
	}

	public Integer getRenewNo() {
		return renewNo;
	}

	public void setRenewNo(Integer renewNo) {
		this.renewNo = renewNo;
	}

	public String getEffDate() {
		return effDate;
	}

	public void setEffDate(String effDate) {
		this.effDate = effDate;
	}

	public Integer getCol1() {
		return col1;
	}

	public void setCol1(Integer col1) {
		this.col1 = col1;
	}

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}	
}
