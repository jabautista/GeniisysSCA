/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import java.util.List;


/**
 * The Class GIISUserGrpDtl.
 */
public class GIISUserGrpDtl extends GIISISSource {

	/** The tran cd. */
	private Integer tranCd;
	
	/** The user grp. */
	private Integer userGrp;
	
	/** The lines. */
	private List<GIISUserGrpLine> lines;

	/**
	 * Gets the lines.
	 * 
	 * @return the lines
	 */
	public List<GIISUserGrpLine> getLines() {
		return lines;
	}

	/**
	 * Sets the lines.
	 * 
	 * @param lines the new lines
	 */
	public void setLines(List<GIISUserGrpLine> lines) {
		this.lines = lines;
	}

	/**
	 * Instantiates a new gIIS user grp dtl.
	 */
	public GIISUserGrpDtl() {

	}

	/**
	 * Instantiates a new gIIS user grp dtl.
	 * 
	 * @param userGrp the user grp
	 * @param tranCd the tran cd
	 * @param issCd the iss cd
	 * @param remarks the remarks
	 * @param userId the user id
	 * @param lines the lines
	 */
	public GIISUserGrpDtl(Integer userGrp, Integer tranCd, String issCd, String remarks, String userId, List<GIISUserGrpLine> lines) {
		this.userGrp = userGrp;
		this.tranCd = tranCd;
		this.issCd = issCd;
		super.setRemarks(remarks);
		super.setUserId(userId);
		this.lines = lines;
	}

	/**
	 * Gets the tran cd.
	 * 
	 * @return the tran cd
	 */
	public Integer getTranCd() {
		return tranCd;
	}

	/**
	 * Sets the tran cd.
	 * 
	 * @param tranCd the new tran cd
	 */
	public void setTranCd(Integer tranCd) {
		this.tranCd = tranCd;
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

}
