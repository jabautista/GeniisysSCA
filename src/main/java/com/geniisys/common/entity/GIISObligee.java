/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIISObligee extends BaseEntity{
	
	/** The Obligee Number	 */
	private Integer obligeeNo;
	
	/** The Obligee Name	 */
	private String obligeeName;
	
	/** The Address	 */
	private String address;
	
	/** mknfelipe_20120925: Inserted additional details of Obligee */
	
	/** The Contact Person for the Obligee */
	private String contactPerson;
	
	/** The Designation */
	private String designation;
	
	/** The Phone Number */
	private String phoneNo;
	
	/** The Remarks for the Obligee*/
	private String remarks;
	
	/** CPI Record Number*/
	private Integer cpiRecNo;
	
	/** CPI Branch Code*/
	private String cpiBranchCd;
	
	private String address1;
	private String address2;
	private String address3;
	private String lastUpdateStr;
	
	/**
	 * Gets the Obligee Number
	 * @return the obligeeNo
	 */
	public Integer getObligeeNo() {
		return obligeeNo;
	}
	
	/**
	 * Sets the Obligee Number
	 * @param obligeeNo
	 */
	public void setObligeeNo(Integer obligeeNo) {
		this.obligeeNo = obligeeNo;
	}
	
	/**
	 * Gets the Obligee Name
	 * @return the obligee name
	 */
	public String getObligeeName() {
		return obligeeName;
	}
	
	/**
	 * Sets the Obligee name
	 * @param obligeeName
	 */
	public void setObligeeName(String obligeeName) {
		this.obligeeName = obligeeName;
	}
	
	/**
	 * Gets the Address of the obligee
	 * @return the address
	 */
	public String getAddress() {
		return address;
	}
	
	/**
	 * Sets the Address of the obligee
	 * @param address
	 */
	public void setAddress(String address) {
		this.address = address;
	}
	
	/**
	 * Gets the contact person
	 * @return the contact person
	 */
	public String getContactPerson() {
		return contactPerson;
	}
	
	/**
	 * Sets the contact person
	 * @param contactPerson
	 */
	public void setContactPerson(String contactPerson) {
		this.contactPerson = contactPerson;
	}
	
	/**
	 * Gets the designation
	 * @return the designation
	 */
	public String getDesignation() {
		return designation;
	}
	
	/**
	 * Sets the designation
	 * @param designation
	 */
	public void setDesignation(String designation) {
		this.designation = designation;
	}
	
	/**
	 * Gets the phone number
	 * @return the phone number
	 */
	public String getPhoneNo() {
		return phoneNo;
	}
	
	/**
	 * Sets the phone number
	 * @param phoneNo
	 */
	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}
	
	/**
	 * Gets the remarks
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}
	
	/**
	 * Sets the remarks
	 * @param remarks
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	/**
	 * Gets the CPI Record Number
	 * @return the CPI record number
	 */
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	
	/**
	 * Sets the CPI Record Number
	 * @param cpiRecNo
	 */
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	
	/**
	 * Gets the CPI Branch Code
	 * @return CPI Branch Code
	 */
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	
	/**
	 * Sets the CPI Branch Code
	 * @param cpiBranchCd
	 */
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	
	public String getAddress1() {
		return address1;
	}

	public void setAddress1(String address1) {
		this.address1 = address1;
	}

	public String getAddress2() {
		return address2;
	}

	public void setAddress2(String address2) {
		this.address2 = address2;
	}

	public String getAddress3() {
		return address3;
	}

	public void setAddress3(String address3) {
		this.address3 = address3;
	}

	public String getLastUpdateStr() {
		return lastUpdateStr;
	}

	public void setLastUpdateStr(String lastUpdateStr) {
		this.lastUpdateStr = lastUpdateStr;
	}
	
}
