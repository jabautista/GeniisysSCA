package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLRecoveryRids extends BaseEntity{

	private Integer recoveryId;
	private Integer recoveryPaytId;
	private Integer recDistNo;
	private String lineCd;
	private String dspLineCd;
	private Integer grpSeqNo;
	private Integer distYear;
	private String shareType;
	private Integer acctTrtyType;
	private Integer riCd;
	private BigDecimal shareRiPct;
	private BigDecimal shrRiRecoveryAmt;
	private BigDecimal shareRiPctReal;
	private String negateTag;
	private Date negateDate;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	
	private String dspRiName;
	
	private BigDecimal shrRecoveryAmt;
	private BigDecimal recoveredAmt;

	public Integer getRecoveryId() {
		return recoveryId;
	}

	public void setRecoveryId(Integer recoveryId) {
		this.recoveryId = recoveryId;
	}

	public Integer getRecoveryPaytId() {
		return recoveryPaytId;
	}

	public void setRecoveryPaytId(Integer recoveryPaytId) {
		this.recoveryPaytId = recoveryPaytId;
	}

	public Integer getRecDistNo() {
		return recDistNo;
	}

	public void setRecDistNo(Integer recDistNo) {
		this.recDistNo = recDistNo;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	
	public String getDspLineCd() {
		return dspLineCd;
	}

	public void setDspLineCd(String dspLineCd) {
		this.dspLineCd = dspLineCd;
	}

	public Integer getGrpSeqNo() {
		return grpSeqNo;
	}

	public void setGrpSeqNo(Integer grpSeqNo) {
		this.grpSeqNo = grpSeqNo;
	}

	public Integer getDistYear() {
		return distYear;
	}

	public void setDistYear(Integer distYear) {
		this.distYear = distYear;
	}

	public String getShareType() {
		return shareType;
	}

	public void setShareType(String shareType) {
		this.shareType = shareType;
	}

	public Integer getAcctTrtyType() {
		return acctTrtyType;
	}

	public void setAcctTrtyType(Integer acctTrtyType) {
		this.acctTrtyType = acctTrtyType;
	}

	public Integer getRiCd() {
		return riCd;
	}

	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}

	public BigDecimal getShareRiPct() {
		return shareRiPct;
	}

	public void setShareRiPct(BigDecimal shareRiPct) {
		this.shareRiPct = shareRiPct;
	}

	public BigDecimal getShrRiRecoveryAmt() {
		return shrRiRecoveryAmt;
	}

	public void setShrRiRecoveryAmt(BigDecimal shrRiRecoveryAmt) {
		this.shrRiRecoveryAmt = shrRiRecoveryAmt;
	}

	public BigDecimal getShareRiPctReal() {
		return shareRiPctReal;
	}

	public void setShareRiPctReal(BigDecimal shareRiPctReal) {
		this.shareRiPctReal = shareRiPctReal;
	}

	public String getNegateTag() {
		return negateTag;
	}

	public void setNegateTag(String negateTag) {
		this.negateTag = negateTag;
	}

	public Date getNegateDate() {
		return negateDate;
	}

	public void setNegateDate(Date negateDate) {
		this.negateDate = negateDate;
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

	public String getDspRiName() {
		return dspRiName;
	}

	public void setDspRiName(String dspRiName) {
		this.dspRiName = dspRiName;
	}

	public void setRecoveredAmt(BigDecimal recoveredAmt) {
		this.recoveredAmt = recoveredAmt;
	}

	public BigDecimal getRecoveredAmt() {
		return recoveredAmt;
	}

	public void setShrRecoveryAmt(BigDecimal shrRecoveryAmt) {
		this.shrRecoveryAmt = shrRecoveryAmt;
	}

	public BigDecimal getShrRecoveryAmt() {
		return shrRecoveryAmt;
	}
	
}
