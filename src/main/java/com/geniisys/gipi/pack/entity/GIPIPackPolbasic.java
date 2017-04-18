package com.geniisys.gipi.pack.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIPackPolbasic extends BaseEntity {

	private Integer packParId;
	private String lineCd;
	private String sublineCd;
	private String issCd;
	private Integer issueYy;
	private Integer polSeqNo;
	private Integer renewNo;
	private String endtIssCd;
	private Integer endtYy;
	private Integer endtSeqNo;
	private String endtType;
	private Date effDate;
	private Date expiryDate;
	private Date inceptDate;
	private Integer assdNo;
	private String distFlag;
	private Integer packPolicyId;
	private Integer policyId;
	private String refPolNo;
	
	private String nbtPackPol;
	private String dspAssdName;
	private Integer distNo;
	private String packPolFlag;
	private Integer riCd;
	
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
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public Integer getPolicyId() {
		return policyId;
	}
	public Integer getPackPolicyId() {
		return packPolicyId;
	}
	public void setPackPolicyId(Integer packPolicyId) {
		this.packPolicyId = packPolicyId;
	}
	public String getNbtPackPol() {
		return nbtPackPol;
	}
	public void setNbtPackPol(String nbtPackPol) {
		this.nbtPackPol = nbtPackPol;
	}
	public Integer getPackParId() {
		return packParId;
	}
	public void setPackParId(Integer packParId) {
		this.packParId = packParId;
	}
	public String getEndtIssCd() {
		return endtIssCd;
	}
	public void setEndtIssCd(String endtIssCd) {
		this.endtIssCd = endtIssCd;
	}
	public Integer getEndtYy() {
		return endtYy;
	}
	public void setEndtYy(Integer endtYy) {
		this.endtYy = endtYy;
	}
	public Integer getEndtSeqNo() {
		return endtSeqNo;
	}
	public void setEndtSeqNo(Integer endtSeqNo) {
		this.endtSeqNo = endtSeqNo;
	}
	public String getEndtType() {
		return endtType;
	}
	public void setEndtType(String endtType) {
		this.endtType = endtType;
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
	public Date getInceptDate() {
		return inceptDate;
	}
	public void setInceptDate(Date inceptDate) {
		this.inceptDate = inceptDate;
	}
	public Integer getAssdNo() {
		return assdNo;
	}
	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}
	public String getDistFlag() {
		return distFlag;
	}
	public void setDistFlag(String distFlag) {
		this.distFlag = distFlag;
	}
	public String getRefPolNo() {
		return refPolNo;
	}
	public void setRefPolNo(String refPolNo) {
		this.refPolNo = refPolNo;
	}
	public String getDspAssdName() {
		return dspAssdName;
	}
	public void setDspAssdName(String dspAssdName) {
		this.dspAssdName = dspAssdName;
	}
	public Integer getDistNo() {
		return distNo;
	}
	public void setDistNo(Integer distNo) {
		this.distNo = distNo;
	}
	public void setPackPolFlag(String packPolFlag) {
		this.packPolFlag = packPolFlag;
	}
	public String getPackPolFlag() {
		return packPolFlag;
	}	
	
}
