package com.geniisys.gipi.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIOpenPolicy extends BaseEntity{
	
	private Integer policyId;		
	private String lineCd;		
	private String opSublineCd;		
	private String opIssCd;		
	private Integer opPolSeqno;		
	private Integer opRenewNo;		
	private String decltnNo;		
	private Date effDate;		
	private Integer opIssueYy;		
	private Integer cpiRecNo;		
	private String cpiBranchCd;		
	private String arcExtData;
	
	private String refOpenPolNo;
	
	public GIPIOpenPolicy() {
		super();
	}

	public GIPIOpenPolicy(Integer policyId, String lineCd, String opSublineCd,
			String opIssCd, Integer opPolSeqno, Integer opRenewNo,
			String decltnNo, Date effDate, Integer opIssueYy, Integer cpiRecNo,
			String cpiBranchCd, String arcExtData, String refOpenPolNo) {
		super();
		this.policyId = policyId;
		this.lineCd = lineCd;
		this.opSublineCd = opSublineCd;
		this.opIssCd = opIssCd;
		this.opPolSeqno = opPolSeqno;
		this.opRenewNo = opRenewNo;
		this.decltnNo = decltnNo;
		this.effDate = effDate;
		this.opIssueYy = opIssueYy;
		this.cpiRecNo = cpiRecNo;
		this.cpiBranchCd = cpiBranchCd;
		this.arcExtData = arcExtData;
		this.refOpenPolNo = refOpenPolNo;
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

	public Integer getOpRenewNo() {
		return opRenewNo;
	}

	public void setOpRenewNo(Integer opRenewNo) {
		this.opRenewNo = opRenewNo;
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

	public String getArcExtData() {
		return arcExtData;
	}

	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}

	public String getRefOpenPolNo() {
		return refOpenPolNo;
	}

	public void setRefOpenPolNo(String refOpenPolNo) {
		this.refOpenPolNo = refOpenPolNo;
	}



	public String getDecltnNo() {
		return decltnNo;
	}



	public void setDecltnNo(String decltnNo) {
		this.decltnNo = decltnNo;
	}
	
	

}
