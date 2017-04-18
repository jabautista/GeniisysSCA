/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.entity
	File Name: GICLRepairHdr.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 27, 2012
	Description: 
*/


package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLRepairHdr extends BaseEntity{
	private Integer evalId;
	private String payeeTypeCd;
	private Integer payeeCd;
	private BigDecimal lpsRepairAmt;
	private BigDecimal actualTotalAmt;
	private BigDecimal actualTinsmithAmt;
	private BigDecimal actualPaintingAmt;
	private BigDecimal otherLaborAmt;
	private String withVat;
	private String updateSw;
	
	//Attributes that are not in the table
	private String dspCompanyType;
	private String dspCompany;
	private String dspLaborComType;
	private String dspLaborCompany;
	private BigDecimal dspTotalLabor;
	private BigDecimal dspTotalT;
	private BigDecimal dspTotalP;
	
	public BigDecimal getDspTotalT() {
		return dspTotalT;
	}
	public void setDspTotalT(BigDecimal dspTotalT) {
		this.dspTotalT = dspTotalT;
	}
	public BigDecimal getDspTotalP() {
		return dspTotalP;
	}
	public void setDspTotalP(BigDecimal dspTotalP) {
		this.dspTotalP = dspTotalP;
	}
	public String getDspCompanyType() {
		return dspCompanyType;
	}
	public void setDspCompanyType(String dspCompanyType) {
		this.dspCompanyType = dspCompanyType;
	}
	public String getDspCompany() {
		return dspCompany;
	}
	public void setDspCompany(String dspCompany) {
		this.dspCompany = dspCompany;
	}
	public String getDspLaborComType() {
		return dspLaborComType;
	}
	public void setDspLaborComType(String dspLaborComType) {
		this.dspLaborComType = dspLaborComType;
	}
	public String getDspLaborCompany() {
		return dspLaborCompany;
	}
	public void setDspLaborCompany(String dspLaborCompany) {
		this.dspLaborCompany = dspLaborCompany;
	}
	public BigDecimal getDspTotalLabor() {
		return dspTotalLabor;
	}
	public void setDspTotalLabor(BigDecimal dspTotalLabor) {
		this.dspTotalLabor = dspTotalLabor;
	}
	public Integer getEvalId() {
		return evalId;
	}
	public void setEvalId(Integer evalId) {
		this.evalId = evalId;
	}
	public String getPayeeTypeCd() {
		return payeeTypeCd;
	}
	public void setPayeeTypeCd(String payeeTypeCd) {
		this.payeeTypeCd = payeeTypeCd;
	}
	public Integer getPayeeCd() {
		return payeeCd;
	}
	public void setPayeeCd(Integer payeeCd) {
		this.payeeCd = payeeCd;
	}
	public BigDecimal getLpsRepairAmt() {
		return lpsRepairAmt;
	}
	public void setLpsRepairAmt(BigDecimal lpsRepairAmt) {
		this.lpsRepairAmt = lpsRepairAmt;
	}
	public BigDecimal getActualTotalAmt() {
		return actualTotalAmt;
	}
	public void setActualTotalAmt(BigDecimal actualTotalAmt) {
		this.actualTotalAmt = actualTotalAmt;
	}
	public BigDecimal getActualTinsmithAmt() {
		return actualTinsmithAmt;
	}
	public void setActualTinsmithAmt(BigDecimal actualTinsmithAmt) {
		this.actualTinsmithAmt = actualTinsmithAmt;
	}
	public BigDecimal getActualPaintingAmt() {
		return actualPaintingAmt;
	}
	public void setActualPaintingAmt(BigDecimal actualPaintingAmt) {
		this.actualPaintingAmt = actualPaintingAmt;
	}
	public BigDecimal getOtherLaborAmt() {
		return otherLaborAmt;
	}
	public void setOtherLaborAmt(BigDecimal otherLaborAmt) {
		this.otherLaborAmt = otherLaborAmt;
	}
	public String getWithVat() {
		return withVat;
	}
	public void setWithVat(String withVat) {
		this.withVat = withVat;
	}
	public String getUpdateSw() {
		return updateSw;
	}
	public void setUpdateSw(String updateSw) {
		this.updateSw = updateSw;
	}
	
}
