package com.geniisys.giis.entity;

import java.math.BigDecimal;

public class GIISDefaultDistPeril extends BaseEntity{

	private Integer defaultNo;
	private String lineCd;
	private Integer perilCd;
	private Integer shareCd;
	private Integer sequence;
	private Double sharePct;
	private BigDecimal shareAmt1;
	private BigDecimal shareAmt2;
	private String remarks;
	private String trtyName;
	private String childTag;
	
	public Integer getDefaultNo() {
		return defaultNo;
	}
	
	public void setDefaultNo(Integer defaultNo) {
		this.defaultNo = defaultNo;
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
	
	public Integer getSequence() {
		return sequence;
	}
	
	public void setSequence(Integer sequence) {
		this.sequence = sequence;
	}
	
	public Double getSharePct() {
		return sharePct;
	}
	
	public void setSharePct(Double sharePct) {
		this.sharePct = sharePct;
	}
	
	public BigDecimal getShareAmt1() {
		return shareAmt1;
	}
	
	public void setShareAmt1(BigDecimal shareAmt1) {
		this.shareAmt1 = shareAmt1;
	}
	
	public BigDecimal getShareAmt2() {
		return shareAmt2;
	}
	
	public void setShareAmt2(BigDecimal shareAmt2) {
		this.shareAmt2 = shareAmt2;
	}
	
	public String getRemarks() {
		return remarks;
	}
	
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getTrtyName() {
		return trtyName;
	}

	public void setTrtyName(String trtyName) {
		this.trtyName = trtyName;
	}
	
	public String getChildTag() {
		return childTag;
	}
	
	public void setChildTag(String childTag) {
		this.childTag = childTag;
	}
	
}
