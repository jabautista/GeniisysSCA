package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACCommSlipExt extends BaseEntity {

	public Integer recId;
	public Integer gaccTranId;
	public String issCd;
	public Integer premSeqNo;
	public Integer intmNo;
	public BigDecimal commAmt;
	public BigDecimal wtaxAmt;
	public BigDecimal inputVatAmt;
	public String commSlipPref;
	public String commSlipNo;
	public Date commSlipDate;
	public String commSlipFlag;
	public String commSlipTag;
	public String orNo;
	public String parentIntmNo;
	public String userId;

	public String refIntmCd;
	public String billNo;
	public BigDecimal netAmt;
	public String commissionSlipNo;

	public Integer getRecId() {
		return recId;
	}

	public void setRecId(Integer recId) {
		this.recId = recId;
	}

	public Integer getGaccTranId() {
		return gaccTranId;
	}

	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public Integer getPremSeqNo() {
		return premSeqNo;
	}

	public void setPremSeqNo(Integer premSeqNo) {
		this.premSeqNo = premSeqNo;
	}

	public Integer getIntmNo() {
		return intmNo;
	}

	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}

	public BigDecimal getCommAmt() {
		return commAmt;
	}

	public void setCommAmt(BigDecimal commAmt) {
		this.commAmt = commAmt;
	}

	public BigDecimal getWtaxAmt() {
		return wtaxAmt;
	}

	public void setWtaxAmt(BigDecimal wtaxAmt) {
		this.wtaxAmt = wtaxAmt;
	}

	public BigDecimal getInputVatAmt() {
		return inputVatAmt;
	}

	public void setInputVatAmt(BigDecimal inputVatAmt) {
		this.inputVatAmt = inputVatAmt;
	}

	public String getCommSlipPref() {
		return commSlipPref;
	}

	public void setCommSlipPref(String commSlipPref) {
		this.commSlipPref = commSlipPref;
	}

	public String getCommSlipNo() {
		return commSlipNo;
	}

	public void setCommSlipNo(String commSlipNo) {
		this.commSlipNo = commSlipNo;
	}

	public Date getCommSlipDate() {
		return commSlipDate;
	}

	public void setCommSlipDate(Date commSlipDate) {
		this.commSlipDate = commSlipDate;
	}

	public String getCommSlipFlag() {
		return commSlipFlag;
	}

	public void setCommSlipFlag(String commSlipFlag) {
		this.commSlipFlag = commSlipFlag;
	}

	public String getCommSlipTag() {
		return commSlipTag;
	}

	public void setCommSlipTag(String commSlipTag) {
		this.commSlipTag = commSlipTag;
	}

	public String getOrNo() {
		return orNo;
	}

	public void setOrNo(String orNo) {
		this.orNo = orNo;
	}

	public String getParentIntmNo() {
		return parentIntmNo;
	}

	public void setParentIntmNo(String parentIntmNo) {
		this.parentIntmNo = parentIntmNo;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getRefIntmCd() {
		return refIntmCd;
	}

	public void setRefIntmCd(String refIntmCd) {
		this.refIntmCd = refIntmCd;
	}

	public String getBillNo() {
		return billNo;
	}

	public void setBillNo(String billNo) {
		this.billNo = billNo;
	}

	public BigDecimal getNetAmt() {
		return netAmt;
	}

	public void setNetAmt(BigDecimal netAmt) {
		this.netAmt = netAmt;
	}

	public String getCommissionSlipNo() {
		return commissionSlipNo;
	}

	public void setCommissionSlipNo(String commissionSlipNo) {
		this.commissionSlipNo = commissionSlipNo;
	}

}
