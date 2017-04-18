package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIErrorLog extends BaseEntity{

	private String uploadNo;  	   	  
	private String filename;
	private String groupedItemTitle;	 
	private String sex;			  
	private String civilStatus;				  				  
	private Date dateOfBirth;
	private String age;  
	private BigDecimal salary;				  
	private String salaryGrade;
	private BigDecimal amountCoverage;
	private String remarks;			  
	private String userId;
	private Date lastUpdate;	  
	private String controlCd;	  
	private String controlTypeCd;
	private String groupedItemNo;
	
	public String getUploadNo() {
		return uploadNo;
	}
	public void setUploadNo(String uploadNo) {
		this.uploadNo = uploadNo;
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public String getGroupedItemTitle() {
		return groupedItemTitle;
	}
	public void setGroupedItemTitle(String groupedItemTitle) {
		this.groupedItemTitle = groupedItemTitle;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
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
	public BigDecimal getAmountCoverage() {
		return amountCoverage;
	}
	public void setAmountCoverage(BigDecimal amountCoverage) {
		this.amountCoverage = amountCoverage;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
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
	public String getGroupedItemNo() {
		return groupedItemNo;
	}
	public void setGroupedItemNo(String groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}
	
}
