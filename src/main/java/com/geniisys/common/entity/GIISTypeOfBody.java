/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

/*import com.geniisys.framework.util.BaseEntity;*/


/**
 * The Class GIISTypeOfBody.
 */
public class GIISTypeOfBody extends BaseEntity {

	/** The type of body cd. */
	private Integer typeOfBodyCd;
	
	/** The type of body. */
	private String typeOfBody;
	
	/** The cpi rec no. */
	private Integer cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;
	
	/** The remarks. */
	private String remarks;

	/**
	 * Gets the type of body cd.
	 * 
	 * @return the type of body cd
	 */
	public Integer getTypeOfBodyCd() {
		return typeOfBodyCd;
	}

	/**
	 * Sets the type of body cd.
	 * 
	 * @param typeOfBodyCd the new type of body cd
	 */
	public void setTypeOfBodyCd(Integer typeOfBodyCd) {
		this.typeOfBodyCd = typeOfBodyCd;
	}

	/**
	 * Gets the type of body.
	 * 
	 * @return the type of body
	 */
	public String getTypeOfBody() {
		return typeOfBody;
	}

	/**
	 * Sets the type of body.
	 * 
	 * @param typeOfBody the new type of body
	 */
	public void setTypeOfBody(String typeOfBody) {
		this.typeOfBody = typeOfBody;
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
}
