package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLClmRecoveryDist extends BaseEntity {
	
	private Integer recoveryId;
	private String recoveryPaytId;
	private Integer recDistNo;
	private String dspLineCd; 
	private Integer grpSeqNo;
	private String dspShareName;
	private Integer acctTrtyType;
	private String shareType;
	private BigDecimal sharePct;
	private Integer distYear;
	private BigDecimal shrRecoveryAmt;
	private String negateTag;
	private Date negateDate;
	
	private String lineCd;
	
	public Integer getRecoveryId() {
		return recoveryId;
	}
	public void setRecoveryId(Integer recoveryId) {
		this.recoveryId = recoveryId;
	}
	public String getRecoveryPaytId() {
		return recoveryPaytId;
	}
	public void setRecoveryPaytId(String recoveryPaytId) {
		this.recoveryPaytId = recoveryPaytId;
	}
	public Integer getRecDistNo() {
		return recDistNo;
	}
	public void setRecDistNo(Integer recDistNo) {
		this.recDistNo = recDistNo;
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
	public String getDspShareName() {
		return dspShareName;
	}
	public void setDspShareName(String dspShareName) {
		this.dspShareName = dspShareName;
	}
	public Integer getAcctTrtyType() {
		return acctTrtyType;
	}
	public void setAcctTrtyType(Integer acctTrtyType) {
		this.acctTrtyType = acctTrtyType;
	}
	public String getShareType() {
		return shareType;
	}
	public void setShareType(String shareType) {
		this.shareType = shareType;
	}
	public BigDecimal getSharePct() {
		return sharePct;
	}
	public void setSharePct(BigDecimal sharePct) {
		this.sharePct = sharePct;
	}
	public Integer getDistYear() {
		return distYear;
	}
	public void setDistYear(Integer distYear) {
		this.distYear = distYear;
	}
	public BigDecimal getShrRecoveryAmt() {
		return shrRecoveryAmt;
	}
	public void setShrRecoveryAmt(BigDecimal shrRecoveryAmt) {
		this.shrRecoveryAmt = shrRecoveryAmt;
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
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	
	
}
