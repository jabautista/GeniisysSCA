package com.geniisys.gipi.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIPIQuoteCosign extends BaseEntity{

	private Integer quoteId;
	private Integer cosignId;
	private String cosignName;
	private Integer assdNo;
	private String indemFlag;
	private String bondsFlag;
	private String bondsRiFlag;
	
	public Integer getQuoteId() {
		return quoteId;
	}
	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
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
	public String getCosignName() {
		return cosignName;
	}
	public void setCosignName(String cosignName) {
		this.cosignName = cosignName;
	}
	
}
