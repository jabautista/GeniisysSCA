package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISInspector extends BaseEntity{
	
	private Integer inspCd;
	private String inspName;
	private String remarks;
	
	public GIISInspector() {
		
	}

	public GIISInspector(Integer inspCd, String inspName, String remarks) {
		super();
		this.inspCd = inspCd;
		this.inspName = inspName;
		this.remarks = remarks;
	}

	public Integer getInspCd() {
		return inspCd;
	}

	public void setInspCd(Integer inspCd) {
		this.inspCd = inspCd;
	}

	public String getInspName() {
		return inspName;
	}

	public void setInspName(String inspName) {
		this.inspName = inspName;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
}
