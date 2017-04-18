/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.seer.framework.util.Entity;


/**
 * The Class GIPIQuotation.
 */
@SuppressWarnings("rawtypes")
public class GIPIQuotation extends Entity{	
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -651280580058657768L;
	
	/** The df. */
	DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
	
	/** The quote id. */
	private Integer quoteId;
	
	/** The quote no. */
	private String quoteNo;
	
	/** The assd name. */
	private String assdName;
	
	/** The incept date. */
	private Date inceptDate;
	
	/** The expiry date. */
	private Date expiryDate;
	
	/** The valid date. */
	private Date validDate;
	
	/** The assd no. */
	private String assdNo;
	
	/** The accept date. */
	private Date acceptDate;
	
	/** The status. */
	private String status;
	
	/** The par assd. */
	private String parAssd;
	
	/** The reason desc. */
	private String reasonDesc;
	
	/** The par no. */
	private String parNo;
	
	/** The pol no. */
	private String polNo;
	
	/** The iss cd. */
	private String issCd;
	
	/** The line cd. */
	private String lineCd;
	
	/** The subline cd. */
	private String sublineCd;
	
	/** The quotation yy. */
	private String quotationYy;
	
	/** The proposal no. */
	private String proposalNo;
	
	/** The assured. */
	private String assured;
	
	/** The assd active tag. */
	private String assdActiveTag;
	
	private Integer reasonCd;
	
	private String bankRefNo;

	/**
	 * Gets the accept date.
	 * 
	 * @return the accept date
	 */
	public Date getAcceptDate() {
		return acceptDate;
	}
	
	/**
	 * Sets the accept date.
	 * @param acceptDate the new accept date
	 */
	public void setAcceptDate(Date acceptDate) {
		this.acceptDate = acceptDate;
	}
	
	/**
	 * Gets the status.
	 * @return the status
	 */
	public String getStatus() {
		return status;
	}
	
	/**
	 * Sets the status.
	 * @param status the new status
	 */
	public void setStatus(String status) {
		this.status = status;
	}
	
	/**
	 * Gets the par assd.
	 * 
	 * @return the par assd
	 */
	public String getParAssd() {
		return parAssd;
	}
	
	/**
	 * Sets the par assd.
	 * 
	 * @param parAssd the new par assd
	 */
	public void setParAssd(String parAssd) {
		this.parAssd = parAssd;
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
	
	/**
	 * Gets the par no.
	 * 
	 * @return the par no
	 */
	public String getParNo() {
		return parNo;
	}
	
	/**
	 * Sets the par no.
	 * 
	 * @param parNo the new par no
	 */
	public void setParNo(String parNo) {
		this.parNo = parNo;
	}
	
	/**
	 * Gets the pol no.
	 * 
	 * @return the pol no
	 */
	public String getPolNo() {
		return polNo;
	}
	
	/**
	 * Sets the pol no.
	 * 
	 * @param polNo the new pol no
	 */
	public void setPolNo(String polNo) {
		this.polNo = polNo;
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
		try {
			if (null != inceptDate) {
				this.inceptDate = df.parse(df.format(inceptDate));
			}
		} catch (ParseException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
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
		try {
			if (null != expiryDate) {
				this.expiryDate = df.parse(df.format(expiryDate));
			}
		} catch (ParseException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
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
		try {
			if (null != validDate) {
				this.validDate = df.parse(df.format(validDate));
			}
		} catch (ParseException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
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
	 * Gets the assd no.
	 * 
	 * @return the assd no
	 */
	public String getAssdNo() {
		return assdNo;
	}
	
	/**
	 * Sets the assd no.
	 * 
	 * @param assdNo the new assd no
	 */
	public void setAssdNo(String assdNo) {
		this.assdNo = assdNo;
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
	 * Gets the iss cd.
	 * 
	 * @return the iss cd
	 */
	public String getIssCd() {
		return issCd;
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
	 * Gets the line cd.
	 * 
	 * @return the line cd
	 */
	public String getLineCd() {
		return lineCd;
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
	 * Gets the subline cd.
	 * 
	 * @return the subline cd
	 */
	public String getSublineCd() {
		return sublineCd;
	}
	
	/**
	 * Sets the quotation yy.
	 * 
	 * @param quotationYy the new quotation yy
	 */
	public void setQuotationYy(String quotationYy) {
		this.quotationYy = quotationYy;
	}
	
	/**
	 * Gets the quotation yy.
	 * 
	 * @return the quotation yy
	 */
	public String getQuotationYy() {
		return quotationYy;
	}
	
	/**
	 * Sets the proposal no.
	 * 
	 * @param proposalNo the new proposal no
	 */
	public void setProposalNo(String proposalNo) {
		this.proposalNo = proposalNo;
	}
	
	/**
	 * Gets the proposal no.
	 * 
	 * @return the proposal no
	 */
	public String getProposalNo() {
		return proposalNo;
	}
	
	/**
	 * Sets the assured.
	 * 
	 * @param assured the new assured
	 */
	public void setAssured(String assured) {
		this.assured = assured;
	}
	
	/**
	 * Gets the assured.
	 * 
	 * @return the assured
	 */
	public String getAssured() {
		return assured;
	}
	
	/**
	 * Sets the assd active tag.
	 * 
	 * @param assdActiveTag the new assd active tag
	 */
	public void setAssdActiveTag(String assdActiveTag) {
		this.assdActiveTag = assdActiveTag;
	}
	
	/**
	 * Gets the assd active tag.
	 * 
	 * @return the assd active tag
	 */
	public String getAssdActiveTag() {
		return assdActiveTag;
	}

	/**
	 * @param reasonCd the reasonCd to set
	 */
	public void setReasonCd(Integer reasonCd) {
		this.reasonCd = reasonCd;
	}

	/**
	 * @return the reasonCd
	 */
	public Integer getReasonCd() {
		return reasonCd;
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
	
	
	

}
