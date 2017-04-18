/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.entity
	File Name: GIACChkDisbursement.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jun 19, 2012
	Description: 
*/


package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACChkDisbursement extends BaseEntity{
    // just add more columns of the table if needed
	private String checkStat;
	private Date checkDate;
	private String checkPrefSuf;
	private Long checkNo;
	private Integer gaccTranId;
	private Integer itemNo;
	private String payee;
	private BigDecimal fCurrencyAmt;
	private BigDecimal amount;
	private String bankAcctCd;
	private String bankCd;
	private Integer currencyCd;
	private BigDecimal currencyRt;
	private String checkClass;
	
	// attributes that are not in the table
    private String dspCheckFlagMean;
    private String strCheckDate;
    private String dspCheckNo;
    private String dspCurrency;
    private String dspBankSname;
    private String dspBankAcct;
    private String dspDVNo;
    private Integer dspLocalCurrency;
    private String nbtDVParticulars;
    
    // for GIACS002
    private String checkStatMean;
    private String checkClassMean;
    private Date checkPrintDate;
    private String strCheckPrintDate;
    private String disbMode;
    private BigDecimal totalAmount;
    private String payeeClassCd;
    private Integer payeeNo;
    private String bankAcctNo;
    private String strLastUpdate2;
    private String checkReceivedBy;
    private String checkReleasedBy;
    private Date checkReleaseDate;
    private String batchTag;
    
	
	public String getCheckReleasedBy() {
		return checkReleasedBy;
	}

	public void setCheckReleasedBy(String checkReleasedBy) {
		this.checkReleasedBy = checkReleasedBy;
	}

	public Date getCheckReleaseDate() {
		return checkReleaseDate;
	}

	public void setCheckReleaseDate(Date checkReleaseDate) {
		this.checkReleaseDate = checkReleaseDate;
	}

	public String getCheckStatMean() {
		return checkStatMean;
	}

	public void setCheckStatMean(String checkStatMean) {
		this.checkStatMean = checkStatMean;
	}

	public String getCheckClassMean() {
		return checkClassMean;
	}

	public void setCheckClassMean(String checkClassMean) {
		this.checkClassMean = checkClassMean;
	}

	public Date getCheckPrintDate() {
		return checkPrintDate;
	}

	public void setCheckPrintDate(Date checkPrintDate) {
		this.checkPrintDate = checkPrintDate;
	}

	public String getStrCheckPrintDate() {
		return strCheckPrintDate;
	}

	public void setStrCheckPrintDate(String strCheckPrintDate) {
		this.strCheckPrintDate = strCheckPrintDate;
	}

	public String getDisbMode() {
		return disbMode;
	}

	public void setDisbMode(String disbMode) {
		this.disbMode = disbMode;
	}

	public BigDecimal getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(BigDecimal totalAmount) {
		this.totalAmount = totalAmount;
	}

	public String getPayeeClassCd() {
		return payeeClassCd;
	}

	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
	}

	public Integer getPayeeNo() {
		return payeeNo;
	}

	public void setPayeeNo(Integer payeeNo) {
		this.payeeNo = payeeNo;
	}

	public String getBankAcctNo() {
		return bankAcctNo;
	}

	public void setBankAcctNo(String bankAcctNo) {
		this.bankAcctNo = bankAcctNo;
	}

	public BigDecimal getfCurrencyAmt() {
		return fCurrencyAmt;
	}

	public void setfCurrencyAmt(BigDecimal fCurrencyAmt) {
		this.fCurrencyAmt = fCurrencyAmt;
	}

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	public String getBankAcctCd() {
		return bankAcctCd;
	}

	public void setBankAcctCd(String bankAcctCd) {
		this.bankAcctCd = bankAcctCd;
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

	public String getCheckClass() {
		return checkClass;
	}

	public void setCheckClass(String checkClass) {
		this.checkClass = checkClass;
	}

	public String getDspCurrency() {
		return dspCurrency;
	}

	public void setDspCurrency(String dspCurrency) {
		this.dspCurrency = dspCurrency;
	}

	public String getDspBankSname() {
		return dspBankSname;
	}

	public void setDspBankSname(String dspBankSname) {
		this.dspBankSname = dspBankSname;
	}

	public String getDspBankAcct() {
		return dspBankAcct;
	}

	public void setDspBankAcct(String dspBankAcct) {
		this.dspBankAcct = dspBankAcct;
	}

	public String getDspDVNo() {
		return dspDVNo;
	}

	public void setDspDVNo(String dspDVNo) {
		this.dspDVNo = dspDVNo;
	}

	public Integer getDspLocalCurrency() {
		return dspLocalCurrency;
	}

	public void setDspLocalCurrency(Integer dspLocalCurrency) {
		this.dspLocalCurrency = dspLocalCurrency;
	}

	public String getNbtDVParticulars() {
		return nbtDVParticulars;
	}

	public void setNbtDVParticulars(String nbtDVParticulars) {
		this.nbtDVParticulars = nbtDVParticulars;
	}
	
    public String getPayee() {
		return payee;
	}

	public void setPayee(String payee) {
		this.payee = payee;
	}

	public String getDspCheckNo() {
		return dspCheckNo;
	}

	public void setDspCheckNo(String dspCheckNo) {
		this.dspCheckNo = dspCheckNo;
	}

	/**
	 * @return the checkStat
	 */
	public String getCheckStat() {
		return checkStat;
	}

	/**
	 * @param checkStat the checkStat to set
	 */
	public void setCheckStat(String checkStat) {
		this.checkStat = checkStat;
	}

	/**
	 * @return the checkDate
	 */
	public Date getCheckDate() {
		return checkDate;
	}

	/**
	 * @param checkDate the checkDate to set
	 */
	public void setCheckDate(Date checkDate) {
		this.checkDate = checkDate;
	}

	/**
	 * @return the checkPrefSuf
	 */
	public String getCheckPrefSuf() {
		return checkPrefSuf;
	}

	/**
	 * @param checkPrefSuf the checkPrefSuf to set
	 */
	public void setCheckPrefSuf(String checkPrefSuf) {
		this.checkPrefSuf = checkPrefSuf;
	}

	/**
	 * @return the checkNo
	 */
	public Long getCheckNo() {
		return checkNo;
	}

	/**
	 * @param checkNo the checkNo to set
	 */
	public void setCheckNo(Long checkNo) {
		this.checkNo = checkNo;
	}

	/**
	 * @return the gaccTranId
	 */
	public Integer getGaccTranId() {
		return gaccTranId;
	}

	/**
	 * @param gaccTranId the gaccTranId to set
	 */
	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}

	/**
	 * @return the itemNo
	 */
	public Integer getItemNo() {
		return itemNo;
	}

	/**
	 * @param itemNo the itemNo to set
	 */
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	/**
	 * @return the dspCheckFlagMean
	 */
	public String getDspCheckFlagMean() {
		return dspCheckFlagMean;
	}

	/**
	 * @param dspCheckFlagMean the dspCheckFlagMean to set
	 */
	public void setDspCheckFlagMean(String dspCheckFlagMean) {
		this.dspCheckFlagMean = dspCheckFlagMean;
	}

	public String getStrCheckDate() {
		return strCheckDate;
	}

	public void setStrCheckDate(String strCheckDate) {
		this.strCheckDate = strCheckDate;
	}

	public String getStrLastUpdate2() {
		return strLastUpdate2;
	}

	public void setStrLastUpdate2(String strLastUpdate2) {
		this.strLastUpdate2 = strLastUpdate2;
	}

	public String getCheckReceivedBy() {
		return checkReceivedBy;
	}

	public void setCheckReceivedBy(String checkReceivedBy) {
		this.checkReceivedBy = checkReceivedBy;
	}

	public String getBatchTag() {
		return batchTag;
	}

	public void setBatchTag(String batchTag) {
		this.batchTag = batchTag;
	}
    
    
}
