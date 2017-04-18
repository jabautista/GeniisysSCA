package com.geniisys.gixx.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIXXOpenPeril extends BaseEntity {

	private Integer extractId;
	private Integer geogCd;
	private String lineCd;
	private Integer perilCd;
	private Float premRate;
	private String recFlag;
	private String remarks;
	private String withInvoiceTag;
	private Integer policyId;
	private String perilName;
	private String perilType;
	
	
	public Integer getExtractId() {
		return extractId;
	}
	public void setExtractId(Integer extractId) {
		this.extractId = extractId;
	}
	public Integer getGeogCd() {
		return geogCd;
	}
	public void setGeogCd(Integer geogCd) {
		this.geogCd = geogCd;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public Integer getPerilCd() {
		return perilCd;
	}
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	public Float getPremRate() {
		return premRate;
	}
	public void setPremRate(Float premRate) {
		this.premRate = premRate;
	}
	public String getRecFlag() {
		return recFlag;
	}
	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getWithInvoiceTag() {
		return withInvoiceTag;
	}
	public void setWithInvoiceTag(String withInvoiceTag) {
		this.withInvoiceTag = withInvoiceTag;
	}
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public String getPerilName() {
		return perilName;
	}
	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}
	public String getPerilType() {
		return perilType;
	}
	public void setPerilType(String perilType) {
		this.perilType = perilType;
	}
	
	
}
