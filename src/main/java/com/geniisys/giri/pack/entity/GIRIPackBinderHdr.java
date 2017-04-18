package com.geniisys.giri.pack.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIRIPackBinderHdr extends BaseEntity{

	private Integer packPolicyId;
	private Integer packBinderId;
	private String lineCd;
	private Integer binderYy;
	private Integer binderSeqNo;
	private Integer riCd;
	private BigDecimal riTsiAmt;
	private BigDecimal riPremAmt;
	private BigDecimal riShrPct;
	private BigDecimal riCommRt;
	private BigDecimal riCommAmt;
	private BigDecimal premTax;
	private BigDecimal riPremVat;
	private BigDecimal riCommVat;
	private BigDecimal riWholdingVat;
	private String reverseTag;
	private String acceptBy;
	private Date acceptDate;
	private String strAcceptDate;
	private String attention;
	private String remarks;
	private Integer currencyCd;
	private BigDecimal currencyRt;
	private BigDecimal tsiAmt;
	private Date binderDate;
	private String strBinderDate;
	private String asNo;
	private BigDecimal premAmt;
	
	private String dspPackBinderNo;

	public Integer getPackPolicyId() {
		return packPolicyId;
	}

	public void setPackPolicyId(Integer packPolicyId) {
		this.packPolicyId = packPolicyId;
	}

	public Integer getPackBinderId() {
		return packBinderId;
	}

	public void setPackBinderId(Integer packBinderId) {
		this.packBinderId = packBinderId;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public Integer getBinderYy() {
		return binderYy;
	}

	public void setBinderYy(Integer binderYy) {
		this.binderYy = binderYy;
	}

	public Integer getBinderSeqNo() {
		return binderSeqNo;
	}

	public void setBinderSeqNo(Integer binderSeqNo) {
		this.binderSeqNo = binderSeqNo;
	}

	public Integer getRiCd() {
		return riCd;
	}

	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}

	public BigDecimal getRiTsiAmt() {
		return riTsiAmt;
	}

	public void setRiTsiAmt(BigDecimal riTsiAmt) {
		this.riTsiAmt = riTsiAmt;
	}

	public BigDecimal getRiPremAmt() {
		return riPremAmt;
	}

	public void setRiPremAmt(BigDecimal riPremAmt) {
		this.riPremAmt = riPremAmt;
	}

	public BigDecimal getRiShrPct() {
		return riShrPct;
	}

	public void setRiShrPct(BigDecimal riShrPct) {
		this.riShrPct = riShrPct;
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

	public BigDecimal getPremTax() {
		return premTax;
	}

	public void setPremTax(BigDecimal premTax) {
		this.premTax = premTax;
	}

	public BigDecimal getRiPremVat() {
		return riPremVat;
	}

	public void setRiPremVat(BigDecimal riPremVat) {
		this.riPremVat = riPremVat;
	}

	public BigDecimal getRiCommVat() {
		return riCommVat;
	}

	public void setRiCommVat(BigDecimal riCommVat) {
		this.riCommVat = riCommVat;
	}

	public BigDecimal getRiWholdingVat() {
		return riWholdingVat;
	}

	public void setRiWholdingVat(BigDecimal riWholdingVat) {
		this.riWholdingVat = riWholdingVat;
	}

	public String getReverseTag() {
		return reverseTag;
	}

	public void setReverseTag(String reverseTag) {
		this.reverseTag = reverseTag;
	}

	public String getAcceptBy() {
		return acceptBy;
	}

	public void setAcceptBy(String acceptBy) {
		this.acceptBy = acceptBy;
	}

	public Date getAcceptDate() {
		return acceptDate;
	}

	public void setAcceptDate(Date acceptDate) {
		this.acceptDate = acceptDate;
	}

	public String getStrAcceptDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (acceptDate != null){
			return df.format(acceptDate);
		}else{
			return strAcceptDate;
		}
	}

	public void setStrAcceptDate(String strAcceptDate) {
		this.strAcceptDate = strAcceptDate;
	}

	public String getStrBinderDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (binderDate != null){
			return df.format(binderDate);
		}else{
			return strBinderDate;
		}
	}

	public void setStrBinderDate(String strBinderDate) {
		this.strBinderDate = strBinderDate;
	}

	public String getAttention() {
		return attention;
	}

	public void setAttention(String attention) {
		this.attention = attention;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
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

	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}

	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}

	public Date getBinderDate() {
		return binderDate;
	}

	public void setBinderDate(Date binderDate) {
		this.binderDate = binderDate;
	}

	public String getAsNo() {
		return asNo;
	}

	public void setAsNo(String asNo) {
		this.asNo = asNo;
	}

	public BigDecimal getPremAmt() {
		return premAmt;
	}

	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}

	public String getDspPackBinderNo() {
		return dspPackBinderNo;
	}

	public void setDspPackBinderNo(String dspPackBinderNo) {
		this.dspPackBinderNo = dspPackBinderNo;
	}
	
}
