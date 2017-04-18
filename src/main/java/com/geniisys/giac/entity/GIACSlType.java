package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACSlType extends BaseEntity {

	private String slTypeCd;
	private String slTypeName;
	private String slTag;
	private String dspSlTagMeaning;
	private String osFlag;
	private String remarks;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	
	public GIACSlType(){
		
	}

	public GIACSlType(String slTypeCd, String slTypeName, String slTag,
			String osFlag, String remarks, Integer cpiRecNo, String cpiBranchCd) {
		super();
		this.slTypeCd = slTypeCd;
		this.slTypeName = slTypeName;
		this.slTag = slTag;
		this.osFlag = osFlag;
		this.remarks = remarks;
		this.cpiRecNo = cpiRecNo;
		this.cpiBranchCd = cpiBranchCd;
	}

	public String getSlTypeCd() {
		return slTypeCd;
	}

	public void setSlTypeCd(String slTypeCd) {
		this.slTypeCd = slTypeCd;
	}

	public String getSlTypeName() {
		return slTypeName;
	}

	public void setSlTypeName(String slTypeName) {
		this.slTypeName = slTypeName;
	}

	public String getSlTag() {
		return slTag;
	}

	public void setSlTag(String slTag) {
		this.slTag = slTag;
	}

	public String getOsFlag() {
		return osFlag;
	}

	public void setOsFlag(String osFlag) {
		this.osFlag = osFlag;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
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

	public String getDspSlTagMeaning() {
		return dspSlTagMeaning;
	}

	public void setDspSlTagMeaning(String dspSlTagMeaning) {
		this.dspSlTagMeaning = dspSlTagMeaning;
	}
	
}
