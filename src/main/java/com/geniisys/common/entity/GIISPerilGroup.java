package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISPerilGroup extends BaseEntity {

	private String lineCd;
	private Integer perilGrpCd;
	private String perilGrpDesc;
	private String remarks;

	public GIISPerilGroup() {

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

}
