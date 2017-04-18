package com.geniisys.giri.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIRIFrpsRi extends BaseEntity{

	private String lineCd;
	private Integer frpsYy;
	private Integer frpsSeqNo;
	private Integer riSeqNo;
	private Integer riCd;
	private Integer fnlBinderId;
	private BigDecimal riShrPct;
	private BigDecimal riTsiAmt;
	private BigDecimal riPremAmt;
	private String reverseSw;
	private BigDecimal annRiSAmt;
	private BigDecimal annRiPct;
	private BigDecimal riCommRt;
	private BigDecimal riCommAmt;
	private BigDecimal premTax;
	private BigDecimal otherCharges;
	private String renewSw;
	private String facobligSw;
	private String bndrRemarks1;
	private String bndrRemarks2;
	private String bndrRemarks3;
	private String remarks;
	private String deleteSw;
	private Date revrsBndrPrintDate;
	private Integer masterBndrId;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private Integer bndrPrintedCnt;
	private Integer revrsBndrPrintedCnt;
	private String riAsNo;
	private String riAcceptBy;
	private Date riAcceptDate;
	private BigDecimal riShrPct2;
	private BigDecimal riPremVat;
	private BigDecimal riCommVat;
	private BigDecimal riWholdingVat;
	private String address1;
	private String address2;
	private String address3;
	private Integer premWarrDays;
	private String premWarrTag;
	private Integer packBinderId;
	private String arcExtData;
	
	private String riSname;
	private String binderNo;
	private String attention;
	private String dspFrpsNo;
	private String dspGrpBdr;
	private String currencyRt;
	private String currencyCd;
	private String dspPolicyNo;
	private String dspGrpBinderNo;
	private String dspReinsurer;
	private String dspBinderNo;
	
	private String fmtRiTsiAmt;
	private String fmtRiPremAmt;
	private String fmtRiShrPct;

	public GIRIFrpsRi(){
		
	}

	/**
	 * @return the lineCd
	 */
	public String getLineCd() {
		return lineCd;
	}

	/**
	 * @param lineCd the lineCd to set
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	
	/**
	 * @return the frpsYy
	 */
	public Integer getFrpsYy() {
		return frpsYy;
	}

	/**
	 * @param frpsYy the frpsYy to set
	 */
	public void setFrpsYy(Integer frpsYy) {
		this.frpsYy = frpsYy;
	}

	/**
	 * @return the frpsSeqNo
	 */
	public Integer getFrpsSeqNo() {
		return frpsSeqNo;
	}
	public String getFmtRiShrPct() {
		return fmtRiShrPct;
	}

	public void setFmtRiShrPct(String fmtRiShrPct) {
		this.fmtRiShrPct = fmtRiShrPct;
	}
	
	public String getDspGrpBinderNo() {
		return dspGrpBinderNo;
	}

	public void setDspGrpBinderNo(String dspGrpBinderNo) {
		this.dspGrpBinderNo = dspGrpBinderNo;
	}
	/**
	 * @param frpsSeqNo the frpsSeqNo to set
	 */
	public void setFrpsSeqNo(Integer frpsSeqNo) {
		this.frpsSeqNo = frpsSeqNo;
	}

	/**
	 * @return the riSeqNo
	 */
	public Integer getRiSeqNo() {
		return riSeqNo;
	}

	/**
	 * @param riSeqNo the riSeqNo to set
	 */
	public void setRiSeqNo(Integer riSeqNo) {
		this.riSeqNo = riSeqNo;
	}

	/**
	 * @return the riCd
	 */
	public Integer getRiCd() {
		return riCd;
	}

	/**
	 * @param riCd the riCd to set
	 */
	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}

	/**
	 * @return the fnlBinderId
	 */
	public Integer getFnlBinderId() {
		return fnlBinderId;
	}

	/**
	 * @param fnlBinderId the fnlBinderId to set
	 */
	public void setFnlBinderId(Integer fnlBinderId) {
		this.fnlBinderId = fnlBinderId;
	}

	/**
	 * @return the riShrPct
	 */
	public BigDecimal getRiShrPct() {
		return riShrPct;
	}

	/**
	 * @param riShrPct the riShrPct to set
	 */
	public void setRiShrPct(BigDecimal riShrPct) {
		this.riShrPct = riShrPct;
	}

	/**
	 * @return the riTsiAmt
	 */
	public BigDecimal getRiTsiAmt() {
		return riTsiAmt;
	}

	/**
	 * @param riTsiAmt the riTsiAmt to set
	 */
	public void setRiTsiAmt(BigDecimal riTsiAmt) {
		this.riTsiAmt = riTsiAmt;
	}

	/**
	 * @return the riPremAmt
	 */
	public BigDecimal getRiPremAmt() {
		return riPremAmt;
	}

	/**
	 * @param riPremAmt the riPremAmt to set
	 */
	public void setRiPremAmt(BigDecimal riPremAmt) {
		this.riPremAmt = riPremAmt;
	}

	/**
	 * @return the reverseSw
	 */
	public String getReverseSw() {
		return reverseSw;
	}

	/**
	 * @param reverseSw the reverseSw to set
	 */
	public void setReverseSw(String reverseSw) {
		this.reverseSw = reverseSw;
	}

	/**
	 * @return the annRiSAmt
	 */
	public BigDecimal getAnnRiSAmt() {
		return annRiSAmt;
	}

	/**
	 * @param annRiSAmt the annRiSAmt to set
	 */
	public void setAnnRiSAmt(BigDecimal annRiSAmt) {
		this.annRiSAmt = annRiSAmt;
	}

	/**
	 * @return the annRiPct
	 */
	public BigDecimal getAnnRiPct() {
		return annRiPct;
	}

	/**
	 * @param annRiPct the annRiPct to set
	 */
	public void setAnnRiPct(BigDecimal annRiPct) {
		this.annRiPct = annRiPct;
	}

	/**
	 * @return the riCommRt
	 */
	public BigDecimal getRiCommRt() {
		return riCommRt;
	}

	/**
	 * @param riCommRt the riCommRt to set
	 */
	public void setRiCommRt(BigDecimal riCommRt) {
		this.riCommRt = riCommRt;
	}

	/**
	 * @return the riCommAmt
	 */
	public BigDecimal getRiCommAmt() {
		return riCommAmt;
	}

	/**
	 * @param riCommAmt the riCommAmt to set
	 */
	public void setRiCommAmt(BigDecimal riCommAmt) {
		this.riCommAmt = riCommAmt;
	}

	/**
	 * @return the premTax
	 */
	public BigDecimal getPremTax() {
		return premTax;
	}

	/**
	 * @param premtax the premTax to set
	 */
	public void setPremTax(BigDecimal premTax) {
		this.premTax = premTax;
	}

	/**
	 * @return the otherCharges
	 */
	public BigDecimal getOtherCharges() {
		return otherCharges;
	}

	/**
	 * @param otherCharges the otherCharges to set
	 */
	public void setOtherCharges(BigDecimal otherCharges) {
		this.otherCharges = otherCharges;
	}

	/**
	 * @return the renewSw
	 */
	public String getRenewSw() {
		return renewSw;
	}

	/**
	 * @param renewSw the renewSw to set
	 */
	public void setRenewSw(String renewSw) {
		this.renewSw = renewSw;
	}

	/**
	 * @return the facobligSw
	 */
	public String getFacobligSw() {
		return facobligSw;
	}

	/**
	 * @param facobligSw the facobligSw to set
	 */
	public void setFacobligSw(String facobligSw) {
		this.facobligSw = facobligSw;
	}

	/**
	 * @return the bndrRemarks1
	 */
	public String getBndrRemarks1() {
		return bndrRemarks1;
	}

	/**
	 * @param bndrRemarks1 the bndrRemarks1 to set
	 */
	public void setBndrRemarks1(String bndrRemarks1) {
		this.bndrRemarks1 = bndrRemarks1;
	}

	/**
	 * @return the bndrRemarks2
	 */
	public String getBndrRemarks2() {
		return bndrRemarks2;
	}

	/**
	 * @param bndrRemarks2 the bndrRemarks2 to set
	 */
	public void setBndrRemarks2(String bndrRemarks2) {
		this.bndrRemarks2 = bndrRemarks2;
	}

	/**
	 * @return the bndrRemarks3
	 */
	public String getBndrRemarks3() {
		return bndrRemarks3;
	}

	/**
	 * @param bndrRemarks3 the bndrRemarks3 to set
	 */
	public void setBndrRemarks3(String bndrRemarks3) {
		this.bndrRemarks3 = bndrRemarks3;
	}

	/**
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * @param remarks the remarks to set
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	/**
	 * @return the deleteSw
	 */
	public String getDeleteSw() {
		return deleteSw;
	}

	/**
	 * @param deleteSw the deleteSw to set
	 */
	public void setDeleteSw(String deleteSw) {
		this.deleteSw = deleteSw;
	}

	/**
	 * @return the revrsBndrPrintDate
	 */
	public Date getRevrsBndrPrintDate() {
		return revrsBndrPrintDate;
	}

	/**
	 * @param revrsBndrPrintDate the revrsBndrPrintDate to set
	 */
	public void setRevrsBndrPrintDate(Date revrsBndrPrintDate) {
		this.revrsBndrPrintDate = revrsBndrPrintDate;
	}

	/**
	 * @return the masterBndrId
	 */
	public Integer getMasterBndrId() {
		return masterBndrId;
	}

	/**
	 * @param masterBndrId the masterBndrId to set
	 */
	public void setMasterBndrId(Integer masterBndrId) {
		this.masterBndrId = masterBndrId;
	}

	/**
	 * @return the bndrPrintedCnt
	 */
	public Integer getBndrPrintedCnt() {
		return bndrPrintedCnt;
	}

	/**
	 * @param bndrPrintedCnt the bndrPrintedCnt to set
	 */
	public void setBndrPrintedCnt(Integer bndrPrintedCnt) {
		this.bndrPrintedCnt = bndrPrintedCnt;
	}

	/**
	 * @return the revrsBndrPrintedCnt
	 */
	public Integer getRevrsBndrPrintedCnt() {
		return revrsBndrPrintedCnt;
	}

	/**
	 * @param revrsBndrPrintedCnt the revrsBndrPrintedCnt to set
	 */
	public void setRevrsBndrPrintedCnt(Integer revrsBndrPrintedCnt) {
		this.revrsBndrPrintedCnt = revrsBndrPrintedCnt;
	}

	/**
	 * @return the riAsNo
	 */
	public String getRiAsNo() {
		return riAsNo;
	}

	/**
	 * @param riAsNo the riAsNo to set
	 */
	public void setRiAsNo(String riAsNo) {
		this.riAsNo = riAsNo;
	}

	/**
	 * @return the riAcceptBy
	 */
	public String getRiAcceptBy() {
		return riAcceptBy;
	}

	/**
	 * @param riAcceptBy the riAcceptBy to set
	 */
	public void setRiAcceptBy(String riAcceptBy) {
		this.riAcceptBy = riAcceptBy;
	}

	/**
	 * @return the riAcceptDate
	 */
	public Date getRiAcceptDate() {
		return riAcceptDate;
	}

	/**
	 * @param riAcceptDate the riAcceptDate to set
	 */
	public void setRiAcceptDate(Date riAcceptDate) {
		this.riAcceptDate = riAcceptDate;
	}

	/**
	 * @return the riShrPct2
	 */
	public BigDecimal getRiShrPct2() {
		return riShrPct2;
	}

	/**
	 * @param riShrPct2 the riShrPct2 to set
	 */
	public void setRiShrPct2(BigDecimal riShrPct2) {
		this.riShrPct2 = riShrPct2;
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

	public BigDecimal getRiPremVat() {
		return riPremVat;
	}

	public void setRiPremVat(BigDecimal riPremVat) {
		this.riPremVat = riPremVat;
	}

	public BigDecimal getRiCommVat() {
		return riCommVat;
	}

	public void setRiCommVat(BigDecimal riCommVat) {
		this.riCommVat = riCommVat;
	}

	public String getRiSname() {
		return riSname;
	}

	public void setRiSname(String riSname) {
		this.riSname = riSname;
	}

	/**
	 * @return the riWholdingVat
	 */
	public BigDecimal getRiWholdingVat() {
		return riWholdingVat;
	}

	/**
	 * @param riWholdingVat the riWholdingVat to set
	 */
	public void setRiWholdingVat(BigDecimal riWholdingVat) {
		this.riWholdingVat = riWholdingVat;
	}

	/**
	 * @return the address1
	 */
	public String getAddress1() {
		return address1;
	}

	/**
	 * @param address1 the address1 to set
	 */
	public void setAddress1(String address1) {
		this.address1 = address1;
	}

	/**
	 * @return the address2
	 */
	public String getAddress2() {
		return address2;
	}

	/**
	 * @param address2 the address2 to set
	 */
	public void setAddress2(String address2) {
		this.address2 = address2;
	}

	/**
	 * @return the address3
	 */
	public String getAddress3() {
		return address3;
	}

	/**
	 * @param address3 the address3 to set
	 */
	public void setAddress3(String address3) {
		this.address3 = address3;
	}

	/**
	 * @return the premWarrDays
	 */
	public Integer getPremWarrDays() {
		return premWarrDays;
	}

	/**
	 * @param premWarrDays the premWarrDays to set
	 */
	public void setPremWarrDays(Integer premWarrDays) {
		this.premWarrDays = premWarrDays;
	}

	/**
	 * @return the premWarrTag
	 */
	public String getPremWarrTag() {
		return premWarrTag;
	}

	/**
	 * @param premWarrTag the premWarrTag to set
	 */
	public void setPremWarrTag(String premWarrTag) {
		this.premWarrTag = premWarrTag;
	}

	/**
	 * @return the packBinderId
	 */
	public Integer getPackBinderId() {
		return packBinderId;
	}

	/**
	 * @param packBinderId the packBinderId to set
	 */
	public void setPackBinderId(Integer packBinderId) {
		this.packBinderId = packBinderId;
	}
	


	/**
	 * @return the arcExtData
	 */
	public String getArcExtData() {
		return arcExtData;
	}

	/**
	 * @param arcExtData the arcExtData to set
	 */
	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}
	public String getBinderNo() {
		return binderNo;
	}

	public void setBinderNo(String binderNo) {
		this.binderNo = binderNo;
	}
	
	public String getAttention() {
		return attention;
	}

	public void setAttention(String attention) {
		this.attention = attention;
	}

	public String getDspFrpsNo() {
		return dspFrpsNo;
	}

	public void setDspFrpsNo(String dspFrpsNo) {
		this.dspFrpsNo = dspFrpsNo;
	}

	public String getDspGrpBdr() {
		return dspGrpBdr;
	}

	public void setDspGrpBdr(String dspGrpBdr) {
		this.dspGrpBdr = dspGrpBdr;
	}

	public String getCurrencyRt() {
		return currencyRt;
	}

	public void setCurrencyRt(String currencyRt) {
		this.currencyRt = currencyRt;
	}

	public String getCurrencyCd() {
		return currencyCd;
	}

	public void setCurrencyCd(String currencyCd) {
		this.currencyCd = currencyCd;
	}

	public String getDspPolicyNo() {
		return dspPolicyNo;
	}

	public void setDspPolicyNo(String dspPolicyNo) {
		this.dspPolicyNo = dspPolicyNo;
	}
	

	public String getDspReinsurer() {
		return dspReinsurer;
	}

	public void setDspReinsurer(String dspReinsurer) {
		this.dspReinsurer = dspReinsurer;
	}

	public String getDspBinderNo() {
		return dspBinderNo;
	}

	public void setDspBinderNo(String dspBinderNo) {
		this.dspBinderNo = dspBinderNo;
	}

	public String getFmtRiTsiAmt() {
		return fmtRiTsiAmt;
	}

	public void setFmtRiTsiAmt(String fmtRiTsiAmt) {
		this.fmtRiTsiAmt = fmtRiTsiAmt;
	}

	public String getFmtRiPremAmt() {
		return fmtRiPremAmt;
	}

	public void setFmtRiPremAmt(String fmtRiPremAmt) {
		this.fmtRiPremAmt = fmtRiPremAmt;
	}



}
