package com.geniisys.common.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIISCurrency extends BaseEntity{
	
	private int code;	//main_currency_cd
	
	private String desc;	//currency_desc
	private String currencyDesc;

	public String getCurrencyDesc() {
		return currencyDesc;
	}

	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}

	private String valueFloat;	//currency_rate (currency rate is named on some modules as valueFloat)
	
	private String shortName;
	
	/* Other attributes */
	private String currRt;
	
	private String remarks;
	
	private BigDecimal currencyRt; // the currency_rt

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

	public String getValueFloat() {
		return valueFloat;
	}

	public void setValueFloat(String valueFloat) {
		this.valueFloat = valueFloat;
	}

	public String getShortName() {
		return shortName;
	}

	public void setShortName(String shortName) {
		this.shortName = shortName;
	}

	public void setCurrRt(String currRt) {
		this.currRt = currRt;
	}

	public String getCurrRt() {
		return currRt;
	}

	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}

	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

}
