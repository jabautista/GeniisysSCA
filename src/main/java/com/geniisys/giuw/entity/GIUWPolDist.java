package com.geniisys.giuw.entity;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import com.geniisys.framework.util.BaseEntity;
import com.geniisys.giri.entity.GIRIDistFrps;

public class GIUWPolDist extends BaseEntity{

	private Integer distNo;
	private Integer parId;
	private String distFlag;
	private String redistFlag;
	private Date effDate;
	private Date expiryDate;
	private Date createDate;
	private String postFlag;
	private Integer policyId;
	private String endtType;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private BigDecimal annTsiAmt;
	private String distType;
	private String itemPostedSw;
	private String exLossSw;
	private Date negateDate;
	private Date acctEntDate;
	private Date acctNegDate;
	private String batchId;
	private Date lastUpdDate;
	private String cpiRecNo;
	private String cpiBranchCd;
	private String autoDist;
	private String oldDistNo;
	private Date postDate;
	private String issCd;
	private String premSeqNo;
	private String takeupSeqNo;
	private String itemGrp;
	private String arcExtData;
	private String multiBookingMm;
	private String multiBookingYy;
	private String meanDistFlag;
	private String varShare;
	private String distPostFlag;
	private String giuwPolicydsDtlExist;
	private String giuwPolicydsExist;
	private String giuwWpolicydsDtlExist;
	private String giuwWpolicydsExist;
	private String giuwWperildsDtlExist;
	private String giuwWperildsExist;
	private Date reverseDate;
	private String reverseSw;
	private List<GIUWPolicyds> giuwPolicyds;
	private List<GIUWWpolicyds> giuwWpolicyds;
	private List<GIUWWPerilds> giuwWPerilds;
	private List<GIRIDistFrps> giriDistFrps;
	private List<GIUWWitemds> giuwWitemds;
	private List<GIUWPerilds> giuwPerilds;
	
	public Integer getDistNo() {
		return distNo;
	}
	public void setDistNo(Integer distNo) {
		this.distNo = distNo;
	}
	public Integer getParId() {
		return parId;
	}
	public void setParId(Integer parId) {
		this.parId = parId;
	}
	public String getDistFlag() {
		return distFlag;
	}
	public void setDistFlag(String distFlag) {
		this.distFlag = distFlag;
	}
	public String getRedistFlag() {
		return redistFlag;
	}
	public void setRedistFlag(String redistFlag) {
		this.redistFlag = redistFlag;
	}
	public Date getEffDate() {
		return effDate;
	}
	public void setEffDate(Date effDate) {
		this.effDate = effDate;
	}
	public Date getExpiryDate() {
		return expiryDate;
	}
	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public String getPostFlag() {
		return postFlag;
	}
	public void setPostFlag(String postFlag) {
		this.postFlag = postFlag;
	}
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public String getEndtType() {
		return endtType;
	}
	public void setEndtType(String endtType) {
		this.endtType = endtType;
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
	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}
	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}
	public String getDistType() {
		return distType;
	}
	public void setDistType(String distType) {
		this.distType = distType;
	}
	public String getItemPostedSw() {
		return itemPostedSw;
	}
	public void setItemPostedSw(String itemPostedSw) {
		this.itemPostedSw = itemPostedSw;
	}
	public String getExLossSw() {
		return exLossSw;
	}
	public void setExLossSw(String exLossSw) {
		this.exLossSw = exLossSw;
	}
	public Date getNegateDate() {
		return negateDate;
	}
	public void setNegateDate(Date negateDate) {
		this.negateDate = negateDate;
	}
	public Date getAcctEntDate() {
		return acctEntDate;
	}
	public void setAcctEntDate(Date acctEntDate) {
		this.acctEntDate = acctEntDate;
	}
	public Date getAcctNegDate() {
		return acctNegDate;
	}
	public void setAcctNegDate(Date acctNegDate) {
		this.acctNegDate = acctNegDate;
	}
	public String getBatchId() {
		return batchId;
	}
	public void setBatchId(String batchId) {
		this.batchId = batchId;
	}
	public Date getLastUpdDate() {
		return lastUpdDate;
	}
	public void setLastUpdDate(Date lastUpdDate) {
		this.lastUpdDate = lastUpdDate;
	}
	public String getCpiRecNo() {
		return cpiRecNo;
	}
	public void setCpiRecNo(String cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	public String getAutoDist() {
		return autoDist;
	}
	public void setAutoDist(String autoDist) {
		this.autoDist = autoDist;
	}
	public String getOldDistNo() {
		return oldDistNo;
	}
	public void setOldDistNo(String oldDistNo) {
		this.oldDistNo = oldDistNo;
	}
	public Date getPostDate() {
		return postDate;
	}
	public void setPostDate(Date postDate) {
		this.postDate = postDate;
	}
	public String getTakeupSeqNo() {
		return takeupSeqNo;
	}
	public void setTakeupSeqNo(String takeupSeqNo) {
		this.takeupSeqNo = takeupSeqNo;
	}
	public String getItemGrp() {
		return itemGrp;
	}
	public void setItemGrp(String itemGrp) {
		this.itemGrp = itemGrp;
	}
	public String getArcExtData() {
		return arcExtData;
	}
	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}
	public String getMultiBookingMm() {
		return multiBookingMm;
	}
	public void setMultiBookingMm(String multiBookingMm) {
		this.multiBookingMm = multiBookingMm;
	}
	public String getMultiBookingYy() {
		return multiBookingYy;
	}
	public void setMultiBookingYy(String multiBookingYy) {
		this.multiBookingYy = multiBookingYy;
	}
	public String getMeanDistFlag() {
		return meanDistFlag;
	}
	public void setMeanDistFlag(String meanDistFlag) {
		this.meanDistFlag = meanDistFlag;
	}
	public String getVarShare() {
		return varShare;
	}
	public void setVarShare(String varShare) {
		this.varShare = varShare;
	}
	public String getDistPostFlag() {
		return distPostFlag;
	}
	public void setDistPostFlag(String distPostFlag) {
		this.distPostFlag = distPostFlag;
	}
	public String getGiuwWpolicydsDtlExist() {
		return giuwWpolicydsDtlExist;
	}
	public void setGiuwWpolicydsDtlExist(String giuwWpolicydsDtlExist) {
		this.giuwWpolicydsDtlExist = giuwWpolicydsDtlExist;
	}
	public String getGiuwWpolicydsExist() {
		return giuwWpolicydsExist;
	}
	public void setGiuwWpolicydsExist(String giuwWpolicydsExist) {
		this.giuwWpolicydsExist = giuwWpolicydsExist;
	}
	public List<GIUWWpolicyds> getGiuwWpolicyds() {
		return giuwWpolicyds;
	}
	public void setGiuwWpolicyds(List<GIUWWpolicyds> giuwWpolicyds) {
		this.giuwWpolicyds = giuwWpolicyds;
	}
	public List<GIUWWPerilds> getGiuwWPerilds() {
		return giuwWPerilds;
	}
	public void setGiuwWPerilds(List<GIUWWPerilds> giuwWPerilds) {
		this.giuwWPerilds = giuwWPerilds;
	}
	public List<GIRIDistFrps> getGiriDistFrps() {
		return giriDistFrps;
	}
	public void setGiriDistFrps(List<GIRIDistFrps> giriDistFrps) {
		this.giriDistFrps = giriDistFrps;
	}
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public String getPremSeqNo() {
		return premSeqNo;
	}
	public void setPremSeqNo(String premSeqNo) {
		this.premSeqNo = premSeqNo;
	}
	public List<GIUWWitemds> getGiuwWitemds() {
		return giuwWitemds;
	}
	public void setGiuwWitemds(List<GIUWWitemds> giuwWitemds) {
		this.giuwWitemds = giuwWitemds;
	}
	public Date getReverseDate() {
		return reverseDate;
	}
	public void setReverseDate(Date reverseDate) {
		this.reverseDate = reverseDate;
	}
	public String getReverseSw() {
		return reverseSw;
	}
	public void setReverseSw(String reverseSw) {
		this.reverseSw = reverseSw;
	}
	public String getGiuwWperildsDtlExist() {
		return giuwWperildsDtlExist;
	}
	public void setGiuwWperildsDtlExist(String giuwWperildsDtlExist) {
		this.giuwWperildsDtlExist = giuwWperildsDtlExist;
	}
	public String getGiuwWperildsExist() {
		return giuwWperildsExist;
	}
	public void setGiuwWperildsExist(String giuwWperildsExist) {
		this.giuwWperildsExist = giuwWperildsExist;
	}	
	public String getGiuwPolicydsDtlExist() {
		return giuwPolicydsDtlExist;
	}
	public void setGiuwPolicydsDtlExist(String giuwPolicydsDtlExist) {
		this.giuwPolicydsDtlExist = giuwPolicydsDtlExist;
	}
	public String getGiuwPolicydsExist() {
		return giuwPolicydsExist;
	}
	public void setGiuwPolicydsExist(String giuwPolicydsExist) {
		this.giuwPolicydsExist = giuwPolicydsExist;
	}
	public List<GIUWPolicyds> getGiuwPolicyds() {
		return giuwPolicyds;
	}
	public void setGiuwPolicyds(List<GIUWPolicyds> giuwPolicyds) {
		this.giuwPolicyds = giuwPolicyds;
	}
	public void setGiuwPerilds(List<GIUWPerilds> giuwPerilds) {
		this.giuwPerilds = giuwPerilds;
	}
	public List<GIUWPerilds> getGiuwPerilds() {
		return giuwPerilds;
	}
	
}
