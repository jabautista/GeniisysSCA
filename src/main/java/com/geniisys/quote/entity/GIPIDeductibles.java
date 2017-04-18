package com.geniisys.quote.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIDeductibles extends BaseEntity{

	private String deductibleCd;
	private String deductibleText;
	private BigDecimal deductibleAmt;
	private BigDecimal deductibleRt;
	private String deductibleTitle;
	private Integer quoteId;
	private Integer itemNo;
	private Integer perilCd;
	private String dedDeductibleCd;
	private String deductibleType; //added by steven 1/3/2013
	private Date lastUpdate;
	
	private Integer dedQuoteId;
	private Integer dedItemNo;
	private Integer dedPerilCd;
	
	public Integer getDedQuoteId() {
		return dedQuoteId;
	}
	public void setDedQuoteId(Integer dedQuoteId) {
		this.dedQuoteId = dedQuoteId;
	}
	public Integer getDedItemNo() {
		return dedItemNo;
	}
	public void setDedItemNo(Integer dedItemNo) {
		this.dedItemNo = dedItemNo;
	}
	public Integer getDedPerilCd() {
		return dedPerilCd;
	}
	public void setDedPerilCd(Integer dedPerilCd) {
		this.dedPerilCd = dedPerilCd;
	}
	public Date getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	public String getDeductibleCd() {
		return deductibleCd;
	}
	public void setDeductibleCd(String deductibleCd) {
		this.deductibleCd = deductibleCd;
	}
	public String getDeductibleText() {
		return deductibleText;
	}
	public void setDeductibleText(String deductibleText) {
		this.deductibleText = deductibleText;
	}	
	public BigDecimal getDeductibleAmt() {
		return deductibleAmt;
	}
	public void setDeductibleAmt(BigDecimal deductibleAmt) {
		this.deductibleAmt = deductibleAmt;
	}
	public String getDeductibleTitle() {
		return deductibleTitle;
	}
	public void setDeductibleTitle(String deductibleTitle) {
		this.deductibleTitle = deductibleTitle;
	}
	public Integer getQuoteId() {
		return quoteId;
	}
	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public Integer getPerilCd() {
		return perilCd;
	}
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	public String getDedDeductibleCd() {
		return dedDeductibleCd;
	}
	public void setDedDeductibleCd(String dedDeductibleCd) {
		this.dedDeductibleCd = dedDeductibleCd;
	}
	public BigDecimal getDeductibleRt() {
		return deductibleRt;
	}
	public void setDeductibleRt(BigDecimal deductibleRt) {
		this.deductibleRt = deductibleRt;
	}
	/**
	 * @return the deductibleType
	 */
	public String getDeductibleType() {
		return deductibleType;
	}
	/**
	 * @param deductibleType the deductibleType to set
	 */
	public void setDeductibleType(String deductibleType) {
		this.deductibleType = deductibleType;
	}
}
