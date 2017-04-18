package com.geniisys.gipi.pack.entity;

import java.sql.Date;

import com.geniisys.framework.util.BaseEntity;
/**
 * The Class GIPIPackWPolnrep.
 *
 */
public class GIPIPackWPolnrep extends BaseEntity {
	
	/** The par id. - this equivalent to packParId.*/
	private Integer parId;
	
	/** The old policy id. - this is equivalent to oldPackPolicyId */
	private Integer oldPolicyId;
	
	/** The line cd. */
	private String lineCd;
	
	/** The subline cd. */
	private String sublineCd;
	
	/** The pol seq no. */
	private int polSeqNo;
	
	/** The iss cd. */
	private String issCd;
	
	/** The issue yy. */
	private int issueYy;
	
	/** The renew no. */
	private int renewNo;
	
	/** The rec flag. */
	private String recFlag;
	
	/** The ren rep sw. */
	private String renRepSw;
	
	private Date expiryDate;
	
	/** The user id. */
	private String userId;
	
	public Integer getParId() {
		return parId;
	}

	public void setParId(Integer parId) {
		this.parId = parId;
	}

	public Integer getOldPolicyId() {
		return oldPolicyId;
	}

	public void setOldPolicyId(Integer oldPolicyId) {
		this.oldPolicyId = oldPolicyId;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getSublineCd() {
		return sublineCd;
	}

	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	public int getPolSeqNo() {
		return polSeqNo;
	}

	public void setPolSeqNo(int polSeqNo) {
		this.polSeqNo = polSeqNo;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public int getIssueYy() {
		return issueYy;
	}

	public void setIssueYy(int issueYy) {
		this.issueYy = issueYy;
	}

	public int getRenewNo() {
		return renewNo;
	}

	public void setRenewNo(int renewNo) {
		this.renewNo = renewNo;
	}

	public String getRecFlag() {
		return recFlag;
	}

	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}

	public String getRenRepSw() {
		return renRepSw;
	}

	public void setRenRepSw(String renRepSw) {
		this.renRepSw = renRepSw;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Date getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}

}
