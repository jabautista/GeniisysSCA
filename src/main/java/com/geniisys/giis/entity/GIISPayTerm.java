package com.geniisys.giis.entity;

public class GIISPayTerm extends BaseEntity {
	private String paytTerms;
	private String paytTermsDesc;
	private Integer noOfPayt;
	private String onInceptTag;
	private Integer noOfDays;
	private String annualSw;
	private Integer noPaytDays;
	private String remarks;

	public GIISPayTerm() {
		super();
	}

	public GIISPayTerm(String paytTerms, String paytTermsDesc,
			Integer noOfPayt, String onInceptTag, Integer noOfDays,
			String annualSw, Integer noPaytDays, String remarks) {
		super();
		this.paytTerms = paytTerms;
		this.paytTermsDesc = paytTermsDesc;
		this.noOfPayt = noOfPayt;
		this.onInceptTag = onInceptTag;
		this.noOfDays = noOfDays;
		this.annualSw = annualSw;
		this.noPaytDays = noPaytDays;
		this.remarks = remarks;
	}

	public String getPaytTerms() {
		return paytTerms;
	}

	public void setPaytTerms(String paytTerms) {
		this.paytTerms = paytTerms;
	}

	public String getPaytTermsDesc() {
		return paytTermsDesc;
	}

	public void setPaytTermsDesc(String paytTermsDesc) {
		this.paytTermsDesc = paytTermsDesc;
	}

	public Integer getNoOfPayt() {
		return noOfPayt;
	}

	public void setNoOfPayt(Integer noOfPayt) {
		this.noOfPayt = noOfPayt;
	}

	public String getOnInceptTag() {
		return onInceptTag;
	}

	public void setOnInceptTag(String onInceptTag) {
		this.onInceptTag = onInceptTag;
	}

	public Integer getNoOfDays() {
		return noOfDays;
	}

	public void setNoOfDays(Integer noOfDays) {
		this.noOfDays = noOfDays;
	}

	public String getAnnualSw() {
		return annualSw;
	}

	public void setAnnualSw(String annualSw) {
		this.annualSw = annualSw;
	}

	public Integer getNoPaytDays() {
		return noPaytDays;
	}

	public void setNoPaytDays(Integer noPaytDays) {
		this.noPaytDays = noPaytDays;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

}
