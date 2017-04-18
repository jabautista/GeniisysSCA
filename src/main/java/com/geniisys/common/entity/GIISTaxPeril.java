/**
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.common.entity;

import com.seer.framework.util.Entity;


@SuppressWarnings("rawtypes")
public class GIISTaxPeril extends Entity {
	
	/** Generated serialVersionId	 */
	private static final long serialVersionUID = 5248559195327628887L;

	/**	 The issue code	 	*/
	private String issCd;
	
	/** The line code	 	*/
	private String lineCd;
	
	/** The taxCode	 		*/
	private Integer taxCd;
	
	/** The peril code		*/
	private Integer perilCd;
	
	/** The peril switch 	*/
	private String perilSw;
	
	/** The tax id			*/
	private Integer taxId;
	
	/** The remarks			*/
	private String remarks;
	
	/** The user id			*/
	private String userId;
	
	/** The branch cd		*/
	private String branchCd;
		
	private String perilName;
	/**
	 * @param issueCode
	 * @param lineCode
	 * @param taxCode
	 * @param perilCode
	 * @param perilSwitch
	 * @param taxId
	 * @param remarks
	 * @param userId
	 * @param branchCode
	 */
	public GIISTaxPeril(String issueCode, String lineCode, Integer taxCode, Integer perilCode, String perilSwitch, Integer taxId, String remarks, String userId, String branchCode){
		this.issCd 		= issueCode;
		this.lineCd 	= lineCode;
		this.taxCd		= taxCode;
		this.perilCd	= perilCode;
		this.perilSw	= perilSwitch;
		this.taxId		= taxId;
		this.remarks	= remarks;
		this.userId		= userId;
		this.branchCd	= branchCode;
	}
	
	/**
	 * Checks if anotherGiisTaxPeril is equal to this GIISTaxPeril
	 * @param anotherGiisTaxPeril
	 * @return
	 */
	public boolean equals(GIISTaxPeril anotherGiisTaxPeril){
		if(this.issCd.equals(anotherGiisTaxPeril.getIssCd()) 
				&& this.lineCd.equals(anotherGiisTaxPeril.getLineCd())
				&& this.taxCd.intValue() == anotherGiisTaxPeril.getTaxCd().intValue()
				&& this.perilCd.intValue() == anotherGiisTaxPeril.getPerilCd().intValue()){
			return true;
		}else{
			return false;
		}
	}
	
	/**
	 * GIISTaxPeril empty constructor
	 */
	public GIISTaxPeril(){
		
	}
	
	/**
	 * Get Issue Code
	 * @return the issue Code
	 */
	public String getIssCd() {
		return issCd;
	}

	/**
	 * Set Issue Code
	 * @param issCd
	 */
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	/**
	 * Get line code
	 * @return the line Code
	 */
	public String getLineCd() {
		return lineCd;
	}

	/**
	 * Set line code
	 * @param lineCd
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	/**
	 * Get tax code
	 * @return the tax code
	 */
	public Integer getTaxCd() {
		return taxCd;
	}

	/**
	 * Set Tax Code
	 * @param taxCd
	 */
	public void setTaxCd(Integer taxCd) {
		this.taxCd = taxCd;
	}

	/**
	 * Get Peril Code
	 * @return the peril Code
	 */
	public Integer getPerilCd() {
		return perilCd;
	}

	/**
	 * Set Peril Code
	 * @param perilCd
	 */
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}

	/**
	 * Get peril Switch
	 * @return the peril switch
	 */
	public String getPerilSw() {
		return perilSw;
	}

	/**
	 * Set peril switch
	 * @param perilSw
	 */
	public void setPerilSw(String perilSw) {
		this.perilSw = perilSw;
	}

	/**
	 * Get Tax ID
	 * @return the tax id
	 */
	public Integer getTaxId() {
		return taxId;
	}

	/**
	 * Set Tax ID
	 * @param taxId
	 */
	public void setTaxId(Integer taxId) {
		this.taxId = taxId;
	}

	/**
	 * Get remarks
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * Set remarks
	 * @param remarks
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	/**
	 * Get User ID
	 * @return the user id
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * Set User Id
	 * @param userId
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}

	/**
	 * Get Branch Code
	 * @return the branchCd
	 */
	public String getBranchCd() {
		return branchCd;
	}
	
	/**
	 * Set Branch Code
	 * @param branchCd
	 */
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}

	/*
	 * (non-Javadoc)
	 * @see com.seer.framework.util.Entity#getId()
	 */
	@SuppressWarnings("static-access")
	@Override
	public Object getId() {
		return this.serialVersionUID;
	}

	/*
	 * (non-Javadoc)
	 * @see com.seer.framework.util.Entity#setId(java.lang.Object)
	 */
	@Override
	public void setId(Object id) {
		// TODO Auto-generated method stub
	}

	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}

	public String getPerilName() {
		return perilName;
	}
}
