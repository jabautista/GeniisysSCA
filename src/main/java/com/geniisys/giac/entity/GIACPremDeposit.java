package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACPremDeposit extends BaseEntity {

	private String orPrintTag;
	
	private Integer itemNo;
	
	private Integer transactionType;
	
	private String tranTypeName;
	
	private Integer oldItemNo;
	
	private Integer oldTranType;
	
	private String b140IssCd;
	
	private String issName;
	
	private Integer b140PremSeqNo;
	
	private Integer instNo;
	
	private BigDecimal collectionAmt;
	
	private String depFlag;
	
	private Integer assdNo;
	
	private String assuredName;
	
	private Integer intmNo;
	
	private Integer riCd;
	
	private String riName;
	
	private Integer parSeqNo;
	
	private Integer quoteSeqNo;
	
	private String lineCd;
	
	private String sublineCd;
	
	private String issCd;
	
	private Integer issueYy;
	
	private Integer polSeqNo;
	
	private Integer renewNo;
	
	private Date collnDt;
	
	private Integer gaccTranId;
	
	private Integer oldTranId;
	
	private String remarks;
	
	private String userId;
	
	private Date lastUpdate;
	
	private Integer currencyCd;
	
	private String currencyDesc; // added by Kris 02.01.2013
	
	private BigDecimal convertRate;
	
	private BigDecimal foreignCurrAmt;
	
	private String orTag;
	
	private Integer commRecNo;
	
	private String intmName;
	
	private String billNo;
	
	private String policyNo;
	
	private Integer parYy;
	
	private String parLineCd;
	
	private String parIssCd;
	
	private String dspParNo;
	
	private String dspDepFlag;
	
	private String dspParYy;
	
	private String dspParSeqNo;
	
	private String dspQuoteSeqNo;
	
	private Integer tranId;
	
	private String gfunFundCd;
	
	private String gibrBranchCd;
	
	private Date tranDate;

	private String tranFlag;
	
	private String tranClass;
	
	private Integer tranClassNo;
	
	private String particulars;
	
	private Integer tranYear;
	
	private Integer tranMonth;
	
	private Integer tranSeqNo;
	
	private String dspOldTranNo;
	 
	private Integer b140_iss_cd;
	
   	private Integer b140_prem_seq_no;  
   	
   	private Integer inst_no;
   	
   	private String dsp_a150_line_cd;
   	
   	private String dsp_total_amount_due;
   	
   	private String dsp_total_payments;
   	
   	private String dsp_temp_payments;	
   	
   	private String dsp_balance_amt_due;	
   	
   	private String dsp_a020_assd_no;
   	
   	private Integer endt_seq_no;
   	
   	private String assd_name;
   	
   	private String dsp_policy_no;
   	
   	private String dsp_old_tran_no;
   	
	public Integer getB140_iss_cd() {
		return b140_iss_cd;
	}

	public void setB140_iss_cd(Integer b140_iss_cd) {
		this.b140_iss_cd = b140_iss_cd;
	}

	public Integer getB140_prem_seq_no() {
		return b140_prem_seq_no;
	}

	public void setB140_prem_seq_no(Integer b140_prem_seq_no) {
		this.b140_prem_seq_no = b140_prem_seq_no;
	}

	public Integer getInst_no() {
		return inst_no;
	}

	public void setInst_no(Integer inst_no) {
		this.inst_no = inst_no;
	}

	public String getDsp_a150_line_cd() {
		return dsp_a150_line_cd;
	}

	public void setDsp_a150_line_cd(String dsp_a150_line_cd) {
		this.dsp_a150_line_cd = dsp_a150_line_cd;
	}

	public String getDsp_total_amount_due() {
		return dsp_total_amount_due;
	}

	public void setDsp_total_amount_due(String dsp_total_amount_due) {
		this.dsp_total_amount_due = dsp_total_amount_due;
	}

	public String getDsp_total_payments() {
		return dsp_total_payments;
	}

	public void setDsp_total_payments(String dsp_total_payments) {
		this.dsp_total_payments = dsp_total_payments;
	}

	public String getDsp_temp_payments() {
		return dsp_temp_payments;
	}

	public void setDsp_temp_payments(String dsp_temp_payments) {
		this.dsp_temp_payments = dsp_temp_payments;
	}

	public String getDsp_balance_amt_due() {
		return dsp_balance_amt_due;
	}

	public void setDsp_balance_amt_due(String dsp_balance_amt_due) {
		this.dsp_balance_amt_due = dsp_balance_amt_due;
	}

	public String getDsp_a020_assd_no() {
		return dsp_a020_assd_no;
	}

	public void setDsp_a020_assd_no(String dsp_a020_assd_no) {
		this.dsp_a020_assd_no = dsp_a020_assd_no;
	}

	public Integer getTranId() {
		return tranId;
	}

	public void setTranId(Integer tranId) {
		this.tranId = tranId;
	}

	public String getGfunFundCd() {
		return gfunFundCd;
	}

	public void setGfunFundCd(String gfunFundCd) {
		this.gfunFundCd = gfunFundCd;
	}

	public String getGibrBranchCd() {
		return gibrBranchCd;
	}

	public void setGibrBranchCd(String gibrBranchCd) {
		this.gibrBranchCd = gibrBranchCd;
	}

	public Date getTranDate() {
		return tranDate;
	}

	public void setTranDate(Date tranDate) {
		this.tranDate = tranDate;
	}

	public String getTranFlag() {
		return tranFlag;
	}

	public void setTranFlag(String tranFlag) {
		this.tranFlag = tranFlag;
	}

	public String getTranClass() {
		return tranClass;
	}

	public void setTranClass(String tranClass) {
		this.tranClass = tranClass;
	}

	public Integer getTranClassNo() {
		return tranClassNo;
	}

	public void setTranClassNo(Integer tranClassNo) {
		this.tranClassNo = tranClassNo;
	}

	public String getParticulars() {
		return particulars;
	}

	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}

	public Integer getTranYear() {
		return tranYear;
	}

	public void setTranYear(Integer tranYear) {
		this.tranYear = tranYear;
	}

	public Integer getTranMonth() {
		return tranMonth;
	}

	public void setTranMonth(Integer tranMonth) {
		this.tranMonth = tranMonth;
	}

	public Integer getTranSeqNo() {
		return tranSeqNo;
	}

	public void setTranSeqNo(Integer tranSeqNo) {
		this.tranSeqNo = tranSeqNo;
	}

	public String getDspParYy() {
		return dspParYy;
	}

	public void setDspParYy(String dspParYy) {
		this.dspParYy = dspParYy;
	}

	public String getDspParSeqNo() {
		return dspParSeqNo;
	}

	public void setDspParSeqNo(String dspParSeqNo) {
		this.dspParSeqNo = dspParSeqNo;
	}

	public String getDspQuoteSeqNo() {
		return dspQuoteSeqNo;
	}

	public void setDspQuoteSeqNo(String dspQuoteSeqNo) {
		this.dspQuoteSeqNo = dspQuoteSeqNo;
	}

	public String getDspDepFlag() {
		return dspDepFlag;
	}

	public void setDspDepFlag(String dspDepFlag) {
		this.dspDepFlag = dspDepFlag;
	}

	public String getDspParNo() {
		return dspParNo;
	}

	public void setDspParNo(String dspParNo) {
		this.dspParNo = dspParNo;
	}

	public String getParLineCd() {
		return parLineCd;
	}

	public void setParLineCd(String parLineCd) {
		this.parLineCd = parLineCd;
	}

	public String getParIssCd() {
		return parIssCd;
	}

	public void setParIssCd(String parIssCd) {
		this.parIssCd = parIssCd;
	}

	public GIACPremDeposit() {
		this.setPolicyNo("");
	}

	public String getOrPrintTag() {
		return orPrintTag;
	}

	public void setOrPrintTag(String orPrintTag) {
		this.orPrintTag = orPrintTag;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	public Integer getTransactionType() {
		return transactionType;
	}

	public void setTransactionType(Integer transactionType) {
		this.transactionType = transactionType;
	}

	public Integer getOldItemNo() {
		return oldItemNo;
	}

	public void setOldItemNo(Integer oldItemNo) {
		this.oldItemNo = oldItemNo;
	}

	public Integer getOldTranType() {
		return oldTranType;
	}

	public void setOldTranType(Integer oldTranType) {
		this.oldTranType = oldTranType;
	}

	public String getB140IssCd() {
		return b140IssCd;
	}

	public void setB140IssCd(String b140IssCd) {
		this.b140IssCd = b140IssCd;
	}

	public Integer getB140PremSeqNo() {
		return b140PremSeqNo;
	}

	public void setB140PremSeqNo(Integer b140PremSeqNo) {
		this.b140PremSeqNo = b140PremSeqNo;
	}

	public Integer getInstNo() {
		return instNo;
	}

	public void setInstNo(Integer instNo) {
		this.instNo = instNo;
	}

	public BigDecimal getCollectionAmt() {
		return collectionAmt;
	}

	public void setCollectionAmt(BigDecimal collectionAmt) {
		this.collectionAmt = collectionAmt;
	}

	public String getDepFlag() {
		return depFlag;
	}

	public void setDepFlag(String depFlag) {
		this.depFlag = depFlag;
	}

	public Integer getAssdNo() {
		return assdNo;
	}

	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}

	public String getAssuredName() {
		return assuredName;
	}

	public void setAssuredName(String assuredName) {
		this.assuredName = assuredName;
	}

	public Integer getIntmNo() {
		return intmNo;
	}

	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}

	public Integer getRiCd() {
		return riCd;
	}

	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}

	public Integer getParSeqNo() {
		return parSeqNo;
	}

	public void setParSeqNo(Integer parSeqNo) {
		this.parSeqNo = parSeqNo;
	}

	public Integer getQuoteSeqNo() {
		return quoteSeqNo;
	}

	public void setQuoteSeqNo(Integer quoteSeqNo) {
		this.quoteSeqNo = quoteSeqNo;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getSublineCd() {
		return sublineCd;
	}

	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public Integer getIssueYy() {
		return issueYy;
	}

	public void setIssueYy(Integer issueYy) {
		this.issueYy = issueYy;
	}

	public Integer getPolSeqNo() {
		return polSeqNo;
	}

	public void setPolSeqNo(Integer polSeqNo) {
		this.polSeqNo = polSeqNo;
	}

	public Integer getRenewNo() {
		return renewNo;
	}

	public void setRenewNo(Integer renewNo) {
		this.renewNo = renewNo;
	}

	public Date getCollnDt() {
		return collnDt;
	}

	public void setCollnDt(Date collnDt) {
//		try {
			this.collnDt =  collnDt;// == null ? null : new SimpleDateFormat("MM/dd/yyyy hh:mm:ss a").parse(collnDt.toString());
//		} catch (ParseException e) {
//			e.printStackTrace();
//			this.collnDt = null;
//		}
	}

	public Integer getGaccTranId() {
		return gaccTranId;
	}

	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}

	public Integer getOldTranId() {
		return oldTranId;
	}

	public void setOldTranId(Integer oldTranId) {
		this.oldTranId = oldTranId;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
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

	public Integer getCurrencyCd() {
		return currencyCd;
	}

	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}

	public String getCurrencyDesc() {
		return currencyDesc;
	}

	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
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

	public String getOrTag() {
		return orTag;
	}

	public void setOrTag(String orTag) {
		this.orTag = orTag;
	}

	public Integer getCommRecNo() {
		return commRecNo;
	}

	public void setCommRecNo(Integer commRecNo) {
		this.commRecNo = commRecNo;
	}

	public String getIntmName() {
		return intmName;
	}

	public void setIntmName(String intmName) {
		this.intmName = intmName;
	}

	public String getRiName() {
		return riName;
	}

	public void setRiName(String riName) {
		this.riName = riName;
	}

	public String getIssName() {
		return issName;
	}

	public void setIssName(String issName) {
		this.issName = issName;
	}

	public String getBillNo() {
		return billNo;
	}

	public void setBillNo(String billNo) {
		this.billNo = billNo;
	}

	public String getPolicyNo() {
		return policyNo;
	}

	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}

	public String getTranTypeName() {
		return tranTypeName;
	}

	public void setTranTypeName(String tranTypeName) {
		this.tranTypeName = tranTypeName;
	}

	public Integer getParYy() {
		return parYy;
	}

	public void setParYy(Integer parYy) {
		this.parYy = parYy;
	}

	public String getDspOldTranNo() {
		return dspOldTranNo;
	}

	public void setDspOldTranNo(String dspOldTranNo) {
		this.dspOldTranNo = dspOldTranNo;
	}

	public Integer getEndt_seq_no() {
		return endt_seq_no;
	}

	public void setEndt_seq_no(Integer endt_seq_no) {
		this.endt_seq_no = endt_seq_no;
	}

	public String getAssd_name() {
		return assd_name;
	}

	public void setAssd_name(String assd_name) {
		this.assd_name = assd_name;
	}

	public String getDsp_policy_no() {
		return dsp_policy_no;
	}

	public void setDsp_policy_no(String dsp_policy_no) {
		this.dsp_policy_no = dsp_policy_no;
	}

	public String getDsp_old_tran_no() {
		return dsp_old_tran_no;
	}

	public void setDsp_old_tran_no(String dsp_old_tran_no) {
		this.dsp_old_tran_no = dsp_old_tran_no;
	}
}
