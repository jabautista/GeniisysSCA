
package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;

public class GIACUploadCollnDtl extends BaseEntity {

	private String sourceCd;
	private Integer fileNo;
	private Integer itemNo;
	private String payMode;
	private BigDecimal amount;
	private BigDecimal grossAmt;
	private BigDecimal commissionAmt;
	private BigDecimal vatAmt;
	private String checkClass;
	private String checkDate;
	private String checkNo;
	private String particulars;
	private String bankCd;
	private Integer currencyCd;
	private BigDecimal currencyRt;
	private String dcbBankCd;
	private String dcbBankAcctCd;
	private BigDecimal fcCommAmt;
	private BigDecimal fcVatAmt;
	private BigDecimal fcGrossAmt;
	private Integer tranId;
	
	public GIACUploadCollnDtl(){
		
	}
	
	public GIACUploadCollnDtl(String sourceCd, Integer fileNo, Integer itemNo,
			String payMode, BigDecimal amount, BigDecimal grossAmt,
			BigDecimal commissionAmt, BigDecimal vatAmt, String checkClass,
			String checkDate, String checkNo, String particulars,
			String bankCd, Integer currencyCd, BigDecimal currencyRt,
			String dcbBankCd, String dcbBankAcctCd, BigDecimal fcCommAmt,
			BigDecimal fcVatAmt, BigDecimal fcGrossAmt, Integer tranId) {
		super();
		this.sourceCd = sourceCd;
		this.fileNo = fileNo;
		this.itemNo = itemNo;
		this.payMode = payMode;
		this.amount = amount;
		this.grossAmt = grossAmt;
		this.commissionAmt = commissionAmt;
		this.vatAmt = vatAmt;
		this.checkClass = checkClass;
		this.checkDate = checkDate;
		this.checkNo = checkNo;
		this.particulars = particulars;
		this.bankCd = bankCd;
		this.currencyCd = currencyCd;
		this.currencyRt = currencyRt;
		this.dcbBankCd = dcbBankCd;
		this.dcbBankAcctCd = dcbBankAcctCd;
		this.fcCommAmt = fcCommAmt;
		this.fcVatAmt = fcVatAmt;
		this.fcGrossAmt = fcGrossAmt;
		this.tranId = tranId;
	}



	public String getSourceCd() {
		return sourceCd;
	}

	public void setSourceCd(String sourceCd) {
		this.sourceCd = sourceCd;
	}

	public Integer getFileNo() {
		return fileNo;
	}

	public void setFileNo(Integer fileNo) {
		this.fileNo = fileNo;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	public String getPayMode() {
		return payMode;
	}

	public void setPayMode(String payMode) {
		this.payMode = payMode;
	}

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	public BigDecimal getGrossAmt() {
		return grossAmt;
	}

	public void setGrossAmt(BigDecimal grossAmt) {
		this.grossAmt = grossAmt;
	}

	public BigDecimal getCommissionAmt() {
		return commissionAmt;
	}

	public void setCommissionAmt(BigDecimal commissionAmt) {
		this.commissionAmt = commissionAmt;
	}

	public BigDecimal getVatAmt() {
		return vatAmt;
	}

	public void setVatAmt(BigDecimal vatAmt) {
		this.vatAmt = vatAmt;
	}

	public String getCheckClass() {
		return checkClass;
	}

	public void setCheckClass(String checkClass) {
		this.checkClass = checkClass;
	}

	public String getCheckDate() {
		return checkDate;
	}

	public void setCheckDate(String checkDate) {
		this.checkDate = checkDate;
	}

	public String getCheckNo() {
		return checkNo;
	}

	public void setCheckNo(String checkNo) {
		this.checkNo = checkNo;
	}

	public String getParticulars() {
		return particulars;
	}

	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}

	public String getBankCd() {
		return bankCd;
	}

	public void setBankCd(String bankCd) {
		this.bankCd = bankCd;
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

	public String getDcbBankCd() {
		return dcbBankCd;
	}

	public void setDcbBankCd(String dcbBankCd) {
		this.dcbBankCd = dcbBankCd;
	}

	public String getDcbBankAcctCd() {
		return dcbBankAcctCd;
	}

	public void setDcbBankAcctCd(String dcbBankAcctCd) {
		this.dcbBankAcctCd = dcbBankAcctCd;
	}

	public BigDecimal getFcCommAmt() {
		return fcCommAmt;
	}

	public void setFcCommAmt(BigDecimal fcCommAmt) {
		this.fcCommAmt = fcCommAmt;
	}

	public BigDecimal getFcVatAmt() {
		return fcVatAmt;
	}

	public void setFcVatAmt(BigDecimal fcVatAmt) {
		this.fcVatAmt = fcVatAmt;
	}

	public BigDecimal getFcGrossAmt() {
		return fcGrossAmt;
	}

	public void setFcGrossAmt(BigDecimal fcGrossAmt) {
		this.fcGrossAmt = fcGrossAmt;
	}

	public Integer getTranId() {
		return tranId;
	}

	public void setTranId(Integer tranId) {
		this.tranId = tranId;
	}
		
}
