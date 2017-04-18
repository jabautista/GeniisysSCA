package com.geniisys.gipi.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIPolbasicPolDistV1 extends BaseEntity {
	
	private Integer policyId;
	private String lineCd;
	private String sublineCd;
	private String issCd;
	private Integer issueYy;
	private Integer polSeqNo;
	private String endtIssCd;
	private Integer endtYy;
	private Integer endtSeqNo;
	private Integer renewNo;
	private Integer parId;
	private String polFlag;
	private Integer assdNo;
	private String assdName;
	private Date acctEntDate;
	private String spldFlag;
	private String packPolFlag;
	private String distFlag;
	private Integer distNo;
	private Date effDate;
	private Date expiryDate;
	private Date negateDate;
	private String distType;
	private Date acctNegDate;
	private String parType;
	private String meanDistFlag;
	private String policyNo;
	private String endtNo;
	private Integer batchId;
	private String multiBookingMm;
	private String multiBookingYy;
	private String msgAlert;
	
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
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
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public Integer getIssueYy() {
		return issueYy;
	}
	public void setIssueYy(Integer issueYy) {
		this.issueYy = issueYy;
	}
	public Integer getPolSeqNo() {
		return polSeqNo;
	}
	public void setPolSeqNo(Integer polSeqNo) {
		this.polSeqNo = polSeqNo;
	}
	public String getEndtIssCd() {
		return endtIssCd;
	}
	public void setEndtIssCd(String endtIssCd) {
		this.endtIssCd = endtIssCd;
	}
	public Integer getEndtYy() {
		return endtYy;
	}
	public void setEndtYy(Integer endtYy) {
		this.endtYy = endtYy;
	}
	public Integer getEndtSeqNo() {
		return endtSeqNo;
	}
	public void setEndtSeqNo(Integer endtSeqNo) {
		this.endtSeqNo = endtSeqNo;
	}
	public Integer getRenewNo() {
		return renewNo;
	}
	public void setRenewNo(Integer renewNo) {
		this.renewNo = renewNo;
	}
	public Integer getParId() {
		return parId;
	}
	public void setParId(Integer parId) {
		this.parId = parId;
	}
	public String getPolFlag() {
		return polFlag;
	}
	public void setPolFlag(String polFlag) {
		this.polFlag = polFlag;
	}
	public Integer getAssdNo() {
		return assdNo;
	}
	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}
	public String getAssdName() {
		return assdName;
	}
	public void setAssdName(String assdName) {
		this.assdName = assdName;
	}
	public Date getAcctEntDate() {
		return acctEntDate;
	}
	public void setAcctEntDate(Date acctEntDate) {
		this.acctEntDate = acctEntDate;
	}
	public String getSpldFlag() {
		return spldFlag;
	}
	public void setSpldFlag(String spldFlag) {
		this.spldFlag = spldFlag;
	}
	public String getPackPolFlag() {
		return packPolFlag;
	}
	public void setPackPolFlag(String packPolFlag) {
		this.packPolFlag = packPolFlag;
	}
	public String getDistFlag() {
		return distFlag;
	}
	public void setDistFlag(String distFlag) {
		this.distFlag = distFlag;
	}
	public Integer getDistNo() {
		return distNo;
	}
	public void setDistNo(Integer distNo) {
		this.distNo = distNo;
	}
	public Date getEffDate() {
		return effDate;
	}
	public void setEffDate(Date effDate) {
		this.effDate = effDate;
	}
	public Date getExpiryDate() {
		return expiryDate;
	}
	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}
	public Date getNegateDate() {
		return negateDate;
	}
	public void setNegateDate(Date negateDate) {
		this.negateDate = negateDate;
	}
	public String getDistType() {
		return distType;
	}
	public void setDistType(String distType) {
		this.distType = distType;
	}
	public void setAcctNegDate(Date acctNegDate) {
		this.acctNegDate = acctNegDate;
	}
	public Date getAcctNegDate() {
		return acctNegDate;
	}
	public String getParType() {
		return parType;
	}
	public void setParType(String parType) {
		this.parType = parType;
	}
	public String getMeanDistFlag() {
		return meanDistFlag;
	}
	public void setMeanDistFlag(String meanDistFlag) {
		this.meanDistFlag = meanDistFlag;
	}
	public String getPolicyNo() {
		return policyNo;
	}
	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}
	public String getEndtNo() {
		return endtNo;
	}
	public void setEndtNo(String endtNo) {
		this.endtNo = endtNo;
	}
	/**
	 * @return the batchId
	 */
	public Integer getBatchId() {
		return batchId;
	}
	/**
	 * @param batchId the batchId to set
	 */
	public void setBatchId(Integer batchId) {
		this.batchId = batchId;
	}
	public String getMultiBookingMm() {
		return multiBookingMm;
	}
	public void setMultiBookingMm(String multiBookingMm) {
		this.multiBookingMm = multiBookingMm;
	}
	public String getMultiBookingYy() {
		return multiBookingYy;
	}
	public void setMultiBookingYy(String multiBookingYy) {
		this.multiBookingYy = multiBookingYy;
	}
	public String getMsgAlert() {
		return msgAlert;
	}
	public void setMsgAlert(String msgAlert) {
		this.msgAlert = msgAlert;
	}
	
}
