package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIInvoice extends BaseEntity{
	
	private Date acctEntDate;		
	private String approvalCd;		
	private String arcExtData;		
	private BigDecimal bondRate;		
	private BigDecimal bondTsiAmt;		
	private String cardName;		
	private Integer cardNo;		
	private String changedTag;		
	private String cpiBranch;		
	private Integer cpiRecNo;
	private Integer currencyCd;		
	private BigDecimal currencyRt;		
	private String distFlag;		
	private Date dueDate;		
	private Date effDate;		
	private Date expiryDate;		
	private String insured;		
	private Integer invoicePrintedCnt;		
	private Date InvoicePrintedDate;		
	private String issCd;
	private Integer itemGrp;		
	private Date lastUpDate;		
	private String multiBookingMm;		
	private Integer multiBookingYy;		
	private BigDecimal notarialFee;		
	private String noOfTakeup;		
	private BigDecimal otherDamages;		
	private String payTerms;		
	private String payType;		
	private String policyCurrency;	
	private Integer policyId;		
	private BigDecimal premAmt;
	private Integer premSeqNo;		
	private String property;		
	private String refInvNo;		
	private String remarks;		
	private BigDecimal riCommAmt;		
	private BigDecimal riCommVat;		
	private Date spoiledAcctEntDate;		
	private Integer takeupSeqNo;		
	private BigDecimal taxAmt;		
	private String userId;
	private String premCollMode;
	private BigDecimal otherCharges;
	private String currencyDesc;
	
	private BigDecimal balanceDue; 
	private String invoiceNo;
	
	public GIPIInvoice() {
		super();
	}

	public Date getAcctEntDate() {
		return acctEntDate;
	}

	public void setAcctEntDate(Date acctEntDate) {
		this.acctEntDate = acctEntDate;
	}

	public String getApprovalCd() {
		return approvalCd;
	}

	public void setApprovalCd(String approvalCd) {
		this.approvalCd = approvalCd;
	}

	public String getArcExtData() {
		return arcExtData;
	}

	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}

	public BigDecimal getBondRate() {
		return bondRate;
	}

	public void setBondRate(BigDecimal bondRate) {
		this.bondRate = bondRate;
	}

	public BigDecimal getBondTsiAmt() {
		return bondTsiAmt;
	}

	public void setBondTsiAmt(BigDecimal bondTsiAmt) {
		this.bondTsiAmt = bondTsiAmt;
	}

	public String getCardName() {
		return cardName;
	}

	public void setCardName(String cardName) {
		this.cardName = cardName;
	}

	public Integer getCardNo() {
		return cardNo;
	}

	public void setCardNo(Integer cardNo) {
		this.cardNo = cardNo;
	}

	public String getChangedTag() {
		return changedTag;
	}

	public void setChangedTag(String changedTag) {
		this.changedTag = changedTag;
	}

	public String getCpiBranch() {
		return cpiBranch;
	}

	public void setCpiBranch(String cpiBranch) {
		this.cpiBranch = cpiBranch;
	}

	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	public Integer getCurrencyCd() {
		return currencyCd;
	}

	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}

	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}

	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}

	public String getDistFlag() {
		return distFlag;
	}

	public void setDistFlag(String distFlag) {
		this.distFlag = distFlag;
	}

	public Date getDueDate() {
		return dueDate;
	}

	public void setDueDate(Date dueDate) {
		this.dueDate = dueDate;
	}

	public Date getEffDate() {
		return effDate;
	}

	public void setEffDate(Date effDate) {
		this.effDate = effDate;
	}

	public Date getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}

	public String getInsured() {
		return insured;
	}

	public void setInsured(String insured) {
		this.insured = insured;
	}

	public Integer getInvoicePrintedCnt() {
		return invoicePrintedCnt;
	}

	public void setInvoicePrintedCnt(Integer invoicePrintedCnt) {
		this.invoicePrintedCnt = invoicePrintedCnt;
	}

	public Date getInvoicePrintedDate() {
		return InvoicePrintedDate;
	}

	public void setInvoicePrintedDate(Date invoicePrintedDate) {
		InvoicePrintedDate = invoicePrintedDate;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public Integer getItemGrp() {
		return itemGrp;
	}

	public void setItemGrp(Integer itemGrp) {
		this.itemGrp = itemGrp;
	}

	public Date getLastUpDate() {
		return lastUpDate;
	}

	public void setLastUpDate(Date lastUpDate) {
		this.lastUpDate = lastUpDate;
	}

	public String getMultiBookingMm() {
		return multiBookingMm;
	}

	public void setMultiBookingMm(String multiBookingMm) {
		this.multiBookingMm = multiBookingMm;
	}

	public Integer getMultiBookingYy() {
		return multiBookingYy;
	}

	public void setMultiBookingYy(Integer multiBookingYy) {
		this.multiBookingYy = multiBookingYy;
	}

	public BigDecimal getNotarialFee() {
		return notarialFee;
	}

	public void setNotarialFee(BigDecimal notarialFee) {
		this.notarialFee = notarialFee;
	}

	public String getNoOfTakeup() {
		return noOfTakeup;
	}

	public void setNoOfTakeup(String noOfTakeup) {
		this.noOfTakeup = noOfTakeup;
	}

	public BigDecimal getOtherDamages() {
		return otherDamages;
	}

	public void setOtherDamages(BigDecimal otherDamages) {
		this.otherDamages = otherDamages;
	}

	public String getPayTerms() {
		return payTerms;
	}

	public void setPayTerms(String payTerms) {
		this.payTerms = payTerms;
	}

	public String getPayType() {
		return payType;
	}

	public void setPayType(String payType) {
		this.payType = payType;
	}

	public String getPolicyCurrency() {
		return policyCurrency;
	}

	public void setPolicyCurrency(String policyCurrency) {
		this.policyCurrency = policyCurrency;
	}

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	public BigDecimal getPremAmt() {
		return premAmt;
	}

	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}

	public Integer getPremSeqNo() {
		return premSeqNo;
	}

	public void setPremSeqNo(Integer premSeqNo) {
		this.premSeqNo = premSeqNo;
	}

	public String getProperty() {
		return property;
	}

	public void setProperty(String property) {
		this.property = property;
	}

	public String getRefInvNo() {
		return refInvNo;
	}

	public void setRefInvNo(String refInvNo) {
		this.refInvNo = refInvNo;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public BigDecimal getRiCommAmt() {
		return riCommAmt;
	}

	public void setRiCommAmt(BigDecimal riCommAmt) {
		this.riCommAmt = riCommAmt;
	}

	public BigDecimal getRiCommVat() {
		return riCommVat;
	}

	public void setRiCommVat(BigDecimal riCommVat) {
		this.riCommVat = riCommVat;
	}

	public Date getSpoiledAcctEntDate() {
		return spoiledAcctEntDate;
	}

	public void setSpoiledAcctEntDate(Date spoiledAcctEntDate) {
		this.spoiledAcctEntDate = spoiledAcctEntDate;
	}

	public Integer getTakeupSeqNo() {
		return takeupSeqNo;
	}

	public void setTakeupSeqNo(Integer takeupSeqNo) {
		this.takeupSeqNo = takeupSeqNo;
	}

	public BigDecimal getTaxAmt() {
		return taxAmt;
	}

	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getPremCollMode() {
		return premCollMode;
	}

	public void setPremCollMode(String premCollMode) {
		this.premCollMode = premCollMode;
	}

	public BigDecimal getOtherCharges() {
		return otherCharges;
	}

	public void setOtherCharges(BigDecimal otherCharges) {
		this.otherCharges = otherCharges;
	}

	public String getCurrencyDesc() {
		return currencyDesc;
	}

	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}

	/**
	 * @param balanceDue the balanceDue to set
	 */
	public void setBalanceDue(BigDecimal balanceDue) {
		this.balanceDue = balanceDue;
	}

	/**
	 * @return the balanceDue
	 */
	public BigDecimal getBalanceDue() {
		return balanceDue;
	}

	/**
	 * @param invoiceNo the invoiceNo to set
	 */
	public void setInvoiceNo(String invoiceNo) {
		this.invoiceNo = invoiceNo;
	}

	/**
	 * @return the invoiceNo
	 */
	public String getInvoiceNo() {
		return invoiceNo;
	}

}
