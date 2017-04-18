package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIACOtherCollns extends BaseEntity{
	private Integer gaccTranId;
	private Integer itemNo;
	private Integer transactionType;
	private BigDecimal collectionAmt;
	private Integer glAcctId;
	private Integer glAcctCategory;
	private Integer glControlAcct;
	private Integer glSubAcct1;
	private Integer glSubAcct2;
	private Integer glSubAcct3;
	private Integer glSubAcct4;
	private Integer glSubAcct5;
	private Integer glSubAcct6;
	private Integer glSubAcct7;
	private Integer gotcGaccTranId;
	private Integer gotcItemNo;
	private String orPrintTag;
	private Integer slCd;
	private String dspSlName;
	private String particulars;
	private String oldTransNo;
	private String oldItemNo;
	private String dspAccountName;
	private Integer dspTranYear;
	private Integer dspTranMonth;
	private Integer dspTranSeqNo;
	private String tranTypeMeaning;
	private String tranTypeDesc; 
	private Integer maxItem;
	private BigDecimal totalAmounts;
	
	public Integer getGaccTranId() {
		return gaccTranId;
	}
	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public Integer getTransactionType() {
		return transactionType;
	}
	public void setTransactionType(Integer transactionType) {
		this.transactionType = transactionType;
	}
	public BigDecimal getCollectionAmt() {
		return collectionAmt;
	}
	public void setCollectionAmt(BigDecimal collectionAmt) {
		this.collectionAmt = collectionAmt;
	}
	public Integer getGlAcctId() {
		return glAcctId;
	}
	public void setGlAcctId(Integer glAcctId) {
		this.glAcctId = glAcctId;
	}
	public Integer getGlAcctCategory() {
		return glAcctCategory;
	}
	public void setGlAcctCategory(Integer glAcctCategory) {
		this.glAcctCategory = glAcctCategory;
	}
	public Integer getGlControlAcct() {
		return glControlAcct;
	}
	public void setGlControlAcct(Integer glControlAcct) {
		this.glControlAcct = glControlAcct;
	}
	public Integer getGlSubAcct1() {
		return glSubAcct1;
	}
	public void setGlSubAcct1(Integer glSubAcct1) {
		this.glSubAcct1 = glSubAcct1;
	}
	public Integer getGlSubAcct2() {
		return glSubAcct2;
	}
	public void setGlSubAcct2(Integer glSubAcct2) {
		this.glSubAcct2 = glSubAcct2;
	}
	public Integer getGlSubAcct3() {
		return glSubAcct3;
	}
	public void setGlSubAcct3(Integer glSubAcct3) {
		this.glSubAcct3 = glSubAcct3;
	}
	public Integer getGlSubAcct4() {
		return glSubAcct4;
	}
	public void setGlSubAcct4(Integer glSubAcct4) {
		this.glSubAcct4 = glSubAcct4;
	}
	public Integer getGlSubAcct5() {
		return glSubAcct5;
	}
	public void setGlSubAcct5(Integer glSubAcct5) {
		this.glSubAcct5 = glSubAcct5;
	}
	public Integer getGlSubAcct6() {
		return glSubAcct6;
	}
	public void setGlSubAcct6(Integer glSubAcct6) {
		this.glSubAcct6 = glSubAcct6;
	}
	public Integer getGlSubAcct7() {
		return glSubAcct7;
	}
	public void setGlSubAcct7(Integer glSubAcct7) {
		this.glSubAcct7 = glSubAcct7;
	}
	public Integer getGotcGaccTranId() {
		return gotcGaccTranId;
	}
	public void setGotcGaccTranId(Integer gotcGaccTranId) {
		this.gotcGaccTranId = gotcGaccTranId;
	}
	public Integer getGotcItemNo() {
		return gotcItemNo;
	}
	public void setGotcItemNo(Integer gotcItemNo) {
		this.gotcItemNo = gotcItemNo;
	}
	public String getOrPrintTag() {
		return orPrintTag;
	}
	public void setOrPrintTag(String orPrintTag) {
		this.orPrintTag = orPrintTag;
	}
	public Integer getSlCd() {
		return slCd;
	}
	public void setSlCd(Integer slCd) {
		this.slCd = slCd;
	}
	public void setDspSlName(String dspSlName) {
		this.dspSlName = dspSlName;
	}
	public String getDspSlName() {
		return dspSlName;
	}
	public String getParticulars() {
		return particulars;
	}
	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}
	public String getOldTransNo() {
		return oldTransNo;
	}
	public void setOldTransNo(String oldTransNo) {
		this.oldTransNo = oldTransNo;
	}
	public String getOldItemNo() {
		return oldItemNo;
	}
	public void setOldItemNo(String oldItemNo) {
		this.oldItemNo = oldItemNo;
	}
	public String getDspAccountName() {
		return dspAccountName;
	}
	public void setDspAccountName(String dspAccountName) {
		this.dspAccountName = dspAccountName;
	}
	public Integer getDspTranYear() {
		return dspTranYear;
	}
	public void setDspTranYear(Integer dspTranYear) {
		this.dspTranYear = dspTranYear;
	}
	public Integer getDspTranMonth() {
		return dspTranMonth;
	}
	public void setDspTranMonth(Integer dspTranMonth) {
		this.dspTranMonth = dspTranMonth;
	}
	public String getTranTypeMeaning() {
		return tranTypeMeaning;
	}
	public void setTranTypeMeaning(String tranTypeMeaning) {
		this.tranTypeMeaning = tranTypeMeaning;
	}
	public String getTranTypeDesc() {
		return tranTypeDesc;
	}
	public void setTranTypeDesc(String tranTypeDesc) {
		this.tranTypeDesc = tranTypeDesc;
	}
	public void setDspTranSeqNo(Integer dspTranSeqNo) {
		this.dspTranSeqNo = dspTranSeqNo;
	}
	public Integer getDspTranSeqNo() {
		return dspTranSeqNo;
	}
	public void setMaxItem(Integer maxItem) {
		this.maxItem = maxItem;
	}
	public Integer getMaxItem() {
		return maxItem;
	}
	public void setTotalAmounts(BigDecimal totalAmounts) {
		this.totalAmounts = totalAmounts;
	}
	public BigDecimal getTotalAmounts() {
		return totalAmounts;
	}
}
