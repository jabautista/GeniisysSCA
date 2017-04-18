package com.geniisys.gipi.pack.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.geniisys.gipi.entity.GIPIQuote;
import com.seer.framework.util.Entity;

@SuppressWarnings({ "rawtypes" })
public class GIPIPackQuote extends Entity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2225871594641850356L;

	@Override
	public Object getId() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void setId(Object id) {
		// TODO Auto-generated method stub
		
	}
	private String quoteNo;
	private Integer packQuoteId;
	private String lineCd;
	private String lineName;
	private String issCd;
	private String issName;
	private String sublineCd;
	private String sublineName;
	private Integer quotationYy;
	private Integer quotationNo;
	private Integer proposalNo;
	private Integer assdNo;
	private String assdName;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private Date printDt;
	private Date acceptDt;
	private Date postDt;
	private Date deniedDt;
	private String status;
	private String printTag;
	private String header;
	private String footer;
	private String remarks;
	private String userId;
	private Date lastUpdate;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private Integer quotationPrintedCnt;
	private Date inceptDate;
	private Date expiryDate;
	private String origin;
	private Integer reasonCd;
	private String address1;
	private String address2;
	private String address3;
	private String assured;
	private String assdActiveTag;
	private Date validDate;
	private String underwriter;
	private Integer noOfDays;
	private String credBranch;
	private String credBranchName;
	private String acctOf;
	private Integer acctOfCd;
	private String acctOfCdSw;
	private String prorateFlag;
	private String reasonDesc;
	private String compSw;
	private BigDecimal shortRatePercent;
	private BigDecimal annPremAmt;
	private BigDecimal annTsiAmt;
	private String withTariffSw;
	private String inceptTag;
	private String expiryTag;
	private Integer inspNo;
	private String bankRefNo;
	private List<GIPIQuote> gipiQuotesList; // added by: nica 06.17.2011
	private Integer accountOfSW; //Added by Jerome 08.18.2016 SR 5586
	//private int quoteNo;

	/**
	 * Gets the valid date.
	 * 
	 * @return the valid date
	 */
	public String getValidDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if(validDate!=null){
			return df.format(validDate);
		}else{
			return null;
		}
	}

	public String getUnderwriter() {
		return underwriter;
	}

	public void setUnderwriter(String underwriter) {
		this.underwriter = underwriter;
	}

	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}

	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}

	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}

	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}

	public String getWithTariffSw() {
		return withTariffSw;
	}

	public void setWithTariffSw(String withTariffSw) {
		this.withTariffSw = withTariffSw;
	}

	public String getInceptTag() {
		return inceptTag;
	}

	public void setInceptTag(String inceptTag) {
		this.inceptTag = inceptTag;
	}

	public String getExpiryTag() {
		return expiryTag;
	}

	public void setExpiryTag(String expiryTag) {
		this.expiryTag = expiryTag;
	}

	/**
	 * Sets the valid date.
	 * 
	 * @param validDate the new valid date
	 */
	public void setValidDate(Date validDate) {
		this.validDate = validDate;
	}

	public Integer getPackQuoteId() {
		return packQuoteId;
	}

	public void setPackQuoteId(Integer packQuoteId) {
		this.packQuoteId = packQuoteId;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public Integer getQuotationYy() {
		return quotationYy;
	}

	public void setQuotationYy(Integer quotationYy) {
		this.quotationYy = quotationYy;
	}

	public Integer getQuotationNo() {
		return quotationNo;
	}

	public void setQuotationNo(Integer quotationNo) {
		this.quotationNo = quotationNo;
	}

	public Integer getProposalNo() {
		return proposalNo;
	}

	public void setProposalNo(Integer proposalNo) {
		this.proposalNo = proposalNo;
	}

	public Integer getAssdNo() {
		return assdNo;
	}

	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}

	public String getAssdName() {
		return assdName;
	}

	public void setAssdName(String assdName) {
		this.assdName = assdName;
	}

	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}

	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}

	public BigDecimal getPremAmt() {
		return premAmt;
	}

	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}

	public String getPrintDt() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if(printDt!=null){
			return df.format(printDt);
		}else{
			return null;
		}
	}

	public void setPrintDt(Date printDt) {
		this.printDt = printDt;
	}

	public String getAcceptDt() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if(acceptDt!=null){
			return df.format(acceptDt);
		}else{
			return null;
		}
	}

	public void setAcceptDt(Date acceptDt) {
		this.acceptDt = acceptDt;
	}

	public String getPostDt() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if(postDt!=null){
			return df.format(postDt);
		}else{
			return null;
		}
	}

	public void setPostDt(Date postDt) {
		this.postDt = postDt;
	}

	public String getDeniedDt() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if(deniedDt!=null){
			return df.format(deniedDt);
		}else{
			return null;
		}
	}

	public void setDeniedDt(Date deniedDt) {
		this.deniedDt = deniedDt;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getPrintTag() {
		return printTag;
	}

	public void setPrintTag(String printTag) {
		this.printTag = printTag;
	}

	public String getHeader() {
		return header;
	}

	public void setHeader(String header) {
		this.header = header;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	@Override
	public String getUserId() {
		return userId;
	}

	@Override
	public void setUserId(String userId) {
		this.userId = userId;
	}

	@Override
	public Date getLastUpdate() {
		return lastUpdate;
	}

	@Override
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
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

	public Integer getQuotationPrintedCnt() {
		return quotationPrintedCnt;
	}

	public void setQuotationPrintedCnt(Integer quotationPrintedCnt) {
		this.quotationPrintedCnt = quotationPrintedCnt;
	}

	public String getInceptDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if(inceptDate!=null){
			return df.format(inceptDate);
		}else{
			return null;
		}
	}

	public void setInceptDate(Date inceptDate) {
		this.inceptDate = inceptDate;
	}

	public String getExpiryDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if(expiryDate!=null){
			return df.format(expiryDate);
		}else{
			return null;
		}
	}

	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public Integer getReasonCd() {
		return reasonCd;
	}

	public void setReasonCd(Integer reasonCd) {
		this.reasonCd = reasonCd;
	}

	public String getAddress1() {
		return address1;
	}

	public void setAddress1(String address1) {
		this.address1 = address1;
	}

	public String getAddress2() {
		return address2;
	}

	public void setAddress2(String address2) {
		this.address2 = address2;
	}

	public String getAddress3() {
		return address3;
	}

	public void setAddress3(String address3) {
		this.address3 = address3;
	}

	public String getSublineCd() {
		return sublineCd;
	}

	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	public void setFooter(String footer) {
		this.footer = footer;
	}

	public String getFooter() {
		return footer;
	}

	public void setAssured(String assured) {
		this.assured = assured;
	}

	public String getAssured() {
		return assured;
	}

	public void setAssdActiveTag(String assdActiveTag) {
		this.assdActiveTag = assdActiveTag;
	}

	public String getAssdActiveTag() {
		return assdActiveTag;
	}

	/**
	 * @param quoteNo the quoteNo to set
	 */
	public void setQuoteNo(String quoteNo) {
		this.quoteNo = quoteNo;
	}

	/**
	 * @return the quoteNo
	 */
	public String getQuoteNo() {
		return quoteNo;
	}

	/**
	 * @param noOfDays the noOfDays to set
	 */
	public void setNoOfDays(Integer noOfDays) {
		this.noOfDays = noOfDays;
	}

	/**
	 * @return the noOfDays
	 */
	public Integer getNoOfDays() {
		return noOfDays;
	}

	/**
	 * @param lineName the lineName to set
	 */
	public void setLineName(String lineName) {
		this.lineName = lineName;
	}

	/**
	 * @return the lineName
	 */
	public String getLineName() {
		return lineName;
	}

	/**
	 * @param sublineName the sublineName to set
	 */
	public void setSublineName(String sublineName) {
		this.sublineName = sublineName;
	}

	/**
	 * @return the sublineName
	 */
	public String getSublineName() {
		return sublineName;
	}

	/**
	 * @param issName the issName to set
	 */
	public void setIssName(String issName) {
		this.issName = issName;
	}

	/**
	 * @return the issName
	 */
	public String getIssName() {
		return issName;
	}

	/**
	 * @param credBranch the credBranch to set
	 */
	public void setCredBranch(String credBranch) {
		this.credBranch = credBranch;
	}

	/**
	 * @return the credBranch
	 */
	public String getCredBranch() {
		return credBranch;
	}

	/**
	 * @param credBranchName the credBranchName to set
	 */
	public void setCredBranchName(String credBranchName) {
		this.credBranchName = credBranchName;
	}

	/**
	 * @return the credBranchName
	 */
	public String getCredBranchName() {
		return credBranchName;
	}

	/**
	 * @param acctOf the acctOf to set
	 */
	public void setAcctOf(String acctOf) {
		this.acctOf = acctOf;
	}

	/**
	 * @return the acctOf
	 */
	public String getAcctOf() {
		return acctOf;
	}

	/**
	 * @param acctOfCd the acctOfCd to set
	 */
	public void setAcctOfCd(Integer acctOfCd) {
		this.acctOfCd = acctOfCd;
	}

	/**
	 * @return the acctOfCd
	 */
	public Integer getAcctOfCd() {
		return acctOfCd;
	}

	/**
	 * @param prorateFlag the prorateFlag to set
	 */
	public void setProrateFlag(String prorateFlag) {
		this.prorateFlag = prorateFlag;
	}

	/**
	 * @return the prorateFlag
	 */
	public String getProrateFlag() {
		return prorateFlag;
	}

	/**
	 * @param reasonDesc the reasonDesc to set
	 */
	public void setReasonDesc(String reasonDesc) {
		this.reasonDesc = reasonDesc;
	}

	/**
	 * @return the reasonDesc
	 */
	public String getReasonDesc() {
		return reasonDesc;
	}

	/**
	 * @param compSw the compSw to set
	 */
	public void setCompSw(String compSw) {
		this.compSw = compSw;
	}

	/**
	 * @return the compSw
	 */
	public String getCompSw() {
		return compSw;
	}

	/**
	 * @param shortRatePercent the shortRatePercent to set
	 */
	public void setShortRatePercent(BigDecimal shortRatePercent) {
		this.shortRatePercent = shortRatePercent;
	}

	/**
	 * @return the shortRatePercent
	 */
	public BigDecimal getShortRatePercent() {
		return shortRatePercent;
	}

	/**
	 * @param inspNo the inspNo to set
	 */
	public void setInspNo(Integer inspNo) {
		this.inspNo = inspNo;
	}

	/**
	 * @return the inspNo
	 */
	public Integer getInspNo() {
		return inspNo;
	}

	/**
	 * @param acctOfCdSw the acctOfCdSw to set
	 */
	public void setAcctOfCdSw(String acctOfCdSw) {
		this.acctOfCdSw = acctOfCdSw;
	}

	/**
	 * @return the acctOfCdSw
	 */
	public String getAcctOfCdSw() {
		return acctOfCdSw;
	}

	/**
	 * @param bankRefNo the bankRefNo to set
	 */
	public void setBankRefNo(String bankRefNo) {
		this.bankRefNo = bankRefNo;
	}

	/**
	 * @return the bankRefNo
	 */
	public String getBankRefNo() {
		return bankRefNo;
	}

	public void setGipiQuotesList(List<GIPIQuote> gipiQuotesList) {
		this.gipiQuotesList = gipiQuotesList;
	}

	public List<GIPIQuote> getGipiQuotesList() {
		return gipiQuotesList;
	}

	public Integer getAccountOfSW() {
		return accountOfSW;
	}

	public void setAccountOfSW(Integer accountOfSW) {
		this.accountOfSW = accountOfSW;
	}


	


	
	

}
