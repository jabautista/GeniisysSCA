package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISPerilGroupDtl extends BaseEntity {
	
	private String lineCd;
	private Integer perilGrpCd;
	private String perilGrpDesc;
	private Integer perilCd;
	private String perilName;
	private String remarks;

	public GIISPerilGroupDtl() {

	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public Integer getPerilGrpCd() {
		return perilGrpCd;
	}

	public void setPerilGrpCd(Integer perilGrpCd) {
		this.perilGrpCd = perilGrpCd;
	}

	public String getPerilGrpDesc() {
		return perilGrpDesc;
	}

	public void setPerilGrpDesc(String perilGrpDesc) {
		this.perilGrpDesc = perilGrpDesc;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public Integer getPerilCd() {
		return perilCd;
	}

	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}

	public String getPerilName() {
		return perilName;
	}

	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}
}
