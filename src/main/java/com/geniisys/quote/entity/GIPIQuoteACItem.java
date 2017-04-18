package com.geniisys.quote.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIQuoteACItem extends BaseEntity{

	private Integer quoteId;
	private Integer itemNo;
	private Integer noOfPersons;
	private Integer positionCd;
	private BigDecimal monthlySalary;
	private String salaryGrade;
	private String destination;
	private String userId;
	private Date lastUpdate;
	private String acClassCd;
	private Integer age;
	private String civilStatus;
	private Date dateOfBirth;
	private String groupPrintSw;
	private String height;
	private String levelCd;
	private Integer parentLevelCd;
	private String sex;
	private String weight;
	
	private String dspOccupation;
	
	public GIPIQuoteACItem() {
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

	public Integer getNoOfPersons() {
		return noOfPersons;
	}

	public void setNoOfPersons(Integer noOfPersons) {
		this.noOfPersons = noOfPersons;
	}

	public Integer getPositionCd() {
		return positionCd;
	}

	public void setPositionCd(Integer positionCd) {
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

	public String getDestination() {
		return destination;
	}

	public void setDestination(String destination) {
		this.destination = destination;
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

	public String getAcClassCd() {
		return acClassCd;
	}

	public void setAcClassCd(String acClassCd) {
		this.acClassCd = acClassCd;
	}

	public Integer getAge() {
		return age;
	}

	public void setAge(Integer age) {
		this.age = age;
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
	
	public Object getStrDateOfBirth(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (dateOfBirth != null) {
			return df.format(dateOfBirth);
		} else {
			return null;
		}
	}

	public String getGroupPrintSw() {
		return groupPrintSw;
	}

	public void setGroupPrintSw(String groupPrintSw) {
		this.groupPrintSw = groupPrintSw;
	}

	public String getHeight() {
		return height;
	}

	public void setHeight(String height) {
		this.height = height;
	}

	public String getLevelCd() {
		return levelCd;
	}

	public void setLevelCd(String levelCd) {
		this.levelCd = levelCd;
	}

	public Integer getParentLevelCd() {
		return parentLevelCd;
	}

	public void setParentLevelCd(Integer parentLevelCd) {
		this.parentLevelCd = parentLevelCd;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public String getWeight() {
		return weight;
	}

	public void setWeight(String weight) {
		this.weight = weight;
	}

	public String getDspOccupation() {
		return dspOccupation;
	}

	public void setDspOccupation(String dspOccupation) {
		this.dspOccupation = dspOccupation;
	}
	
}
