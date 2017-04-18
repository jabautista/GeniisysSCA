package com.geniisys.giri.entity;

import java.math.BigDecimal;
import com.geniisys.framework.util.BaseEntity;

public class GIRIIntreatyCharges extends BaseEntity {
	private Integer intreatyId;
	private Integer chargeCd;
	private BigDecimal amount;
	private String wTax;
	
	public Integer getIntreatyId() {
		return intreatyId;
	}
	public void setIntreatyId(Integer intreatyId) {
		this.intreatyId = intreatyId;
	}
	public Integer getChargeCd() {
		return chargeCd;
	}
	public void setChargeCd(Integer chargeCd) {
		this.chargeCd = chargeCd;
	}
	public BigDecimal getAmount() {
		return amount;
	}
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	public String getwTax() {
		return wTax;
	}
	public void setwTax(String wTax) {
		this.wTax = wTax;
	}
}
