/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIWOpenPolicy.
 */
public class GIPIWOpenPolicy extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The par id. */
	private Integer parId;
	
	/** The line cd. */
	private String lineCd;
	
	/** The op subline cd. */
	private String opSublineCd;
	
	/** The op iss cd. */
	private String opIssCd;
	
	/** The op issue yy. */
	private Integer opIssueYy;
	
	/** The op pol seqno. */
	private Integer opPolSeqno;
	
	/** The op renew no. */
	private Integer opRenewNo;
	
	/** The decltn no. */
	private String decltnNo;
	
	/** The eff date. */
	private Date effDate;
	
	/** The ref open pol no. */
	private String refOpenPolNo;
	
	private String gipiWItemExist;
	
	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public Integer getParId() {
		return parId;
	}
	
	/**
	 * Sets the par id.
	 * 
	 * @param parId the new par id
	 */
	public void setParId(Integer parId) {
		this.parId = parId;
	}
	
	/**
	 * Gets the line cd.
	 * 
	 * @return the line cd
	 */
	public String getLineCd() {
		return lineCd;
	}
	
	/**
	 * Sets the line cd.
	 * 
	 * @param lineCd the new line cd
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	
	/**
	 * Gets the op subline cd.
	 * 
	 * @return the op subline cd
	 */
	public String getOpSublineCd() {
		return opSublineCd;
	}
	
	/**
	 * Sets the op subline cd.
	 * 
	 * @param opSublineCd the new op subline cd
	 */
	public void setOpSublineCd(String opSublineCd) {
		this.opSublineCd = opSublineCd;
	}
	
	/**
	 * Gets the op iss cd.
	 * 
	 * @return the op iss cd
	 */
	public String getOpIssCd() {
		return opIssCd;
	}
	
	/**
	 * Sets the op iss cd.
	 * 
	 * @param opIssCd the new op iss cd
	 */
	public void setOpIssCd(String opIssCd) {
		this.opIssCd = opIssCd;
	}
	
	/**
	 * Gets the op issue yy.
	 * 
	 * @return the op issue yy
	 */
	public Integer getOpIssueYy() {
		return opIssueYy;
	}
	
	/**
	 * Sets the op issue yy.
	 * 
	 * @param opIssueYy the new op issue yy
	 */
	public void setOpIssueYy(Integer opIssueYy) {
		this.opIssueYy = opIssueYy;
	}
	
	/**
	 * Gets the op pol seqno.
	 * 
	 * @return the op pol seqno
	 */
	public Integer getOpPolSeqno() {
		return opPolSeqno;
	}
	
	/**
	 * Sets the op pol seqno.
	 * 
	 * @param opPolSeqno the new op pol seqno
	 */
	public void setOpPolSeqno(Integer opPolSeqno) {
		this.opPolSeqno = opPolSeqno;
	}
	
	/**
	 * Gets the op renew no.
	 * 
	 * @return the op renew no
	 */
	public Integer getOpRenewNo() {
		return opRenewNo;
	}
	
	/**
	 * Sets the op renew no.
	 * 
	 * @param opRenewNo the new op renew no
	 */
	public void setOpRenewNo(Integer opRenewNo) {
		this.opRenewNo = opRenewNo;
	}
	
	/**
	 * Gets the decltn no.
	 * 
	 * @return the decltn no
	 */
	public String getDecltnNo() {
		return decltnNo;
	}
	
	/**
	 * Sets the decltn no.
	 * 
	 * @param decltnNo the new decltn no
	 */
	public void setDecltnNo(String decltnNo) {
		this.decltnNo = decltnNo;
	}
	
	/**
	 * Gets the eff date.
	 * 
	 * @return the eff date
	 */
	public Date getEffDate() {
		return effDate;
	}
	
	/**
	 * Sets the eff date.
	 * 
	 * @param effDate the new eff date
	 */
	public void setEffDate(Date effDate) {
		this.effDate = effDate;
	}
	
	/**
	 * Gets the ref open pol no.
	 * 
	 * @return the ref open pol no
	 */
	public String getRefOpenPolNo() {
		return refOpenPolNo;
	}
	
	/**
	 * Sets the ref open pol no.
	 * 
	 * @param refOpenPolNo the new ref open pol no
	 */
	public void setRefOpenPolNo(String refOpenPolNo) {
		this.refOpenPolNo = refOpenPolNo;
	}

	/**
	 * @param gipiWItemExist the gipiWItemExist to set
	 */
	public void setGipiWItemExist(String gipiWItemExist) {
		this.gipiWItemExist = gipiWItemExist;
	}

	/**
	 * @return the gipiWItemExist
	 */
	public String getGipiWItemExist() {
		return gipiWItemExist;
	}

}
