package com.geniisys.gicl.entity;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

import com.geniisys.framework.util.BaseEntity;

public class GICLRecHist extends BaseEntity{

	private Integer recoveryId;
	private Integer recHistNo;
	private String recStatCd;
	private String remarks;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	
	private String dspRecStatDesc;
	private String strLastUpdate;
	
	public Integer getRecoveryId() {
		return recoveryId;
	}
	public void setRecoveryId(Integer recoveryId) {
		this.recoveryId = recoveryId;
	}
	public Integer getRecHistNo() {
		return recHistNo;
	}
	public void setRecHistNo(Integer recHistNo) {
		this.recHistNo = recHistNo;
	}
	public String getRecStatCd() {
		return recStatCd;
	}
	public void setRecStatCd(String recStatCd) {
		this.recStatCd = recStatCd;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
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
	public String getDspRecStatDesc() {
		return dspRecStatDesc;
	}
	public void setDspRecStatDesc(String dspRecStatDesc) {
		this.dspRecStatDesc = dspRecStatDesc;
	}
	public String getStrLastUpdate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (super.getLastUpdate() != null){
			strLastUpdate = df.format(super.getLastUpdate());
			return strLastUpdate;	
		}else{
			return null;
		}
	}
	public void setStrLastUpdate(String strLastUpdate) {
		this.strLastUpdate = strLastUpdate;
	}
}
