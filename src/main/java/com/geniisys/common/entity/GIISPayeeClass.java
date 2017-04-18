package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

//import com.geniisys.framework.util.BaseEntity;

public class GIISPayeeClass extends BaseEntity{

	private String payeeClassCd;
	private String classDesc;
	/* Gzelle 11.25.2013
	 * For Payee Class Maintenance GICLS140
	 */
	private String evalSw;
	private String loaSw;
	private String payeeClassTag;
	private String dspPcTagDesc;
	private String masterPayeeClassCd;
	private String slTypeTag;
	private String slTypeCd;
	private Integer clmVatCd;
	private String remarks;
	
	public String getPayeeClassCd() {
		return payeeClassCd;
	}
	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
	}
	public String getClassDesc() {
		return classDesc;
	}
	public void setClassDesc(String classDesc) {
		this.classDesc = classDesc;
	}
	public String getEvalSw() {
		return evalSw;
	}
	public void setEvalSw(String evalSw) {
		this.evalSw = evalSw;
	}
	public String getLoaSw() {
		return loaSw;
	}
	public void setLoaSw(String loaSw) {
		this.loaSw = loaSw;
	}
	public String getPayeeClassTag() {
		return payeeClassTag;
	}
	public void setPayeeClassTag(String payeeClassTag) {
		this.payeeClassTag = payeeClassTag;
	}
	public String getDspPcTagDesc() {
		return dspPcTagDesc;
	}
	public void setDspPcTagDesc(String dspPcTagDesc) {
		this.dspPcTagDesc = dspPcTagDesc;
	}
	public String getMasterPayeeClassCd() {
		return masterPayeeClassCd;
	}
	public void setMasterPayeeClassCd(String masterPayeeClassCd) {
		this.masterPayeeClassCd = masterPayeeClassCd;
	}
	public String getSlTypeTag() {
		return slTypeTag;
	}
	public void setSlTypeTag(String slTypeTag) {
		this.slTypeTag = slTypeTag;
	}
	public String getSlTypeCd() {
		return slTypeCd;
	}
	public void setSlTypeCd(String slTypeCd) {
		this.slTypeCd = slTypeCd;
	}
	public Integer getClmVatCd() {
		return clmVatCd;
	}
	public void setClmVatCd(Integer clmVatCd) {
		this.clmVatCd = clmVatCd;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	
}
