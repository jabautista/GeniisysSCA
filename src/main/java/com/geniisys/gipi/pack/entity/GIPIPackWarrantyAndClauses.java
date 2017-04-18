package com.geniisys.gipi.pack.entity;

import java.util.List;

import com.geniisys.framework.util.BaseEntity;
import com.geniisys.gipi.entity.GIPIWPolicyWarrantyAndClause;

public class GIPIPackWarrantyAndClauses extends BaseEntity{
	
	private Integer parId;
	
	private String lineCd;
	
	private String lineName;
	
	private String issCd;
	
	private Integer parYy;
	
	private Integer issueYy;
	
	private Integer parSeqNo;
	
	private Integer quoteSeqNo;
	
	private String remarks;
	
	private String sublineCd;
	
	private String sublineName;
	
	private String parNo;
	
	private Integer polSeqNo;
	
	private String policyNo;
	
	private List<GIPIWPolicyWarrantyAndClause> gipiWarrantyAndClauses;

	public Integer getParId() {
		return parId;
	}

	public void setParId(Integer parId) {
		this.parId = parId;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getLineName() {
		return lineName;
	}

	public void setLineName(String lineName) {
		this.lineName = lineName;
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

	public void setIssueYy(Integer issueYy) {
		this.issueYy = issueYy;
	}

	public Integer getIssueYy() {
		return issueYy;
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

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getSublineCd() {
		return sublineCd;
	}

	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	public String getSublineName() {
		return sublineName;
	}

	public void setSublineName(String sublineName) {
		this.sublineName = sublineName;
	}

	public String getParNo() {
		return parNo;
	}

	public void setParNo(String parNo) {
		this.parNo = parNo;
	}

	public void setPolSeqNo(Integer polSeqNo) {
		this.polSeqNo = polSeqNo;
	}

	public Integer getPolSeqNo() {
		return polSeqNo;
	}


	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}

	public String getPolicyNo() {
		return policyNo;
	}

	public void setGipiWarrantyAndClauses(List<GIPIWPolicyWarrantyAndClause> gipiWarrantyAndClauses) {
		this.gipiWarrantyAndClauses = gipiWarrantyAndClauses;
	}

	public List<GIPIWPolicyWarrantyAndClause> getGipiWarrantyAndClauses() {
		return gipiWarrantyAndClauses;
	}

	
}
