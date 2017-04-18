package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIACAgingRiSoaDetails extends BaseEntity {

	private Integer a180RiCd;
	
	private Integer premSeqNo;
	
	private Integer instNo;
	
	private String a150LineCd;
	
	private BigDecimal totalAmountDue;
	
	private BigDecimal totalPayments;
	
	private BigDecimal tempPayments;
	
	private BigDecimal balanceDue;
	
	private Integer a020AssdNo;

	public Integer getA180RiCd() {
		return a180RiCd;
	}

	public void setA180RiCd(Integer a180RiCd) {
		this.a180RiCd = a180RiCd;
	}

	public Integer getPremSeqNo() {
		return premSeqNo;
	}

	public void setPremSeqNo(Integer premSeqNo) {
		this.premSeqNo = premSeqNo;
	}

	public Integer getInstNo() {
		return instNo;
	}

	public void setInstNo(Integer instNo) {
		this.instNo = instNo;
	}

	public String getA150LineCd() {
		return a150LineCd;
	}

	public void setA150LineCd(String a150LineCd) {
		this.a150LineCd = a150LineCd;
	}

	public BigDecimal getTotalAmountDue() {
		return totalAmountDue;
	}

	public void setTotalAmountDue(BigDecimal totalAmountDue) {
		this.totalAmountDue = totalAmountDue;
	}

	public BigDecimal getTotalPayments() {
		return totalPayments;
	}

	public void setTotalPayments(BigDecimal totalPayments) {
		this.totalPayments = totalPayments;
	}

	public BigDecimal getTempPayments() {
		return tempPayments;
	}

	public void setTempPayments(BigDecimal tempPayments) {
		this.tempPayments = tempPayments;
	}

	public BigDecimal getBalanceDue() {
		return balanceDue;
	}

	public void setBalanceDue(BigDecimal balanceDue) {
		this.balanceDue = balanceDue;
	}

	public Integer getA020AssdNo() {
		return a020AssdNo;
	}

	public void setA020AssdNo(Integer a020AssdNo) {
		this.a020AssdNo = a020AssdNo;
	}
}
