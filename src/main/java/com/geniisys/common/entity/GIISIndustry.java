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
 * The Class GIISIndustry.
 */
public class GIISIndustry extends BaseEntity {

	/** The industry cd. */
	private int industryCd;
	
	/** The industry name. */
	private String industryName;
	
	/** The remarks. */
	private String remarks;
	
	/** The cpi rec no. */
	private Integer cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;
	
	/** The industry group cd. */
	private Integer industryGroupCd;

	/**
	 * Gets the industry cd.
	 * 
	 * @return the industry cd
	 */
	public int getIndustryCd() {
		return industryCd;
	}

	/**
	 * Sets the industry cd.
	 * 
	 * @param industryCd the new industry cd
	 */
	public void setIndustryCd(int industryCd) {
		this.industryCd = industryCd;
	}

	/**
	 * Gets the industry name.
	 * 
	 * @return the industry name
	 */
	public String getIndustryName() {
		return industryName;
	}

	/**
	 * Sets the industry name.
	 * 
	 * @param industryName the new industry name
	 */
	public void setIndustryName(String industryName) {
		this.industryName = industryName;
	}

	/**
	 * Gets the remarks.
	 * 
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * Sets the remarks.
	 * 
	 * @param remarks the new remarks
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
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

	/**
	 * Gets the industry group cd.
	 * 
	 * @return the industry group cd
	 */
	public Integer getIndustryGroupCd() {
		return industryGroupCd;
	}

	/**
	 * Sets the industry group cd.
	 * 
	 * @param industryGroupCd the new industry group cd
	 */
	public void setIndustryGroupCd(Integer industryGroupCd) {
		this.industryGroupCd = industryGroupCd;
	}

}
