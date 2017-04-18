package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

/**
 * The class GIACCommPayts
 * @author eman
 *
 */
public class GIACCommPayts extends BaseEntity {

	private Integer gaccTranId;
	
	private Integer intmNo;
	
	private String issCd;
	
	private Integer premSeqNo;
	
	private Integer tranType;
	
	private BigDecimal commAmt;
	
	private BigDecimal wtaxAmt;
	
	private BigDecimal inputVATAmt;
	
	private String userId;
	
	private Date lastUpdate;
	
	private String particulars;
	
	private Integer currencyCd;
	
	private String currDesc;
	
	private BigDecimal convertRate;
	
	private BigDecimal foreignCurrAmt;
	
	private String defCommTag;
	
	private Integer instNo;
	
	private String printTag;
	
	private String orPrintTag;
	
	private Integer cpiRecNo;
	
	private String cpiBranchCd;
	
	private String spAcctg;
	
	private Integer parentIntmNo;
	
	private String acctTag;
	
	private String commTag;
	
	private Integer recordNo;
	
	private BigDecimal disbComm;
	
	private String dspLineCd;
	
	private String dspAssdName;
	
	private BigDecimal drvCommAmt;
	
	private Integer dspPolicyId;
	
	private String dspIntmName;
	
	private Integer dspAssdNo;
	
	private Integer billGaccTranId;
	
	private Integer recordSeqNo; //added by robert SR 19752 07.28.15

	public Integer getBillGaccTranId() {
		return billGaccTranId;
	}

	public void setBillGaccTranId(Integer billGaccTranId) {
		this.billGaccTranId = billGaccTranId;
	}

	public String getDspLineCd() {
		return dspLineCd;
	}

	public void setDspLineCd(String dspLineCd) {
		this.dspLineCd = dspLineCd;
	}

	public String getDspAssdName() {
		return dspAssdName;
	}

	public void setDspAssdName(String dspAssdName) {
		this.dspAssdName = dspAssdName;
	}

	public BigDecimal getDrvCommAmt() {
		return drvCommAmt;
	}

	public void setDrvCommAmt(BigDecimal drvCommAmt) {
		this.drvCommAmt = drvCommAmt;
	}

	public Integer getDspPolicyId() {
		return dspPolicyId;
	}

	public void setDspPolicyId(Integer dspPolicyId) {
		this.dspPolicyId = dspPolicyId;
	}

	public String getDspIntmName() {
		return dspIntmName;
	}

	public void setDspIntmName(String dspIntmName) {
		this.dspIntmName = dspIntmName;
	}

	public Integer getDspAssdNo() {
		return dspAssdNo;
	}

	public void setDspAssdNo(Integer dspAssdNo) {
		this.dspAssdNo = dspAssdNo;
	}

	public Integer getGaccTranId() {
		return gaccTranId;
	}

	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}

	public Integer getIntmNo() {
		return intmNo;
	}

	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public Integer getPremSeqNo() {
		return premSeqNo;
	}

	public void setPremSeqNo(Integer premSeqNo) {
		this.premSeqNo = premSeqNo;
	}

	public Integer getTranType() {
		return tranType;
	}

	public void setTranType(Integer tranType) {
		this.tranType = tranType;
	}

	public BigDecimal getCommAmt() {
		return commAmt;
	}

	public void setCommAmt(BigDecimal commAmt) {
		this.commAmt = commAmt;
	}

	public BigDecimal getWtaxAmt() {
		return wtaxAmt;
	}

	public void setWtaxAmt(BigDecimal wtaxAmt) {
		this.wtaxAmt = wtaxAmt;
	}

	public BigDecimal getInputVATAmt() {
		return inputVATAmt;
	}

	public void setInputVATAmt(BigDecimal inputVATAmt) {
		this.inputVATAmt = inputVATAmt;
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

	public String getParticulars() {
		return particulars;
	}

	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}

	public Integer getCurrencyCd() {
		return currencyCd;
	}

	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}

	public BigDecimal getConvertRate() {
		return convertRate;
	}

	public void setConvertRate(BigDecimal convertRate) {
		this.convertRate = convertRate;
	}

	public BigDecimal getForeignCurrAmt() {
		return foreignCurrAmt;
	}

	public void setForeignCurrAmt(BigDecimal foreignCurrAmt) {
		this.foreignCurrAmt = foreignCurrAmt;
	}

	public String getDefCommTag() {
		return defCommTag;
	}

	public void setDefCommTag(String defCommTag) {
		this.defCommTag = defCommTag;
	}

	public Integer getInstNo() {
		return instNo;
	}

	public void setInstNo(Integer instNo) {
		this.instNo = instNo;
	}

	public String getPrintTag() {
		return printTag;
	}

	public void setPrintTag(String printTag) {
		this.printTag = printTag;
	}

	public String getOrPrintTag() {
		return orPrintTag;
	}

	public void setOrPrintTag(String orPrintTag) {
		this.orPrintTag = orPrintTag;
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

	public String getSpAcctg() {
		return spAcctg;
	}

	public void setSpAcctg(String spAcctg) {
		this.spAcctg = spAcctg;
	}

	public Integer getParentIntmNo() {
		return parentIntmNo;
	}

	public void setParentIntmNo(Integer parentIntmNo) {
		this.parentIntmNo = parentIntmNo;
	}

	public String getAcctTag() {
		return acctTag;
	}

	public void setAcctTag(String acctTag) {
		this.acctTag = acctTag;
	}

	public String getCommTag() {
		return commTag;
	}

	public void setCommTag(String commTag) {
		this.commTag = commTag;
	}

	public Integer getRecordNo() {
		return recordNo;
	}

	public void setRecordNo(Integer recordNo) {
		this.recordNo = recordNo;
	}

	public BigDecimal getDisbComm() {
		return disbComm;
	}

	public void setDisbComm(BigDecimal disbComm) {
		this.disbComm = disbComm;
	}

	public String getCurrDesc() {
		return currDesc;
	}

	public void setCurrDesc(String currDesc) {
		this.currDesc = currDesc;
	}
	//added by robert SR 19752 07.28.15
	public Integer getRecordSeqNo() {
		return recordSeqNo;
	}

	public void setRecordSeqNo(Integer recordSeqNo) {
		this.recordSeqNo = recordSeqNo;
	}
	//end robert SR 19752 07.28.15
}
