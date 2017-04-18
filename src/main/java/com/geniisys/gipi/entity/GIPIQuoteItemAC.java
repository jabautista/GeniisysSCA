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
 * The Class GIPIQuoteItemAC.
 */
public class GIPIQuoteItemAC extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -8310992255106476092L;

	/** The quote id. */
	private int quoteId;
	
	/** The item no. */
	private int itemNo;
	
	/** The no of person. */
	private String noOfPerson;
	
	/** The position cd. */
	private String positionCd;
	
	/** The monthly salary. */
	private BigDecimal monthlySalary;
	
	/** The salary grade. */
	private String salaryGrade;
	
	/** The destination. */
	private String destination;
	
	/** The ac class cd. */
	private String acClassCd;
	
	/** The age. */
	private String age;
	
	/** The civil status. */
	private String civilStatus;
	
	/** The date of birth. */
	private Date dateOfBirth;
	
	/** The group print sw. */
	private String groupPrintSw;
	
	/** The height. */
	private String height;
	
	/** The level cd. */
	private String levelCd;
	
	/** The parent level cd. */
	private String parentLevelCd;
	
	/** The sex. */
	private String sex;
	
	/** The weight. */
	private String weight;
	
	/** The position. */
	private String position;

	/**
	 * Instantiates a new gIPI quote item ac.
	 */
	public GIPIQuoteItemAC() {
	}

	/**
	 * Instantiates a new gIPI quote item ac.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @param noOfPersons the no of persons
	 * @param positionCd the position cd
	 * @param destination the destination
	 * @param monthlySalary the monthly salary
	 * @param salaryGrade the salary grade
	 * @param dateOfBirth the date of birth
	 * @param civilStatus the civil status
	 * @param age the age
	 * @param weight the weight
	 * @param height the height
	 * @param sex the sex
	 */
	public GIPIQuoteItemAC(int quoteId, int itemNo, long noOfPersons,
			Integer positionCd, String destination, BigDecimal monthlySalary,
			String salaryGrade, Date dateOfBirth, String civilStatus, int age,
			String weight, String height, String sex) {
	}

	/**
	 * Gets the quote id.
	 * 
	 * @return the quote id
	 */
	public int getQuoteId() {
		return quoteId;
	}

	/**
	 * Sets the quote id.
	 * 
	 * @param quoteId the new quote id
	 */
	public void setQuoteId(int quoteId) {
		this.quoteId = quoteId;
	}

	/**
	 * Gets the item no.
	 * 
	 * @return the item no
	 */
	public int getItemNo() {
		return itemNo;
	}

	/**
	 * Sets the item no.
	 * 
	 * @param itemNo the new item no
	 */
	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}

	/**
	 * Gets the no of person.
	 * 
	 * @return the no of person
	 */
	public String getNoOfPerson() {
		return noOfPerson;
	}

	/**
	 * Sets the no of person.
	 * 
	 * @param noOfPerson the new no of person
	 */
	public void setNoOfPerson(String noOfPerson) {
		this.noOfPerson = noOfPerson;
	}

	/**
	 * Gets the position cd.
	 * 
	 * @return the position cd
	 */
	public String getPositionCd() {
		return positionCd;
	}

	/**
	 * Sets the position cd.
	 * 
	 * @param positionCd the new position cd
	 */
	public void setPositionCd(String positionCd) {
		this.positionCd = positionCd;
	}

	/**
	 * Gets the monthly salary.
	 * 
	 * @return the monthly salary
	 */
	public BigDecimal getMonthlySalary() {
		return monthlySalary;
	}

	/**
	 * Sets the monthly salary.
	 * 
	 * @param monthlySalary the new monthly salary
	 */
	public void setMonthlySalary(BigDecimal monthlySalary) {
		this.monthlySalary = monthlySalary;
	}

	/**
	 * Gets the salary grade.
	 * 
	 * @return the salary grade
	 */
	public String getSalaryGrade() {
		return salaryGrade;
	}

	/**
	 * Sets the salary grade.
	 * 
	 * @param salaryGrade the new salary grade
	 */
	public void setSalaryGrade(String salaryGrade) {
		this.salaryGrade = salaryGrade;
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
	 * Gets the ac class cd.
	 * 
	 * @return the ac class cd
	 */
	public String getAcClassCd() {
		return acClassCd;
	}

	/**
	 * Sets the ac class cd.
	 * 
	 * @param acClassCd the new ac class cd
	 */
	public void setAcClassCd(String acClassCd) {
		this.acClassCd = acClassCd;
	}

	/**
	 * Gets the age.
	 * 
	 * @return the age
	 */
	public String getAge() {
		return age;
	}

	/**
	 * Sets the age.
	 * 
	 * @param age the new age
	 */
	public void setAge(String age) {
		this.age = age;
	}

	/**
	 * Gets the civil status.
	 * 
	 * @return the civil status
	 */
	public String getCivilStatus() {
		return civilStatus;
	}

	/**
	 * Sets the civil status.
	 * 
	 * @param civilStatus the new civil status
	 */
	public void setCivilStatus(String civilStatus) {
		this.civilStatus = civilStatus;
	}

	/**
	 * Gets the date of birth.
	 * 
	 * @return the date of birth
	 */
	public Date getDateOfBirth() {
		return dateOfBirth;
	}

	/**
	 * Sets the date of birth.
	 * 
	 * @param dateOfBirth the new date of birth
	 */
	public void setDateOfBirth(Date dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}

	/**
	 * Gets the group print sw.
	 * 
	 * @return the group print sw
	 */
	public String getGroupPrintSw() {
		return groupPrintSw;
	}

	/**
	 * Sets the group print sw.
	 * 
	 * @param groupPrintSw the new group print sw
	 */
	public void setGroupPrintSw(String groupPrintSw) {
		this.groupPrintSw = groupPrintSw;
	}

	/**
	 * Gets the height.
	 * 
	 * @return the height
	 */
	public String getHeight() {
		return height;
	}

	/**
	 * Sets the height.
	 * 
	 * @param height the new height
	 */
	public void setHeight(String height) {
		this.height = height;
	}

	/**
	 * Gets the level cd.
	 * 
	 * @return the level cd
	 */
	public String getLevelCd() {
		return levelCd;
	}

	/**
	 * Sets the level cd.
	 * 
	 * @param levelCd the new level cd
	 */
	public void setLevelCd(String levelCd) {
		this.levelCd = levelCd;
	}

	/**
	 * Gets the parent level cd.
	 * 
	 * @return the parent level cd
	 */
	public String getParentLevelCd() {
		return parentLevelCd;
	}

	/**
	 * Sets the parent level cd.
	 * 
	 * @param parentLevelCd the new parent level cd
	 */
	public void setParentLevelCd(String parentLevelCd) {
		this.parentLevelCd = parentLevelCd;
	}

	/**
	 * Gets the sex.
	 * 
	 * @return the sex
	 */
	public String getSex() {
		return sex;
	}

	/**
	 * Sets the sex.
	 * 
	 * @param sex the new sex
	 */
	public void setSex(String sex) {
		this.sex = sex;
	}

	/**
	 * Gets the weight.
	 * 
	 * @return the weight
	 */
	public String getWeight() {
		return weight;
	}

	/**
	 * Sets the weight.
	 * 
	 * @param weight the new weight
	 */
	public void setWeight(String weight) {
		this.weight = weight;
	}

	/**
	 * Gets the position.
	 * 
	 * @return the position
	 */
	public String getPosition() {
		return position;
	}

	/**
	 * Sets the position.
	 * 
	 * @param position the new position
	 */
	public void setPosition(String position) {
		this.position = position;
	}

}
