package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLClmRecoveryDtl extends BaseEntity{
	
	private Integer recoveryId;
	private Integer claimId;
	private Integer clmLossId;
	private Integer itemNo;
	private Integer perilCd;
    private BigDecimal recoverableAmt;
    private Integer cpiRecNo;
    private String cpiBranchCd;
    
    private String dspItemNo;
    private String dspPerilCd;
    private String dspChkBox;
    private BigDecimal dspTsiAmt;
    private BigDecimal dspTotalRecAmt;
    
	public Integer getRecoveryId() {
		return recoveryId;
	}
	public void setRecoveryId(Integer recoveryId) {
		this.recoveryId = recoveryId;
	}
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public Integer getClmLossId() {
		return clmLossId;
	}
	public void setClmLossId(Integer clmLossId) {
		this.clmLossId = clmLossId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public Integer getPerilCd() {
		return perilCd;
	}
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	public BigDecimal getRecoverableAmt() {
		return recoverableAmt;
	}
	public void setRecoverableAmt(BigDecimal recoverableAmt) {
		this.recoverableAmt = recoverableAmt;
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
	public String getDspItemNo() {
		return dspItemNo;
	}
	public void setDspItemNo(String dspItemNo) {
		this.dspItemNo = dspItemNo;
	}
	public String getDspPerilCd() {
		return dspPerilCd;
	}
	public void setDspPerilCd(String dspPerilCd) {
		this.dspPerilCd = dspPerilCd;
	}
	public String getDspChkBox() {
		return dspChkBox;
	}
	public void setDspChkBox(String dspChkBox) {
		this.dspChkBox = dspChkBox;
	}
	public BigDecimal getDspTsiAmt() {
		return dspTsiAmt;
	}
	public void setDspTsiAmt(BigDecimal dspTsiAmt) {
		this.dspTsiAmt = dspTsiAmt;
	}
	public BigDecimal getDspTotalRecAmt() {
		return dspTotalRecAmt;
	}
	public void setDspTotalRecAmt(BigDecimal dspTotalRecAmt) {
		this.dspTotalRecAmt = dspTotalRecAmt;
	}
    
}
