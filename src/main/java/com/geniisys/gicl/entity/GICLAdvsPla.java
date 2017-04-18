package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLAdvsPla extends BaseEntity{

	private Integer plaId;         
	private Integer claimId;       
	private Integer grpSeqNo;     
	private Integer riCd;          
	private String lineCd;         
	private Integer laYy;          
	private Integer plaSeqNo;        	
	private String shareType;      
	private Integer perilCd;       
	private BigDecimal lossShrAmt;
	private BigDecimal expShrAmt; 
	private String plaTitle;       
	private String plaHeader;      
	private String plaFooter;      
	private String printSw;        
	private Integer cpiRecNo;     
	private String cpiBranchCd;   
	private Integer itemNo;        
	private String cancelTag;      
	private Integer resPlaId;     
	private Date plaDate;         	
	private Integer groupedItemNo;
	private String dspRiName;
	
	// additional attributes used in print PLA
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
	private Integer policyId;
	private Integer histSeqNo;
	private String itemTitle;
	private String perilSname;
	private BigDecimal lossReserve;
	private BigDecimal expenseReserve;
	private String trtyName;
	private BigDecimal shareLossResAmt;
	private BigDecimal shareExpResAmt;
	private BigDecimal sharePct;
	
	
	
	public Integer getPlaId() {
		return plaId;
	}
	public void setPlaId(Integer plaId) {
		this.plaId = plaId;
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
	public Integer getPlaSeqNo() {
		return plaSeqNo;
	}
	public void setPlaSeqNo(Integer plaSeqNo) {
		this.plaSeqNo = plaSeqNo;
	}
	public String getShareType() {
		return shareType;
	}
	public void setShareType(String shareType) {
		this.shareType = shareType;
	}
	public Integer getPerilCd() {
		return perilCd;
	}
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
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
	public String getPlaTitle() {
		return plaTitle;
	}
	public void setPlaTitle(String plaTitle) {
		this.plaTitle = plaTitle;
	}
	public String getPlaHeader() {
		return plaHeader;
	}
	public void setPlaHeader(String plaHeader) {
		this.plaHeader = plaHeader;
	}
	public String getPlaFooter() {
		return plaFooter;
	}
	public void setPlaFooter(String plaFooter) {
		this.plaFooter = plaFooter;
	}
	public String getPrintSw() {
		return printSw;
	}
	public void setPrintSw(String printSw) {
		this.printSw = printSw;
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
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public String getCancelTag() {
		return cancelTag;
	}
	public void setCancelTag(String cancelTag) {
		this.cancelTag = cancelTag;
	}
	public Integer getResPlaId() {
		return resPlaId;
	}
	public void setResPlaId(Integer resPlaId) {
		this.resPlaId = resPlaId;
	}
	public Date getPlaDate() {
		return plaDate;
	}
	public void setPlaDate(Date plaDate) {
		this.plaDate = plaDate;
	}
	public Integer getGroupedItemNo() {
		return groupedItemNo;
	}
	public void setGroupedItemNo(Integer groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}
	public String getDspRiName() {
		return dspRiName;
	}
	public void setDspRiName(String dspRiName) {
		this.dspRiName = dspRiName;
	}
	
	//
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
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public Integer getHistSeqNo() {
		return histSeqNo;
	}
	public void setHistSeqNo(Integer histSeqNo) {
		this.histSeqNo = histSeqNo;
	}
	public String getItemTitle() {
		return itemTitle;
	}
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}
	public String getPerilSname() {
		return perilSname;
	}
	public void setPerilSname(String perilSname) {
		this.perilSname = perilSname;
	}
	public BigDecimal getLossReserve() {
		return lossReserve;
	}
	public void setLossReserve(BigDecimal lossReserve) {
		this.lossReserve = lossReserve;
	}
	public BigDecimal getExpenseReserve() {
		return expenseReserve;
	}
	public void setExpenseReserve(BigDecimal expenseReserve) {
		this.expenseReserve = expenseReserve;
	}
	public String getTrtyName() {
		return trtyName;
	}
	public void setTrtyName(String trtyName) {
		this.trtyName = trtyName;
	}
	public BigDecimal getShareLossResAmt() {
		return shareLossResAmt;
	}
	public void setShareLossResAmt(BigDecimal shareLossResAmt) {
		this.shareLossResAmt = shareLossResAmt;
	}
	public BigDecimal getShareExpResAmt() {
		return shareExpResAmt;
	}
	public void setShareExpResAmt(BigDecimal shareExpResAmt) {
		this.shareExpResAmt = shareExpResAmt;
	}
	public BigDecimal getSharePct() {
		return sharePct;
	}
	public void setSharePct(BigDecimal sharePct) {
		this.sharePct = sharePct;
	}
	
}
