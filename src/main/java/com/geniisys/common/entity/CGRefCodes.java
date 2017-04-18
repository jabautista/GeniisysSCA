/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class CGRefCodes.
 */
public class CGRefCodes extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -6573383195838850056L;

	/** The rv low value. */
	private String rvLowValue;
	
	/** The rv high value. */
	private String rvHighValue;
	
	/** The rv abbreviation. */
	private String rvAbbreviation;
	
	/** The rv domain. */
	private String rvDomain;
	
	/** The rv meaning. */
	private String rvMeaning;
	
	/** The rv type. */
	private String rvType;
	
	/** The cpi rec no. */
	private Integer cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;
	
	/**
	 * Gets the rv low value.
	 * 
	 * @return the rv low value
	 */
	public String getRvLowValue() {
		return rvLowValue;
	}
	
	/**
	 * Sets the rv low value.
	 * 
	 * @param rvLowValue the new rv low value
	 */
	public void setRvLowValue(String rvLowValue) {
		this.rvLowValue = rvLowValue;
	}
	
	/**
	 * Gets the rv high value.
	 * 
	 * @return the rv high value
	 */
	public String getRvHighValue() {
		return rvHighValue;
	}
	
	/**
	 * Sets the rv high value.
	 * 
	 * @param rvHighValue the new rv high value
	 */
	public void setRvHighValue(String rvHighValue) {
		this.rvHighValue = rvHighValue;
	}
	
	/**
	 * Gets the rv abbreviation.
	 * 
	 * @return the rv abbreviation
	 */
	public String getRvAbbreviation() {
		return rvAbbreviation;
	}
	
	/**
	 * Sets the rv abbreviation.
	 * 
	 * @param rvAbbreviation the new rv abbreviation
	 */
	public void setRvAbbreviation(String rvAbbreviation) {
		this.rvAbbreviation = rvAbbreviation;
	}
	
	/**
	 * Gets the rv domain.
	 * 
	 * @return the rv domain
	 */
	public String getRvDomain() {
		return rvDomain;
	}
	
	/**
	 * Sets the rv domain.
	 * 
	 * @param rvDomain the new rv domain
	 */
	public void setRvDomain(String rvDomain) {
		this.rvDomain = rvDomain;
	}
	
	/**
	 * Gets the rv meaning.
	 * 
	 * @return the rv meaning
	 */
	public String getRvMeaning() {
		return rvMeaning;
	}
	
	/**
	 * Sets the rv meaning.
	 * 
	 * @param rvMeaning the new rv meaning
	 */
	public void setRvMeaning(String rvMeaning) {
		this.rvMeaning = rvMeaning;
	}
	
	/**
	 * Gets the rv type.
	 * 
	 * @return the rv type
	 */
	public String getRvType() {
		return rvType;
	}
	
	/**
	 * Sets the rv type.
	 * 
	 * @param rvType the new rv type
	 */
	public void setRvType(String rvType) {
		this.rvType = rvType;
	}
	
	/**
	 * Gets the cpi rec no.
	 * 
	 * @return the cpi rec no
	 */
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	
	/**
	 * Sets the cpi rec no.
	 * 
	 * @param cpiRecNo the new cpi rec no
	 */
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	
	/**
	 * Gets the cpi branch cd.
	 * 
	 * @return the cpi branch cd
	 */
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	
	/**
	 * Sets the cpi branch cd.
	 * 
	 * @param cpiBranchCd the new cpi branch cd
	 */
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	
}
