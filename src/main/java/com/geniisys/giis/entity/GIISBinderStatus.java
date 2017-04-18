package com.geniisys.giis.entity;

public class GIISBinderStatus extends BaseEntity{
	
	private String bndrStatCd;
	private String bndrStatDesc;
	private String bndrTag;
	private String dspBndrTagMeaning;
	private String remarks;
	
	public GIISBinderStatus(){
		
	}
	
	public GIISBinderStatus(String bndrStatCd, String bndrStatDesc, String bndrTag, String remarks){
		super();
		this.bndrStatCd = bndrStatCd;
		this.bndrStatDesc = bndrStatDesc;
		this.bndrTag = bndrTag;
		this.remarks = remarks;
	}
	
	public String getBndrStatCd() {
		return bndrStatCd;
	}
	
	public void setBndrStatCd(String bndrStatCd) {
		this.bndrStatCd = bndrStatCd;
	}
	
	public String getBndrStatDesc() {
		return bndrStatDesc;
	}
	
	public void setBndrStatDesc(String bndrStatDesc) {
		this.bndrStatDesc = bndrStatDesc;
	}
	
	public String getBndrTag() {
		return bndrTag;
	}
	
	public void setBndrTag(String bndrTag) {
		this.bndrTag = bndrTag;
	}
	
	public String getRemarks() {
		return remarks;
	}
	
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getDspBndrTagMeaning() {
		return dspBndrTagMeaning;
	}

	public void setDspBndrTagMeaning(String dspBndrTagMeaning) {
		this.dspBndrTagMeaning = dspBndrTagMeaning;
	}
}
