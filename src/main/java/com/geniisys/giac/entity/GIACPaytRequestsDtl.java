package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACPaytRequestsDtl extends BaseEntity{

	private Integer reqDtlNo;
	private Integer gprqRefId;
	private String payeeClassCd;
	private String paytReqFlag;
	private Integer payeeCd;
	private String payee;
	private Integer currencyCd;
	private BigDecimal paytAmt;
	private Integer tranId;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String particulars;
	private String cancelBy;
	private Date cancelDate;
	private BigDecimal dvFcurrencyAmt;
	private BigDecimal currencyRt;
	private String commTag;
	private Integer replenishId;
	
	private String dspFshortName;
	private String dspShortName;
	private String meanPaytReqFlag;
	private String nbtReplenishNo;
	private BigDecimal nbtReplenishAmt;
	private String acctEntExist;
	private String strLastUpdate;
	
	public Integer getReqDtlNo() {
		return reqDtlNo;
	}
	public void setReqDtlNo(Integer reqDtlNo) {
		this.reqDtlNo = reqDtlNo;
	}
	public Integer getGprqRefId() {
		return gprqRefId;
	}
	public void setGprqRefId(Integer gprqRefId) {
		this.gprqRefId = gprqRefId;
	}
	public String getPayeeClassCd() {
		return payeeClassCd;
	}
	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
	}
	public String getPaytReqFlag() {
		return paytReqFlag;
	}
	public void setPaytReqFlag(String paytReqFlag) {
		this.paytReqFlag = paytReqFlag;
	}
	public Integer getPayeeCd() {
		return payeeCd;
	}
	public void setPayeeCd(Integer payeeCd) {
		this.payeeCd = payeeCd;
	}
	public String getPayee() {
		return payee;
	}
	public void setPayee(String payee) {
		this.payee = payee;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public BigDecimal getPaytAmt() {
		return paytAmt;
	}
	public void setPaytAmt(BigDecimal paytAmt) {
		this.paytAmt = paytAmt;
	}
	public Integer getTranId() {
		return tranId;
	}
	public void setTranId(Integer tranId) {
		this.tranId = tranId;
	}
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	public String getParticulars() {
		return particulars;
	}
	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}
	public String getCancelBy() {
		return cancelBy;
	}
	public void setCancelBy(String cancelBy) {
		this.cancelBy = cancelBy;
	}
	public Date getCancelDate() {
		return cancelDate;
	}
	public Object getStrCancelDate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (cancelDate != null) {
			return df.format(cancelDate);			
		} else {
			return null;
		}
	}
	public void setCancelDate(Date cancelDate) {
		this.cancelDate = cancelDate;
	}
	public BigDecimal getDvFcurrencyAmt() {
		return dvFcurrencyAmt;
	}
	public void setDvFcurrencyAmt(BigDecimal dvFcurrencyAmt) {
		this.dvFcurrencyAmt = dvFcurrencyAmt;
	}
	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}
	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}
	public String getCommTag() {
		return commTag;
	}
	public void setCommTag(String commTag) {
		this.commTag = commTag;
	}
	public Integer getReplenishId() {
		return replenishId;
	}
	public void setReplenishId(Integer replenishId) {
		this.replenishId = replenishId;
	}
	public String getDspFshortName() {
		return dspFshortName;
	}
	public void setDspFshortName(String dspFshortName) {
		this.dspFshortName = dspFshortName;
	}
	public String getDspShortName() {
		return dspShortName;
	}
	public void setDspShortName(String dspShortName) {
		this.dspShortName = dspShortName;
	}
	public String getMeanPaytReqFlag() {
		return meanPaytReqFlag;
	}
	public void setMeanPaytReqFlag(String meanPaytReqFlag) {
		this.meanPaytReqFlag = meanPaytReqFlag;
	}
	public String getNbtReplenishNo() {
		return nbtReplenishNo;
	}
	public void setNbtReplenishNo(String nbtReplenishNo) {
		this.nbtReplenishNo = nbtReplenishNo;
	}
	public BigDecimal getNbtReplenishAmt() {
		return nbtReplenishAmt;
	}
	public void setNbtReplenishAmt(BigDecimal nbtReplenishAmt) {
		this.nbtReplenishAmt = nbtReplenishAmt;
	}
	public String getAcctEntExist() {
		return acctEntExist;
	}
	public void setAcctEntExist(String acctEntExist) {
		this.acctEntExist = acctEntExist;
	}
	public String getStrLastUpdate() {
		return strLastUpdate;
	}
	public void setStrLastUpdate(String strLastUpdate) {
		this.strLastUpdate = strLastUpdate;
	}
	
}
