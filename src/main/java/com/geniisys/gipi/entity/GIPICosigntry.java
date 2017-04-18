package com.geniisys.gipi.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIPICosigntry extends BaseEntity{

	private Integer policyId;
	private Integer cosignId;
	private Integer assdNo;
	private String indemFlag;
	private String bondsFlag;
	private String bondsRiFlag;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String arcExtData;
	
	private String dspCosignName;

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	public Integer getCosignId() {
		return cosignId;
	}

	public void setCosignId(Integer cosignId) {
		this.cosignId = cosignId;
	}

	public Integer getAssdNo() {
		return assdNo;
	}

	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}

	public String getIndemFlag() {
		return indemFlag;
	}

	public void setIndemFlag(String indemFlag) {
		this.indemFlag = indemFlag;
	}

	public String getBondsFlag() {
		return bondsFlag;
	}

	public void setBondsFlag(String bondsFlag) {
		this.bondsFlag = bondsFlag;
	}

	public String getBondsRiFlag() {
		return bondsRiFlag;
	}

	public void setBondsRiFlag(String bondsRiFlag) {
		this.bondsRiFlag = bondsRiFlag;
	}

	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	public String getArcExtData() {
		return arcExtData;
	}

	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}

	public String getDspCosignName() {
		return dspCosignName;
	}

	public void setDspCosignName(String dspCosignName) {
		this.dspCosignName = dspCosignName;
	}
	
}
