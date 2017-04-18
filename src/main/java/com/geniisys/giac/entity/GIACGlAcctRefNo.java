/** 
 *  Created by   : Gzelle
 *  Date Created : 11-06-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACGlAcctRefNo extends BaseEntity {

	private Integer gaccTranId;
	private Integer glAcctId;
	private String ledgerCd;
	private String subLedgerCd;
	private String transactionCd;
	private String slCd;
	private String acctSeqNo;
	private String acctTranType;
	
	public String getAcctTranType() {
		return acctTranType;
	}

	public void setAcctTranType(String acctTranType) {
		this.acctTranType = acctTranType;
	}

	public Integer getGaccTranId() {
		return gaccTranId;
	}
	
	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}
	
	public Integer getGlAcctId() {
		return glAcctId;
	}
	
	public void setGlAcctId(Integer glAcctId) {
		this.glAcctId = glAcctId;
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
	
	public String getSlCd() {
		return slCd;
	}
	
	public void setSlCd(String slCd) {
		this.slCd = slCd;
	}
	
	public String getAcctSeqNo() {
		return acctSeqNo;
	}
	
	public void setAcctSeqNo(String acctSeqNo) {
		this.acctSeqNo = acctSeqNo;
	}
}
