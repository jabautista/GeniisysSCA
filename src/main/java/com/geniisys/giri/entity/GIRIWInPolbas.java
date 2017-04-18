package com.geniisys.giri.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIRIWInPolbas extends BaseEntity {

	private Integer acceptNo;
	private Integer parId;
	private Integer riCd;
	private String acceptDate;
	private String riPolicyNo;
	private String riEndtNo;
	private String riBinderNo;
	private Integer writerCd;
	private String offerDate;
	private String acceptBy;
	private BigDecimal origTsiAmt;
	private BigDecimal origPremAmt;
	private String remarks;
	private String refAcceptNo;
	private Integer packAcceptNo;
	private Integer packPolicyId;
	private String offeredBy;
	private BigDecimal amountOffered;
	private Integer packParId;
	private Date oarPrintDate;
	
	private String writerCdName;
	private String riCdName;

	public Integer getAcceptNo() {
		return acceptNo;
	}

	public void setAcceptNo(Integer acceptNo) {
		this.acceptNo = acceptNo;
	}

	public Integer getParId() {
		return parId;
	}

	public void setParId(Integer parId) {
		this.parId = parId;
	}

	public Integer getRiCd() {
		return riCd;
	}

	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}

	public String getAcceptDate() {
		return acceptDate;
	}

	public void setAcceptDate(String acceptDate) {
		this.acceptDate = acceptDate;
	}

	public String getRiPolicyNo() {
		return riPolicyNo;
	}

	public void setRiPolicyNo(String riPolicyNo) {
		this.riPolicyNo = riPolicyNo;
	}

	public String getRiEndtNo() {
		return riEndtNo;
	}

	public void setRiEndtNo(String riEndtNo) {
		this.riEndtNo = riEndtNo;
	}

	public String getRiBinderNo() {
		return riBinderNo;
	}

	public void setRiBinderNo(String riBinderNo) {
		this.riBinderNo = riBinderNo;
	}

	public Integer getWriterCd() {
		return writerCd;
	}

	public void setWriterCd(Integer writerCd) {
		this.writerCd = writerCd;
	}

	public String getOfferDate() {
		return offerDate;
	}

	public void setOfferDate(String offerDate) {
		this.offerDate = offerDate;
	}

	public String getAcceptBy() {
		return acceptBy;
	}

	public void setAcceptBy(String acceptBy) {
		this.acceptBy = acceptBy;
	}

	public BigDecimal getOrigTsiAmt() {
		return origTsiAmt;
	}

	public void setOrigTsiAmt(BigDecimal origTsiAmt) {
		this.origTsiAmt = origTsiAmt;
	}

	public BigDecimal getOrigPremAmt() {
		return origPremAmt;
	}

	public void setOrigPremAmt(BigDecimal origPremAmt) {
		this.origPremAmt = origPremAmt;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getRefAcceptNo() {
		return refAcceptNo;
	}

	public void setRefAcceptNo(String refAcceptNo) {
		this.refAcceptNo = refAcceptNo;
	}

	public Integer getPackAcceptNo() {
		return packAcceptNo;
	}

	public void setPackAcceptNo(Integer packAcceptNo) {
		this.packAcceptNo = packAcceptNo;
	}

	public Integer getPackPolicyId() {
		return packPolicyId;
	}

	public void setPackPolicyId(Integer packPolicyId) {
		this.packPolicyId = packPolicyId;
	}

	public String getOfferedBy() {
		return offeredBy;
	}

	public void setOfferedBy(String offeredBy) {
		this.offeredBy = offeredBy;
	}

	public BigDecimal getAmountOffered() {
		return amountOffered;
	}

	public void setAmountOffered(BigDecimal amountOffered) {
		this.amountOffered = amountOffered;
	}

	public Integer getPackParId() {
		return packParId;
	}

	public void setPackParId(Integer packParId) {
		this.packParId = packParId;
	}

	public Date getOarPrintDate() {
		return oarPrintDate;
	}

	public void setOarPrintDate(Date oarPrintDate) {
		this.oarPrintDate = oarPrintDate;
	}

	public String getWriterCdName() {
		return writerCdName;
	}

	public void setWriterCdName(String writerCdName) {
		this.writerCdName = writerCdName;
	}

	public String getRiCdName() {
		return riCdName;
	}

	public void setRiCdName(String riCdName) {
		this.riCdName = riCdName;
	}

}
