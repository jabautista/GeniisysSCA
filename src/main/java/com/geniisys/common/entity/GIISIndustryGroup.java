package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISIndustryGroup extends BaseEntity{
	private Integer indGrpCd;
	private String indGrpNm;
	private String remarks;
	
	public GIISIndustryGroup(){
		
	}

	public Integer getIndGrpCd() {
		return indGrpCd;
	}

	public void setIndGrpCd(Integer indGrpCd) {
		this.indGrpCd = indGrpCd;
	}

	public String getIndGrpNm() {
		return indGrpNm;
	}

	public void setIndGrpNm(String indGrpNm) {
		this.indGrpNm = indGrpNm;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
}
