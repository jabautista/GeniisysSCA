package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACPaytReqDocs extends BaseEntity{
	
	private String gibrGfunFundCd;
	private String gibrBranchCd;
	private String documentCd;
	private String documentName;
	private String lineCdTag;
	private String yyTag;
	private String mmTag;
	private String purchaseTag;
	private Integer docId;
	private String remarks;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	
	public String getGibrGfunFundCd() {
		return gibrGfunFundCd;
	}
	public void setGibrGfunFundCd(String gibrGfunFundCd) {
		this.gibrGfunFundCd = gibrGfunFundCd;
	}
	public String getGibrBranchCd() {
		return gibrBranchCd;
	}
	public void setGibrBranchCd(String gibrBranchCd) {
		this.gibrBranchCd = gibrBranchCd;
	}
	public String getDocumentCd() {
		return documentCd;
	}
	public void setDocumentCd(String documentCd) {
		this.documentCd = documentCd;
	}
	public String getDocumentName() {
		return documentName;
	}
	public void setDocumentName(String documentName) {
		this.documentName = documentName;
	}
	public String getLineCdTag() {
		return lineCdTag;
	}
	public void setLineCdTag(String lineCdTag) {
		this.lineCdTag = lineCdTag;
	}
	public String getYyTag() {
		return yyTag;
	}
	public void setYyTag(String yyTag) {
		this.yyTag = yyTag;
	}
	public String getMmTag() {
		return mmTag;
	}
	public void setMmTag(String mmTag) {
		this.mmTag = mmTag;
	}
	public Integer getDocId() {
		return docId;
	}
	public void setDocId(Integer docId) {
		this.docId = docId;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	public String getPurchaseTag() {
		return purchaseTag;
	}
	public void setPurchaseTag(String purchaseTag) {
		this.purchaseTag = purchaseTag;
	}
	
}
