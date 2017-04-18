/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import java.util.List;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIISUserGrpHdr.
 */
public class GIISUserGrpHdr extends BaseEntity {
	
	/** The user grp. */
	private Integer userGrp;
	
	/** The user grp desc. */
	private String userGrpDesc;
	
	/** The grp iss cd. */
	private String grpIssCd;
	
	/** The iss name. */
	private String issName;
	
	/** The remarks. */
	private String remarks;
	
	/** The transactions. */
	private List<GIISUserGrpTran> transactions;
	
	private String dspLastUpdate;
	
	private String copyTag;

	/**
	 * Instantiates a new gIIS user grp hdr.
	 */
	public GIISUserGrpHdr() {

	}

	/**
	 * Instantiates a new gIIS user grp hdr.
	 * 
	 * @param userGrp the user grp
	 * @param userGrpDesc the user grp desc
	 * @param grpIssCd the grp iss cd
	 * @param remarks the remarks
	 * @param userId the user id
	 * @param transactions the transactions
	 */
	public GIISUserGrpHdr(int userGrp, String userGrpDesc, String grpIssCd, String remarks, String userId, List<GIISUserGrpTran> transactions) {
		this.userGrp = userGrp;
		this.userGrpDesc = userGrpDesc;
		this.grpIssCd = grpIssCd;
		this.remarks = remarks;
		super.setUserId(userId);
		this.transactions = transactions;
	}

	/**
	 * Gets the transactions.
	 * 
	 * @return the transactions
	 */
	public List<GIISUserGrpTran> getTransactions() {
		return transactions;
	}

	/**
	 * Sets the transactions.
	 * 
	 * @param transactions the new transactions
	 */
	public void setTransactions(List<GIISUserGrpTran> transactions) {
		this.transactions = transactions;
	}

	/**
	 * Gets the user grp.
	 * 
	 * @return the user grp
	 */
	public Integer getUserGrp() {
		return userGrp;
	}

	/**
	 * Sets the user grp.
	 * 
	 * @param userGrp the new user grp
	 */
	public void setUserGrp(Integer userGrp) {
		this.userGrp = userGrp;
	}

	/**
	 * Gets the user grp desc.
	 * 
	 * @return the user grp desc
	 */
	public String getUserGrpDesc() {
		return userGrpDesc;
	}

	/**
	 * Sets the user grp desc.
	 * 
	 * @param userGrpDesc the new user grp desc
	 */
	public void setUserGrpDesc(String userGrpDesc) {
		this.userGrpDesc = userGrpDesc;
	}

	/**
	 * Gets the grp iss cd.
	 * 
	 * @return the grp iss cd
	 */
	public String getGrpIssCd() {
		return grpIssCd;
	}

	/**
	 * Sets the grp iss cd.
	 * 
	 * @param grpIssCd the new grp iss cd
	 */
	public void setGrpIssCd(String grpIssCd) {
		this.grpIssCd = grpIssCd;
	}

	/**
	 * Gets the iss name.
	 * 
	 * @return the iss name
	 */
	public String getIssName() {
		return issName;
	}

	/**
	 * Sets the iss name.
	 * 
	 * @param issName the new iss name
	 */
	public void setIssName(String issName) {
		this.issName = issName;
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
	 * @return the dspLastUpdate
	 */
	public String getDspLastUpdate() {
		return dspLastUpdate;
	}

	/**
	 * @param dspLastUpdate the dspLastUpdate to set
	 */
	public void setDspLastUpdate(String dspLastUpdate) {
		this.dspLastUpdate = dspLastUpdate;
	}

	public String getCopyTag() {
		return copyTag;
	}

	public void setCopyTag(String copyTag) {
		this.copyTag = copyTag;
	}
}