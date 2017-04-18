package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACBankBookTran extends BaseEntity{
	private String bankName;
	private String bankSname;
	private String bankCd;
	private String bankTranCd;
	private String bankTranDesc;
	private String bookTranCd;
	private String bookTranDesc;
	private String remarks;
	
	public GIACBankBookTran(){
		
	}

	public String getBankName() {
		return bankName;
	}

	public void setBankName(String bankName) {
		this.bankName = bankName;
	}

	public String getBankSname() {
		return bankSname;
	}

	public void setBankSname(String bankSname) {
		this.bankSname = bankSname;
	}

	public String getBankCd() {
		return bankCd;
	}

	public void setBankCd(String bankCd) {
		this.bankCd = bankCd;
	}

	public String getBankTranCd() {
		return bankTranCd;
	}

	public void setBankTranCd(String bankTranCd) {
		this.bankTranCd = bankTranCd;
	}

	public String getBankTranDesc() {
		return bankTranDesc;
	}

	public void setBankTranDesc(String bankTranDesc) {
		this.bankTranDesc = bankTranDesc;
	}

	public String getBookTranCd() {
		return bookTranCd;
	}

	public void setBookTranCd(String bookTranCd) {
		this.bookTranCd = bookTranCd;
	}

	public String getBookTranDesc() {
		return bookTranDesc;
	}

	public void setBookTranDesc(String bookTranDesc) {
		this.bookTranDesc = bookTranDesc;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
}
