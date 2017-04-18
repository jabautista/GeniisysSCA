package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACDocSequenceUser extends BaseEntity {

	private String docCode;
	private String branchCd;
	private Integer userCd;
	private String userName;
	private String docPref;
	private String oldDocPref;
	/*private Integer minSeqNo;
	private Integer oldMinSeqNo;
	private Integer maxSeqNo;
	private Integer oldMaxSeqNo;*/
	private String minSeqNo;
	private String oldMinSeqNo;
	private String maxSeqNo;
	private String oldMaxSeqNo;
	private String activeTag;
	private String oldActiveTag;
	private String remarks;
	
	public String getDocCode() {
		return docCode;
	}
	public void setDocCode(String docCode) {
		this.docCode = docCode;
	}
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	public Integer getUserCd() {
		return userCd;
	}
	public void setUserCd(Integer userCd) {
		this.userCd = userCd;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getDocPref() {
		return docPref;
	}
	public void setDocPref(String docPref) {
		this.docPref = docPref;
	}
	public String getOldDocPref() {
		return oldDocPref;
	}
	public void setOldDocPref(String oldDocPref) {
		this.oldDocPref = oldDocPref;
	}
	public String getMinSeqNo() {
		return minSeqNo;
	}
	public void setMinSeqNo(String minSeqNo) {
		this.minSeqNo = minSeqNo;
	}
	public String getOldMinSeqNo() {
		return oldMinSeqNo;
	}
	public void setOldMinSeqNo(String oldMinSeqNo) {
		this.oldMinSeqNo = oldMinSeqNo;
	}
	public String getMaxSeqNo() {
		return maxSeqNo;
	}
	public void setMaxSeqNo(String maxSeqNo) {
		this.maxSeqNo = maxSeqNo;
	}
	public String getOldMaxSeqNo() {
		return oldMaxSeqNo;
	}
	public void setOldMaxSeqNo(String oldMaxSeqNo) {
		this.oldMaxSeqNo = oldMaxSeqNo;
	}
	public String getActiveTag() {
		return activeTag;
	}
	public void setActiveTag(String activeTag) {
		this.activeTag = activeTag;
	}
	public String getOldActiveTag() {
		return oldActiveTag;
	}
	public void setOldActiveTag(String oldActiveTag) {
		this.oldActiveTag = oldActiveTag;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	
}
