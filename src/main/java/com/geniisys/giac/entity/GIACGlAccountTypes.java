/** 
 *  Created by   : Gzelle
 *  Date Created : 10-27-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACGlAccountTypes extends BaseEntity {

	private String ledgerCd;
	private String ledgerDesc;
	private String activeTag;
	private String dspActiveTag;
	private String remarks;

	public String getLedgerCd() {
		return ledgerCd;
	}

	public void setLedgerCd(String ledgerCd) {
		this.ledgerCd = ledgerCd;
	}

	public String getLedgerDesc() {
		return ledgerDesc;
	}

	public void setLedgerDesc(String ledgerDesc) {
		this.ledgerDesc = ledgerDesc;
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

	public String getDspActiveTag() {
		return dspActiveTag;
	}

	public void setDspActiveTag(String dspActiveTag) {
		this.dspActiveTag = dspActiveTag;
	}

}
