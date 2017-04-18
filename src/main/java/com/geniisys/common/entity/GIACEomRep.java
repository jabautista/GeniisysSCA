package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACEomRep extends BaseEntity{
	
	private String repCd;
	private String repTitle;
	private String remarks;
	
	public GIACEomRep(){
		
	}
	
	public String getRepCd() {
		return repCd;
	}
	
	public void setRepCd(String repCd) {
		this.repCd = repCd;
	}
	
	public String getRepTitle() {
		return repTitle;
	}
	
	public void setRepTitle(String repTitle) {
		this.repTitle = repTitle;
	}
	
	public String getRemarks() {
		return remarks;
	}
	
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
}
