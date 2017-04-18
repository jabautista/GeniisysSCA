/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giri.entity
	File Name: GIRIPackWInPolbas.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: May 31, 2012
	Description: 
*/


package com.geniisys.giri.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIRIPackWInPolbas extends BaseEntity{
	private Integer packAcceptNo;
	private Integer packParId;
	private Integer riCd;
	private String acceptDate;
	private String riPolicyNo;
	private String riEndtNo;
	private String riBinderNo;
	private Integer writerCd;
	private String offerDate;
	private String acceptBy;
	private BigDecimal origTsiAmt;
	private BigDecimal origPremAmt;
	private String remarks;
	private String refAcceptNo;
	
	/***properties that are not in the talbe***/
	private String riSName;
	private String riSName2;
	
	
	/**
	 * @return the riSName
	 */
	public String getRiSName() {
		return riSName;
	}
	/**
	 * @param riSName the riSName to set
	 */
	public void setRiSName(String riSName) {
		this.riSName = riSName;
	}
	/**
	 * @return the riSName2
	 */
	public String getRiSName2() {
		return riSName2;
	}
	/**
	 * @param riSName2 the riSName2 to set
	 */
	public void setRiSName2(String riSName2) {
		this.riSName2 = riSName2;
	}
	/**
	 * @return the packAcceptNo
	 */
	public Integer getPackAcceptNo() {
		return packAcceptNo;
	}
	/**
	 * @param packAcceptNo the packAcceptNo to set
	 */
	public void setPackAcceptNo(Integer packAcceptNo) {
		this.packAcceptNo = packAcceptNo;
	}
	/**
	 * @return the packParId
	 */
	public Integer getPackParId() {
		return packParId;
	}
	/**
	 * @param packParId the packParId to set
	 */
	public void setPackParId(Integer packParId) {
		this.packParId = packParId;
	}
	/**
	 * @return the riCd
	 */
	public Integer getRiCd() {
		return riCd;
	}
	/**
	 * @param riCd the riCd to set
	 */
	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}
	/**
	 * @return the acceptDate
	 */
	public String getAcceptDate() {
		return acceptDate;
	}
	/**
	 * @param acceptDate the acceptDate to set
	 */
	public void setAcceptDate(String acceptDate) {
		this.acceptDate = acceptDate;
	}
	/**
	 * @return the riPolicyNo
	 */
	public String getRiPolicyNo() {
		return riPolicyNo;
	}
	/**
	 * @param riPolicyNo the riPolicyNo to set
	 */
	public void setRiPolicyNo(String riPolicyNo) {
		this.riPolicyNo = riPolicyNo;
	}
	/**
	 * @return the riEndtNo
	 */
	public String getRiEndtNo() {
		return riEndtNo;
	}
	/**
	 * @param riEndtNo the riEndtNo to set
	 */
	public void setRiEndtNo(String riEndtNo) {
		this.riEndtNo = riEndtNo;
	}
	/**
	 * @return the riBinderNo
	 */
	public String getRiBinderNo() {
		return riBinderNo;
	}
	/**
	 * @param riBinderNo the riBinderNo to set
	 */
	public void setRiBinderNo(String riBinderNo) {
		this.riBinderNo = riBinderNo;
	}
	/**
	 * @return the writerCd
	 */
	public Integer getWriterCd() {
		return writerCd;
	}
	/**
	 * @param writerCd the writerCd to set
	 */
	public void setWriterCd(Integer writerCd) {
		this.writerCd = writerCd;
	}
	/**
	 * @return the offerDate
	 */
	public String getOfferDate() {
		return offerDate;
	}
	/**
	 * @param offerDate the offerDate to set
	 */
	public void setOfferDate(String offerDate) {
		this.offerDate = offerDate;
	}
	/**
	 * @return the acceptBy
	 */
	public String getAcceptBy() {
		return acceptBy;
	}
	/**
	 * @param acceptBy the acceptBy to set
	 */
	public void setAcceptBy(String acceptBy) {
		this.acceptBy = acceptBy;
	}
	/**
	 * @return the origTsiAmt
	 */
	public BigDecimal getOrigTsiAmt() {
		return origTsiAmt;
	}
	/**
	 * @param origTsiAmt the origTsiAmt to set
	 */
	public void setOrigTsiAmt(BigDecimal origTsiAmt) {
		this.origTsiAmt = origTsiAmt;
	}
	/**
	 * @return the origPremAmt
	 */
	public BigDecimal getOrigPremAmt() {
		return origPremAmt;
	}
	/**
	 * @param origPremAmt the origPremAmt to set
	 */
	public void setOrigPremAmt(BigDecimal origPremAmt) {
		this.origPremAmt = origPremAmt;
	}
	/**
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}
	/**
	 * @param remarks the remarks to set
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	/**
	 * @return the refAcceptNo
	 */
	public String getRefAcceptNo() {
		return refAcceptNo;
	}
	/**
	 * @param refAcceptNo the refAcceptNo to set
	 */
	public void setRefAcceptNo(String refAcceptNo) {
		this.refAcceptNo = refAcceptNo;
	}
	
	
}
