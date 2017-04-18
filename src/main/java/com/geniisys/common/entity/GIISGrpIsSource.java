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
 * The Class GIISGrpIsSource.
 */
public class GIISGrpIsSource extends BaseEntity {

	/** The iss grp. */
	private String issGrp;
	
	/** The iss grp desc. */
	private String issGrpDesc;
	
	/** The cpi rec no. */
	private int cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;
	
	/** The remarks. */
	private String remarks;
	
	/**
	 * Gets the iss grp.
	 * 
	 * @return the iss grp
	 */
	public String getIssGrp() {
		return issGrp;
	}
	
	/**
	 * Sets the iss grp.
	 * 
	 * @param issGrp the new iss grp
	 */
	public void setIssGrp(String issGrp) {
		this.issGrp = issGrp;
	}
	
	/**
	 * Gets the iss grp desc.
	 * 
	 * @return the iss grp desc
	 */
	public String getIssGrpDesc() {
		return issGrpDesc;
	}
	
	/**
	 * Sets the iss grp desc.
	 * 
	 * @param issGrpDesc the new iss grp desc
	 */
	public void setIssGrpDesc(String issGrpDesc) {
		this.issGrpDesc = issGrpDesc;
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
