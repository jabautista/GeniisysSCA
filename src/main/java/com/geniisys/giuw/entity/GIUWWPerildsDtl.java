package com.geniisys.giuw.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIUWWPerildsDtl extends BaseEntity{
	
	private Integer distNo;
	private Integer distSeqNo;
	private String lineCd;
	private Integer perilCd;
	private Integer shareCd;
	private String distSpct;	// changed from BigDecimal to prevent passing the exponential value to ibatis (e.g. 0E-9 will be passed as 9): shan 06.11.2014 
	private BigDecimal distTsi;
	private BigDecimal distPrem;
	private String annDistSpct;	// changed from BigDecimal to prevent passing the exponential value to ibatis (e.g. 0E-9 will be passed as 9): shan 06.11.2014
	private BigDecimal annDistTsi;
	private Integer distGrp;
	private String distSpct1;	// changed from BigDecimal to prevent passing the exponential value to ibatis (e.g. 0E-9 will be passed as 9): shan 06.11.2014
	private String arcExtData;
	private String trtyName;
	
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
	public Integer getPerilCd() {
		return perilCd;
	}
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	public Integer getShareCd() {
		return shareCd;
	}
	public void setShareCd(Integer shareCd) {
		this.shareCd = shareCd;
	}
	/*public BigDecimal getDistSpct() {
		return distSpct;
	}
	public void setDistSpct(BigDecimal distSpct) {
		this.distSpct = distSpct;
	}*/
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
	/*public BigDecimal getAnnDistSpct() {
		return annDistSpct;
	}
	public void setAnnDistSpct(BigDecimal annDistSpct) {
		this.annDistSpct = annDistSpct;
	}*/
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
	/*public BigDecimal getDistSpct1() {
		return distSpct1;
	}
	public void setDistSpct1(BigDecimal distSpct1) {
		this.distSpct1 = distSpct1;
	}*/
	public String getArcExtData() {
		return arcExtData;
	}
	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}
	public String getTrtyName() {
		return trtyName;
	}
	public void setTrtyName(String trtyName) {
		this.trtyName = trtyName;
	}
	public String getDistSpct() {
		return distSpct;
	}
	public void setDistSpct(String distSpct) {
		this.distSpct = distSpct;
	}
	public String getAnnDistSpct() {
		return annDistSpct;
	}
	public void setAnnDistSpct(String annDistSpct) {
		this.annDistSpct = annDistSpct;
	}
	public String getDistSpct1() {
		return distSpct1;
	}
	public void setDistSpct1(String distSpct1) {
		this.distSpct1 = distSpct1;
	}	
	
}
