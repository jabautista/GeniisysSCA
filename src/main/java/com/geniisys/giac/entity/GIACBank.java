/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

/**
 * The Class GIACBank.
 */
public class GIACBank extends BaseEntity {
	
	/** The bank_cd. */
	private String bankCd;
	
	/** The bank name. */
	private String bankName;
	
	/** The bank sname. */
	private String bankSname;
	
	/** The remarks. */
	private String remarks;
	
	/** The cpi record no. */
	private Integer cpiRecNo;
	
	/** The cpi branch code. */
	private String cpiBranchCd;
	
	public GIACBank (){
		
	}

	/**
	 * Gets the bank code.
	 */
	public String getBankCd() {
		return bankCd;
	}
	
	/**
	 * Sets the bank code.
	 */
	public void setBankCd(String bankCd) {
		this.bankCd = bankCd;
	}

	/**
	 * Gets the bank name.
	 */
	public String getBankName() {
		return bankName;
	}

	/**
	 * Sets the bank name.
	 */
	public void setBankName(String bankName) {
		this.bankName = bankName;
	}

	/**
	 * Gets the bank sname.
	 */
	public String getBankSname() {
		return bankSname;
	}

	/**
	 * Sets the bank sname.
	 */
	public void setBankSname(String bankSname) {
		this.bankSname = bankSname;
	}

	/**
	 * Gets the remarks.
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * Sets the remarks.
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	/**
	 * Gets the cpi rec no.
	 */
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	/**
	 * Sets the cpi rec no.
	 */
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	/**
	 * Gets the cpi branch cd.
	 */
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	/**
	 * Sets the cpi branch cd.
	 */
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	

}
