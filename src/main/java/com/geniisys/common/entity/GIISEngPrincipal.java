package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISEngPrincipal extends BaseEntity{
	
	private Integer principalId;
	private Integer principalCd;
	private String principalName;
	private String principalType;
	private String principalTypeMean;
	private String sublineCd;
	private String sublineName;
	private String address1;
	private String address2;
	private String address3;
	private String remarks;
	
	public GIISEngPrincipal(){
		
	}

	/**
	 * @return the principalCd
	 */
	public Integer getPrincipalCd() {
		return principalCd;
	}

	/**
	 * @param principalCd the principalCd to set
	 */
	public void setPrincipalCd(Integer principalCd) {
		this.principalCd = principalCd;
	}

	/**
	 * @return the principalName
	 */
	public String getPrincipalName() {
		return principalName;
	}

	/**
	 * @param principalName the principalName to set
	 */
	public void setPrincipalName(String principalName) {
		this.principalName = principalName;
	}

	/**
	 * @return the principalType
	 */
	public String getPrincipalType() {
		return principalType;
	}

	/**
	 * @param principalType the principalType to set
	 */
	public void setPrincipalType(String principalType) {
		this.principalType = principalType;
	}

	public String getPrincipalTypeMean() {
		return principalTypeMean;
	}

	public void setPrincipalTypeMean(String principalTypeMean) {
		this.principalTypeMean = principalTypeMean;
	}

	/**
	 * @return the sublineCd
	 */
	public String getSublineCd() {
		return sublineCd;
	}

	/**
	 * @param sublineCd the sublineCd to set
	 */
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	public String getSublineName() {
		return sublineName;
	}

	public void setSublineName(String sublineName) {
		this.sublineName = sublineName;
	}

	/**
	 * @return the address1
	 */
	public String getAddress1() {
		return address1;
	}

	/**
	 * @param address1 the address1 to set
	 */
	public void setAddress1(String address1) {
		this.address1 = address1;
	}

	/**
	 * @return the address2
	 */
	public String getAddress2() {
		return address2;
	}

	/**
	 * @param address2 the address2 to set
	 */
	public void setAddress2(String address2) {
		this.address2 = address2;
	}

	/**
	 * @return the address3
	 */
	public String getAddress3() {
		return address3;
	}

	/**
	 * @param address3 the address3 to set
	 */
	public void setAddress3(String address3) {
		this.address3 = address3;
	}

	/**
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * @param remarks the remarks to set
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	/**
	 * @return the principalId
	 */
	public Integer getPrincipalId() {
		return principalId;
	}

	/**
	 * @param principalId the principalId to set
	 */
	public void setPrincipalId(Integer principalId) {
		this.principalId = principalId;
	}
	
	

}
