package com.geniisys.giac.entity;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.giis.entity.BaseEntity;

/**
 * @author steven
 * @date 03.18.2013
 */
public class GIACJournalEntry extends BaseEntity{
	
	private String fundCd;
	
	private Integer tranId;	
	
	private String branchCd;
	
	private Integer tranYy;	
	
	private Integer tranMm;	
	
	private Integer tranSeqNo;	
	
	private Date tranDate;	
	
	private String tranFlag;
	
	private String jvTranTag;
	
	private String tranClass;	
	
	private Integer tranClassNo;
	
	private Integer jvNo;	
	
	private String particulars;	
	
	private String userId;	
	
	private Date journalLastUpdate;	
	
	private String remarks;		
	
	private String jvTranType;	
	
	private String jvTranDesc;	
	
	private Integer jvTranMm;	
	
	private Integer jvTranYy;
	
	private String refJvNo;
	
	private String jvPrefSuff;	
	
	private String createBy;
	
	private String aeTag;		
	
	private String sapIncTag;
	
	private String uploadTag;	
	
	private String meanTranFlag;
	
	private String meanTranClass;
	
	private String branchName;
	
	private String fundDesc;
	
	private String gracDacCd;
	
	@SuppressWarnings("unused")
	private String strJournalLastUpdate;
	
	@SuppressWarnings("unused")
	private String strTrandate;
	
	

	/**
	 * @return the fundCd
	 */
	public String getFundCd() {
		return fundCd;
	}

	/**
	 * @param fundCd the fundCd to set
	 */
	public void setFundCd(String fundCd) {
		this.fundCd = fundCd;
	}

	/**
	 * @return the tranId
	 */
	public Integer getTranId() {
		return tranId;
	}

	/**
	 * @param tranId the tranId to set
	 */
	public void setTranId(Integer tranId) {
		this.tranId = tranId;
	}

	/**
	 * @return the branchCd
	 */
	public String getBranchCd() {
		return branchCd;
	}

	/**
	 * @param branchCd the branchCd to set
	 */
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}

	/**
	 * @return the tranYy
	 */
	public Integer getTranYy() {
		return tranYy;
	}

	/**
	 * @param tranYy the tranYy to set
	 */
	public void setTranYy(Integer tranYy) {
		this.tranYy = tranYy;
	}

	/**
	 * @return the tranMm
	 */
	public Integer getTranMm() {
		return tranMm;
	}

	/**
	 * @param tranMm the tranMm to set
	 */
	public void setTranMm(Integer tranMm) {
		this.tranMm = tranMm;
	}

	/**
	 * @return the tranSeqNo
	 */
	public Integer getTranSeqNo() {
		return tranSeqNo;
	}

	/**
	 * @param tranSeqNo the tranSeqNo to set
	 */
	public void setTranSeqNo(Integer tranSeqNo) {
		this.tranSeqNo = tranSeqNo;
	}

	/**
	 * @return the tranDate
	 */
	public Date getTranDate() {
		return tranDate;
	}

	/**
	 * @param tranDate the tranDate to set
	 */
	public void setTranDate(Date tranDate) {
		this.tranDate = tranDate;
	}

	/**
	 * @return the tranFlag
	 */
	public String getTranFlag() {
		return tranFlag;
	}

	/**
	 * @param tranFlag the tranFlag to set
	 */
	public void setTranFlag(String tranFlag) {
		this.tranFlag = tranFlag;
	}

	/**
	 * @return the jvTranTag
	 */
	public String getJvTranTag() {
		return jvTranTag;
	}

	/**
	 * @param jvTranTag the jvTranTag to set
	 */
	public void setJvTranTag(String jvTranTag) {
		this.jvTranTag = jvTranTag;
	}

	/**
	 * @return the tranClass
	 */
	public String getTranClass() {
		return tranClass;
	}

	/**
	 * @param tranClass the tranClass to set
	 */
	public void setTranClass(String tranClass) {
		this.tranClass = tranClass;
	}

	/**
	 * @return the tranClassNo
	 */
	public Integer getTranClassNo() {
		return tranClassNo;
	}

	/**
	 * @param tranClassNo the tranClassNo to set
	 */
	public void setTranClassNo(Integer tranClassNo) {
		this.tranClassNo = tranClassNo;
	}

	/**
	 * @return the jvNo
	 */
	public Integer getJvNo() {
		return jvNo;
	}

	/**
	 * @param jvNo the jvNo to set
	 */
	public void setJvNo(Integer jvNo) {
		this.jvNo = jvNo;
	}

	/**
	 * @return the particulars
	 */
	public String getParticulars() {
		return particulars;
	}

	/**
	 * @param particulars the particulars to set
	 */
	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}

	/**
	 * @return the userId
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * @param userId the userId to set
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}

	/**
	 * @return the journalLastUpdate
	 */
	public Date getJournalLastUpdate() {
		return journalLastUpdate;
	}

	/**
	 * @param journalLastUpdate the journalLastUpdate to set
	 */
	public void setJournalLastUpdate(Date journalLastUpdate) {
		this.journalLastUpdate = journalLastUpdate;
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
	 * @return the jvTranType
	 */
	public String getJvTranType() {
		return jvTranType;
	}

	/**
	 * @param jvTranType the jvTranType to set
	 */
	public void setJvTranType(String jvTranType) {
		this.jvTranType = jvTranType;
	}

	/**
	 * @return the jvTranDesc
	 */
	public String getJvTranDesc() {
		return jvTranDesc;
	}

	/**
	 * @param jvTranDesc the jvTranDesc to set
	 */
	public void setJvTranDesc(String jvTranDesc) {
		this.jvTranDesc = jvTranDesc;
	}

	/**
	 * @return the jvTranMm
	 */
	public Integer getJvTranMm() {
		return jvTranMm;
	}

	/**
	 * @param jvTranMm the jvTranMm to set
	 */
	public void setJvTranMm(Integer jvTranMm) {
		this.jvTranMm = jvTranMm;
	}

	/**
	 * @return the jvTranYy
	 */
	public Integer getJvTranYy() {
		return jvTranYy;
	}

	/**
	 * @param jvTranYy the jvTranYy to set
	 */
	public void setJvTranYy(Integer jvTranYy) {
		this.jvTranYy = jvTranYy;
	}

	/**
	 * @return the jvPrefSuff
	 */
	public String getJvPrefSuff() {
		return jvPrefSuff;
	}

	/**
	 * @param jvPrefSuff the jvPrefSuff to set
	 */
	public void setJvPrefSuff(String jvPrefSuff) {
		this.jvPrefSuff = jvPrefSuff;
	}

	/**
	 * @return the createBy
	 */
	public String getCreateBy() {
		return createBy;
	}

	/**
	 * @param createBy the createBy to set
	 */
	public void setCreateBy(String createBy) {
		this.createBy = createBy;
	}

	/**
	 * @return the aeTag
	 */
	public String getAeTag() {
		return aeTag;
	}

	/**
	 * @param aeTag the aeTag to set
	 */
	public void setAeTag(String aeTag) {
		this.aeTag = aeTag;
	}

	/**
	 * @return the sapIncTag
	 */
	public String getSapIncTag() {
		return sapIncTag;
	}

	/**
	 * @param sapIncTag the sapIncTag to set
	 */
	public void setSapIncTag(String sapIncTag) {
		this.sapIncTag = sapIncTag;
	}

	/**
	 * @return the uploadTag
	 */
	public String getUploadTag() {
		return uploadTag;
	}

	/**
	 * @param uploadTag the uploadTag to set
	 */
	public void setUploadTag(String uploadTag) {
		this.uploadTag = uploadTag;
	}

	/**
	 * @return the meanTranFlag
	 */
	public String getMeanTranFlag() {
		return meanTranFlag;
	}

	/**
	 * @param meanTranFlag the meanTranFlag to set
	 */
	public void setMeanTranFlag(String meanTranFlag) {
		this.meanTranFlag = meanTranFlag;
	}

	/**
	 * @return the meanTranClass
	 */
	public String getMeanTranClass() {
		return meanTranClass;
	}

	/**
	 * @param meanTranClass the meanTranClass to set
	 */
	public void setMeanTranClass(String meanTranClass) {
		this.meanTranClass = meanTranClass;
	}

	/**
	 * @return the branchName
	 */
	public String getBranchName() {
		return branchName;
	}

	/**
	 * @param branchName the branchName to set
	 */
	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}

	/**
	 * @return the fundDesc
	 */
	public String getFundDesc() {
		return fundDesc;
	}

	/**
	 * @param fundDesc the fundDesc to set
	 */
	public void setFundDesc(String fundDesc) {
		this.fundDesc = fundDesc;
	}

	/**
	 * @return the gracDacCd
	 */
	public String getGracDacCd() {
		return gracDacCd;
	}

	/**
	 * @param gracDacCd the gracDacCd to set
	 */
	public void setGracDacCd(String gracDacCd) {
		this.gracDacCd = gracDacCd;
	}

	/**
	 * @return the refJvNo
	 */
	public String getRefJvNo() {
		return refJvNo;
	}

	/**
	 * @param refJvNo the refJvNo to set
	 */
	public void setRefJvNo(String refJvNo) {
		this.refJvNo = refJvNo;
	}

	/**
	 * @return the strJournalLastUpdate
	 */
	public String getStrJournalLastUpdate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (this.journalLastUpdate != null) {
			return sdf.format(journalLastUpdate);
		} else {
			return null;
		}
	}

	/**
	 * @param strJournalLastUpdate the strJournalLastUpdate to set
	 */
	public void setStrJournalLastUpdate(String strJournalLastUpdate) {
		this.strJournalLastUpdate = strJournalLastUpdate;
	}

	/**
	 * @return the strTrandate
	 */
	public String getStrTrandate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if (this.tranDate != null) {
			return sdf.format(tranDate);
		} else {
			return null;
		}
	}

	/**
	 * @param strTrandate the strTrandate to set
	 */
	public void setStrTrandate(String strTrandate) {
		this.strTrandate = strTrandate;
	}
	
	
}
