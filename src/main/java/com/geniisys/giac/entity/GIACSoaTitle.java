package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACSoaTitle extends BaseEntity{
	
	private String repCd;
	private String colNo;
	private String colTitle;
	private String remarks;
	
	public GIACSoaTitle(){
		
	}
	public GIACSoaTitle(String repCd, String colNo, String colTitle, String remarks) {
		super();
		this.repCd = repCd;
		this.colNo = colNo;
		this.colTitle = colTitle;
		this.remarks = remarks;
	}
	
	public String getRepCd() {
		return repCd;
	}

	public void setRepCd(String repCd) {
		this.repCd = repCd;
	}

	public String getColNo() {
		return colNo;
	}

	public void setColNo(String colNo) {
		this.colNo = colNo;
	}

	public String getColTitle() {
		return colTitle;
	}

	public void setColTitle(String colTitle) {
		this.colTitle = colTitle;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

}
