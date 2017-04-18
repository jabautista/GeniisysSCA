package com.geniisys.giis.entity;

public class GIISMortgagee extends BaseEntity {
	
	private String issCd;
	private String issName;
	private String mortgCd;
	private String mortgName;
	private String mailAddr1;
	private String mailAddr2;
	private String mailAddr3;
	private String designation;
	private String tin;
	private String contactPers;
	private String remarks;
	private Integer mortgageeId;
	
	public GIISMortgagee(){
		super();
	}

	public GIISMortgagee(String issCd, String issName, String mortgCd, String mortgName,
			String mailAddr1, String mailAddr2, String mailAddr3,
			String designation, String tin, String contactPers, String remarks, Integer mortgageeId) {
		super();
		this.issCd = issCd;
		this.issName = issName;
		this.mortgCd = mortgCd;
		this.mortgName = mortgName;
		this.mailAddr1 = mailAddr1;
		this.mailAddr2 = mailAddr2;
		this.mailAddr3 = mailAddr3;
		this.designation = designation;
		this.tin = tin;
		this.contactPers = contactPers;
		this.remarks = remarks;
		this.mortgageeId = mortgageeId;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public String getIssName() {
		return issName;
	}

	public void setIssName(String issName) {
		this.issName = issName;
	}

	public String getMortgCd() {
		return mortgCd;
	}

	public void setMortgCd(String mortgCd) {
		this.mortgCd = mortgCd;
	}

	public String getMortgName() {
		return mortgName;
	}

	public void setMortgName(String mortgName) {
		this.mortgName = mortgName;
	}

	public String getMailAddr1() {
		return mailAddr1;
	}

	public void setMailAddr1(String mailAddr1) {
		this.mailAddr1 = mailAddr1;
	}

	public String getMailAddr2() {
		return mailAddr2;
	}

	public void setMailAddr2(String mailAddr2) {
		this.mailAddr2 = mailAddr2;
	}

	public String getMailAddr3() {
		return mailAddr3;
	}

	public void setMailAddr3(String mailAddr3) {
		this.mailAddr3 = mailAddr3;
	}

	public String getDesignation() {
		return designation;
	}

	public void setDesignation(String designation) {
		this.designation = designation;
	}

	public String getTin() {
		return tin;
	}

	public void setTin(String tin) {
		this.tin = tin;
	}

	public String getContactPers() {
		return contactPers;
	}

	public void setContactPers(String contactPers) {
		this.contactPers = contactPers;
	}
	
	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public Integer getMortgageeId() {
		return mortgageeId;
	}

	public void setMortgageeId(Integer mortgageeId) {
		this.mortgageeId = mortgageeId;
	}
}
