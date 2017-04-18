package com.geniisys.giis.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISRequiredDoc extends BaseEntity {
	private String lineCd;
	private String sublineCd;
	private String docCd;
	private String docName;
	private String validFlag;
	private String effectivityDate;
	private String remarks;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	
	public GIISRequiredDoc(){
		super();
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

	public String getDocCd() {
		return docCd;
	}

	public void setDocCd(String docCd) {
		this.docCd = docCd;
	}

	public String getDocName() {
		return docName;
	}

	public void setDocName(String docName) {
		this.docName = docName;
	}

	public String getValidFlag() {
		return validFlag;
	}

	public void setValidFlag(String validFlag) {
		this.validFlag = validFlag;
	}

	public String getEffectivityDate() {
		return effectivityDate;
	}

	public void setEffectivityDate(String effectivityDate) {
		this.effectivityDate = effectivityDate;
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
}
