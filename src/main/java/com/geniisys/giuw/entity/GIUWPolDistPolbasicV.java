package com.geniisys.giuw.entity;

import java.math.BigDecimal;
import java.util.Date;
import com.geniisys.framework.util.BaseEntity;

public class GIUWPolDistPolbasicV extends BaseEntity{
	
	private Integer policyId;
	private String lineCd;
	private String sublineCd;
	private String issCd;
	private Integer issueYy;
	private Integer parId;
	private Integer polSeqNo;
	private String policyNo;
	private Integer assdNo;
	private String endtIssCd;
	private String spldFlag;
	private String distFlag;
	private Integer distNo;
	private Date effDate;
	private Date effDatePolbas;
	private Date issueDate;
	private Date expiryDatePolbas;
	private Date endtExpiryDate;
	private Date expiryDatePolDist;
	private Integer endtYy;
	private String distType;
	private Date acctEntDate;
	private Integer endtSeqNo;
	private String endtNo;
	private Integer renewNo;
	private String polFlag;
	private Date negateDate;
	private Date acctNegDate;
	private Date inceptDate;
	private Date lastUpDate;
	private String userId;
	private Integer batchId;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private String userId2;
	private Integer distSeqNo;
	private String binderNo;
	private String riSname;
	private Integer riShrPct;
	private Integer riTsiAmt;
	private Integer riPremAmt;
	
	
	
	public Integer getRiShrPct() {
		return riShrPct;
	}
	public void setRiShrPct(Integer riShrPct) {
		this.riShrPct = riShrPct;
	}
	public Integer getRiTsiAmt() {
		return riTsiAmt;
	}
	public void setRiTsiAmt(Integer riTsiAmt) {
		this.riTsiAmt = riTsiAmt;
	}
	public Integer getRiPremAmt() {
		return riPremAmt;
	}
	public void setRiPremAmt(Integer riPremAmt) {
		this.riPremAmt = riPremAmt;
	}
	public String getBinderNo() {
		return binderNo;
	}
	public void setBinderNo(String binderNo) {
		this.binderNo = binderNo;
	}
	public String getRiSname() {
		return riSname;
	}
	public void setRiSname(String riSname) {
		this.riSname = riSname;
	}
	public Integer getDistSeqNo() {
		return distSeqNo;
	}
	public void setDistSeqNo(Integer distSeqNo) {
		this.distSeqNo = distSeqNo;
	}
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
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
	public void setIssueYy(Integer issueYy) {
		this.issueYy = issueYy;
	}
	public Integer getIssueYy() {
		return issueYy;
	}
	public Integer getParId() {
		return parId;
	}
	public void setParId(Integer parId) {
		this.parId = parId;
	}
	public Integer getPolSeqNo() {
		return polSeqNo;
	}
	public void setPolSeqNo(Integer polSeqNo) {
		this.polSeqNo = polSeqNo;
	}
	public String getPolicyNo() {
		return policyNo;
	}
	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}
	public Integer getAssdNo() {
		return assdNo;
	}
	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}
	public String getEndtIssCd() {
		return endtIssCd;
	}
	public void setEndtIssCd(String endtIssCd) {
		this.endtIssCd = endtIssCd;
	}
	public String getSpldFlag() {
		return spldFlag;
	}
	public void setSpldFlag(String spldFlag) {
		this.spldFlag = spldFlag;
	}
	public String getDistFlag() {
		return distFlag;
	}
	public void setDistFlag(String distFlag) {
		this.distFlag = distFlag;
	}
	public void setDistNo(Integer distNo) {
		this.distNo = distNo;
	}
	public Integer getDistNo() {
		return distNo;
	}
	public Date getEffDate() {
		return effDate;
	}
	public void setEffDate(Date effDate) {
		this.effDate = effDate;
	}
	public Date getEffDatePolbas() {
		return effDatePolbas;
	}
	public void setEffDatePolbas(Date effDatePolbas) {
		this.effDatePolbas = effDatePolbas;
	}
	public Date getIssueDate() {
		return issueDate;
	}
	public void setIssueDate(Date issueDate) {
		this.issueDate = issueDate;
	}
	public Date getExpiryDatePolbas() {
		return expiryDatePolbas;
	}
	public void setExpiryDatePolbas(Date expiryDatePolbas) {
		this.expiryDatePolbas = expiryDatePolbas;
	}
	public Date getEndtExpiryDate() {
		return endtExpiryDate;
	}
	public void setEndtExpiryDate(Date endtExpiryDate) {
		this.endtExpiryDate = endtExpiryDate;
	}
	public Date getExpiryDatePolDist() {
		return expiryDatePolDist;
	}
	public void setExpiryDatePolDist(Date expiryDatePolDist) {
		this.expiryDatePolDist = expiryDatePolDist;
	}
	public Integer getEndtYy() {
		return endtYy;
	}
	public void setEndtYy(Integer endtYy) {
		this.endtYy = endtYy;
	}
	public String getDistType() {
		return distType;
	}
	public void setDistType(String distType) {
		this.distType = distType;
	}
	public Date getAcctEntDate() {
		return acctEntDate;
	}
	public void setAcctEntDate(Date acctEntDate) {
		this.acctEntDate = acctEntDate;
	}
	public Integer getEndtSeqNo() {
		return endtSeqNo;
	}
	public void setEndtSeqNo(Integer endtSeqNo) {
		this.endtSeqNo = endtSeqNo;
	}
	public String getEndtNo() {
		return endtNo;
	}
	public void setEndtNo(String endtNo) {
		this.endtNo = endtNo;
	}
	public Integer getRenewNo() {
		return renewNo;
	}
	public void setRenewNo(Integer renewNo) {
		this.renewNo = renewNo;
	}
	public String getPolFlag() {
		return polFlag;
	}
	public void setPolFlag(String polFlag) {
		this.polFlag = polFlag;
	}
	public Date getNegateDate() {
		return negateDate;
	}
	public void setNegateDate(Date negateDate) {
		this.negateDate = negateDate;
	}
	public Date getAcctNegDate() {
		return acctNegDate;
	}
	public void setAcctNegDate(Date acctNegDate) {
		this.acctNegDate = acctNegDate;
	}
	public Date getInceptDate() {
		return inceptDate;
	}
	public void setInceptDate(Date inceptDate) {
		this.inceptDate = inceptDate;
	}
	public Date getLastUpDate() {
		return lastUpDate;
	}
	public void setLastUpDate(Date lastUpDate) {
		this.lastUpDate = lastUpDate;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public Integer getBatchId() {
		return batchId;
	}
	public void setBatchId(Integer batchId) {
		this.batchId = batchId;
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
	public String getUserId2() {
		return userId2;
	}
	public void setUserId2(String userId2) {
		this.userId2 = userId2;
	}
}
