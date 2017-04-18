
package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIACUploadJvPaytDtl extends BaseEntity {
	private String sourceCd;
	private Integer fileNo;
	private String branchCd;
	private Integer tranYear;
	private Integer tranMonth;
	private Integer tranSeqNo;
	private String tranDate;
	private String jvPrefSuff;
	private Integer jvNo;
	private String particulars;
	private String jvTranTag;
	private String jvTranType;
	private Integer jvTranMm;
	private Integer jvTranYy;
	private Integer tranId;
	
	public GIACUploadJvPaytDtl(String sourceCd, Integer fileNo,
			String branchCd, Integer tranYear, Integer tranMonth,
			Integer tranSeqNo, String tranDate, String jvPrefSuff,
			Integer jvNo, String particulars, String jvTranTag,
			String jvTranType, Integer jvTranMm, Integer jvTranYy, Integer tranId) {
		super();
		this.sourceCd = sourceCd;
		this.fileNo = fileNo;
		this.branchCd = branchCd;
		this.tranYear = tranYear;
		this.tranMonth = tranMonth;
		this.tranSeqNo = tranSeqNo;
		this.tranDate = tranDate;
		this.jvPrefSuff = jvPrefSuff;
		this.jvNo = jvNo;
		this.particulars = particulars;
		this.jvTranTag = jvTranTag;
		this.jvTranType = jvTranType;
		this.jvTranMm = jvTranMm;
		this.jvTranYy = jvTranYy;
		this.tranId = tranId;
	}

	public GIACUploadJvPaytDtl() {
		
	}

	public String getSourceCd() {
		return sourceCd;
	}

	public void setSourceCd(String sourceCd) {
		this.sourceCd = sourceCd;
	}

	public Integer getFileNo() {
		return fileNo;
	}

	public void setFileNo(Integer fileNo) {
		this.fileNo = fileNo;
	}

	public String getBranchCd() {
		return branchCd;
	}

	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}

	public Integer getTranYear() {
		return tranYear;
	}

	public void setTranYear(Integer tranYear) {
		this.tranYear = tranYear;
	}

	public Integer getTranMonth() {
		return tranMonth;
	}

	public void setTranMonth(Integer tranMonth) {
		this.tranMonth = tranMonth;
	}

	public Integer getTranSeqNo() {
		return tranSeqNo;
	}

	public void setTranSeqNo(Integer tranSeqNo) {
		this.tranSeqNo = tranSeqNo;
	}

	public String getTranDate() {
		return tranDate;
	}

	public void setTranDate(String tranDate) {
		this.tranDate = tranDate;
	}

	public String getJvPrefSuff() {
		return jvPrefSuff;
	}

	public void setJvPrefSuff(String jvPrefSuff) {
		this.jvPrefSuff = jvPrefSuff;
	}

	public Integer getJvNo() {
		return jvNo;
	}

	public void setJvNo(Integer jvNo) {
		this.jvNo = jvNo;
	}

	public String getParticulars() {
		return particulars;
	}

	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}

	public String getJvTranTag() {
		return jvTranTag;
	}

	public void setJvTranTag(String jvTranTag) {
		this.jvTranTag = jvTranTag;
	}

	public String getJvTranType() {
		return jvTranType;
	}

	public void setJvTranType(String jvTranType) {
		this.jvTranType = jvTranType;
	}

	public Integer getJvTranMm() {
		return jvTranMm;
	}

	public void setJvTranMm(Integer jvTranMm) {
		this.jvTranMm = jvTranMm;
	}

	public Integer getJvTranYy() {
		return jvTranYy;
	}

	public void setJvTranYy(Integer jvTranYy) {
		this.jvTranYy = jvTranYy;
	}

	public Integer getTranId() {
		return tranId;
	}

	public void setTranId(Integer tranId) {
		this.tranId = tranId;
	}
	
}
