/** 
 *  Created by   : Gzelle
 *  Date Created : 10-30-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACGlTransactionTypes extends BaseEntity {

	private String ledgerCd;
	private String subLedgerCd;
	private String transactionCd;
	private String transactionDesc;
	private String activeTag;
	private String remarks;
	private String dspActiveTag;
	
	public String getDspActiveTag() {
		return dspActiveTag;
	}

	public void setDspActiveTag(String dspActiveTag) {
		this.dspActiveTag = dspActiveTag;
	}

	public String getLedgerCd() {
		return ledgerCd;
	}
	
	public void setLedgerCd(String ledgerCd) {
		this.ledgerCd = ledgerCd;
	}
	
	public String getSubLedgerCd() {
		return subLedgerCd;
	}
	
	public void setSubLedgerCd(String subLedgerCd) {
		this.subLedgerCd = subLedgerCd;
	}
	
	public String getTransactionCd() {
		return transactionCd;
	}
	
	public void setTransactionCd(String transactionCd) {
		this.transactionCd = transactionCd;
	}
	
	public String getTransactionDesc() {
		return transactionDesc;
	}
	
	public void setTransactionDesc(String transactionDesc) {
		this.transactionDesc = transactionDesc;
	}
	
	public String getActiveTag() {
		return activeTag;
	}
	
	public void setActiveTag(String activeTag) {
		this.activeTag = activeTag;
	}
	
	public String getRemarks() {
		return remarks;
	}
	
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

}
