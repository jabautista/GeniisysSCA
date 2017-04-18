package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACEomRepDtl extends  BaseEntity{
	
	private String repCd;
	private String repTitle;
	private String glAcctId;
	private String glAcctName;
	private Integer glAcctCategory;
	private Integer glControlAcct;
	private Integer glSubAcct1;
	private Integer glSubAcct2;
	private Integer glSubAcct3;
	private Integer glSubAcct4;
	private Integer glSubAcct5;
	private Integer glSubAcct6;
	private Integer glSubAcct7;
	private String glAcctNo;
	private String remarks;
	
	public GIACEomRepDtl(){
		
	}
	
	public String getRepCd() {
		return repCd;
	}
	
	public void setRepCd(String repCd) {
		this.repCd = repCd;
	}
	
	public String getGlAcctId() {
		return glAcctId;
	}
	
	public void setGlAcctId(String glAcctId) {
		this.glAcctId = glAcctId;
	}
	
	public Integer getGlAcctCategory() {
		return glAcctCategory;
	}
	
	public void setGlAcctCategory(Integer glAcctCategory) {
		this.glAcctCategory = glAcctCategory;
	}
	
	public Integer getGlControlAcct() {
		return glControlAcct;
	}
	
	public void setGlControlAcct(Integer glControlAcct) {
		this.glControlAcct = glControlAcct;
	}
	
	public Integer getGlSubAcct1() {
		return glSubAcct1;
	}
	
	public void setGlSubAcct1(Integer glSubAcct1) {
		this.glSubAcct1 = glSubAcct1;
	}
	
	public Integer getGlSubAcct2() {
		return glSubAcct2;
	}
	
	public void setGlSubAcct2(Integer glSubAcct2) {
		this.glSubAcct2 = glSubAcct2;
	}
	
	public Integer getGlSubAcct3() {
		return glSubAcct3;
	}
	
	public void setGlSubAcct3(Integer glSubAcct3) {
		this.glSubAcct3 = glSubAcct3;
	}
	
	public Integer getGlSubAcct4() {
		return glSubAcct4;
	}
	
	public void setGlSubAcct4(Integer glSubAcct4) {
		this.glSubAcct4 = glSubAcct4;
	}
	
	public Integer getGlSubAcct5() {
		return glSubAcct5;
	}
	
	public void setGlSubAcct5(Integer glSubAcct5) {
		this.glSubAcct5 = glSubAcct5;
	}
	
	public Integer getGlSubAcct6() {
		return glSubAcct6;
	}
	
	public void setGlSubAcct6(Integer glSubAcct6) {
		this.glSubAcct6 = glSubAcct6;
	}
	
	public Integer getGlSubAcct7() {
		return glSubAcct7;
	}
	
	public void setGlSubAcct7(Integer glSubAcct7) {
		this.glSubAcct7 = glSubAcct7;
	}
	
	public String getRemarks() {
		return remarks;
	}
	
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getGlAcctName() {
		return glAcctName;
	}

	public void setGlAcctName(String glAcctName) {
		this.glAcctName = glAcctName;
	}

	public String getRepTitle() {
		return repTitle;
	}

	public void setRepTitle(String repTitle) {
		this.repTitle = repTitle;
	}

	public String getGlAcctNo() {
		return glAcctNo;
	}

	public void setGlAcctNo(String glAcctNo) {
		this.glAcctNo = glAcctNo;
	}
	
}
