package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACUploadFile extends BaseEntity {

	private String sourceCd;
	private Integer fileNo;
	private String fileName;
	private Date convertDate;
	private String transactionType;
	private Date uploadDate;
	private String fileStatus;
	private BigDecimal hashBill;
	private BigDecimal hashCollection;
	private Integer noOfRecords;
	private String tranClass;
	private Integer tranId;
	private Date tranDate;
	private Date paymentDate;
	private String userId;
	private Date lastUpdate;
	private String remarks;
	private Integer intmNo;
	private String grossTag;
	private Date cancelDate;
	private Integer riCd;
	private String completeSw;
	
	public GIACUploadFile(){
		
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

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public Date getConvertDate() {
		return convertDate;
	}

	public void setConvertDate(Date convertDate) {
		this.convertDate = convertDate;
	}

	public String getTransactionType() {
		return transactionType;
	}

	public void setTransactionType(String transactionType) {
		this.transactionType = transactionType;
	}

	public Date getUploadDate() {
		return uploadDate;
	}

	public void setUploadDate(Date uploadDate) {
		this.uploadDate = uploadDate;
	}

	public String getFileStatus() {
		return fileStatus;
	}

	public void setFileStatus(String fileStatus) {
		this.fileStatus = fileStatus;
	}

	public BigDecimal getHashBill() {
		return hashBill;
	}

	public void setHashBill(BigDecimal hashBill) {
		this.hashBill = hashBill;
	}

	public BigDecimal getHashCollection() {
		return hashCollection;
	}

	public void setHashCollection(BigDecimal hashCollection) {
		this.hashCollection = hashCollection;
	}

	public Integer getNoOfRecords() {
		return noOfRecords;
	}

	public void setNoOfRecords(Integer noOfRecords) {
		this.noOfRecords = noOfRecords;
	}

	public String getTranClass() {
		return tranClass;
	}

	public void setTranClass(String tranClass) {
		this.tranClass = tranClass;
	}

	public Integer getTranId() {
		return tranId;
	}

	public void setTranId(Integer tranId) {
		this.tranId = tranId;
	}

	public Date getTranDate() {
		return tranDate;
	}

	public void setTranDate(Date tranDate) {
		this.tranDate = tranDate;
	}

	public Date getPaymentDate() {
		return paymentDate;
	}

	public void setPaymentDate(Date paymentDate) {
		this.paymentDate = paymentDate;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Date getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public Integer getIntmNo() {
		return intmNo;
	}

	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}

	public String getGrossTag() {
		return grossTag;
	}

	public void setGrossTag(String grossTag) {
		this.grossTag = grossTag;
	}

	public Date getCancelDate() {
		return cancelDate;
	}

	public void setCancelDate(Date cancelDate) {
		this.cancelDate = cancelDate;
	}

	public Integer getRiCd() {
		return riCd;
	}

	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}

	public String getCompleteSw() {
		return completeSw;
	}

	public void setCompleteSw(String completeSw) {
		this.completeSw = completeSw;
	}

}
