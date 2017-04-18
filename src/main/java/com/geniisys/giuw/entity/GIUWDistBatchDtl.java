package com.geniisys.giuw.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIUWDistBatchDtl extends BaseEntity{
	
	private Integer batchId;
	private String lineCd;
	private Integer shareCd;
	private BigDecimal distSpct;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String arcExtData;
	private Integer dspTrtyCd;
	private String dspTrtyName;
	private String dspTrtySw;
	
	public Integer getBatchId() {
		return batchId;
	}
	public void setBatchId(Integer batchId) {
		this.batchId = batchId;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public Integer getShareCd() {
		return shareCd;
	}
	public void setShareCd(Integer shareCd) {
		this.shareCd = shareCd;
	}
	public BigDecimal getDistSpct() {
		return distSpct;
	}
	public void setDistSpct(BigDecimal distSpct) {
		this.distSpct = distSpct;
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
	public Integer getDspTrtyCd() {
		return dspTrtyCd;
	}
	public void setDspTrtyCd(Integer dspTrtyCd) {
		this.dspTrtyCd = dspTrtyCd;
	}
	public String getDspTrtyName() {
		return dspTrtyName;
	}
	public void setDspTrtyName(String dspTrtyName) {
		this.dspTrtyName = dspTrtyName;
	}
	public String getDspTrtySw() {
		return dspTrtySw;
	}
	public void setDspTrtySw(String dspTrtySw) {
		this.dspTrtySw = dspTrtySw;
	} 

}
