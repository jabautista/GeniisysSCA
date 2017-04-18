package com.geniisys.gixx.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIXXOpenPolicy extends BaseEntity{
	
	private Integer extractId;
	private String lineCd;
	private String opSublineCd;
	private String opIssCd;
	private Integer opPolSeqno;
	private String decltnNo;
	private Date effDate;
	private Integer opIssueYy;
	private Integer opRenewNo;
	private Integer policyId;
	private String refOpenPolNo;
	
	
	public Integer getExtractId() {
		return extractId;
	}
	public void setExtractId(Integer extractId) {
		this.extractId = extractId;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getOpSublineCd() {
		return opSublineCd;
	}
	public void setOpSublineCd(String opSublineCd) {
		this.opSublineCd = opSublineCd;
	}
	public String getOpIssCd() {
		return opIssCd;
	}
	public void setOpIssCd(String opIssCd) {
		this.opIssCd = opIssCd;
	}
	public Integer getOpPolSeqno() {
		return opPolSeqno;
	}
	public void setOpPolSeqno(Integer opPolSeqno) {
		this.opPolSeqno = opPolSeqno;
	}
	public String getDecltnNo() {
		return decltnNo;
	}
	public void setDecltnNo(String decltnNo) {
		this.decltnNo = decltnNo;
	}
	public Date getEffDate() {
		return effDate;
	}
	public void setEffDate(Date effDate) {
		this.effDate = effDate;
	}
	public Integer getOpIssueYy() {
		return opIssueYy;
	}
	public void setOpIssueYy(Integer opIssueYy) {
		this.opIssueYy = opIssueYy;
	}
	public Integer getOpRenewNo() {
		return opRenewNo;
	}
	public void setOpRenewNo(Integer opRenewNo) {
		this.opRenewNo = opRenewNo;
	}
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public String getRefOpenPolNo() {
		return refOpenPolNo;
	}
	public void setRefOpenPolNo(String refOpenPolNo) {
		this.refOpenPolNo = refOpenPolNo;
	}

	
}
