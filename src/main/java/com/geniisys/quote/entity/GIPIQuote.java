package com.geniisys.quote.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.geniisys.framework.util.BaseEntity;
import com.geniisys.quote.entity.GIPIQuotePictures;

public class GIPIQuote extends BaseEntity{
	
	private Integer quoteId;
	private String lineCd;
	private String sublineCd;
	private String issCd;
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
	private Integer quotationPrintedCnt;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private Date inceptDate;
	private Date expiryDate;
	private String origin;
	private Integer reasonCd; 
	private String address1;
	private String address2;
	private String address3;
	private Date validDate;
	private String prorateFlag;
	private BigDecimal shortRtPercent;
	private String compSw;
	private String withTariffSw;
	private BigDecimal annPremAmt;
	private BigDecimal annTsiAmt;
	private String expiryTag;
	private String inceptTag;
	private String credBranch;
	private Integer acctOfCd;
	private String acctOfCdSw;
	private Integer inspNo;
	private Integer packQuoteId;
	private String packPolFlag;
	private String bankRefNo;
	private String underwriter;
	private Integer copiedQuoteId;
	
	private Integer noOfDays;
	private String menuLineCd;
	private String lineName;
	private String sublineName;
	private String issName;
	private String dspQuotationNo;
	private String credBranchName;
	private String acctOf;
	private String reasonDesc;
	private List<GIPIQuotePictures> attachedMedia;
	
	public GIPIQuote() {
		super();
	}

	public Integer getQuoteId() {
		return quoteId;
	}

	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
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

	public Date getPrintDt() {
		return printDt;
	}

	public void setPrintDt(Date printDt) {
		this.printDt = printDt;
	}
	
	public Object getStrPrintDt(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (printDt != null) {
			return df.format(printDt);
		} else {
			return null;
		}
	}

	public Date getAcceptDt() {
		return acceptDt;
	}

	public void setAcceptDt(Date acceptDt) {
		this.acceptDt = acceptDt;
	}
	
	public Object getStrAcceptDt(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (acceptDt != null) {
			return df.format(acceptDt);
		} else {
			return null;
		}
	}

	public Date getPostDt() {
		return postDt;
	}

	public void setPostDt(Date postDt) {
		this.postDt = postDt;
	}
	
	public Object getStrPostDt(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (postDt != null) {
			return df.format(postDt);
		} else {
			return null;
		}
	}

	public Date getDeniedDt() {
		return deniedDt;
	}

	public void setDeniedDt(Date deniedDt) {
		this.deniedDt = deniedDt;
	}
	
	public Object getStrDeniedDt(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (deniedDt != null) {
			return df.format(deniedDt);
		} else {
			return null;
		}
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

	public String getFooter() {
		return footer;
	}

	public void setFooter(String footer) {
		this.footer = footer;
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
	
	public Object getStrLastUpdate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (lastUpdate != null) {
			return df.format(lastUpdate);
		} else {
			return null;
		}
	}

	public Integer getQuotationPrintedCnt() {
		return quotationPrintedCnt;
	}

	public void setQuotationPrintedCnt(Integer quotationPrintedCnt) {
		this.quotationPrintedCnt = quotationPrintedCnt;
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

	public Date getInceptDate() {
		return inceptDate;
	}

	public void setInceptDate(Date inceptDate) {
		this.inceptDate = inceptDate;
	}
	
	public Object getStrInceptDate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (inceptDate != null) {
			return df.format(inceptDate);
		} else {
			return null;
		}
	}

	public Date getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}
	
	public Object getStrExpiryDate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (expiryDate != null) {
			return df.format(expiryDate);
		} else {
			return null;
		}
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

	public Date getValidDate() {
		return validDate;
	}

	public void setValidDate(Date validDate) {
		this.validDate = validDate;
	}
	
	public Object getStrValidDate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (validDate != null) {
			return df.format(validDate);
		} else {
			return null;
		}
	}

	public String getProrateFlag() {
		return prorateFlag;
	}

	public void setProrateFlag(String prorateFlag) {
		this.prorateFlag = prorateFlag;
	}

	public BigDecimal getShortRtPercent() {
		return shortRtPercent;
	}

	public void setShortRtPercent(BigDecimal shortRtPercent) {
		this.shortRtPercent = shortRtPercent;
	}

	public String getCompSw() {
		return compSw;
	}

	public void setCompSw(String compSw) {
		this.compSw = compSw;
	}

	public String getWithTariffSw() {
		return withTariffSw;
	}

	public void setWithTariffSw(String withTariffSw) {
		this.withTariffSw = withTariffSw;
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

	public String getExpiryTag() {
		return expiryTag;
	}

	public void setExpiryTag(String expiryTag) {
		this.expiryTag = expiryTag;
	}

	public String getInceptTag() {
		return inceptTag;
	}

	public void setInceptTag(String inceptTag) {
		this.inceptTag = inceptTag;
	}

	public String getCredBranch() {
		return credBranch;
	}

	public void setCredBranch(String credBranch) {
		this.credBranch = credBranch;
	}

	public Integer getAcctOfCd() {
		return acctOfCd;
	}

	public void setAcctOfCd(Integer acctOfCd) {
		this.acctOfCd = acctOfCd;
	}

	public String getAcctOfCdSw() {
		return acctOfCdSw;
	}

	public void setAcctOfCdSw(String acctOfCdSw) {
		this.acctOfCdSw = acctOfCdSw;
	}

	public Integer getInspNo() {
		return inspNo;
	}

	public void setInspNo(Integer inspNo) {
		this.inspNo = inspNo;
	}

	public Integer getPackQuoteId() {
		return packQuoteId;
	}

	public void setPackQuoteId(Integer packQuoteId) {
		this.packQuoteId = packQuoteId;
	}

	public String getPackPolFlag() {
		return packPolFlag;
	}

	public void setPackPolFlag(String packPolFlag) {
		this.packPolFlag = packPolFlag;
	}

	public String getBankRefNo() {
		return bankRefNo;
	}

	public void setBankRefNo(String bankRefNo) {
		this.bankRefNo = bankRefNo;
	}

	public String getUnderwriter() {
		return underwriter;
	}

	public void setUnderwriter(String underwriter) {
		this.underwriter = underwriter;
	}

	public Integer getCopiedQuoteId() {
		return copiedQuoteId;
	}

	public void setCopiedQuoteId(Integer copiedQuoteId) {
		this.copiedQuoteId = copiedQuoteId;
	}

	public Integer getNoOfDays() {
		return noOfDays;
	}

	public void setNoOfDays(Integer noOfDays) {
		this.noOfDays = noOfDays;
	}

	public String getMenuLineCd() {
		return menuLineCd;
	}

	public void setMenuLineCd(String menuLineCd) {
		this.menuLineCd = menuLineCd;
	}

	public String getLineName() {
		return lineName;
	}

	public void setLineName(String lineName) {
		this.lineName = lineName;
	}

	public String getSublineName() {
		return sublineName;
	}

	public void setSublineName(String sublineName) {
		this.sublineName = sublineName;
	}

	public String getIssName() {
		return issName;
	}

	public void setIssName(String issName) {
		this.issName = issName;
	}

	public String getDspQuotationNo() {
		return dspQuotationNo;
	}

	public void setDspQuotationNo(String dspQuotationNo) {
		this.dspQuotationNo = dspQuotationNo;
	}

	public String getCredBranchName() {
		return credBranchName;
	}

	public void setCredBranchName(String credBranchName) {
		this.credBranchName = credBranchName;
	}

	public String getAcctOf() {
		return acctOf;
	}

	public void setAcctOf(String acctOf) {
		this.acctOf = acctOf;
	}

	public String getReasonDesc() {
		return reasonDesc;
	}

	public void setReasonDesc(String reasonDesc) {
		this.reasonDesc = reasonDesc;
	}

	public List<GIPIQuotePictures> getAttachedMedia() {
		return attachedMedia;
	}

	public void setAttachedMedia(List<GIPIQuotePictures> attachedMedia) {
		this.attachedMedia = attachedMedia;
	}
		
}
