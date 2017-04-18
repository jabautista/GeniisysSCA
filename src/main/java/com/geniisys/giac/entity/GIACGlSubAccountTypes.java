/** 
 *  Created by   : Gzelle
 *  Date Created : 10-29-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACGlSubAccountTypes extends BaseEntity {

	private String ledgerCd;
	private String subLedgerCd;
	private String subLedgerDesc;
	private String glAcctId;
	private String glAcctCategory;
	private String glControlAcct;
	private String glSubAcct1;
	private String glSubAcct2;
	private String glSubAcct3;
	private String glSubAcct4;
	private String glSubAcct5;
	private String glSubAcct6;
	private String glSubAcct7;
	private String glAcctName;
	private String activeTag;
	private String remarks;
	
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
	
	public String getSubLedgerDesc() {
		return subLedgerDesc;
	}
	
	public void setSubLedgerDesc(String subLedgerDesc) {
		this.subLedgerDesc = subLedgerDesc;
	}
	
	public String getGlAcctId() {
		return glAcctId;
	}
	
	public void setGlAcctId(String glAcctId) {
		this.glAcctId = glAcctId;
	}
	
	public String getGlAcctCategory() {
		return glAcctCategory;
	}
	
	public void setGlAcctCategory(String glAcctCategory) {
		this.glAcctCategory = glAcctCategory;
	}
	
	public String getGlControlAcct() {
		return glControlAcct;
	}
	
	public void setGlControlAcct(String glControlAcct) {
		this.glControlAcct = glControlAcct;
	}
	
	public String getGlSubAcct1() {
		return glSubAcct1;
	}
	
	public void setGlSubAcct1(String glSubAcct1) {
		this.glSubAcct1 = glSubAcct1;
	}
	
	public String getGlSubAcct2() {
		return glSubAcct2;
	}
	
	public void setGlSubAcct2(String glSubAcct2) {
		this.glSubAcct2 = glSubAcct2;
	}
	
	public String getGlSubAcct3() {
		return glSubAcct3;
	}
	
	public void setGlSubAcct3(String glSubAcct3) {
		this.glSubAcct3 = glSubAcct3;
	}
	
	public String getGlSubAcct4() {
		return glSubAcct4;
	}
	
	public void setGlSubAcct4(String glSubAcct4) {
		this.glSubAcct4 = glSubAcct4;
	}
	
	public String getGlSubAcct5() {
		return glSubAcct5;
	}
	
	public void setGlSubAcct5(String glSubAcct5) {
		this.glSubAcct5 = glSubAcct5;
	}
	
	public String getGlSubAcct6() {
		return glSubAcct6;
	}
	
	public void setGlSubAcct6(String glSubAcct6) {
		this.glSubAcct6 = glSubAcct6;
	}
	
	public String getGlSubAcct7() {
		return glSubAcct7;
	}
	
	public void setGlSubAcct7(String glSubAcct7) {
		this.glSubAcct7 = glSubAcct7;
	}
	
	public String getGlAcctName() {
		return glAcctName;
	}
	
	public void setGlAcctName(String glAcctName) {
		this.glAcctName = glAcctName;
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
