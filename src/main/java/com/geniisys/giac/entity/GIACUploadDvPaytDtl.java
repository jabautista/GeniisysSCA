
package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;

public class GIACUploadDvPaytDtl extends BaseEntity {

	private String sourceCd;
	private Integer fileNo;
	private String documentCd;
	private String branchCd;
	private String lineCd;
	private Integer docYear;
	private Integer docMm;
	private Integer docSeqNo;
	private Integer goucOucId;
	private String requestDate;
	private String payeeClassCd;
	private Integer payeeCd;
	private String payee;
	private String particulars;
	private BigDecimal dvFcurrencyAmt;
	private BigDecimal currencyRt;
	private BigDecimal paytAmt;
	private Integer currencyCd;
	private Integer tranId;
	
	public GIACUploadDvPaytDtl(){
		
	}
	
	public GIACUploadDvPaytDtl(String sourceCd, Integer fileNo,
			String documentCd, String branchCd, String lineCd, Integer docYear,
			Integer docMm, Integer docSeqNo, Integer goucOucId,
			String requestDate, String payeeClassCd, Integer payeeCd,
			String payee, String particulars, BigDecimal dvFcurrencyAmt,
			BigDecimal currencyRt, BigDecimal paytAmt, Integer currencyCd,
			Integer tranId) {
		super();
		this.sourceCd = sourceCd;
		this.fileNo = fileNo;
		this.documentCd = documentCd;
		this.branchCd = branchCd;
		this.lineCd = lineCd;
		this.docYear = docYear;
		this.docMm = docMm;
		this.docSeqNo = docSeqNo;
		this.goucOucId = goucOucId;
		this.requestDate = requestDate;
		this.payeeClassCd = payeeClassCd;
		this.payeeCd = payeeCd;
		this.payee = payee;
		this.particulars = particulars;
		this.dvFcurrencyAmt = dvFcurrencyAmt;
		this.currencyRt = currencyRt;
		this.paytAmt = paytAmt;
		this.currencyCd = currencyCd;
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
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public Integer getDocYear() {
		return docYear;
	}
	public void setDocYear(Integer docYear) {
		this.docYear = docYear;
	}
	public Integer getDocMm() {
		return docMm;
	}
	public void setDocMm(Integer docMm) {
		this.docMm = docMm;
	}
	public Integer getDocSeqNo() {
		return docSeqNo;
	}
	public void setDocSeqNo(Integer docSeqNo) {
		this.docSeqNo = docSeqNo;
	}
	public Integer getGoucOucId() {
		return goucOucId;
	}
	public void setGoucOucId(Integer goucOucId) {
		this.goucOucId = goucOucId;
	}
	public String getRequestDate() {
		return requestDate;
	}
	public void setRequestDate(String requestDate) {
		this.requestDate = requestDate;
	}
	public String getPayeeClassCd() {
		return payeeClassCd;
	}
	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
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
	public String getParticulars() {
		return particulars;
	}
	public void setParticulars(String particulars) {
		this.particulars = particulars;
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
	public BigDecimal getPaytAmt() {
		return paytAmt;
	}
	public void setPaytAmt(BigDecimal paytAmt) {
		this.paytAmt = paytAmt;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public Integer getTranId() {
		return tranId;
	}
	public void setTranId(Integer tranId) {
		this.tranId = tranId;
	}
	public String getDocumentCd() {
		return documentCd;
	}
	public void setDocumentCd(String documentCd) {
		this.documentCd = documentCd;
	}
	
}
