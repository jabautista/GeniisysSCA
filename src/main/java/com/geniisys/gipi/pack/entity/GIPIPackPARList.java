package com.geniisys.gipi.pack.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIPIPackPARList extends BaseEntity{

	private Integer packParId;
	private String lineCd;
	private String lineName;
	private	String issCd;
	private Integer parYy;
	private Integer parSeqNo;
	private Integer quoteSeqNo;
	private Integer assdNo;
	private String assdName;
	private int parStatus;
	private String remarks;
	private String underwriter;
	private String assignSw;
	private String parType;
	private Integer quoteId;
	private String parNo;
	private String status;
	private String bankRefNo;
	private Integer parId; // added to avoid error on jsp
	private String address1;
	private String address2;
	private String address3;
	
	 // added by emman 11.22.2010
	/** The pol flag */
	private String sublineCd;
	private Integer issueYy;
	private Integer polSeqNo;
	private Integer renewNo;	
	
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
	public Integer getRenewNo() {
		return renewNo;
	}
	public void setRenewNo(Integer renewNo) {
		this.renewNo = renewNo;
	}
	public Integer getPackParId() {
		return packParId;
	}
	public void setPackParId(Integer packParId) {
		this.packParId = packParId;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public void setLineName(String lineName) {
		this.lineName = lineName;
	}
	public String getLineName() {
		return lineName;
	}
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public Integer getParYy() {
		return parYy;
	}
	public void setParYy(Integer parYy) {
		this.parYy = parYy;
	}
	public Integer getParSeqNo() {
		return parSeqNo;
	}
	public void setParSeqNo(Integer parSeqNo) {
		this.parSeqNo = parSeqNo;
	}
	public Integer getQuoteSeqNo() {
		return quoteSeqNo;
	}
	public void setQuoteSeqNo(Integer quoteSeqNo) {
		this.quoteSeqNo = quoteSeqNo;
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
	public int getParStatus() {
		return parStatus;
	}
	public void setParStatus(int parStatus) {
		this.parStatus = parStatus;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getUnderwriter() {
		return underwriter;
	}
	public void setUnderwriter(String underwriter) {
		this.underwriter = underwriter;
	}
	public String getAssignSw() {
		return assignSw;
	}
	public void setAssignSw(String assignSw) {
		this.assignSw = assignSw;
	}
	public void setParType(String parType) {
		this.parType = parType;
	}
	public String getParType() {
		return parType;
	}
	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}
	public Integer getQuoteId() {
		return quoteId;
	}
	public String getParNo() {
		return parNo;
	}
	public void setParNo(String parNo) {
		this.parNo = parNo;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getBankRefNo() {
		return bankRefNo;
	}
	public void setBankRefNo(String bankRefNo) {
		this.bankRefNo = bankRefNo;
	}
	public Integer getParId() {
		return parId;
	}
	public void setParId(Integer parId) {
		this.parId = parId;
	}
	public String getAddress1() {
		return address1;
	}
	public void setAddress1(String address1) {
		this.address1 = address1;
	}
	public String getAddress2() {
		return address2;
	}
	public void setAddress2(String address2) {
		this.address2 = address2;
	}
	public String getAddress3() {
		return address3;
	}
	public void setAddress3(String address3) {
		this.address3 = address3;
	}
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	public String getSublineCd() {
		return sublineCd;
	}	
}
