package com.geniisys.giri.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIRIDistFrpsWdistFrpsV extends BaseEntity{
	
	private Integer parPolicyId;
    private Integer parId;
    private String  lineCd;
    private Integer frpsYy;
    private Integer frpsSeqNo;
    private String  issCd;
    private Integer parYy;
    private Integer parSeqNo;
    private Integer quoteSeqNo;
    private String  sublineCd;
    private Integer issueYy;
    private Integer polSeqNo;
    private Integer renewNo;
    private String  endtIssCd;
    private Integer endtYy;
    private Integer endtSeqNo;
    private String  assdName;
    private Date    effDate;
    private Date    expiryDate;
    private Integer distNo;
    private Integer distSeqNo;
    private BigDecimal totFacSpct;
    private BigDecimal tsiAmt;
    private BigDecimal totFacTsi;
    private BigDecimal premAmt;
    private BigDecimal totFacPrem;
    private String	   currencyDesc;
    private String     distFlag;
    private String 	   premWarrSw;
    private String     endtType;
    private String     riFlag;
    private Date       inceptDate;
    private Integer    opGroupNo;
    private BigDecimal totFacSpct2;
    private Date       createDate;

    public GIRIDistFrpsWdistFrpsV(){
    	
    }

	/**
	 * @return the parPolicyId
	 */
	public Integer getParPolicyId() {
		return parPolicyId;
	}

	/**
	 * @param parPolicyId the parPolicyId to set
	 */
	public void setParPolicyId(Integer parPolicyId) {
		this.parPolicyId = parPolicyId;
	}

	/**
	 * @return the parId
	 */
	public Integer getParId() {
		return parId;
	}

	/**
	 * @param parId the parId to set
	 */
	public void setParId(Integer parId) {
		this.parId = parId;
	}

	/**
	 * @return the lineCd
	 */
	public String getLineCd() {
		return lineCd;
	}

	/**
	 * @param lineCd the lineCd to set
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	/**
	 * @return the frpsYy
	 */
	public Integer getFrpsYy() {
		return frpsYy;
	}

	/**
	 * @param frpsYy the frpsYy to set
	 */
	public void setFrpsYy(Integer frpsYy) {
		this.frpsYy = frpsYy;
	}

	/**
	 * @return the frpsSeqNo
	 */
	public Integer getFrpsSeqNo() {
		return frpsSeqNo;
	}

	/**
	 * @param frpsSeqNo the frpsSeqNo to set
	 */
	public void setFrpsSeqNo(Integer frpsSeqNo) {
		this.frpsSeqNo = frpsSeqNo;
	}

	/**
	 * @return the issCd
	 */
	public String getIssCd() {
		return issCd;
	}

	/**
	 * @param issCd the issCd to set
	 */
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	/**
	 * @return the parYy
	 */
	public Integer getParYy() {
		return parYy;
	}

	/**
	 * @param parYy the parYy to set
	 */
	public void setParYy(Integer parYy) {
		this.parYy = parYy;
	}

	/**
	 * @return the parSeqNo
	 */
	public Integer getParSeqNo() {
		return parSeqNo;
	}

	/**
	 * @param parSeqNo the parSeqNo to set
	 */
	public void setParSeqNo(Integer parSeqNo) {
		this.parSeqNo = parSeqNo;
	}

	/**
	 * @return the quoteSeqNo
	 */
	public Integer getQuoteSeqNo() {
		return quoteSeqNo;
	}

	/**
	 * @param quoteSeqNo the quoteSeqNo to set
	 */
	public void setQuoteSeqNo(Integer quoteSeqNo) {
		this.quoteSeqNo = quoteSeqNo;
	}

	/**
	 * @return the sublineCd
	 */
	public String getSublineCd() {
		return sublineCd;
	}

	/**
	 * @param sublineCd the sublineCd to set
	 */
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	/**
	 * @return the issueYy
	 */
	public Integer getIssueYy() {
		return issueYy;
	}

	/**
	 * @param issueYy the issueYy to set
	 */
	public void setIssueYy(Integer issueYy) {
		this.issueYy = issueYy;
	}

	/**
	 * @return the polSeqNo
	 */
	public Integer getPolSeqNo() {
		return polSeqNo;
	}

	/**
	 * @param polSeqNo the polSeqNo to set
	 */
	public void setPolSeqNo(Integer polSeqNo) {
		this.polSeqNo = polSeqNo;
	}

	/**
	 * @return the renewNo
	 */
	public Integer getRenewNo() {
		return renewNo;
	}

	/**
	 * @param renewNo the renewNo to set
	 */
	public void setRenewNo(Integer renewNo) {
		this.renewNo = renewNo;
	}

	/**
	 * @return the endtIssCd
	 */
	public String getEndtIssCd() {
		return endtIssCd;
	}

	/**
	 * @param endtIssCd the endtIssCd to set
	 */
	public void setEndtIssCd(String endtIssCd) {
		this.endtIssCd = endtIssCd;
	}

	/**
	 * @return the endtYy
	 */
	public Integer getEndtYy() {
		return endtYy;
	}

	/**
	 * @param endtYy the endtYy to set
	 */
	public void setEndtYy(Integer endtYy) {
		this.endtYy = endtYy;
	}

	/**
	 * @return the endtSeqNo
	 */
	public Integer getEndtSeqNo() {
		return endtSeqNo;
	}

	/**
	 * @param endtSeqNo the endtSeqNo to set
	 */
	public void setEndtSeqNo(Integer endtSeqNo) {
		this.endtSeqNo = endtSeqNo;
	}

	/**
	 * @return the assdName
	 */
	public String getAssdName() {
		return assdName;
	}

	/**
	 * @param assdName the assdName to set
	 */
	public void setAssdName(String assdName) {
		this.assdName = assdName;
	}

	/**
	 * @return the effDate
	 */
	public Date getEffDate() {
		return effDate;
	}

	/**
	 * @param effDate the effDate to set
	 */
	public void setEffDate(Date effDate) {
		this.effDate = effDate;
	}

	/**
	 * @return the expiryDate
	 */
	public Date getExpiryDate() {
		return expiryDate;
	}

	/**
	 * @param expiryDate the expiryDate to set
	 */
	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}

	/**
	 * @return the distNo
	 */
	public Integer getDistNo() {
		return distNo;
	}

	/**
	 * @param distNo the distNo to set
	 */
	public void setDistNo(Integer distNo) {
		this.distNo = distNo;
	}

	/**
	 * @return the distSeqNo
	 */
	public Integer getDistSeqNo() {
		return distSeqNo;
	}

	/**
	 * @param distSeqNo the distSeqNo to set
	 */
	public void setDistSeqNo(Integer distSeqNo) {
		this.distSeqNo = distSeqNo;
	}

	/**
	 * @return the totFacSpct
	 */
	public BigDecimal getTotFacSpct() {
		return totFacSpct;
	}

	/**
	 * @param totFacSpct the totFacSpct to set
	 */
	public void setTotFacSpct(BigDecimal totFacSpct) {
		this.totFacSpct = totFacSpct;
	}

	/**
	 * @return the tsiAmt
	 */
	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}

	/**
	 * @param tsiAmt the tsiAmt to set
	 */
	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}

	/**
	 * @return the totFacTsi
	 */
	public BigDecimal getTotFacTsi() {
		return totFacTsi;
	}

	/**
	 * @param totFacTsi the totFacTsi to set
	 */
	public void setTotFacTsi(BigDecimal totFacTsi) {
		this.totFacTsi = totFacTsi;
	}

	/**
	 * @return the premAmt
	 */
	public BigDecimal getPremAmt() {
		return premAmt;
	}

	/**
	 * @param premAmt the premAmt to set
	 */
	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}

	/**
	 * @return the totFacPrem
	 */
	public BigDecimal getTotFacPrem() {
		return totFacPrem;
	}

	/**
	 * @param totFacPrem the totFacPrem to set
	 */
	public void setTotFacPrem(BigDecimal totFacPrem) {
		this.totFacPrem = totFacPrem;
	}

	/**
	 * @return the currencyDesc
	 */
	public String getCurrencyDesc() {
		return currencyDesc;
	}

	/**
	 * @param currencyDesc the currencyDesc to set
	 */
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}

	/**
	 * @return the distFlag
	 */
	public String getDistFlag() {
		return distFlag;
	}

	/**
	 * @param distFlag the distFlag to set
	 */
	public void setDistFlag(String distFlag) {
		this.distFlag = distFlag;
	}

	/**
	 * @return the premWarrSw
	 */
	public String getPremWarrSw() {
		return premWarrSw;
	}

	/**
	 * @param premWarrSw the premWarrSw to set
	 */
	public void setPremWarrSw(String premWarrSw) {
		this.premWarrSw = premWarrSw;
	}

	/**
	 * @return the endtType
	 */
	public String getEndtType() {
		return endtType;
	}

	/**
	 * @param endtType the endtType to set
	 */
	public void setEndtType(String endtType) {
		this.endtType = endtType;
	}

	/**
	 * @return the riFlag
	 */
	public String getRiFlag() {
		return riFlag;
	}

	/**
	 * @param riFlag the riFlag to set
	 */
	public void setRiFlag(String riFlag) {
		this.riFlag = riFlag;
	}

	/**
	 * @return the inceptDate
	 */
	public Date getInceptDate() {
		return inceptDate;
	}

	/**
	 * @param inceptDate the inceptDate to set
	 */
	public void setInceptDate(Date inceptDate) {
		this.inceptDate = inceptDate;
	}

	/**
	 * @return the opGroupNo
	 */
	public Integer getOpGroupNo() {
		return opGroupNo;
	}

	/**
	 * @param opGroupNo the opGroupNo to set
	 */
	public void setOpGroupNo(Integer opGroupNo) {
		this.opGroupNo = opGroupNo;
	}

	/**
	 * @return the totFacSpct2
	 */
	public BigDecimal getTotFacSpct2() {
		return totFacSpct2;
	}

	/**
	 * @param totFacSpct2 the totFacSpct2 to set
	 */
	public void setTotFacSpct2(BigDecimal totFacSpct2) {
		this.totFacSpct2 = totFacSpct2;
	}

	/**
	 * @return the createDate
	 */
	public Date getCreateDate() {
		return createDate;
	}

	/**
	 * @param createDate the createDate to set
	 */
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

}