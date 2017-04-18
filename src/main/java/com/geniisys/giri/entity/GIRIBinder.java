package com.geniisys.giri.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIRIBinder extends BaseEntity{
	
	private Integer fnlBinderId;
	private String lineCd;
	private Integer binderYy;
	private Integer binderSeqNo;
	private Integer riCd;
	private BigDecimal riTsiAmt;
	private BigDecimal riShrPct;
	private BigDecimal riPremAmt;
	private BigDecimal riCommRt;
	private BigDecimal riCommAmt;
	private BigDecimal premTax;
	private Date effDate;
	private Date expiryDate;
	private Date binderDate;
	private String attention;
	private String confirmNo;
	private Date confirmDate;
	private Date reverseDate;
	private Date accEntDate;
	private Date accRevDate;
	private String replacedFlag;
	private Date bndrPrintDate;
	private Integer bndrPrintedCnt;
	private Date createBinderDate;
	private String endtText;
	private String refBinderNo;
	private Integer policyId;
	private String issCd;
	private BigDecimal riPremVat;
	private BigDecimal riCommVat;
	private BigDecimal wHoldingVat;
	private String bndrStatCd;
	private Date releaseDate;
	private String releasedBy;
	private String riName;
	private String binderNo;
	
	public GIRIBinder(){
		
	}


	/**
	 * @return the fnlBinderId
	 */
	public Integer getFnlBinderId() {
		return fnlBinderId;
	}


	/**
	 * @param fnlBinderId the fnlBinderId to set
	 */
	public void setFnlBinderId(Integer fnlBinderId) {
		this.fnlBinderId = fnlBinderId;
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
	 * @return the binderYy
	 */
	public Integer getBinderYy() {
		return binderYy;
	}


	/**
	 * @param binderYy the binderYy to set
	 */
	public void setBinderYy(Integer binderYy) {
		this.binderYy = binderYy;
	}


	/**
	 * @return the binderSeqNo
	 */
	public Integer getBinderSeqNo() {
		return binderSeqNo;
	}


	/**
	 * @param binderSeqNo the binderSeqNo to set
	 */
	public void setBinderSeqNo(Integer binderSeqNo) {
		this.binderSeqNo = binderSeqNo;
	}


	/**
	 * @return the riCd
	 */
	public Integer getRiCd() {
		return riCd;
	}


	/**
	 * @param riCd the riCd to set
	 */
	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}


	/**
	 * @return the riTsiAmt
	 */
	public BigDecimal getRiTsiAmt() {
		return riTsiAmt;
	}


	/**
	 * @param riTsiAmt the riTsiAmt to set
	 */
	public void setRiTsiAmt(BigDecimal riTsiAmt) {
		this.riTsiAmt = riTsiAmt;
	}


	/**
	 * @return the riShrPct
	 */
	public BigDecimal getRiShrPct() {
		return riShrPct;
	}


	/**
	 * @param riShrPct the riShrPct to set
	 */
	public void setRiShrPct(BigDecimal riShrPct) {
		this.riShrPct = riShrPct;
	}


	/**
	 * @return the riPremAmt
	 */
	public BigDecimal getRiPremAmt() {
		return riPremAmt;
	}


	/**
	 * @param riPremAmt the riPremAmt to set
	 */
	public void setRiPremAmt(BigDecimal riPremAmt) {
		this.riPremAmt = riPremAmt;
	}


	/**
	 * @return the riCommRt
	 */
	public BigDecimal getRiCommRt() {
		return riCommRt;
	}


	/**
	 * @param riCommRt the riCommRt to set
	 */
	public void setRiCommRt(BigDecimal riCommRt) {
		this.riCommRt = riCommRt;
	}


	/**
	 * @return the riCommAmt
	 */
	public BigDecimal getRiCommAmt() {
		return riCommAmt;
	}


	/**
	 * @param riCommAmt the riCommAmt to set
	 */
	public void setRiCommAmt(BigDecimal riCommAmt) {
		this.riCommAmt = riCommAmt;
	}


	/**
	 * @return the premTax
	 */
	public BigDecimal getPremTax() {
		return premTax;
	}


	/**
	 * @param premTax the premTax to set
	 */
	public void setPremTax(BigDecimal premTax) {
		this.premTax = premTax;
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
	 * @return the binderDate
	 */
	/*
	public Date getBinderDate() {
		return binderDate;
	}*/
	
	public String getBinderDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		if (binderDate != null) {
			return df.format(binderDate);			
		} else {
			return null;
		}
	}


	/**
	 * @param binderDate the binderDate to set
	 */
	public void setBinderDate(Date binderDate) {
		this.binderDate = binderDate;
	}


	/**
	 * @return the attention
	 */
	public String getAttention() {
		return attention;
	}


	/**
	 * @param attention the attention to set
	 */
	public void setAttention(String attention) {
		this.attention = attention;
	}


	/**
	 * @return the confirmNo
	 */
	public String getConfirmNo() {
		return confirmNo;
	}


	/**
	 * @param confirmNo the confirmNo to set
	 */
	public void setConfirmNo(String confirmNo) {
		this.confirmNo = confirmNo;
	}


	/**
	 * @return the confirmDate
	 */
	public Date getConfirmDate() {
		return confirmDate;
	}


	/**
	 * @param confirmDate the confirmDate to set
	 */
	public void setConfirmDate(Date confirmDate) {
		this.confirmDate = confirmDate;
	}


	/**
	 * @return the reverseDate
	 */
	public Date getReverseDate() {
		return reverseDate;
	}


	/**
	 * @param reverseDate the reverseDate to set
	 */
	public void setReverseDate(Date reverseDate) {
		this.reverseDate = reverseDate;
	}


	/**
	 * @return the accEntDate
	 */
	public Date getAccEntDate() {
		return accEntDate;
	}


	/**
	 * @param accEntDate the accEntDate to set
	 */
	public void setAccEntDate(Date accEntDate) {
		this.accEntDate = accEntDate;
	}


	/**
	 * @return the accRevDate
	 */
	public Date getAccRevDate() {
		return accRevDate;
	}


	/**
	 * @param accRevDate the accRevDate to set
	 */
	public void setAccRevDate(Date accRevDate) {
		this.accRevDate = accRevDate;
	}


	/**
	 * @return the replacedFlag
	 */
	public String getReplacedFlag() {
		return replacedFlag;
	}


	/**
	 * @param replacedFlag the replacedFlag to set
	 */
	public void setReplacedFlag(String replacedFlag) {
		this.replacedFlag = replacedFlag;
	}


	/**
	 * @return the bndrPrintDate
	 */
	public Date getBndrPrintDate() {
		return bndrPrintDate;
	}


	/**
	 * @param bndrPrintDate the bndrPrintDate to set
	 */
	public void setBndrPrintDate(Date bndrPrintDate) {
		this.bndrPrintDate = bndrPrintDate;
	}


	/**
	 * @return the bndrPrintedCnt
	 */
	public Integer getBndrPrintedCnt() {
		return bndrPrintedCnt;
	}


	/**
	 * @param bndrPrintedCnt the bndrPrintedCnt to set
	 */
	public void setBndrPrintedCnt(Integer bndrPrintedCnt) {
		this.bndrPrintedCnt = bndrPrintedCnt;
	}


	/**
	 * @return the createBinderDate
	 */
	public Date getCreateBinderDate() {
		return createBinderDate;
	}


	/**
	 * @param createrBindeDate the createBinderDate to set
	 */
	public void setCreateBinderDate(Date createBinderDate) {
		this.createBinderDate = createBinderDate;
	}


	/**
	 * @return the endtText
	 */
	public String getEndtText() {
		return endtText;
	}


	/**
	 * @param endtText the endtText to set
	 */
	public void setEndtText(String endtText) {
		this.endtText = endtText;
	}


	/**
	 * @return the refBinderNo
	 */
	public String getRefBinderNo() {
		return refBinderNo;
	}


	/**
	 * @param refBinderNo the refBinderNo to set
	 */
	public void setRefBinderNo(String refBinderNo) {
		this.refBinderNo = refBinderNo;
	}


	/**
	 * @return the policyId
	 */
	public Integer getPolicyId() {
		return policyId;
	}


	/**
	 * @param policyId the policyId to set
	 */
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
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
	 * @return the riPremVat
	 */
	public BigDecimal getRiPremVat() {
		return riPremVat;
	}


	/**
	 * @param riPremVat the riPremVat to set
	 */
	public void setRiPremVat(BigDecimal riPremVat) {
		this.riPremVat = riPremVat;
	}


	/**
	 * @return the riCommVat
	 */
	public BigDecimal getRiCommVat() {
		return riCommVat;
	}


	/**
	 * @param riCommVat the riCommVat to set
	 */
	public void setRiCommVat(BigDecimal riCommVat) {
		this.riCommVat = riCommVat;
	}


	/**
	 * @return the wHoldingVat
	 */
	public BigDecimal getwHoldingVat() {
		return wHoldingVat;
	}


	/**
	 * @param wHoldingVat the wHoldingVat to set
	 */
	public void setwHoldingVat(BigDecimal wHoldingVat) {
		this.wHoldingVat = wHoldingVat;
	}


	/**
	 * @return the bndrStatCd
	 */
	public String getBndrStatCd() {
		return bndrStatCd;
	}


	/**
	 * @param bndrStatCd the bndrStatCd to set
	 */
	public void setBndrStatCd(String bndrStatCd) {
		this.bndrStatCd = bndrStatCd;
	}


	/**
	 * @return the releaseDate
	 */
	public Date getReleaseDate() {
		return releaseDate;
	}


	/**
	 * @param releaseDate the releaseDate to set
	 */
	public void setReleaseDate(Date releaseDate) {
		this.releaseDate = releaseDate;
	}


	/**
	 * @return the releasedBy
	 */
	public String getReleasedBy() {
		return releasedBy;
	}


	/**
	 * @param releasedBy the releasedBy to set
	 */
	public void setReleasedBy(String releasedBy) {
		this.releasedBy = releasedBy;
	}


	/**
	 * @return the riName
	 */
	public String getRiName() {
		return riName;
	}


	/**
	 * @param riName the riName to set
	 */
	public void setRiName(String riName) {
		this.riName = riName;
	}


	/**
	 * @return the binderNo
	 */
	public String getBinderNo() {
		return binderNo;
	}


	/**
	 * @param binderNo the binderNo to set
	 */
	public void setBinderNo(String binderNo) {
		this.binderNo = binderNo;
	}
	
	
}
