package com.geniisys.giuw.entity;

import java.util.List;

import com.geniisys.framework.util.BaseEntity;

public class GIUWDistBatch extends BaseEntity {
	
	private Integer batchId;
	private String batchDate;
	private String batchFlag;
	private Integer batchQty;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String arcExtData;
	private String lineCd;
	private List<GIUWDistBatchDtl> giuwDistBatchDtlList;
	
	public Integer getBatchId() {
		return batchId;
	}
	public void setBatchId(Integer batchId) {
		this.batchId = batchId;
	}
	public String getBatchDate() {
		return batchDate;
	}
	public void setBatchDate(String batchDate) {
		this.batchDate = batchDate;
	}
	public String getBatchFlag() {
		return batchFlag;
	}
	public void setBatchFlag(String batchFlag) {
		this.batchFlag = batchFlag;
	}
	public Integer getBatchQty() {
		return batchQty;
	}
	public void setBatchQty(Integer batchQty) {
		this.batchQty = batchQty;
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
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public void setGiuwDistBatchDtlList(List<GIUWDistBatchDtl> giuwDistBatchDtlList) {
		this.giuwDistBatchDtlList = giuwDistBatchDtlList;
	}
	public List<GIUWDistBatchDtl> getGiuwDistBatchDtlList() {
		return giuwDistBatchDtlList;
	}

}
