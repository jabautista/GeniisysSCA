package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLMortgagee extends BaseEntity{

	private Integer claimId;
    private Integer itemNo;
    private String mortgCd;
    private BigDecimal amount;
    private String issCd;
    
    private String nbtMortgNm;
    
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public String getMortgCd() {
		return mortgCd;
	}
	public void setMortgCd(String mortgCd) {
		this.mortgCd = mortgCd;
	}
	public BigDecimal getAmount() {
		return amount;
	}
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public String getNbtMortgNm() {
		return nbtMortgNm;
	}
	public void setNbtMortgNm(String nbtMortgNm) {
		this.nbtMortgNm = nbtMortgNm;
	}
	
}
