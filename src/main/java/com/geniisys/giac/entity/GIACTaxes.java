package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACTaxes extends BaseEntity{

	private String fundCd;
	private String taxCd;
	private String taxName;
	private String taxType;
	private Integer priorityCd;
	private Integer glAcctId;
	private Integer glSubAcct1;
	private Integer glSubAcct2;
	private Integer glSubAcct3;
	private Integer glSubAcct4;
	private Integer glSubAcct5;
	private Integer glSubAcct6;
	private Integer glSubAcct7;
    private Integer glAcctCategory;
    private Integer glControlAcct;
    private String remarks;
    private String userId;
    private String dspLastUpdate;
    
	public String getFundCd() {
		return fundCd;
	}
	
	public void setFundCd(String fundCd) {
		this.fundCd = fundCd;
	}
	
	public String getTaxCd() {
		return taxCd;
	}
	
	public void setTaxCd(String taxCd) {
		this.taxCd = taxCd;
	}
	
	public String getTaxName() {
		return taxName;
	}
	
	public void setTaxName(String taxName) {
		this.taxName = taxName;
	}
	
	public String getTaxType() {
		return taxType;
	}
	
	public void setTaxType(String taxType) {
		this.taxType = taxType;
	}
	
	public Integer getPriorityCd() {
		return priorityCd;
	}
	
	public void setPriorityCd(Integer priorityCd) {
		this.priorityCd = priorityCd;
	}
	
	public Integer getGlAcctId() {
		return glAcctId;
	}
	
	public void setGlAcctId(Integer glAcctId) {
		this.glAcctId = glAcctId;
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
	
	public String getRemarks() {
		return remarks;
	}
	
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public String getDspLastUpdate() {
		return dspLastUpdate;
	}
	
	public void setDspLastUpdate(String dspLastUpdate) {
		this.dspLastUpdate = dspLastUpdate;
	}
    
}
