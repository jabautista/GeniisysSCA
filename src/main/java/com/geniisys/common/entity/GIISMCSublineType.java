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
 * The Class GIISMCSublineType.
 */
public class GIISMCSublineType extends BaseEntity {

	/** The subline cd. */
	private String sublineCd;
	
	/** The subline type cd. */
	private String sublineTypeCd;
	
	/** The subline type desc. */
	private String sublineTypeDesc;
	
	/** The remarks. */
	private String remarks;
	
	/** The cpi rec no. */
	private Integer cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;

	/**
	 * Gets the subline cd.
	 * 
	 * @return the subline cd
	 */
	public String getSublineCd() {
		return sublineCd;
	}

	/**
	 * Sets the subline cd.
	 * 
	 * @param sublineCd the new subline cd
	 */
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	/**
	 * Gets the subline type cd.
	 * 
	 * @return the subline type cd
	 */
	public String getSublineTypeCd() {
		return sublineTypeCd;
	}

	/**
	 * Sets the subline type cd.
	 * 
	 * @param sublineTypeCd the new subline type cd
	 */
	public void setSublineTypeCd(String sublineTypeCd) {
		this.sublineTypeCd = sublineTypeCd;
	}

	/**
	 * Gets the subline type desc.
	 * 
	 * @return the subline type desc
	 */
	public String getSublineTypeDesc() {
		return sublineTypeDesc;
	}

	/**
	 * Sets the subline type desc.
	 * 
	 * @param sublineTypeDesc the new subline type desc
	 */
	public void setSublineTypeDesc(String sublineTypeDesc) {
		this.sublineTypeDesc = sublineTypeDesc;
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

}
