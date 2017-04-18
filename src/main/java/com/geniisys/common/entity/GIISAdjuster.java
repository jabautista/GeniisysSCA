package com.geniisys.common.entity;

import java.util.Date;

import com.geniisys.giis.entity.BaseEntity;

public class GIISAdjuster extends BaseEntity {

	private Integer adjCompanyCd;
	private Integer privAdjCd;
	private String payeeName;
	private Date entryDate;
	private String locCd;
	private String payeeClassCd;
	private String lineCd;
	private String mailAddr;
	private String billAddr;
	private String contactPers;
	private String designation;
	private String phoneNo;
	private String lfSw;
	private String attention;
	private String selectSw;
	private Date lastSelectDate;
	private String remarks;
	
	
	public Integer getAdjCompanyCd() {
		return adjCompanyCd;
	}
	public void setAdjCompanyCd(Integer adjCompanyCd) {
		this.adjCompanyCd = adjCompanyCd;
	}
	public Integer getPrivAdjCd() {
		return privAdjCd;
	}
	public void setPrivAdjCd(Integer privAdjCd) {
		this.privAdjCd = privAdjCd;
	}
	public String getPayeeName() {
		return payeeName;
	}
	public void setPayeeName(String payeeName) {
		this.payeeName = payeeName;
	}
	public Date getEntryDate() {
		return entryDate;
	}
	public void setEntryDate(Date entryDate) {
		this.entryDate = entryDate;
	}
	public String getLocCd() {
		return locCd;
	}
	public void setLocCd(String locCd) {
		this.locCd = locCd;
	}
	public String getPayeeClassCd() {
		return payeeClassCd;
	}
	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getMailAddr() {
		return mailAddr;
	}
	public void setMailAddr(String mailAddr) {
		this.mailAddr = mailAddr;
	}
	public String getBillAddr() {
		return billAddr;
	}
	public void setBillAddr(String billAddr) {
		this.billAddr = billAddr;
	}
	public String getContactPers() {
		return contactPers;
	}
	public void setContactPers(String contactPers) {
		this.contactPers = contactPers;
	}
	public String getDesignation() {
		return designation;
	}
	public void setDesignation(String designation) {
		this.designation = designation;
	}
	public String getPhoneNo() {
		return phoneNo;
	}
	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}
	public String getLfSw() {
		return lfSw;
	}
	public void setLfSw(String lfSw) {
		this.lfSw = lfSw;
	}
	public String getAttention() {
		return attention;
	}
	public void setAttention(String attention) {
		this.attention = attention;
	}
	public String getSelectSw() {
		return selectSw;
	}
	public void setSelectSw(String selectSw) {
		this.selectSw = selectSw;
	}
	public Date getLastSelectDate() {
		return lastSelectDate;
	}
	public void setLastSelectDate(Date lastSelectDate) {
		this.lastSelectDate = lastSelectDate;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
}
