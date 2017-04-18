package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISRiTypeDocs extends BaseEntity{
	
	private String riType;
	private String docCd;
	private String docName;
	private String remarks;
	
	public GIISRiTypeDocs(){
		
	}

	public GIISRiTypeDocs(String riType, String docCd, String docName, String remarks) {
		super();
		this.riType = riType;
		this.docCd = docCd;
		this.docName = docName;
		this.remarks = remarks;
	}

	public String getRiType() {
		return riType;
	}
	public void setRiType(String riType) {
		this.riType = riType;
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
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
}
