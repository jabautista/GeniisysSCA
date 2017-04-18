/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;


/**
 * The Class GIISUserGrpLine.
 */
public class GIISUserGrpLine extends GIISLine {
	
	/** The user grp. */
	private int userGrp;
	
	/** The remarks. */
	private String remarks;
	
	/** The tran cd. */
	private int tranCd;
	
	/** The iss cd. */
	private String issCd;
	
	/** The line cd. */
	private String lineCd;
	
	/**
	 * Instantiates a new gIIS user grp line.
	 */
	public GIISUserGrpLine() {
	
	}
	
	/**
	 * Instantiates a new gIIS user grp line.
	 * 
	 * @param userGrp the user grp
	 * @param tranCd the tran cd
	 * @param issCd the iss cd
	 * @param lineCd the line cd
	 * @param remarks the remarks
	 * @param userId the user id
	 */
	public GIISUserGrpLine(int userGrp, int tranCd, String issCd, String lineCd, String remarks, String userId) {
		this.userGrp = userGrp;
		this.tranCd = tranCd;
		this.issCd = issCd;
		this.lineCd = lineCd;
		this.remarks = remarks;
		super.setUserId(userId);
	}
	
	/**
	 * Gets the iss cd.
	 * 
	 * @return the iss cd
	 */
	public String getIssCd() {
		return issCd;
	}
	
	/**
	 * Sets the iss cd.
	 * 
	 * @param issCd the new iss cd
	 */
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.entity.GIISLine#getLineCd()
	 */
	@Override
	public String getLineCd() {
		return lineCd;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.entity.GIISLine#setLineCd(java.lang.String)
	 */
	@Override
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	
	/**
	 * Gets the user grp.
	 * 
	 * @return the user grp
	 */
	public int getUserGrp() {
		return userGrp;
	}
	
	/**
	 * Sets the user grp.
	 * 
	 * @param userGrp the new user grp
	 */
	public void setUserGrp(int userGrp) {
		this.userGrp = userGrp;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.entity.GIISLine#getRemarks()
	 */
	@Override
	public String getRemarks() {
		return remarks;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.entity.GIISLine#setRemarks(java.lang.String)
	 */
	@Override
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	/**
	 * Gets the tran cd.
	 * 
	 * @return the tran cd
	 */
	public int getTranCd() {
		return tranCd;
	}
	
	/**
	 * Sets the tran cd.
	 * 
	 * @param tranCd the new tran cd
	 */
	public void setTranCd(int tranCd) {
		this.tranCd = tranCd;
	}
	

}
