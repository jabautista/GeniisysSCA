package com.geniisys.giri.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIRIWFrpsRi extends BaseEntity {

	private String lineCd;
	private Integer frpsYy;
	private Integer frpsSeqNo;
	private Integer riSeqNo;
	private Integer riCd;
	private Integer origRiCd;
	private Integer preBinderId;
	private BigDecimal riShrPct;
	private BigDecimal riTsiAmt;
	private BigDecimal riPremAmt;
	private BigDecimal annRiSAmt;
	private BigDecimal annRiPct;
	private BigDecimal riCommAmt;
	private BigDecimal riCommRt;
	private BigDecimal premTax;
	private BigDecimal otherCharges;
	private String renewSw;
	private String reverseSw;
	private String facobligSw;
	private String bndrRemarks1;
	private String bndrRemarks2;
	private String bndrRemarks3;
	private String deleteSw;
	private String remarks;
	private String riAsNo;
	private String riAcceptBy;
	private Date riAcceptDate;
	private BigDecimal riShrPct2;
	private BigDecimal riPremVat;
	private BigDecimal riCommVat;
	private String address1;
	private String address2;
	private String address3;
	private Integer premWarrDays;
	private String premWarrTag;
	private String arcExtData;

	private String riSname;
	private String riName;
	private String giriFrpsRiCtr;
	private BigDecimal netDue;
	private String dspFnlBinderId;
	private String reusedBinder;
	private String localForeignSw;
	
	public String getLocalForeignSw() {
		return localForeignSw;
	}

	public void setLocalForeignSw(String localForeignSw) {
		this.localForeignSw = localForeignSw;
	}
	
	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public Integer getFrpsYy() {
		return frpsYy;
	}

	public void setFrpsYy(Integer frpsYy) {
		this.frpsYy = frpsYy;
	}

	public Integer getFrpsSeqNo() {
		return frpsSeqNo;
	}

	public void setFrpsSeqNo(Integer frpsSeqNo) {
		this.frpsSeqNo = frpsSeqNo;
	}

	public Integer getRiSeqNo() {
		return riSeqNo;
	}

	public void setRiSeqNo(Integer riSeqNo) {
		this.riSeqNo = riSeqNo;
	}

	public Integer getRiCd() {
		return riCd;
	}

	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}
	
	public Integer getOrigRiCd() {
		return origRiCd;
	}

	public void setOrigRiCd(Integer origRiCd) {
		this.origRiCd = origRiCd;
	}

	public Integer getPreBinderId() {
		return preBinderId;
	}

	public void setPreBinderId(Integer preBinderId) {
		this.preBinderId = preBinderId;
	}

	public BigDecimal getRiShrPct() {
		return riShrPct;
	}
	
	public Object getStrRiShrPct() {
		if (riShrPct != null){
			return riShrPct.toString();
		}else{
			return null;
		}
	}

	public void setRiShrPct(BigDecimal riShrPct) {
		this.riShrPct = riShrPct;
	}

	public BigDecimal getRiTsiAmt() {
		return riTsiAmt;
	}

	public void setRiTsiAmt(BigDecimal riTsiAmt) {
		this.riTsiAmt = riTsiAmt;
	}

	public BigDecimal getRiPremAmt() {
		return riPremAmt;
	}

	public void setRiPremAmt(BigDecimal riPremAmt) {
		this.riPremAmt = riPremAmt;
	}

	public BigDecimal getAnnRiSAmt() {
		return annRiSAmt;
	}

	public void setAnnRiSAmt(BigDecimal annRiSAmt) {
		this.annRiSAmt = annRiSAmt;
	}

	public BigDecimal getAnnRiPct() {
		return annRiPct;
	}

	public void setAnnRiPct(BigDecimal annRiPct) {
		this.annRiPct = annRiPct;
	}

	public BigDecimal getRiCommAmt() {
		return riCommAmt;
	}

	public void setRiCommAmt(BigDecimal riCommAmt) {
		this.riCommAmt = riCommAmt;
	}

	public BigDecimal getRiCommRt() {
		return riCommRt;
	}

	public void setRiCommRt(BigDecimal riCommRt) {
		this.riCommRt = riCommRt;
	}

	public BigDecimal getPremTax() {
		return premTax;
	}

	public void setPremTax(BigDecimal premTax) {
		this.premTax = premTax;
	}

	public BigDecimal getOtherCharges() {
		return otherCharges;
	}

	public void setOtherCharges(BigDecimal otherCharges) {
		this.otherCharges = otherCharges;
	}

	public String getRenewSw() {
		return renewSw;
	}

	public void setRenewSw(String renewSw) {
		this.renewSw = renewSw;
	}

	public String getReverseSw() {
		return reverseSw;
	}

	public void setReverseSw(String reverseSw) {
		this.reverseSw = reverseSw;
	}

	public String getFacobligSw() {
		return facobligSw;
	}

	public void setFacobligSw(String facobligSw) {
		this.facobligSw = facobligSw;
	}

	public String getBndrRemarks1() {
		return bndrRemarks1;
	}

	public void setBndrRemarks1(String bndrRemarks1) {
		this.bndrRemarks1 = bndrRemarks1;
	}

	public String getBndrRemarks2() {
		return bndrRemarks2;
	}

	public void setBndrRemarks2(String bndrRemarks2) {
		this.bndrRemarks2 = bndrRemarks2;
	}

	public String getBndrRemarks3() {
		return bndrRemarks3;
	}

	public void setBndrRemarks3(String bndrRemarks3) {
		this.bndrRemarks3 = bndrRemarks3;
	}

	public String getDeleteSw() {
		return deleteSw;
	}

	public void setDeleteSw(String deleteSw) {
		this.deleteSw = deleteSw;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getRiAsNo() {
		return riAsNo;
	}

	public void setRiAsNo(String riAsNo) {
		this.riAsNo = riAsNo;
	}

	public String getRiAcceptBy() {
		return riAcceptBy;
	}

	public void setRiAcceptBy(String riAcceptBy) {
		this.riAcceptBy = riAcceptBy;
	}

	public Date getRiAcceptDate() {
		return riAcceptDate;
	}

	public void setRiAcceptDate(Date riAcceptDate) {
		this.riAcceptDate = riAcceptDate;
	}

	public BigDecimal getRiShrPct2() {
		return riShrPct2;
	}
	
	public Object getStrRiShrPct2() {
		if (riShrPct2 != null){
			return riShrPct2.toString();
		}else{
			return null;
		}
	}

	public void setRiShrPct2(BigDecimal riShrPct2) {
		this.riShrPct2 = riShrPct2;
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

	public String getAddress1() {
		return address1;
	}

	public void setAddress1(String address1) {
		this.address1 = address1;
	}

	public String getAddress2() {
		return address2;
	}

	public void setAddress2(String address2) {
		this.address2 = address2;
	}

	public String getAddress3() {
		return address3;
	}

	public void setAddress3(String address3) {
		this.address3 = address3;
	}

	public Integer getPremWarrDays() {
		return premWarrDays;
	}

	public void setPremWarrDays(Integer premWarrDays) {
		this.premWarrDays = premWarrDays;
	}

	public String getPremWarrTag() {
		return premWarrTag;
	}

	public void setPremWarrTag(String premWarrTag) {
		this.premWarrTag = premWarrTag;
	}

	public String getArcExtData() {
		return arcExtData;
	}

	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}

	public String getRiSname() {
		return riSname;
	}

	public void setRiSname(String riSname) {
		this.riSname = riSname;
	}

	public String getRiName() {
		return riName;
	}

	public void setRiName(String riName) {
		this.riName = riName;
	}

	public String getGiriFrpsRiCtr() {
		return giriFrpsRiCtr;
	}

	public void setGiriFrpsRiCtr(String giriFrpsRiCtr) {
		this.giriFrpsRiCtr = giriFrpsRiCtr;
	}

	public BigDecimal getNetDue() {
		return netDue;
	}

	public void setNetDue(BigDecimal netDue) {
		this.netDue = netDue;
	}

	public String getDspFnlBinderId() {
		return dspFnlBinderId;
	}

	public void setDspFnlBinderId(String dspFnlBinderId) {
		this.dspFnlBinderId = dspFnlBinderId;
	}

	public String getReusedBinder() {
		return reusedBinder;
	}

	public void setReusedBinder(String reusedBinder) {
		this.reusedBinder = reusedBinder;
	}

}
