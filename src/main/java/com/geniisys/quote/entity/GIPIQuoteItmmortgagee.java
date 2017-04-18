package com.geniisys.quote.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIQuoteItmmortgagee extends BaseEntity{

private String mortgCd;
private String mortgName;
private BigDecimal amount;
private Integer itemNo;
private Integer quoteId;
private String issCd;
private String remarks;
private Integer mortgageeId;



public Integer getMortgageeId() {
	return mortgageeId;
}
public void setMortgageeId(Integer mortgageeId) {
	this.mortgageeId = mortgageeId;
}
public String getRemarks() {
	return remarks;
}
public void setRemarks(String remarks) {
	this.remarks = remarks;
}
public String getIssCd() {
	return issCd;
}
public void setIssCd(String issCd) {
	this.issCd = issCd;
}
public Integer getQuoteId() {
	return quoteId;
}
public void setQuoteId(Integer quoteId) {
	this.quoteId = quoteId;
}
public String getMortgCd() {
	return mortgCd;
}
public void setMortgCd(String mortgCd) {
	this.mortgCd = mortgCd;
}
public String getMortgName() {
	return mortgName;
}
public void setMortgName(String mortgName) {
	this.mortgName = mortgName;
}
public BigDecimal getAmount() {
	return amount;
}
public void setAmount(BigDecimal amount) {
	this.amount = amount;
}
public Integer getItemNo() {
	return itemNo;
}
public void setItemNo(Integer itemNo) {
	this.itemNo = itemNo;
}


}
