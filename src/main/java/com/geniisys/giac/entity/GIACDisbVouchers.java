/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.entity
	File Name: GIACDisbVouchers.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jun 19, 2012
	Description: 
*/


package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACDisbVouchers extends BaseEntity{

	private Integer gaccTranId;
	private String gibrGfunFundCd;
	private String gibrBranchCd;
	private Integer goucOucId;
	private Integer gprqRefId;
	private Integer reqDtlNo;
	private String particulars;
	private BigDecimal dvAmt;
	private String dvCreatedBy;
	private Date dvCreateDate;
	private String dvFlag;
	private String payee;
	private Integer currencyCd;
	private Date dvDate;
	private String dvDateStrSp;
	private String dvDateStr;
	private Integer dvNo;
	private String tranNo;
	private Date printDate;
	private String dvApprovedBy;
	private String dvTag;
	private String dvPref;
	private Integer printTag;
	private Date dvApproveDate;
	private String refNo;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private Integer payeeNo;
	private String payeeClassCd;
	private BigDecimal dvFcurrencyAmt;
	private BigDecimal currencyRt;
	private String replnishedTag;
	
	
	// attributes that are not in the table
	private String dspDvFlagMean;
	private String strDvPrintDate;
	private String strDvCreateDate;
	
	//additional attributes for GIACS002
	private String dvFlagMean;
	private String foreignCurrency;
	private String localCurrency;
	private String payeeClassDesc;
	private String fundDesc;
	private String branchName;
	private String dspPrintDate;
	private String dspPrintTime;
	private String gprqDocumentCd;
	private String gprqBranchCd;
	private String gprqLineCd;
	private Integer gprqDocYear;
	private Integer gprqDocMonth;
	private Integer gprqDocSeqNo;
	private String nbtLineCdTag;
	private String nbtYyTag;
	private String nbtMmTag;
	private String printTagMean;
	private String checkDVPrint;
	private String allowMultiCheck;
	private String dvApproval;
	private String updatePayeeName;
	private String clmDocCd;
	private String riDocCd;
	private String commDocCd;
	private String bcsrDocCd;
	private Integer approveDVTag;
	private String grpIssCd;
	private Integer oucCd;
	private String oucName;
	private String fundCd2;
	private String branchCd2;
	private String seqFundCd;
	private String seqBranchCd;
	private String strLastUpdate;
	private String strCreateDate;
	private String strApproveDate;
	private String strPrintDate;
	private String strPrintTime;
	private String allowTranForClosedMonthTag;
	private Integer checkUserPerIssCdAcctg;
	
	private String paytReqNo; //added by robert SR 5190 12.02.15
	
	/**
	 * @return the strDvPrintDate
	 */
	public String getStrDvPrintDate() {
		return strDvPrintDate;
	}
	/**
	 * @param strDvPrintDate the strDvPrintDate to set
	 */
	public void setStrDvPrintDate(String strDvPrintDate) {
		this.strDvPrintDate = strDvPrintDate;
	}

	/**
	 * @return the gaccTranId
	 */
	public Integer getGaccTranId() {
		return gaccTranId;
	}
	/**
	 * @param gaccTranId the gaccTranId to set
	 */
	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}
	/**
	 * @return the gibrGfunFundCd
	 */
	public String getGibrGfunFundCd() {
		return gibrGfunFundCd;
	}
	/**
	 * @param gibrGfunFundCd the gibrGfunFundCd to set
	 */
	public void setGibrGfunFundCd(String gibrGfunFundCd) {
		this.gibrGfunFundCd = gibrGfunFundCd;
	}
	/**
	 * @return the gibrBranchCd
	 */
	public String getGibrBranchCd() {
		return gibrBranchCd;
	}
	/**
	 * @param gibrBranchCd the gibrBranchCd to set
	 */
	public void setGibrBranchCd(String gibrBranchCd) {
		this.gibrBranchCd = gibrBranchCd;
	}
	/**
	 * @return the goucOucId
	 */
	public Integer getGoucOucId() {
		return goucOucId;
	}
	/**
	 * @param goucOucId the goucOucId to set
	 */
	public void setGoucOucId(Integer goucOucId) {
		this.goucOucId = goucOucId;
	}
	/**
	 * @return the gprqRefIdl
	 */
	public Integer getGprqRefId() {
		return gprqRefId;
	}
	/**
	 * @param gprqRefIdl the gprqRefIdl to set
	 */
	public void setGprqRefId(Integer gprqRefId) {
		this.gprqRefId = gprqRefId;
	}
	/**
	 * @return the reqDtlNo
	 */
	public Integer getReqDtlNo() {
		return reqDtlNo;
	}
	/**
	 * @param reqDtlNo the reqDtlNo to set
	 */
	public void setReqDtlNo(Integer reqDtlNo) {
		this.reqDtlNo = reqDtlNo;
	}
	/**
	 * @return the particulars
	 */
	public String getParticulars() {
		return particulars;
	}
	/**
	 * @param particulars the particulars to set
	 */
	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}
	/**
	 * @return the dvAmt
	 */
	public BigDecimal getDvAmt() {
		return dvAmt;
	}
	/**
	 * @param dvAmt the dvAmt to set
	 */
	public void setDvAmt(BigDecimal dvAmt) {
		this.dvAmt = dvAmt;
	}
	/**
	 * @return the dvCreatedBy
	 */
	public String getDvCreatedBy() {
		return dvCreatedBy;
	}
	/**
	 * @param dvCreatedBy the dvCreatedBy to set
	 */
	public void setDvCreatedBy(String dvCreatedBy) {
		this.dvCreatedBy = dvCreatedBy;
	}
	/**
	 * @return the dvCreateDate
	 */
	public Date getDvCreateDate() {
		return dvCreateDate;
	}
	/**
	 * @param dvCreateDate the dvCreateDate to set
	 */
	public void setDvCreateDate(Date dvCreateDate) {
		this.dvCreateDate = dvCreateDate;
	}
	/**
	 * @return the dvFlag
	 */
	public String getDvFlag() {
		return dvFlag;
	}
	/**
	 * @param dvFlag the dvFlag to set
	 */
	public void setDvFlag(String dvFlag) {
		this.dvFlag = dvFlag;
	}
	/**
	 * @return the payee
	 */
	public String getPayee() {
		return payee;
	}
	/**
	 * @param payee the payee to set
	 */
	public void setPayee(String payee) {
		this.payee = payee;
	}
	/**
	 * @return the currencyCd
	 */
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	/**
	 * @param currencyCd the currencyCd to set
	 */
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	/**
	 * @return the dvDate
	 */
	public Date getDvDate() {
		return dvDate;
	}
	/**
	 * @param dvDate the dvDate to set
	 */
	public void setDvDate(Date dvDate) {
		this.dvDate = dvDate;
	}
	public String getDvDateStrSp() {
		return dvDateStrSp;
	}
	public void setDvDateStrSp(String dvDateStrSp) {
		this.dvDateStrSp = dvDateStrSp;
	}
	/**
	 * @return the dvNo
	 */
	public Integer getDvNo() {
		return dvNo;
	}
	/**
	 * @param dvNo the dvNo to set
	 */
	public void setDvNo(Integer dvNo) {
		this.dvNo = dvNo;
	}
	/**
	 * @return the printDate
	 */
	public Date getPrintDate() {
		return printDate;
	}
	/**
	 * @param printDate the printDate to set
	 */
	public void setPrintDate(Date printDate) {
		this.printDate = printDate;
	}
	/**
	 * @return the dvApprovedBy
	 */
	public String getDvApprovedBy() {
		return dvApprovedBy;
	}
	/**
	 * @param dvApprovedBy the dvApprovedBy to set
	 */
	public void setDvApprovedBy(String dvApprovedBy) {
		this.dvApprovedBy = dvApprovedBy;
	}
	/**
	 * @return the dvTag
	 */
	public String getDvTag() {
		return dvTag;
	}
	/**
	 * @param dvTag the dvTag to set
	 */
	public void setDvTag(String dvTag) {
		this.dvTag = dvTag;
	}
	/**
	 * @return the dvPref
	 */
	public String getDvPref() {
		return dvPref;
	}
	/**
	 * @param dvPref the dvPref to set
	 */
	public void setDvPref(String dvPref) {
		this.dvPref = dvPref;
	}
	/**
	 * @return the printTag
	 */
	public Integer getPrintTag() {
		return printTag;
	}
	/**
	 * @param printTag the printTag to set
	 */
	public void setPrintTag(Integer printTag) {
		this.printTag = printTag;
	}
	/**
	 * @return the dvApproveDate
	 */
	public Date getDvApproveDate() {
		return dvApproveDate;
	}
	/**
	 * @param dvApproveDate the dvApproveDate to set
	 */
	public void setDvApproveDate(Date dvApproveDate) {
		this.dvApproveDate = dvApproveDate;
	}
	/**
	 * @return the refNo
	 */
	public String getRefNo() {
		return refNo;
	}
	/**
	 * @param refNo the refNo to set
	 */
	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}
	/**
	 * @return the cpiRecNo
	 */
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	/**
	 * @param cpiRecNo the cpiRecNo to set
	 */
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	/**
	 * @return the cpiBranchCd
	 */
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	/**
	 * @param cpiBranchCd the cpiBranchCd to set
	 */
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	/**
	 * @return the payeeNo
	 */
	public Integer getPayeeNo() {
		return payeeNo;
	}
	/**
	 * @param payeeNo the payeeNo to set
	 */
	public void setPayeeNo(Integer payeeNo) {
		this.payeeNo = payeeNo;
	}
	/**
	 * @return the payeeClassCd
	 */
	public String getPayeeClassCd() {
		return payeeClassCd;
	}
	/**
	 * @param payeeClassCd the payeeClassCd to set
	 */
	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
	}
	/**
	 * @return the dvFcurrencyAmt
	 */
	public BigDecimal getDvFcurrencyAmt() {
		return dvFcurrencyAmt;
	}
	/**
	 * @param dvFcurrencyAmt the dvFcurrencyAmt to set
	 */
	public void setDvFcurrencyAmt(BigDecimal dvFcurrencyAmt) {
		this.dvFcurrencyAmt = dvFcurrencyAmt;
	}
	
	/**
	 * @return the replnishedTag
	 */
	public String getReplnishedTag() {
		return replnishedTag;
	}
	/**
	 * @param replnishedTag the replnishedTag to set
	 */
	public void setReplnishedTag(String replnishedTag) {
		this.replnishedTag = replnishedTag;
	}
	
	/**
	 * @return the dspDvFlagMean
	 */
	public String getDspDvFlagMean() {
		return dspDvFlagMean;
	}
	/**
	 * @param dspDvFlagMean the dspDvFlagMean to set
	 */
	public void setDspDvFlagMean(String dspDvFlagMean) {
		this.dspDvFlagMean = dspDvFlagMean;
	}
	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}
	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}
	public String getStrDvCreateDate() {
		return strDvCreateDate;
	}
	public void setStrDvCreateDate(String strDvCreateDate) {
		this.strDvCreateDate = strDvCreateDate;
	}
	
	public String getDvFlagMean() {
		return dvFlagMean;
	}
	public void setDvFlagMean(String dvFlagMean) {
		this.dvFlagMean = dvFlagMean;
	}
	// for attributes used in GIACS002
	public String getForeignCurrency() {
		return foreignCurrency;
	}
	public void setForeignCurrency(String foreignCurrency) {
		this.foreignCurrency = foreignCurrency;
	}
	public String getLocalCurrency() {
		return localCurrency;
	}
	public void setLocalCurrency(String localCurrency) {
		this.localCurrency = localCurrency;
	}
	public String getPayeeClassDesc() {
		return payeeClassDesc;
	}
	public void setPayeeClassDesc(String payeeClassDesc) {
		this.payeeClassDesc = payeeClassDesc;
	}
	public String getFundDesc() {
		return fundDesc;
	}
	public void setFundDesc(String fundDesc) {
		this.fundDesc = fundDesc;
	}
	public String getBranchName() {
		return branchName;
	}
	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}
	public String getDspPrintDate() {
		return dspPrintDate;
	}
	public void setDspPrintDate(String dspPrintDate) {
		this.dspPrintDate = dspPrintDate;
	}
	public String getDspPrintTime() {
		return dspPrintTime;
	}
	public void setDspPrintTime(String dspPrintTime) {
		this.dspPrintTime = dspPrintTime;
	}
	public String getGprqDocumentCd() {
		return gprqDocumentCd;
	}
	public void setGprqDocumentCd(String gprqDocumentCd) {
		this.gprqDocumentCd = gprqDocumentCd;
	}
	public String getGprqBranchCd() {
		return gprqBranchCd;
	}
	public void setGprqBranchCd(String gprqBranchCd) {
		this.gprqBranchCd = gprqBranchCd;
	}
	public String getGprqLineCd() {
		return gprqLineCd;
	}
	public void setGprqLineCd(String gprqLineCd) {
		this.gprqLineCd = gprqLineCd;
	}
	public Integer getGprqDocYear() {
		return gprqDocYear;
	}
	public void setGprqDocYear(Integer gprqDocYear) {
		this.gprqDocYear = gprqDocYear;
	}
	public Integer getGprqDocMonth() {
		return gprqDocMonth;
	}
	public void setGprqDocMonth(Integer gprqDocMonth) {
		this.gprqDocMonth = gprqDocMonth;
	}
	public Integer getGprqDocSeqNo() {
		return gprqDocSeqNo;
	}
	public void setGprqDocSeqNo(Integer gprqDocSeqNo) {
		this.gprqDocSeqNo = gprqDocSeqNo;
	}
	public String getNbtLineCdTag() {
		return nbtLineCdTag;
	}
	public void setNbtLineCdTag(String nbtLineCdTag) {
		this.nbtLineCdTag = nbtLineCdTag;
	}
	public String getNbtYyTag() {
		return nbtYyTag;
	}
	public void setNbtYyTag(String nbtYyTag) {
		this.nbtYyTag = nbtYyTag;
	}
	public String getNbtMmTag() {
		return nbtMmTag;
	}
	public void setNbtMmTag(String nbtMmTag) {
		this.nbtMmTag = nbtMmTag;
	}
	public String getPrintTagMean() {
		return printTagMean;
	}
	public void setPrintTagMean(String printTagMean) {
		this.printTagMean = printTagMean;
	}
	public String getCheckDVPrint() {
		return checkDVPrint;
	}
	public void setCheckDVPrint(String checkDVPrint) {
		this.checkDVPrint = checkDVPrint;
	}
	public String getAllowMultiCheck() {
		return allowMultiCheck;
	}
	public void setAllowMultiCheck(String allowMultiCheck) {
		this.allowMultiCheck = allowMultiCheck;
	}
	public String getDvApproval() {
		return dvApproval;
	}
	public void setDvApproval(String dvApproval) {
		this.dvApproval = dvApproval;
	}
	public String getUpdatePayeeName() {
		return updatePayeeName;
	}
	public void setUpdatePayeeName(String updatePayeeName) {
		this.updatePayeeName = updatePayeeName;
	}
	public String getClmDocCd() {
		return clmDocCd;
	}
	public void setClmDocCd(String clmDocCd) {
		this.clmDocCd = clmDocCd;
	}
	public String getRiDocCd() {
		return riDocCd;
	}
	public void setRiDocCd(String riDocCd) {
		this.riDocCd = riDocCd;
	}
	public String getCommDocCd() {
		return commDocCd;
	}
	public void setCommDocCd(String commDocCd) {
		this.commDocCd = commDocCd;
	}
	public String getBcsrDocCd() {
		return bcsrDocCd;
	}
	public void setBcsrDocCd(String bcsrDocCd) {
		this.bcsrDocCd = bcsrDocCd;
	}
	public Integer getApproveDVTag() {
		return approveDVTag;
	}
	public void setApproveDVTag(Integer approveDVTag) {
		this.approveDVTag = approveDVTag;
	}
	public String getGrpIssCd() {
		return grpIssCd;
	}
	public void setGrpIssCd(String grpIssCd) {
		this.grpIssCd = grpIssCd;
	}
	public Integer getOucCd() {
		return oucCd;
	}
	public void setOucCd(Integer oucCd) {
		this.oucCd = oucCd;
	}
	public String getOucName() {
		return oucName;
	}
	public void setOucName(String oucName) {
		this.oucName = oucName;
	}
	public String getFundCd2() {
		return fundCd2;
	}
	public void setFundCd2(String fundCd2) {
		this.fundCd2 = fundCd2;
	}
	public String getBranchCd2() {
		return branchCd2;
	}
	public void setBranchCd2(String branchCd2) {
		this.branchCd2 = branchCd2;
	}
	public String getSeqFundCd() {
		return seqFundCd;
	}
	public void setSeqFundCd(String seqFundCd) {
		this.seqFundCd = seqFundCd;
	}
	public String getSeqBranchCd() {
		return seqBranchCd;
	}
	public void setSeqBranchCd(String seqBranchCd) {
		this.seqBranchCd = seqBranchCd;
	}
	public String getStrLastUpdate() {
		return strLastUpdate;
	}
	public void setStrLastUpdate(String strLastUpdate) {
		this.strLastUpdate = strLastUpdate;
	}
	public String getStrCreateDate() {
		return strCreateDate;
	}
	public void setStrCreateDate(String strCreateDate) {
		this.strCreateDate = strCreateDate;
	}
	public String getStrApproveDate() {
		return strApproveDate;
	}
	public void setStrApproveDate(String strApproveDate) {
		this.strApproveDate = strApproveDate;
	}
	public String getStrPrintDate() {
		return strPrintDate;
	}
	public void setStrPrintDate(String strPrintDate) {
		this.strPrintDate = strPrintDate;
	}
	public String getStrPrintTime() {
		return strPrintTime;
	}
	public void setStrPrintTime(String strPrintTime) {
		this.strPrintTime = strPrintTime;
	}
	public String getAllowTranForClosedMonthTag() {
		return allowTranForClosedMonthTag;
	}
	public void setAllowTranForClosedMonthTag(String allowTranForClosedMonthTag) {
		this.allowTranForClosedMonthTag = allowTranForClosedMonthTag;
	}
	public Integer getCheckUserPerIssCdAcctg() {
		return checkUserPerIssCdAcctg;
	}
	public void setCheckUserPerIssCdAcctg(Integer checkUserPerIssCdAcctg) {
		this.checkUserPerIssCdAcctg = checkUserPerIssCdAcctg;
	}
	public String getDvDateStr() {
		return dvDateStr;
	}
	public void setDvDateStr(String dvDateStr) {
		this.dvDateStr = dvDateStr;
	}
	public String getTranNo() {
		return tranNo;
	}
	public void setTranNo(String tranNo) {
		this.tranNo = tranNo;
	}
	//added by robert SR 5190 12.02.15
	public String getPaytReqNo() {
		return paytReqNo;
	}
	public void setPaytReqNo(String paytReqNo) {
		this.paytReqNo = paytReqNo;
	}
	//end robert SR 5190 12.02.15
	
}
