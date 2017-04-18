package com.geniisys.giuw.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIUWPolicydsDtl extends BaseEntity{

	private Integer distNo;
	private Integer distSeqNo;
	private String lineCd;
	private Integer shareCd;
	private BigDecimal distTsi;
	private BigDecimal distPrem;
	private BigDecimal distSpct;
	private BigDecimal distSpct1;
	private BigDecimal annDistSpct;
	private BigDecimal annDistTsi;
	private Integer distGrp;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String arcExtData;
	private String dspTrtyCd;
	private String dspTrtyName;
	private String dspTrtySw;
	private String nbtShareType;
	
	public Integer getDistNo() {
		return distNo;
	}
	public void setDistNo(Integer distNo) {
		this.distNo = distNo;
	}
	public Integer getDistSeqNo() {
		return distSeqNo;
	}
	public void setDistSeqNo(Integer distSeqNo) {
		this.distSeqNo = distSeqNo;
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
	public BigDecimal getDistTsi() {
		return distTsi;
	}
	public void setDistTsi(BigDecimal distTsi) {
		this.distTsi = distTsi;
	}
	public BigDecimal getDistPrem() {
		return distPrem;
	}
	public void setDistPrem(BigDecimal distPrem) {
		this.distPrem = distPrem;
	}
	public BigDecimal getDistSpct() {
		return distSpct;
	}
	public void setDistSpct(BigDecimal distSpct) {
		this.distSpct = distSpct;
	}
	public BigDecimal getDistSpct1() {
		return distSpct1;
	}
	public void setDistSpct1(BigDecimal distSpct1) {
		this.distSpct1 = distSpct1;
	}
	public BigDecimal getAnnDistSpct() {
		return annDistSpct;
	}
	public void setAnnDistSpct(BigDecimal annDistSpct) {
		this.annDistSpct = annDistSpct;
	}
	public BigDecimal getAnnDistTsi() {
		return annDistTsi;
	}
	public void setAnnDistTsi(BigDecimal annDistTsi) {
		this.annDistTsi = annDistTsi;
	}
	public Integer getDistGrp() {
		return distGrp;
	}
	public void setDistGrp(Integer distGrp) {
		this.distGrp = distGrp;
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
	public String getDspTrtyCd() {
		return dspTrtyCd;
	}
	public void setDspTrtyCd(String dspTrtyCd) {
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
	public String getNbtShareType() {
		return nbtShareType;
	}
	public void setNbtShareType(String nbtShareType) {
		this.nbtShareType = nbtShareType;
	}
	
}
