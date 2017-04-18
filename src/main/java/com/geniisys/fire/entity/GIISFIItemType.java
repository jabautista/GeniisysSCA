/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.fire.entity;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIISFIItemType.
 */
public class GIISFIItemType extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -609414365067272795L;

	/** The fr item type. */
	private String frItemType;
	
	/** The fr item type ds. */
	private String frItemTypeDs;
	
	/** The main itm type. */
	private String mainItmType;
	
	/** The remarks. */
	private String remarks;
	
	/** The cpi rec no. */
	private int cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;
	
	/** The fi item grp. */
	private String fiItemGrp;

	/**
	 * Gets the fr item type.
	 * 
	 * @return the fr item type
	 */
	public String getFrItemType() {
		return frItemType;
	}

	/**
	 * Sets the fr item type.
	 * 
	 * @param frItemType the new fr item type
	 */
	public void setFrItemType(String frItemType) {
		this.frItemType = frItemType;
	}

	/**
	 * Gets the fr item type ds.
	 * 
	 * @return the fr item type ds
	 */
	public String getFrItemTypeDs() {
		return frItemTypeDs;
	}

	/**
	 * Sets the fr item type ds.
	 * 
	 * @param frItemTypeDs the new fr item type ds
	 */
	public void setFrItemTypeDs(String frItemTypeDs) {
		this.frItemTypeDs = frItemTypeDs;
	}

	/**
	 * Gets the main itm type.
	 * 
	 * @return the main itm type
	 */
	public String getMainItmType() {
		return mainItmType;
	}

	/**
	 * Sets the main itm type.
	 * 
	 * @param mainItmType the new main itm type
	 */
	public void setMainItmType(String mainItmType) {
		this.mainItmType = mainItmType;
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
	public int getCpiRecNo() {
		return cpiRecNo;
	}

	/**
	 * Sets the cpi rec no.
	 * 
	 * @param cpiRecNo the new cpi rec no
	 */
	public void setCpiRecNo(int cpiRecNo) {
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
	 * Gets the fi item grp.
	 * 
	 * @return the fi item grp
	 */
	public String getFiItemGrp() {
		return fiItemGrp;
	}

	/**
	 * Sets the fi item grp.
	 * 
	 * @param fiItemGrp the new fi item grp
	 */
	public void setFiItemGrp(String fiItemGrp) {
		this.fiItemGrp = fiItemGrp;
	}

}
