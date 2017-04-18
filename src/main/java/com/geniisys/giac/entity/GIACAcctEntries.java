package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIACAcctEntries extends BaseEntity {
	
	private int gaccTranId;
	private String gaccGfunFundCd;
	private String gaccGibrBranchCd;
	private String acctEntryId;
	private String glAcctId;
	private String glAcctCategory;
	private String glControlAcct;
	private String glSubAcct1;
	private String glSubAcct2;
	private String glSubAcct3;
	private String glSubAcct4;
	private String glSubAcct5;
	private String glSubAcct6;
	private String glSubAcct7;
	private String slCd;
	private BigDecimal debitAmt;
	private BigDecimal creditAmt;
	private String generationType;
	private String slTypeCd;
	private String slSourceCd;
	private String remarks;
	private String cpiRecNo;
	private String cpiBranchCd;
	private String sapText;

	private String glAcctName;
	private String slName;
	
	/*start - Gzelle 11102015 KB#132 AP/AR ENH*/
	private String acctRefNo;
	private String acctTranType;
	
	public String getAcctRefNo() {
		return acctRefNo;
	}

	public void setAcctRefNo(String acctRefNo) {
		this.acctRefNo = acctRefNo;
	}
	
	public String getAcctTranType() {
		return acctTranType;
	}

	public void setAcctTranType(String acctTranType) {
		this.acctTranType = acctTranType;
	}
	/*end - Gzelle 11102015 KB#132 AP/AR ENH*/

	public int getGaccTranId() {
		return gaccTranId;
	}

	public void setGaccTranId(int gaccTranId) {
		this.gaccTranId = gaccTranId;
	}

	public String getGaccGfunFundCd() {
		return gaccGfunFundCd;
	}

	public void setGaccGfunFundCd(String gaccGfunFundCd) {
		this.gaccGfunFundCd = gaccGfunFundCd;
	}

	public String getGaccGibrBranchCd() {
		return gaccGibrBranchCd;
	}

	public void setGaccGibrBranchCd(String gaccGibrBranchCd) {
		this.gaccGibrBranchCd = gaccGibrBranchCd;
	}

	public String getAcctEntryId() {
		return acctEntryId;
	}

	public void setAcctEntryId(String acctEntryId) {
		this.acctEntryId = acctEntryId;
	}

	public String getGlAcctId() {
		return glAcctId;
	}

	public void setGlAcctId(String glAcctId) {
		this.glAcctId = glAcctId;
	}

	public String getGlAcctCategory() {
		return glAcctCategory;
	}

	public void setGlAcctCategory(String glAcctCategory) {
		this.glAcctCategory = glAcctCategory;
	}

	public String getGlControlAcct() {
		return glControlAcct;
	}

	public void setGlControlAcct(String glControlAcct) {
		this.glControlAcct = glControlAcct;
	}

	public String getGlSubAcct1() {
		return glSubAcct1;
	}

	public void setGlSubAcct1(String glSubAcct1) {
		this.glSubAcct1 = glSubAcct1;
	}

	public String getGlSubAcct2() {
		return glSubAcct2;
	}

	public void setGlSubAcct2(String glSubAcct2) {
		this.glSubAcct2 = glSubAcct2;
	}

	public String getGlSubAcct3() {
		return glSubAcct3;
	}

	public void setGlSubAcct3(String glSubAcct3) {
		this.glSubAcct3 = glSubAcct3;
	}

	public String getGlSubAcct4() {
		return glSubAcct4;
	}

	public void setGlSubAcct4(String glSubAcct4) {
		this.glSubAcct4 = glSubAcct4;
	}

	public String getGlSubAcct5() {
		return glSubAcct5;
	}

	public void setGlSubAcct5(String glSubAcct5) {
		this.glSubAcct5 = glSubAcct5;
	}

	public String getGlSubAcct6() {
		return glSubAcct6;
	}

	public void setGlSubAcct6(String glSubAcct6) {
		this.glSubAcct6 = glSubAcct6;
	}

	public String getGlSubAcct7() {
		return glSubAcct7;
	}

	public void setGlSubAcct7(String glSubAcct7) {
		this.glSubAcct7 = glSubAcct7;
	}

	public String getSlCd() {
		return slCd;
	}

	public void setSlCd(String slCd) {
		this.slCd = slCd;
	}

	public BigDecimal getDebitAmt() {
		return debitAmt;
	}

	public void setDebitAmt(BigDecimal debitAmt) {
		this.debitAmt = debitAmt;
	}

	public BigDecimal getCreditAmt() {
		return creditAmt;
	}

	public void setCreditAmt(BigDecimal creditAmt) {
		this.creditAmt = creditAmt;
	}

	public String getGenerationType() {
		return generationType;
	}

	public void setGenerationType(String generationType) {
		this.generationType = generationType;
	}

	public String getSlTypeCd() {
		return slTypeCd;
	}

	public void setSlTypeCd(String slTypeCd) {
		this.slTypeCd = slTypeCd;
	}

	public String getSlSourceCd() {
		return slSourceCd;
	}

	public void setSlSourceCd(String slSourceCd) {
		this.slSourceCd = slSourceCd;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getCpiRecNo() {
		return cpiRecNo;
	}

	public void setCpiRecNo(String cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	public String getSapText() {
		return sapText;
	}

	public void setSapText(String sapText) {
		this.sapText = sapText;
	}

	public String getGlAcctName() {
		return glAcctName;
	}

	public void setGlAcctName(String glAcctName) {
		this.glAcctName = glAcctName;
	}

	public String getSlName() {
		return slName;
	}

	public void setSlName(String slName) {
		this.slName = slName;
	}

	
}
