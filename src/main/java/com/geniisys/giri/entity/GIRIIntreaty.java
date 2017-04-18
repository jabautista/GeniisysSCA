package com.geniisys.giri.entity;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import com.geniisys.framework.util.BaseEntity;

public class GIRIIntreaty extends BaseEntity {
	private Integer intreatyId;
	private String lineCd;
	private Integer trtyYy;
	private Integer intrtySeqNo;
	private Integer riCd;
	private Date acceptDate;
	private String approveBy;
	private Date approveDate;
	private String cancelUser;
	private Date cancelDate;
	private Date acctEntDate;
	private Date acctNegDate;
	private String bookingMth;
	private Integer bookingYy;
	private String tranType;
	private Integer tranNo;
	private Integer currencyCd;
	private BigDecimal currencyRt;
	private BigDecimal riPremAmt;
	private BigDecimal riCommRt;
	private BigDecimal riCommAmt;
	private BigDecimal riVatRt;
	private BigDecimal riCommVat;
	private BigDecimal clmLossPdAmt;
	private BigDecimal clmLossExpAmt;
	private BigDecimal clmRecoverableAmt;
	private BigDecimal chargeAmount;
	private Integer intrtyFlag;
	private Integer shareCd;
	
	public Integer getIntreatyId() {
		return intreatyId;
	}
	public void setIntreatyId(Integer intreatyId) {
		this.intreatyId = intreatyId;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public Integer getTrtyYy() {
		return trtyYy;
	}
	public void setTrtyYy(Integer trtyYy) {
		this.trtyYy = trtyYy;
	}
	public Integer getIntrtySeqNo() {
		return intrtySeqNo;
	}
	public void setIntrtySeqNo(Integer intrtySeqNo) {
		this.intrtySeqNo = intrtySeqNo;
	}
	public Integer getRiCd() {
		return riCd;
	}
	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}
	public Date getAcceptDate() {
		return acceptDate;
	}
	public void setAcceptDate(Date acceptDate) {
		this.acceptDate = acceptDate;
	}
	public String getApproveBy() {
		return approveBy;
	}
	public void setApproveBy(String approveBy) {
		this.approveBy = approveBy;
	}
	public Date getApproveDate() {
		return approveDate;
	}
	public void setApproveDate(Date approveDate) {
		this.approveDate = approveDate;
	}
	public String getCancelUser() {
		return cancelUser;
	}
	public void setCancelUser(String cancelUser) {
		this.cancelUser = cancelUser;
	}
	public Date getCancelDate() {
		return cancelDate;
	}
	public void setCancelDate(Date cancelDate) {
		this.cancelDate = cancelDate;
	}
	public Date getAcctEntDate() {
		return acctEntDate;
	}
	public void setAcctEntDate(Date acctEntDate) {
		this.acctEntDate = acctEntDate;
	}
	public Date getAcctNegDate() {
		return acctNegDate;
	}
	public void setAcctNegDate(Date acctNegDate) {
		this.acctNegDate = acctNegDate;
	}
	public String getBookingMth() {
		return bookingMth;
	}
	public void setBookingMth(String bookingMth) {
		this.bookingMth = bookingMth;
	}
	public Integer getBookingYy() {
		return bookingYy;
	}
	public void setBookingYy(Integer bookingYy) {
		this.bookingYy = bookingYy;
	}
	public String getTranType() {
		return tranType;
	}
	public void setTranType(String tranType) {
		this.tranType = tranType;
	}
	public Integer getTranNo() {
		return tranNo;
	}
	public void setTranNo(Integer tranNo) {
		this.tranNo = tranNo;
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
	public BigDecimal getRiPremAmt() {
		return riPremAmt;
	}
	public void setRiPremAmt(BigDecimal riPremAmt) {
		this.riPremAmt = riPremAmt;
	}
	public BigDecimal getRiCommRt() {
		return riCommRt;
	}
	public void setRiCommRt(BigDecimal riCommRt) {
		this.riCommRt = riCommRt;
	}
	public BigDecimal getRiCommAmt() {
		return riCommAmt;
	}
	public void setRiCommAmt(BigDecimal riCommAmt) {
		this.riCommAmt = riCommAmt;
	}
	public BigDecimal getRiVatRt() {
		return riVatRt;
	}
	public void setRiVatRt(BigDecimal riVatRt) {
		this.riVatRt = riVatRt;
	}
	public BigDecimal getRiCommVat() {
		return riCommVat;
	}
	public void setRiCommVat(BigDecimal riCommVat) {
		this.riCommVat = riCommVat;
	}
	public BigDecimal getClmLossPdAmt() {
		return clmLossPdAmt;
	}
	public void setClmLossPdAmt(BigDecimal clmLossPdAmt) {
		this.clmLossPdAmt = clmLossPdAmt;
	}
	public BigDecimal getClmLossExpAmt() {
		return clmLossExpAmt;
	}
	public void setClmLossExpAmt(BigDecimal clmLossExpAmt) {
		this.clmLossExpAmt = clmLossExpAmt;
	}
	public BigDecimal getClmRecoverableAmt() {
		return clmRecoverableAmt;
	}
	public void setClmRecoverableAmt(BigDecimal clmRecoverableAmt) {
		this.clmRecoverableAmt = clmRecoverableAmt;
	}
	public BigDecimal getChargeAmount() {
		return chargeAmount;
	}
	public void setChargeAmount(BigDecimal chargeAmount) {
		this.chargeAmount = chargeAmount;
	}
	public Integer getIntrtyFlag() {
		return intrtyFlag;
	}
	public void setIntrtyFlag(Integer intrtyFlag) {
		this.intrtyFlag = intrtyFlag;
	}
	public Integer getShareCd() {
		return shareCd;
	}
	public void setShareCd(Integer shareCd) {
		this.shareCd = shareCd;
	}
	public String getStrAcceptDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(acceptDate != null){
			return sdf.format(acceptDate).toString();
		} else {
			return null;
		}
	}
	public void setStrAcceptDate(String strAcceptDate) {
	}
	public String getStrApproveDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(approveDate != null){
			return sdf.format(approveDate).toString();
		} else {
			return null;
		}
	}
	public void setStrApproveDate(String strApproveDate) {
	}
	public String getStrCancelDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(cancelDate != null){
			return sdf.format(cancelDate).toString();
		} else {
			return null;
		}
	}
	public void setStrCancelDate(String strCancelDate) {
	}
}
