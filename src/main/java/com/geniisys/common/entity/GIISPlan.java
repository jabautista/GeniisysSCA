package com.geniisys.common.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIISPlan extends BaseEntity{
	
	private String planCd;
	private String planDesc;
	private String lineCd;
	private String sublineCd;
	private String remarks;
	
	public String getPlanCd() {
		return planCd;
	}
	public void setPlanCd(String planCd) {
		this.planCd = planCd;
	}
	public String getPlanDesc() {
		return planDesc;
	}
	public void setPlanDesc(String planDesc) {
		this.planDesc = planDesc;
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
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
}
