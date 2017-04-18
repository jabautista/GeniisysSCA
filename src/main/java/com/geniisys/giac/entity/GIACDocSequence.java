package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACDocSequence extends BaseEntity{ 
	
	private String fundCd;
	private String branchCd;
	private String docName;
	private String docPrefSuf;
	private String docSeqNo;
	private String approvedSeries;
	private String remarks;
	
	public String getDocName() {
		return docName;
	}
	public void setDocName(String docName) {
		this.docName = docName;
	}
	public String getDocPrefSuf() {
		return docPrefSuf;
	}
	public void setDocPrefSuf(String docPrefSuf) {
		this.docPrefSuf = docPrefSuf;
	}
	public String getDocSeqNo() {
		return docSeqNo;
	}
	public void setDocSeqNo(String docSeqNo) {
		this.docSeqNo = docSeqNo;
	}
	public String getApprovedSeries() {
		return approvedSeries;
	}
	public void setApprovedSeries(String approvedSeries) {
		this.approvedSeries = approvedSeries;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getFundCd() {
		return fundCd;
	}
	public void setFundCd(String fundCd) {
		this.fundCd = fundCd;
	}
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	
	public GIACDocSequence() {
		
	}
	public GIACDocSequence(String fundCd, String branchCd, String docName,
			String docPrefSuf, String docSeqNo, String approvedSeries,
			String remarks) {
		super();
		this.fundCd = fundCd;
		this.branchCd = branchCd;
		this.docName = docName;
		this.docPrefSuf = docPrefSuf;
		this.docSeqNo = docSeqNo;
		this.approvedSeries = approvedSeries;
		this.remarks = remarks;
	}
	
}
