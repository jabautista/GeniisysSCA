package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACOucs extends BaseEntity{

	private Integer oucId;
	private String gibrGfunFundCd;
	private String gibrBranchCd;
	private Integer oucCd;
	private String oucName;
	private Integer cpiRecCo;
	private String cpiBranchCd;
	private String claimTag;
	private String remarks;
	
	public Integer getOucId() {
		return oucId;
	}
	public void setOucId(Integer oucId) {
		this.oucId = oucId;
	}
	public String getGibrGfunFundCd() {
		return gibrGfunFundCd;
	}
	public void setGibrGfunFundCd(String gibrGfunFundCd) {
		this.gibrGfunFundCd = gibrGfunFundCd;
	}
	public String getGibrBranchCd() {
		return gibrBranchCd;
	}
	public void setGibrBranchCd(String gibrBranchCd) {
		this.gibrBranchCd = gibrBranchCd;
	}
	public Integer getOucCd() {
		return oucCd;
	}
	public void setOucCd(Integer oucCd) {
		this.oucCd = oucCd;
	}
	public String getOucName() {
		return oucName;
	}
	public void setOucName(String oucName) {
		this.oucName = oucName;
	}
	public Integer getCpiRecCo() {
		return cpiRecCo;
	}
	public void setCpiRecCo(Integer cpiRecCo) {
		this.cpiRecCo = cpiRecCo;
	}
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	public String getClaimTag() {
		return claimTag;
	}
	public void setClaimTag(String claimTag) {
		this.claimTag = claimTag;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks; 
	}
		
}
