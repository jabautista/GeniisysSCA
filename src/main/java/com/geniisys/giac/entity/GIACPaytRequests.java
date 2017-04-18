package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACPaytRequests extends BaseEntity{

	private Integer goucOucId;    
	private Integer refId;         
	private String fundCd;         
	private String branchCd;       
	private String documentCd;     
	private Integer docSeqNo;     
	private Date requestDate;      
	private String lineCd;         
	private Integer docYear;       
	private Integer docMm;         
	private Integer cpiRecNo;     
	private String cpiBranchCd;   
	private String withDv;         
	private String createBy;       
	private String uploadTag;      
	private String rfReplenishTag;
	
	private String dspDeptCd;
	private String dspFundDesc;
	private String dspBranchName;
	private String dspOucName;
	
	// additional for GIACS002
	private String paytReqNo;
	private String documentName;
	private Integer tranId;
	private Integer reqDtlNo;
	private String payeeClassCd;
	private String classDesc;
	private Integer payeeCd;
	private String payee;
	private BigDecimal paytAmt;
	private String particulars;
	private String currencyDesc;
	private Integer currencyCd;
	private BigDecimal dvFcurrencyAmt;
	private BigDecimal currencyRt; // bonok :: 4.12.2016 :: UCPB SR 21793 :: changed data type from Float to BigDecimal to properly retrieve all decimal places
	
	
	public Integer getGoucOucId() {
		return goucOucId;
	}
	public void setGoucOucId(Integer goucOucId) {
		this.goucOucId = goucOucId;
	}
	public Integer getRefId() {
		return refId;
	}
	public void setRefId(Integer refId) {
		this.refId = refId;
	}
	public String getFundCd() {
		return fundCd;
	}
	public void setFundCd(String fundCd) {
		this.fundCd = fundCd;
	}
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	public String getDocumentCd() {
		return documentCd;
	}
	public void setDocumentCd(String documentCd) {
		this.documentCd = documentCd;
	}
	public Integer getDocSeqNo() {
		return docSeqNo;
	}
	public void setDocSeqNo(Integer docSeqNo) {
		this.docSeqNo = docSeqNo;
	}
	public Date getRequestDate() {
		return requestDate;
	}
	public Object getStrRequestDate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (requestDate != null) {
			return df.format(requestDate);			
		} else {
			return null;
		}
	}
	public void setRequestDate(Date requestDate) {
		this.requestDate = requestDate;
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
	public String getWithDv() {
		return withDv;
	}
	public void setWithDv(String withDv) {
		this.withDv = withDv;
	}
	public String getCreateBy() {
		return createBy;
	}
	public void setCreateBy(String createBy) {
		this.createBy = createBy;
	}
	public String getUploadTag() {
		return uploadTag;
	}
	public void setUploadTag(String uploadTag) {
		this.uploadTag = uploadTag;
	}
	public String getRfReplenishTag() {
		return rfReplenishTag;
	}
	public void setRfReplenishTag(String rfReplenishTag) {
		this.rfReplenishTag = rfReplenishTag;
	}
	public String getDspDeptCd() {
		return dspDeptCd;
	}
	public void setDspDeptCd(String dspDeptCd) {
		this.dspDeptCd = dspDeptCd;
	}
	public String getDspFundDesc() {
		return dspFundDesc;
	}
	public void setDspFundDesc(String dspFundDesc) {
		this.dspFundDesc = dspFundDesc;
	}
	public String getDspBranchName() {
		return dspBranchName;
	}
	public void setDspBranchName(String dspBranchName) {
		this.dspBranchName = dspBranchName;
	}
	public String getDspOucName() {
		return dspOucName;
	}
	public void setDspOucName(String dspOucName) {
		this.dspOucName = dspOucName;
	}
	
	
	public String getPaytReqNo() {
		return paytReqNo;
	}
	public void setPaytReqNo(String paytReqNo) {
		this.paytReqNo = paytReqNo;
	}
	public String getDocumentName() {
		return documentName;
	}
	public void setDocumentName(String documentName) {
		this.documentName = documentName;
	}
	public Integer getTranId() {
		return tranId;
	}
	public void setTranId(Integer tranId) {
		this.tranId = tranId;
	}
	public Integer getReqDtlNo() {
		return reqDtlNo;
	}
	public void setReqDtlNo(Integer reqDtlNo) {
		this.reqDtlNo = reqDtlNo;
	}
	public String getPayeeClassCd() {
		return payeeClassCd;
	}
	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
	}
	public String getClassDesc() {
		return classDesc;
	}
	public void setClassDesc(String classDesc) {
		this.classDesc = classDesc;
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
	public BigDecimal getPaytAmt() {
		return paytAmt;
	}
	public void setPaytAmt(BigDecimal paytAmt) {
		this.paytAmt = paytAmt;
	}
	public String getParticulars() {
		return particulars;
	}
	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}
	public String getCurrencyDesc() {
		return currencyDesc;
	}
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public BigDecimal getDvFcurrencyAmt() {
		return dvFcurrencyAmt;
	}
	public void setDvFcurrencyAmt(BigDecimal dvFcurrencyAmt) {
		this.dvFcurrencyAmt = dvFcurrencyAmt;
	}
	// bonok :: 4.12.2016 :: UCPB SR 21793 :: changed data type from Float to BigDecimal to properly retrieve all decimal places
	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}
	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}
	
}
