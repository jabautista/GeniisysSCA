package com.geniisys.giis.entity;

import java.math.BigDecimal;

public class GIISDefaultDistGroup extends BaseEntity {
	
	private Integer defaultNo;
	private String lineCd;
	private Integer shareCd;
	private String dspTreatyName;
	private Integer sequence;
	private BigDecimal sharePct;
	private BigDecimal shareAmt1;
	private String remarks;
	private String childTag;
	
	public GIISDefaultDistGroup(){
		
	}

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

	public Integer getShareCd() {
		return shareCd;
	}

	public void setShareCd(Integer shareCd) {
		this.shareCd = shareCd;
	}

	public String getDspTreatyName() {
		return dspTreatyName;
	}

	public void setDspTreatyName(String dspTreatyName) {
		this.dspTreatyName = dspTreatyName;
	}

	public Integer getSequence() {
		return sequence;
	}

	public void setSequence(Integer sequence) {
		this.sequence = sequence;
	}

	public BigDecimal getSharePct() {
		return sharePct;
	}

	public void setSharePct(BigDecimal sharePct) {
		this.sharePct = sharePct;
	}

	public BigDecimal getShareAmt1() {
		return shareAmt1;
	}

	public void setShareAmt1(BigDecimal shareAmt1) {
		this.shareAmt1 = shareAmt1;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getChildTag() {
		return childTag;
	}

	public void setChildTag(String childTag) {
		this.childTag = childTag;
	}
	
}
