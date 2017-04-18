/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.DateUtil;
import com.seer.framework.util.Entity;


/**
 * The Class GIPIQuote.
 */
@SuppressWarnings("rawtypes")
public class GIPIQuote extends Entity{

	private static final long serialVersionUID = 7288158398202596683L;
	
	private Integer quoteId;
	private String lineCd;
	private String menuLineCd;
	private String lineName;
	private String sublineCd;
	private String sublineName;
	private String issCd;
	private String issName;
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
	private String remarks;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private Integer quotationPrintedCnt;
	private Date inceptDate;
	private Date expiryDate;
	private String origin;
	private Integer reasonCd;
	private String reasonDesc;
	private String address1;
	private String address2;
	private String address3;
	private Date validDate;
	private String prorateFlag;
	private BigDecimal shortRatePercent;
	private String compSw;
	private String underwriter;
	private Integer inspNo;
	private BigDecimal annPremAmt;
	private BigDecimal annTsiAmt;
	private String withTariffSw;
	private String inceptTag;
	private String expiryTag;
	private String credBranch;
	private String credBranchName;
	private String acctOf;
	private Integer acctOfCd;
	private String acctOfCdSw;
	private Integer packQuoteId;
	private String packPolFlag;
	private String footer;
	private String quoteNo;
	private Integer noOfDays;
	private Integer parId;
	private String parNo;	
	private String polNo;
	private Date acceptDate;
	private String parAssd;
	private String assdActiveTag;
	private Integer elapsedDays;
	private String bankRefNo;
	private Integer parYy;
	private Integer parSeqNo;	
	private Integer quoteSeqNo;	
	private Integer policyId;	
	private Integer issueYy;	
	private Integer polSeqNo;	
	private String endtIssCd;	
	private Integer endtYy;	
	private Integer endtSeqNo;	
	private Integer renewNo;
	private String packQuoteNo;
	private String packQuoteLineCd;
	private Integer accountOfSW; //Added by Jerome 08.18.2016
	
	public GIPIQuote(){
		
	}
	
	public Integer getParId() {
		return parId;
	}

	public void setParId(Integer parId) {
		this.parId = parId;
	}

	public Integer getParYy() {
		return parYy;
	}

	public void setParYy(Integer parYy) {
		this.parYy = parYy;
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

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
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

	public String getEndtIssCd() {
		return endtIssCd;
	}

	public void setEndtIssCd(String endtIssCd) {
		this.endtIssCd = endtIssCd;
	}

	public Integer getEndtYy() {
		return endtYy;
	}

	public void setEndtYy(Integer endtYy) {
		this.endtYy = endtYy;
	}

	public Integer getEndtSeqNo() {
		return endtSeqNo;
	}

	public void setEndtSeqNo(Integer endtSeqNo) {
		this.endtSeqNo = endtSeqNo;
	}

	public Integer getRenewNo() {
		return renewNo;
	}

	public void setRenewNo(Integer renewNo) {
		this.renewNo = renewNo;
	}

	/**
	 * Gets the no of days.
	 * 
	 * @return the no of days
	 */
	public Integer getNoOfDays() {
		return noOfDays;
	}

	/**
	 * Sets the no of days.
	 * 
	 * @param noOfDays the new no of days
	 */
	public void setNoOfDays(Integer noOfDays) {
		this.noOfDays = noOfDays;
	}

	/**
	 * Gets the subline name.
	 * 
	 * @return the subline name
	 */
	public String getSublineName() {
		return sublineName;
	}

	/**
	 * Sets the subline name.
	 * 
	 * @param sublineName the new subline name
	 */
	public void setSublineName(String sublineName) {
		this.sublineName = sublineName;
	}

	/**
	 * Gets the iss name.
	 * 
	 * @return the iss name
	 */
	public String getIssName() {
		return issName;
	}

	/**
	 * Sets the iss name.
	 * 
	 * @param issName the new iss name
	 */
	public void setIssName(String issName) {
		this.issName = issName;
	}

	/**
	 * Gets the cred branch name.
	 * 
	 * @return the cred branch name
	 */
	public String getCredBranchName() {
		return credBranchName;
	}

	/**
	 * Sets the cred branch name.
	 * 
	 * @param credBranchName the new cred branch name
	 */
	public void setCredBranchName(String credBranchName) {
		this.credBranchName = credBranchName;
	}

	/**
	 * Gets the acct of.
	 * 
	 * @return the acct of
	 */
	public String getAcctOf() {
		return acctOf;
	}

	/**
	 * Sets the acct of.
	 * 
	 * @param acctOf the new acct of
	 */
	public void setAcctOf(String acctOf) {
		this.acctOf = acctOf;
	}
	
	/**
	 * Gets the quote id.
	 * 
	 * @return the quote id
	 */
	public Integer getQuoteId() {
		return quoteId;
	}

	/**
	 * Sets the quote id.
	 * 
	 * @param quoteId the new quote id
	 */
	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}

	/**
	 * Gets the line cd.
	 * 
	 * @return the line cd
	 */
	public String getLineCd() {
		return lineCd;
	}

	/**
	 * Sets the line cd.
	 * 
	 * @param lineCd the new line cd
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	/**
	 * Gets the subline cd.
	 * 
	 * @return the subline cd
	 */
	public String getSublineCd() {
		return sublineCd;
	}

	/**
	 * Sets the subline cd.
	 * 
	 * @param sublineCd the new subline cd
	 */
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	/**
	 * Gets the iss cd.
	 * 
	 * @return the iss cd
	 */
	public String getIssCd() {
		return issCd;
	}

	/**
	 * Sets the iss cd.
	 * 
	 * @param issCd the new iss cd
	 */
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	/**
	 * Gets the quotation yy.
	 * 
	 * @return the quotation yy
	 */
	public Integer getQuotationYy() {
		return quotationYy;
	}

	/**
	 * Sets the quotation yy.
	 * 
	 * @param quotationYy the new quotation yy
	 */
	public void setQuotationYy(Integer quotationYy) {
		this.quotationYy = quotationYy;
	}

	/**
	 * Gets the quotation no.
	 * 
	 * @return the quotation no
	 */
	public Integer getQuotationNo() {
		return quotationNo;
	}

	/**
	 * Sets the quotation no.
	 * 
	 * @param quotationNo the new quotation no
	 */
	public void setQuotationNo(Integer quotationNo) {
		this.quotationNo = quotationNo;
	}

	/**
	 * Gets the proposal no.
	 * 
	 * @return the proposal no
	 */
	public Integer getProposalNo() {
		return proposalNo;
	}

	/**
	 * Sets the proposal no.
	 * 
	 * @param proposalNo the new proposal no
	 */
	public void setProposalNo(Integer proposalNo) {
		this.proposalNo = proposalNo;
	}

	/**
	 * Gets the assd no.
	 * 
	 * @return the assd no
	 */
	public Integer getAssdNo() {
		return assdNo;
	}

	/**
	 * Sets the assd no.
	 * 
	 * @param assdNo the new assd no
	 */
	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}

	/**
	 * Gets the assd name.
	 * 
	 * @return the assd name
	 */
	public String getAssdName() {
		return assdName;
	}

	/**
	 * Sets the assd name.
	 * 
	 * @param assdName the new assd name
	 */
	public void setAssdName(String assdName) {
		this.assdName = assdName;
	}

	/**
	 * Gets the tsi amt.
	 * 
	 * @return the tsi amt
	 */
	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}

	/**
	 * Sets the tsi amt.
	 * 
	 * @param tsiAmt the new tsi amt
	 */
	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}

	/**
	 * Gets the prem amt.
	 * 
	 * @return the prem amt
	 */
	public BigDecimal getPremAmt() {
		return premAmt;
	}

	/**
	 * Sets the prem amt.
	 * 
	 * @param premAmt the new prem amt
	 */
	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}

	/**
	 * Gets the prints the dt.
	 * 
	 * @return the prints the dt
	 */
	public String getPrintDt() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if(printDt!=null){
			return df.format(printDt);
		}else{
			return null;
		}
	}

	/**
	 * Sets the prints the dt.
	 * 
	 * @param printDt the new prints the dt
	 */
	public void setPrintDt(Date printDt) {
		this.printDt = printDt;
	}

	/**
	 * Gets the accept dt.
	 * 
	 * @return the accept dt
	 */
	public String getAcceptDt() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if(acceptDt!=null){
			return df.format(acceptDt);
		}else{
			return null;
		}
	}

	/**
	 * Sets the accept dt.
	 * 
	 * @param acceptDt the new accept dt
	 */
	public void setAcceptDt(Date acceptDt) {
		this.acceptDt = acceptDt;
	}

	/**
	 * Gets the post dt.
	 * 
	 * @return the post dt
	 */
	public String getPostDt() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if(postDt!=null){
			return df.format(postDt);
		}else{
			return null;
		}
	}

	/**
	 * Sets the post dt.
	 * 
	 * @param postDt the new post dt
	 */
	public void setPostDt(Date postDt) {
		this.postDt = postDt;
	}

	/**
	 * Gets the denied dt.
	 * 
	 * @return the denied dt
	 */
	public String getDeniedDt() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if(deniedDt!=null){
			return df.format(deniedDt);
		}else{
			return null;
		}
	}

	/**
	 * Sets the denied dt.
	 * 
	 * @param deniedDt the new denied dt
	 */
	public void setDeniedDt(Date deniedDt) {
		this.deniedDt = deniedDt;
	}

	/**
	 * Gets the status.
	 * 
	 * @return the status
	 */
	public String getStatus() {
		return status;
	}

	/**
	 * Sets the status.
	 * 
	 * @param status the new status
	 */
	public void setStatus(String status) {
		this.status = status;
	}

	/**
	 * Gets the prints the tag.
	 * 
	 * @return the prints the tag
	 */
	public String getPrintTag() {
		return printTag;
	}

	/**
	 * Sets the prints the tag.
	 * 
	 * @param printTag the new prints the tag
	 */
	public void setPrintTag(String printTag) {
		this.printTag = printTag;
	}

	/**
	 * Gets the header.
	 * 
	 * @return the header
	 */
	public String getHeader() {
		return header;
	}

	/**
	 * Sets the header.
	 * 
	 * @param header the new header
	 */
	public void setHeader(String header) {
		this.header = header;
	}

	/**
	 * Gets the remarks.
	 * 
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * Sets the remarks.
	 * 
	 * @param remarks the new remarks
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	/**
	 * Gets the cpi rec no.
	 * 
	 * @return the cpi rec no
	 */
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	/**
	 * Sets the cpi rec no.
	 * 
	 * @param cpiRecNo the new cpi rec no
	 */
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	/**
	 * Gets the cpi branch cd.
	 * 
	 * @return the cpi branch cd
	 */
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	/**
	 * Sets the cpi branch cd.
	 * 
	 * @param cpiBranchCd the new cpi branch cd
	 */
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	/**
	 * Gets the quotation printed cnt.
	 * 
	 * @return the quotation printed cnt
	 */
	public Integer getQuotationPrintedCnt() {
		return quotationPrintedCnt;
	}

	/**
	 * Sets the quotation printed cnt.
	 * 
	 * @param quotationPrintedCnt the new quotation printed cnt
	 */
	public void setQuotationPrintedCnt(Integer quotationPrintedCnt) {
		this.quotationPrintedCnt = quotationPrintedCnt;
	}

	/**
	 * Gets the incept date.
	 * 
	 * @return the incept date
	 */
	public String getInceptDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if(inceptDate!=null){
			return df.format(inceptDate);
		}else{
			return null;
		}
	}

	/**
	 * Sets the incept date.
	 * 
	 * @param inceptDate the new incept date
	 */
	public void setInceptDate(Date inceptDate) {
		this.inceptDate = inceptDate;
	}

	/**
	 * Gets the expiry date.
	 * 
	 * @return the expiry date
	 */
	public String getExpiryDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if(expiryDate!=null){
			return df.format(expiryDate);
		}else{
			return null;
		}
	}
	
	/**
	 * Sets the expiry date.
	 * 
	 * @param expiryDate the new expiry date
	 */
	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}

	/**
	 * Gets the origin.
	 * 
	 * @return the origin
	 */
	public String getOrigin() {
		return origin;
	}

	/**
	 * Sets the origin.
	 * 
	 * @param origin the new origin
	 */
	public void setOrigin(String origin) {
		this.origin = origin;
	}

	/**
	 * Gets the reason cd.
	 * 
	 * @return the reason cd
	 */
	public Integer getReasonCd() {
		return reasonCd;
	}

	/**
	 * Sets the reason cd.
	 * 
	 * @param reasonCd the new reason cd
	 */
	public void setReasonCd(Integer reasonCd) {
		this.reasonCd = reasonCd;
	}

	/**
	 * Gets the address1.
	 * 
	 * @return the address1
	 */
	public String getAddress1() {
		return address1;
	}

	/**
	 * Sets the address1.
	 * 
	 * @param address1 the new address1
	 */
	public void setAddress1(String address1) {
		this.address1 = address1;
	}

	/**
	 * Gets the address2.
	 * 
	 * @return the address2
	 */
	public String getAddress2() {
		return address2;
	}

	/**
	 * Sets the address2.
	 * 
	 * @param address2 the new address2
	 */
	public void setAddress2(String address2) {
		this.address2 = address2;
	}

	/**
	 * Gets the address3.
	 * 
	 * @return the address3
	 */
	public String getAddress3() {
		return address3;
	}

	/**
	 * Sets the address3.
	 * 
	 * @param address3 the new address3
	 */
	public void setAddress3(String address3) {
		this.address3 = address3;
	}

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

	/**
	 * Sets the valid date.
	 * 
	 * @param validDate the new valid date
	 */
	public void setValidDate(Date validDate) {
		this.validDate = validDate;
	}

	/**
	 * Gets the prorate flag.
	 * 
	 * @return the prorate flag
	 */
	public String getProrateFlag() {
		return prorateFlag;
	}

	/**
	 * Sets the prorate flag.
	 * 
	 * @param prorateFlag the new prorate flag
	 */
	public void setProrateFlag(String prorateFlag) {
		this.prorateFlag = prorateFlag;
	}

	/**
	 * Gets the short rate percent.
	 * 
	 * @return the short rate percent
	 */
	public BigDecimal getShortRatePercent() {
		return shortRatePercent;
	}

	/**
	 * Sets the short rate percent.
	 * 
	 * @param shortRatePercent the new short rate percent
	 */
	public void setShortRatePercent(BigDecimal shortRatePercent) {
		this.shortRatePercent = shortRatePercent;
	}

	/**
	 * Gets the comp sw.
	 * 
	 * @return the comp sw
	 */
	public String getCompSw() {
		return compSw;
	}

	/**
	 * Sets the comp sw.
	 * 
	 * @param compSw the new comp sw
	 */
	public void setCompSw(String compSw) {
		this.compSw = compSw;
	}

	/**
	 * Gets the underwriter.
	 * 
	 * @return the underwriter
	 */
	public String getUnderwriter() {
		return underwriter;
	}

	/**
	 * Sets the underwriter.
	 * 
	 * @param underwriter the new underwriter
	 */
	public void setUnderwriter(String underwriter) {
		this.underwriter = underwriter;
	}

	/**
	 * Gets the insp no.
	 * 
	 * @return the insp no
	 */
	public Integer getInspNo() {
		return inspNo;
	}

	/**
	 * Sets the insp no.
	 * 
	 * @param inspNo the new insp no
	 */
	public void setInspNo(Integer inspNo) {
		this.inspNo = inspNo;
	}

	/**
	 * Gets the ann prem amt.
	 * 
	 * @return the ann prem amt
	 */
	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}

	/**
	 * Sets the ann prem amt.
	 * 
	 * @param annPremAmt the new ann prem amt
	 */
	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}

	/**
	 * Gets the ann tsi amt.
	 * 
	 * @return the ann tsi amt
	 */
	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}

	/**
	 * Sets the ann tsi amt.
	 * 
	 * @param annTsiAmt the new ann tsi amt
	 */
	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}

	/**
	 * Gets the with tariff sw.
	 * 
	 * @return the with tariff sw
	 */
	public String getWithTariffSw() {
		return withTariffSw;
	}

	/**
	 * Sets the with tariff sw.
	 * 
	 * @param withTariffSw the new with tariff sw
	 */
	public void setWithTariffSw(String withTariffSw) {
		this.withTariffSw = withTariffSw;
	}

	/**
	 * Gets the incept tag.
	 * 
	 * @return the incept tag
	 */
	public String getInceptTag() {
		return inceptTag;
	}

	/**
	 * Sets the incept tag.
	 * 
	 * @param inceptTag the new incept tag
	 */
	public void setInceptTag(String inceptTag) {
		this.inceptTag = inceptTag;
	}

	/**
	 * Gets the expiry tag.
	 * 
	 * @return the expiry tag
	 */
	public String getExpiryTag() {
		return expiryTag;
	}

	/**
	 * Sets the expiry tag.
	 * 
	 * @param expiryTag the new expiry tag
	 */
	public void setExpiryTag(String expiryTag) {
		this.expiryTag = expiryTag;
	}

	/**
	 * Gets the cred branch.
	 * 
	 * @return the cred branch
	 */
	public String getCredBranch() {
		return credBranch;
	}

	/**
	 * Sets the cred branch.
	 * 
	 * @param credBranch the new cred branch
	 */
	public void setCredBranch(String credBranch) {
		this.credBranch = credBranch;
	}

	/**
	 * Gets the acct of cd.
	 * 
	 * @return the acct of cd
	 */
	public Integer getAcctOfCd() {
		return acctOfCd;
	}

	/**
	 * Sets the acct of cd.
	 * 
	 * @param acctOfCd the new acct of cd
	 */
	public void setAcctOfCd(Integer acctOfCd) {
		this.acctOfCd = acctOfCd;
	}

	/**
	 * Gets the acct of cd sw.
	 * 
	 * @return the acct of cd sw
	 */
	public String getAcctOfCdSw() {
		return acctOfCdSw;
	}

	/**
	 * Sets the acct of cd sw.
	 * 
	 * @param acctOfCdSw the new acct of cd sw
	 */
	public void setAcctOfCdSw(String acctOfCdSw) {
		this.acctOfCdSw = acctOfCdSw;
	}

	/**
	 * Gets the pack quote id.
	 * 
	 * @return the pack quote id
	 */
	public Integer getPackQuoteId() {
		return packQuoteId;
	}

	/**
	 * Sets the pack quote id.
	 * 
	 * @param packQuoteId the new pack quote id
	 */
	public void setPackQuoteId(Integer packQuoteId) {
		this.packQuoteId = packQuoteId;
	}

	/**
	 * Gets the pack pol flag.
	 * 
	 * @return the pack pol flag
	 */
	public String getPackPolFlag() {
		return packPolFlag;
	}

	/**
	 * Sets the pack pol flag.
	 * 
	 * @param packPolFlag the new pack pol flag
	 */
	public void setPackPolFlag(String packPolFlag) {
		this.packPolFlag = packPolFlag;
	}

	/**
	 * Gets the footer.
	 * 
	 * @return the footer
	 */
	public String getFooter() {
		return footer;
	}

	/**
	 * Sets the footer.
	 * 
	 * @param footer the new footer
	 */
	public void setFooter(String footer) {
		this.footer = footer;
	}

	/**
	 * Gets the quote no.
	 * 
	 * @return the quote no
	 */
	public String getQuoteNo() {
		return quoteNo;
	}

	/**
	 * Sets the quote no.
	 * 
	 * @param quoteNo the new quote no
	 */
	public void setQuoteNo(String quoteNo) {
		this.quoteNo = quoteNo;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#getId()
	 */
	/*@Override
	public Object getId() {
		return null;
	}*/

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#setId(java.lang.Object)
	 */
	/*@Override
	public void setId(Object id) {
		
	}*/

	/**
	 * Gets the line name.
	 * 
	 * @return the line name
	 */
	public String getLineName() {
		return lineName;
	}

	/**
	 * Sets the line name.
	 * 
	 * @param lineName the new line name
	 */
	public void setLineName(String lineName) {
		this.lineName = lineName;
	}

	/**
	 * Gets the reason desc.
	 * 
	 * @return the reason desc
	 */
	public String getReasonDesc() {
		return reasonDesc;
	}

	/**
	 * Sets the reason desc.
	 * 
	 * @param reasonDesc the new reason desc
	 */
	public void setReasonDesc(String reasonDesc) {
		this.reasonDesc = reasonDesc;
	}

	@Override
	public Object getId() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void setId(Object id) {
		// TODO Auto-generated method stub
		
	}

	/**
	 * @param parNo the parNo to set
	 */
	public void setParNo(String parNo) {
		this.parNo = parNo;
	}

	/**
	 * @return the parNo
	 */
	public String getParNo() {
		return parNo;
	}

	/**
	 * @param polNo the polNo to set
	 */
	public void setPolNo(String polNo) {
		this.polNo = polNo;
	}

	/**
	 * @return the polNo
	 */
	public String getPolNo() {
		return polNo;
	}

	/**
	 * Get Difference between expiryDate and inceptionDate
	 * @return 
	 */
	public Integer getElapsedDays(){
		if(this.expiryDate==null){
			System.out.println("expiry is NULL");
		}
		if(this.inceptDate==null){
			System.out.println("incept is NULL");
		}
		if (this.expiryDate != null && this.inceptDate != null) {
			this.elapsedDays = DateUtil.getElapsedDays(this.expiryDate, this.inceptDate);
		}
		return this.elapsedDays;
	}

	public void setAcceptDate(Date acceptDate) {
		this.acceptDate = acceptDate;
	}

	public Date getAcceptDate() {
		return acceptDate;
	}

	public void setParAssd(String parAssd) {
		this.parAssd = parAssd;
	}

	public String getParAssd() {
		return parAssd;
	}

	public void setAssdActiveTag(String assdActiveTag) {
		this.assdActiveTag = assdActiveTag;
	}

	public String getAssdActiveTag() {
		return assdActiveTag;
	}

	/**
	 * @param elapsedDays the elapsedDays to set
	 */
	public void setElapsedDays(Integer elapsedDays) {
		this.elapsedDays = elapsedDays;
	}

	public void setMenuLineCd(String menuLineCd) {
		this.menuLineCd = menuLineCd;
	}

	public String getMenuLineCd() {
		return menuLineCd;
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

	public void setPackQuoteNo(String packQuoteNo) {
		this.packQuoteNo = packQuoteNo;
	}

	public String getPackQuoteNo() {
		return packQuoteNo;
	}

	public String getPackQuoteLineCd() {
		return packQuoteLineCd;
	}

	public void setPackQuoteLineCd(String packQuoteLineCd) {
		this.packQuoteLineCd = packQuoteLineCd;
	}

	public Integer getAccountOfSW() {
		return accountOfSW;
	}

	public void setAccountOfSW(Integer accountOfSW) {
		this.accountOfSW = accountOfSW;
	}
	
}
