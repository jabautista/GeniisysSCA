package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;
import com.seer.framework.util.StringFormatter;

public class GICLClmResHist extends BaseEntity{
	private Integer claimId;
	private Integer clmResHistId;
	private Integer histSeqNo;
	private Integer itemNo;
	private Integer perilCd;
	private String payeeClassCd;
	private Integer payeeCd;
	private Date datePaid;
	private BigDecimal lossReserve;
	private BigDecimal lossesPaid;
	private BigDecimal expenseReserve;
	private BigDecimal expensesPaid;
	private String distSw;            
	private Integer currencyCd;
	private BigDecimal convertRate;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private BigDecimal prevLossRes;
	private BigDecimal prevLossPaid;
	private BigDecimal prevExpRes;
	private BigDecimal prevExpPaid;
	private String eimTakeupTag;
	private Integer tranId;
	private String cancelTag;
	private String remarks;
	private String bookingMonth;
	private Integer bookingYear;
	private Date negateDate;
	private Date cancelDate;
	private Integer adviceId;
	private Date distributionDate;
	private Integer clmLossId;
	private BigDecimal netPdLoss;
	private BigDecimal netPdExp;
	private Integer distNo;
	private Integer groupedItemNo;
	private Integer distType;
	private String dspPerilName;
	private String userId;
    
    private String giclReserveRidsExist;
    
    // non-column properties
    private String dspCurrencyDesc;
    private String nbtDistTypeDesc;
    private String dspBookingDate;
    private String sdfLastUpdate; //added by steven 06.04.2013
    
    public GICLClmResHist() {
		
	}
    
    public GICLClmResHist(Integer claimId, Integer clmResHistId, String remarks) {
		this.claimId = claimId;
		this.clmResHistId = clmResHistId;
		this.remarks = remarks;
	}
    
    public GICLClmResHist(Integer claimId, Integer clmResHistId, String remarks, String userId) {
		this.claimId = claimId;
		this.clmResHistId = clmResHistId;
		this.remarks = remarks;
		this.userId = userId;
	}

    public GICLClmResHist(Integer claimId, Integer itemNo, Integer perilCd,
			Integer groupedItemNo) {
		this.claimId = claimId;
		this.itemNo = itemNo;
		this.perilCd = perilCd;
		this.groupedItemNo = groupedItemNo;
	}

	/**
     * For Testing
     */
    public void displayValuesInConsole(){
    	System.out.println("claimId       : " + claimId);
    	System.out.println("perilCd       : " + perilCd);
    	System.out.println("lossReserve   : " + lossReserve);
    	System.out.println("lossesPaid    : " + lossesPaid);
    	System.out.println("expenseReserve: " + expenseReserve);
    	System.out.println("expensesPaid  : " + expensesPaid);
    	System.out.println("convertRate   : " + convertRate); 
    	System.out.println("bookingMonth  : " + bookingMonth);
    	System.out.println("bookingYear   : " + bookingYear);
    }
    
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public Integer getClmResHistId() {
		return clmResHistId;
	}
	public void setClmResHistId(Integer clmResHistId) {
		this.clmResHistId = clmResHistId;
	}
	public Integer getHistSeqNo() {
		return histSeqNo;
	}
	public void setHistSeqNo(Integer histSeqNo) {
		this.histSeqNo = histSeqNo;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public Integer getPerilCd() {
		return perilCd;
	}
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	public String getPayeeClassCd() {
		return payeeClassCd;
	}
	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
	}
	public Integer getPayeeCd() {
		return payeeCd;
	}
	public void setPayeeCd(Integer payeeCd) {
		this.payeeCd = payeeCd;
	}
	public Date getDatePaid() {
		return datePaid;
	}
	public void setDatePaid(Date datePaid) {
		this.datePaid = datePaid;
	}
	public BigDecimal getLossReserve() {
		return lossReserve;
	}
	public void setLossReserve(BigDecimal lossReserve) {
		this.lossReserve = lossReserve;
	}
	public BigDecimal getLossesPaid() {
		return lossesPaid;
	}
	public void setLossesPaid(BigDecimal lossesPaid) {
		this.lossesPaid = lossesPaid;
	}
	public BigDecimal getExpenseReserve() {
		return expenseReserve;
	}
	public void setExpenseReserve(BigDecimal expenseReserve) {
		this.expenseReserve = expenseReserve;
	}
	public BigDecimal getExpensesPaid() {
		return expensesPaid;
	}
	public void setExpensesPaid(BigDecimal expensesPaid) {
		this.expensesPaid = expensesPaid;
	}
	public String getDistSw() {
		return distSw;
	}
	public void setDistSw(String distSw) {
		this.distSw = distSw;
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
	public BigDecimal getPrevLossRes() {
		return prevLossRes;
	}
	public void setPrevLossRes(BigDecimal prevLossRes) {
		this.prevLossRes = prevLossRes;
	}
	public BigDecimal getPrevLossPaid() {
		return prevLossPaid;
	}
	public void setPrevLossPaid(BigDecimal prevLossPaid) {
		this.prevLossPaid = prevLossPaid;
	}
	public BigDecimal getPrevExpRes() {
		return prevExpRes;
	}
	public void setPrevExpRes(BigDecimal prevExpRes) {
		this.prevExpRes = prevExpRes;
	}
	public BigDecimal getPrevExpPaid() {
		return prevExpPaid;
	}
	public void setPrevExpPaid(BigDecimal prevExpPaid) {
		this.prevExpPaid = prevExpPaid;
	}
	public String getEimTakeupTag() {
		return eimTakeupTag;
	}
	public void setEimTakeupTag(String eimTakeupTag) {
		this.eimTakeupTag = eimTakeupTag;
	}
	public Integer getTranId() {
		return tranId;
	}
	public void setTranId(Integer tranId) {
		this.tranId = tranId;
	}
	public String getCancelTag() {
		return cancelTag;
	}
	public void setCancelTag(String cancelTag) {
		this.cancelTag = cancelTag;
	}
	public String getRemarks() {
		return StringFormatter.escapeBackslash(StringFormatter.replaceTildes(StringFormatter.replaceQuotes(StringFormatter.escapeHTML(remarks)))); //lara 11-07-2013
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getBookingMonth() {
		return bookingMonth;
	}
	public void setBookingMonth(String bookingMonth) {
		this.bookingMonth = bookingMonth;
	}
	public Integer getBookingYear() {
		return bookingYear;
	}
	public void setBookingYear(Integer bookingYear) {
		this.bookingYear = bookingYear;
	}
	public Date getNegateDate() {
		return negateDate;
	}
	public void setNegateDate(Date negateDate) {
		this.negateDate = negateDate;
	}
	public Date getCancelDate() {
		return cancelDate;
	}
	public void setCancelDate(Date cancelDate) {
		this.cancelDate = cancelDate;
	}
	public Integer getAdviceId() {
		return adviceId;
	}
	public void setAdviceId(Integer adviceId) {
		this.adviceId = adviceId;
	}
	public Date getDistributionDate() {
		return distributionDate;
	}
	public void setDistributionDate(Date distributionDate) {
		this.distributionDate = distributionDate;
	}
	public Integer getClmLossId() {
		return clmLossId;
	}
	public void setClmLossId(Integer clmLossId) {
		this.clmLossId = clmLossId;
	}
	public BigDecimal getNetPdLoss() {
		return netPdLoss;
	}
	public void setNetPdLoss(BigDecimal netPdLoss) {
		this.netPdLoss = netPdLoss;
	}
	public BigDecimal getNetPdExp() {
		return netPdExp;
	}
	public void setNetPdExp(BigDecimal netPdExp) {
		this.netPdExp = netPdExp;
	}
	public Integer getDistNo() {
		return distNo;
	}
	public void setDistNo(Integer distNo) {
		this.distNo = distNo;
	}
	public Integer getGroupedItemNo() {
		return groupedItemNo;
	}
	public void setGroupedItemNo(Integer groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}
	public Integer getDistType() {
		return distType;
	}
	public void setDistType(Integer distType) {
		this.distType = distType;
	}
	public String getDspPerilName() {
		return dspPerilName;
	}
	public void setDspPerilName(String dspPerilName) {
		this.dspPerilName = dspPerilName;
	}
	public String getDspCurrencyDesc() {
		return dspCurrencyDesc;
	}
	public void setDspCurrencyDesc(String dspCurrencyDesc) {
		this.dspCurrencyDesc = dspCurrencyDesc;
	}
	public String getGiclReserveRidsExist() {
		return giclReserveRidsExist;
	}
	public void setGiclReserveRidsExist(String giclReserveRidsExist) {
		this.giclReserveRidsExist = giclReserveRidsExist;
	}

	public void setNbtDistTypeDesc(String nbtDistTypeDesc) {
		this.nbtDistTypeDesc = nbtDistTypeDesc;
	}

	public String getNbtDistTypeDesc() {
		return nbtDistTypeDesc;
	}
	
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getDspBookingDate() {
		if(this.getBookingMonth() != null){ // added so that null pointer exception won't occur retrieving tablegrid irwin - 11.16.2012
			return this.getBookingMonth()+" - "+this.getBookingYear().toString();
		}
		return "";
	}

	public void setDspBookingDate(String dspBookingDate) {
		this.dspBookingDate = dspBookingDate;
	}
	
	public GICLClaimReserve toGICLClaimReserve(){
		GICLClaimReserve claimReserve = new GICLClaimReserve();
		claimReserve.setClaimId(claimId);
		claimReserve.setItemNo(itemNo);
		claimReserve.setPerilCd(perilCd);
		claimReserve.setLossReserve(lossReserve);
		claimReserve.setLossesPaid(lossesPaid);
		claimReserve.setExpenseReserve(expenseReserve);
		claimReserve.setExpensesPaid(expensesPaid);
		claimReserve.setCurrencyCd(currencyCd);
		claimReserve.setConvertRate(convertRate);
		claimReserve.setNetPdLoss(netPdLoss);
		claimReserve.setNetPdExp(netPdExp);
		claimReserve.setGroupedItemNo(groupedItemNo);		
		
		return claimReserve;
	}

	/**
	 * @return the sdfLastUpdate
	 */
	public String getSdfLastUpdate() {
		return sdfLastUpdate;
	}

	/**
	 * @param sdfLastUpdate the sdfLastUpdate to set
	 */
	public void setSdfLastUpdate(String sdfLastUpdate) {
		this.sdfLastUpdate = sdfLastUpdate;
	}
}