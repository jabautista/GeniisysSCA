/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import com.seer.framework.util.Entity;


/**
 * The Class GIPIQuoteWithItem.
 */
@SuppressWarnings("rawtypes")
public class GIPIQuoteWithItem extends Entity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 921708463724847095L;

	/** The quote id. */
	private int quoteId;
	
	/** The line cd. */
	private String lineCd; 
	
	/** The subline cd. */
	private String sublineCd;
	
	/** The iss cd. */
	private String issCd;
	
	/** The quotation yy. */
	private int quotationYy;
	
	/** The quotation no. */
	private int quotationNo;
	
	/** The proposal no. */
	private int proposalNo;
	
	/** The assd no. */
	private Integer assdNo;
	
	/** The assd name. */
	private String assdName;
	
	/** The tsi amt. */
	private BigDecimal tsiAmt;
	
	/** The prem amt. */
	private BigDecimal premAmt;
	
	/** The print dt. */
	private Date printDt;
	
	/** The accept dt. */
	private Date acceptDt;
	
	/** The post dt. */
	private Date postDt;
	
	/** The denied dt. */
	private Date deniedDt;
	
	/** The status. */
	private String status;
	
	/** The print tag. */
	private String printTag;
	
	/** The header. */
	private String header;
	
	/** The footer. */
	private String footer;
	
	/** The remarks. */
	private String remarks;
	
	/** The user id. */
	private String userId;
	
	/** The last update. */
	private Date lastUpdate;
	
	/** The cpi rec no. */
	private Integer cpiRecNo;
	
	/** The cpi branch cd. */
	private String cpiBranchCd;
	
	/** The quotation printed cnt. */
	private Integer quotationPrintedCnt;
	
	/** The incept date. */
	private Date inceptDate;
	
	/** The expiry date. */
	private Date expiryDate;
	
	/** The origin. */
	private String origin;
	
	/** The reason cd. */
	private Integer reasonCd;
	
	/** The address1. */
	private String address1;
	
	/** The address2. */
	private String address2;
	
	/** The address3. */
	private String address3;
	
	/** The valid date. */
	private Date validDate;
	
	/** The prorate flag. */
	private String prorateFlag;
	
	/** The short rt percent. */
	private BigDecimal shortRtPercent;
	
	/** The comp sw. */
	private String compSw;
	
	/** The underwriter. */
	private String underwriter;
	
	/** The insp no. */
	private Integer inspNo;
	
	/** The ann prem amt. */
	private BigDecimal annPremAmt;
	
	/** The ann tsi amt. */
	private BigDecimal annTsiAmt;
	
	/** The with tariff sw. */
	private String withTariffSw;
	
	/** The incept tag. */
	private String inceptTag;
	
	/** The expiry tag. */
	private String expiryTag;
	
	/** The cred branch. */
	private String credBranch;
	
	/** The acct of cd. */
	private Integer acctOfCd;
	
	/** The acct of cd sw. */
	private String acctOfCdSw;
	
	/** The pack quote id. */
	private Integer packQuoteId;
	
	/** The pack pol flag. */
	private String packPolFlag;
	
	/** The quote no. */
	private String quoteNo;
	
	/** The quote items. */
	private List<GIPIQuoteItem> quoteItems;
	
	/**
	 * Gets the quote items.
	 * 
	 * @return the quote items
	 */
	public List<GIPIQuoteItem> getQuoteItems() {
		return quoteItems;
	}

	/**
	 * Sets the quote items.
	 * 
	 * @param quoteItems the new quote items
	 */
	public void setQuoteItems(List<GIPIQuoteItem> quoteItems) {
		this.quoteItems = quoteItems;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#getId()
	 */
	@Override
	public Object getId() {
		return null;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#setId(java.lang.Object)
	 */
	@Override
	public void setId(Object id) {
		
	}

	/**
	 * Gets the quote id.
	 * 
	 * @return the quote id
	 */
	public int getQuoteId() {
		return quoteId;
	}

	/**
	 * Sets the quote id.
	 * 
	 * @param quoteId the new quote id
	 */
	public void setQuoteId(int quoteId) {
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
	public int getQuotationYy() {
		return quotationYy;
	}

	/**
	 * Sets the quotation yy.
	 * 
	 * @param quotationYy the new quotation yy
	 */
	public void setQuotationYy(int quotationYy) {
		this.quotationYy = quotationYy;
	}

	/**
	 * Gets the quotation no.
	 * 
	 * @return the quotation no
	 */
	public int getQuotationNo() {
		return quotationNo;
	}

	/**
	 * Sets the quotation no.
	 * 
	 * @param quotationNo the new quotation no
	 */
	public void setQuotationNo(int quotationNo) {
		this.quotationNo = quotationNo;
	}

	/**
	 * Gets the proposal no.
	 * 
	 * @return the proposal no
	 */
	public int getProposalNo() {
		return proposalNo;
	}

	/**
	 * Sets the proposal no.
	 * 
	 * @param proposalNo the new proposal no
	 */
	public void setProposalNo(int proposalNo) {
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
	public Date getPrintDt() {
		return printDt;
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
	public Date getAcceptDt() {
		return acceptDt;
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
	public Date getPostDt() {
		return postDt;
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
	public Date getDeniedDt() {
		return deniedDt;
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

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#getUserId()
	 */
	@Override
	public String getUserId() {
		return userId;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#setUserId(java.lang.String)
	 */
	@Override
	public void setUserId(String userId) {
		this.userId = userId;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#getLastUpdate()
	 */
	@Override
	public Date getLastUpdate() {
		return lastUpdate;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.util.Entity#setLastUpdate(java.util.Date)
	 */
	@Override
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
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
	public Date getInceptDate() {
		return inceptDate;
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
	public Date getExpiryDate() {
		return expiryDate;
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
	public Date getValidDate() {
		return validDate;
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
	 * Gets the short rt percent.
	 * 
	 * @return the short rt percent
	 */
	public BigDecimal getShortRtPercent() {
		return shortRtPercent;
	}

	/**
	 * Sets the short rt percent.
	 * 
	 * @param shortRtPercent the new short rt percent
	 */
	public void setShortRtPercent(BigDecimal shortRtPercent) {
		this.shortRtPercent = shortRtPercent;
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

	/**
	 * Gets the serial version uid.
	 * 
	 * @return the serial version uid
	 */
	public static long getSerialVersionUID() {
		return serialVersionUID;
	}

}
