package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLAdvsFla extends BaseEntity{
	
	private Integer flaId;
	private Integer claimId;
	private Integer grpSeqNo;
	private Integer riCd;
	private String lineCd;
	private Integer laYy;
	private Integer flaSeqNo;
	private String userId;
	private Date lastUpdate;
	private Date flaDate;
	private BigDecimal paidShrAmt;
	private BigDecimal netShrAmt;
	private BigDecimal advShrAmt;
	private String flaTitle;
	private String flaHeader;
	private String flaFooter;
	private String shareType;
	private String printSw;
	private String cancelTag;
	private Integer advFlaId;
	private Integer acctTrtyType;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private BigDecimal lossShrAmt;
	private BigDecimal expShrAmt;
	
	// properties not present in GICL_ADVS_FLA table
	private String flaNo;
	private String riName;
	private String dspRiName;
	
	// additional attributes for Print FLA
	private Integer adviceId;
	private String sublineCd;
	private String issCd;
	private String polIssCd;
	private Integer issueYy;
	private Integer polSeqNo;
	private Integer renewNo;
	private String assuredName;
	private String inHouAdj;
	private Integer clmYy;
	private Integer clmSeqNo;
	private String clmStatCd;
	private String clmStatDesc;	
	private String advLineCd;
	private String advIssCd;
	private Integer adviceYear;
	private Integer adviceSeqNo;
	private BigDecimal netAmt;
	private BigDecimal paidAmt;
	private BigDecimal adviseAmt;
	private String trtyName;
	private BigDecimal shrPaidAmt;
	private BigDecimal shrNetAmt;
	private BigDecimal shrAdviseAmt;

	public Integer getFlaId() {
		return flaId;
	}

	public void setFlaId(Integer flaId) {
		this.flaId = flaId;
	}

	public Integer getClaimId() {
		return claimId;
	}

	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}

	public Integer getGrpSeqNo() {
		return grpSeqNo;
	}

	public void setGrpSeqNo(Integer grpSeqNo) {
		this.grpSeqNo = grpSeqNo;
	}

	public Integer getRiCd() {
		return riCd;
	}

	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public Integer getLaYy() {
		return laYy;
	}

	public void setLaYy(Integer laYy) {
		this.laYy = laYy;
	}

	public Integer getFlaSeqNo() {
		return flaSeqNo;
	}

	public void setFlaSeqNo(Integer flaSeqNo) {
		this.flaSeqNo = flaSeqNo;
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

	public Date getFlaDate() {
		return flaDate;
	}

	public void setFlaDate(Date flaDate) {
		this.flaDate = flaDate;
	}

	public BigDecimal getPaidShrAmt() {
		return paidShrAmt;
	}

	public void setPaidShrAmt(BigDecimal paidShrAmt) {
		this.paidShrAmt = paidShrAmt;
	}

	public BigDecimal getNetShrAmt() {
		return netShrAmt;
	}

	public void setNetShrAmt(BigDecimal netShrAmt) {
		this.netShrAmt = netShrAmt;
	}

	public BigDecimal getAdvShrAmt() {
		return advShrAmt;
	}

	public void setAdvShrAmt(BigDecimal advShrAmt) {
		this.advShrAmt = advShrAmt;
	}

	public String getFlaTitle() {
		return flaTitle;
	}

	public void setFlaTitle(String flaTitle) {
		this.flaTitle = flaTitle;
	}

	public String getFlaHeader() {
		return flaHeader;
	}

	public void setFlaHeader(String flaHeader) {
		this.flaHeader = flaHeader;
	}

	public String getFlaFooter() {
		return flaFooter;
	}

	public void setFlaFooter(String flaFooter) {
		this.flaFooter = flaFooter;
	}

	public String getShareType() {
		return shareType;
	}

	public void setShareType(String shareType) {
		this.shareType = shareType;
	}

	public String getPrintSw() {
		return printSw;
	}

	public void setPrintSw(String printSw) {
		this.printSw = printSw;
	}

	public String getCancelTag() {
		return cancelTag;
	}

	public void setCancelTag(String cancelTag) {
		this.cancelTag = cancelTag;
	}

	public Integer getAdvFlaId() {
		return advFlaId;
	}

	public void setAdvFlaId(Integer advFlaId) {
		this.advFlaId = advFlaId;
	}

	public Integer getAcctTrtyType() {
		return acctTrtyType;
	}

	public void setAcctTrtyType(Integer acctTrtyType) {
		this.acctTrtyType = acctTrtyType;
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

	public BigDecimal getLossShrAmt() {
		return lossShrAmt;
	}

	public void setLossShrAmt(BigDecimal lossShrAmt) {
		this.lossShrAmt = lossShrAmt;
	}

	public BigDecimal getExpShrAmt() {
		return expShrAmt;
	}

	public void setExpShrAmt(BigDecimal expShrAmt) {
		this.expShrAmt = expShrAmt;
	}

	public String getRiName() {
		return riName;
	}

	public void setRiName(String riName) {
		this.riName = riName;
	}

	public void setFlaNo(String flaNo) {
		this.flaNo = flaNo;
	}

	public String getFlaNo() {
		return flaNo;
	}

	public void setDspRiName(String dspRiName) {
		this.dspRiName = dspRiName;
	}

	public String getDspRiName() {
		return dspRiName;
	}

	// additional for Print FLA
	public Integer getAdviceId() {
		return adviceId;
	}

	public void setAdviceId(Integer adviceId) {
		this.adviceId = adviceId;
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

	public String getPolIssCd() {
		return polIssCd;
	}

	public void setPolIssCd(String polIssCd) {
		this.polIssCd = polIssCd;
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

	public Integer getRenewNo() {
		return renewNo;
	}

	public void setRenewNo(Integer renewNo) {
		this.renewNo = renewNo;
	}

	public String getAssuredName() {
		return assuredName;
	}

	public void setAssuredName(String assuredName) {
		this.assuredName = assuredName;
	}

	public String getInHouAdj() {
		return inHouAdj;
	}

	public void setInHouAdj(String inHouAdj) {
		this.inHouAdj = inHouAdj;
	}

	public Integer getClmYy() {
		return clmYy;
	}

	public void setClmYy(Integer clmYy) {
		this.clmYy = clmYy;
	}

	public Integer getClmSeqNo() {
		return clmSeqNo;
	}

	public void setClmSeqNo(Integer clmSeqNo) {
		this.clmSeqNo = clmSeqNo;
	}

	public String getClmStatCd() {
		return clmStatCd;
	}

	public void setClmStatCd(String clmStatCd) {
		this.clmStatCd = clmStatCd;
	}

	public String getClmStatDesc() {
		return clmStatDesc;
	}

	public void setClmStatDesc(String clmStatDesc) {
		this.clmStatDesc = clmStatDesc;
	}

	public String getAdvLineCd() {
		return advLineCd;
	}

	public void setAdvLineCd(String advLineCd) {
		this.advLineCd = advLineCd;
	}

	public String getAdvIssCd() {
		return advIssCd;
	}

	public void setAdvIssCd(String advIssCd) {
		this.advIssCd = advIssCd;
	}

	public Integer getAdviceYear() {
		return adviceYear;
	}

	public void setAdviceYear(Integer adviceYear) {
		this.adviceYear = adviceYear;
	}

	public Integer getAdviceSeqNo() {
		return adviceSeqNo;
	}

	public void setAdviceSeqNo(Integer adviceSeqNo) {
		this.adviceSeqNo = adviceSeqNo;
	}

	public BigDecimal getNetAmt() {
		return netAmt;
	}

	public void setNetAmt(BigDecimal netAmt) {
		this.netAmt = netAmt;
	}

	public BigDecimal getPaidAmt() {
		return paidAmt;
	}

	public void setPaidAmt(BigDecimal paidAmt) {
		this.paidAmt = paidAmt;
	}

	public BigDecimal getAdviseAmt() {
		return adviseAmt;
	}

	public void setAdviseAmt(BigDecimal adviseAmt) {
		this.adviseAmt = adviseAmt;
	}

	public String getTrtyName() {
		return trtyName;
	}

	public void setTrtyName(String trtyName) {
		this.trtyName = trtyName;
	}

	public BigDecimal getShrPaidAmt() {
		return shrPaidAmt;
	}

	public void setShrPaidAmt(BigDecimal shrPaidAmt) {
		this.shrPaidAmt = shrPaidAmt;
	}

	public BigDecimal getShrNetAmt() {
		return shrNetAmt;
	}

	public void setShrNetAmt(BigDecimal shrNetAmt) {
		this.shrNetAmt = shrNetAmt;
	}

	public BigDecimal getShrAdviseAmt() {
		return shrAdviseAmt;
	}

	public void setShrAdviseAmt(BigDecimal shrAdviseAmt) {
		this.shrAdviseAmt = shrAdviseAmt;
	}
}
