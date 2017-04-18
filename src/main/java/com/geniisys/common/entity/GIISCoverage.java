package com.geniisys.common.entity;

//import com.geniisys.framework.util.BaseEntity;
import com.geniisys.giis.entity.BaseEntity;

public class GIISCoverage extends BaseEntity{
	
	private Integer coverageCd;
	private String coverageDesc;
	private String remarks;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String lineCd;
	private String lineName;
	private String sublineCd;
	private String sublineName;
	
	public GIISCoverage(){
		
	}
	
	public Integer getCoverageCd() {
		return coverageCd;
	}
	
	public void setCoverageCd(Integer coverageCd) {
		this.coverageCd = coverageCd;
	}
	
	public String getCoverageDesc() {
		return coverageDesc;
	}
	
	public void setCoverageDesc(String coverageDesc) {
		this.coverageDesc = coverageDesc;
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
	
	public String getLineCd() {
		return lineCd;
	}
	
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	
	public String getSublineCd() {
		return sublineCd;
	}
	
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	public String getLineName() {
		return lineName;
	}

	public void setLineName(String lineName) {
		this.lineName = lineName;
	}

	public String getSublineName() {
		return sublineName;
	}

	public void setSublineName(String sublineName) {
		this.sublineName = sublineName;
	}
}
