package com.geniisys.giex.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIEXNewGroupDeductibles extends BaseEntity{
	
	private Integer policyId;
	private Integer itemNo;
	private Integer perilCd;
	private String dedDeductibleCd;
	private String lineCd;
	private String sublineCd;
	private BigDecimal deductibleRt;
	private BigDecimal deductibleAmt;
	
	private String deductibleText;
	private String dspPerilName;
	private String dedType;
	
	private BigDecimal deductibleLocalAmt; //added by joanne 06.06.14
	
	public GIEXNewGroupDeductibles() {
		super();
	}

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
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

	public BigDecimal getDeductibleRt() {
		return deductibleRt;
	}

	public void setDeductibleRt(BigDecimal deductibleRt) {
		this.deductibleRt = deductibleRt;
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

	public void setDeductibleText(String deductibleText) {
		this.deductibleText = deductibleText;
	}

	public String getDspPerilName() {
		return dspPerilName;
	}

	public void setDspPerilName(String dspPerilName) {
		this.dspPerilName = dspPerilName;
	}

	public String getDedType() {
		return dedType;
	}

	public void setDedType(String dedType) {
		this.dedType = dedType;
	}

	public BigDecimal getDeductibleLocalAmt() {
		return deductibleLocalAmt;
	}

	public void setDeductibleLocalAmt(BigDecimal deductibleLocalAmt) {
		this.deductibleLocalAmt = deductibleLocalAmt;
	}	

}
