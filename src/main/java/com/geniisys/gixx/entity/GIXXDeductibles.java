package com.geniisys.gixx.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIXXDeductibles extends BaseEntity{
	
	private Integer extractId;
	private Integer itemNo;
	private String dedDeductibleCd;
	private Integer policyId;
	private String dedLineCd;
	private String dedSublineCd;
	private BigDecimal deductibleAmt;
	private String deductibleText;
	private BigDecimal deductibleRt;
	private Integer perilCd;
	
	private BigDecimal totalDeductibleAmt;
	private String deductibleTitle;
	
	public Integer getExtractId() {
		return extractId;
	}
	public void setExtractId(Integer extractId) {
		this.extractId = extractId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public String getDedDeductibleCd() {
		return dedDeductibleCd;
	}
	public void setDedDeductibleCd(String dedDeductibleCd) {
		this.dedDeductibleCd = dedDeductibleCd;
	}
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public String getDedLineCd() {
		return dedLineCd;
	}
	public void setDedLineCd(String dedLineCd) {
		this.dedLineCd = dedLineCd;
	}
	public String getDedSublineCd() {
		return dedSublineCd;
	}
	public void setDedSublineCd(String dedSublineCd) {
		this.dedSublineCd = dedSublineCd;
	}
	public BigDecimal getDeductibleAmt() {
		return deductibleAmt;
	}
	public void setDeductibleAmt(BigDecimal deductibleAmt) {
		this.deductibleAmt = deductibleAmt;
	}
	public String getDeductibleText() {
		return deductibleText;
	}
	public void setDeductibleText(String dedutibleText) {
		this.deductibleText = dedutibleText;
	}
	public BigDecimal getDeductibleRt() {
		return deductibleRt;
	}
	public void setDeductibleRt(BigDecimal deductibleRt) {
		this.deductibleRt = deductibleRt;
	}
	public Integer getPerilCd() {
		return perilCd;
	}
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	public BigDecimal getTotalDeductibleAmt() {
		return totalDeductibleAmt;
	}
	public void setTotalDeductibleAmt(BigDecimal totalDeductibleAmt) {
		this.totalDeductibleAmt = totalDeductibleAmt;
	}
	public String getDeductibleTitle() {
		return deductibleTitle;
	}
	public void setDeductibleTitle(String deductibleTitle) {
		this.deductibleTitle = deductibleTitle;
	}

	
}
