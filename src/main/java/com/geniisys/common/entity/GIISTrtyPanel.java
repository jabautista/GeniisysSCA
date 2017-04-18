package com.geniisys.common.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;

public class GIISTrtyPanel extends BaseEntity {
	private String lineCd;
	private Integer trtySeqNo;
	private Integer trtyYy;
	private Integer riCd;
	private Integer prntRiCd;
	private BigDecimal trtyShrPct;
	private BigDecimal trtyShrAmt;
	private BigDecimal ccallLimit;
	private BigDecimal whTaxRt;
	private BigDecimal brokerPct;
	private Integer broker;
	private BigDecimal premRes;
	private BigDecimal intOnPremRes;
	private BigDecimal riCommRt;
	private BigDecimal profRt;
	private BigDecimal fundsHeldPct;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String remarks;
	private BigDecimal intTaxRt; //benjo 08.03.2016 SR-5512
	
	private String strRiCommRt;
	private String strFundsHeldPct;
	
	public GIISTrtyPanel() {

	}

	public GIISTrtyPanel(String userId, String appUser, String lastUpdate,
			String createUser, String createDate, Integer rowNum,
			Integer rowCount, String lineCd, Integer trtySeqNo, Integer trtyYy,
			Integer riCd, Integer prntRiCd, BigDecimal trtyShrPct,
			BigDecimal trtyShrAmt, BigDecimal ccallLimit, BigDecimal whTaxRt,
			BigDecimal brokerPct, Integer broker, BigDecimal premRes,
			BigDecimal intOnPremRes, BigDecimal riCommRt, BigDecimal profRt,
			BigDecimal fundsHeldPct, Integer cpiRecNo, String cpiBranchCd,
			String remarks, BigDecimal intTaxRt) { //benjo 08.03.2016 SR-5512
		super();
		this.lineCd = lineCd;
		this.trtySeqNo = trtySeqNo;
		this.trtyYy = trtyYy;
		this.riCd = riCd;
		this.prntRiCd = prntRiCd;
		this.trtyShrPct = trtyShrPct;
		this.trtyShrAmt = trtyShrAmt;
		this.ccallLimit = ccallLimit;
		this.whTaxRt = whTaxRt;
		this.brokerPct = brokerPct;
		this.broker = broker;
		this.premRes = premRes;
		this.intOnPremRes = intOnPremRes;
		this.riCommRt = riCommRt;
		this.profRt = profRt;
		this.fundsHeldPct = fundsHeldPct;
		this.cpiRecNo = cpiRecNo;
		this.cpiBranchCd = cpiBranchCd;
		this.remarks = remarks;
		this.intTaxRt = intTaxRt; //benjo 08.03.2016 SR-5512
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public Integer getTrtySeqNo() {
		return trtySeqNo;
	}

	public void setTrtySeqNo(Integer trtySeqNo) {
		this.trtySeqNo = trtySeqNo;
	}

	public Integer getTrtyYy() {
		return trtyYy;
	}

	public void setTrtyYy(Integer trtyYy) {
		this.trtyYy = trtyYy;
	}

	public Integer getRiCd() {
		return riCd;
	}

	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}

	public Integer getPrntRiCd() {
		return prntRiCd;
	}

	public void setPrntRiCd(Integer prntRiCd) {
		this.prntRiCd = prntRiCd;
	}

	public BigDecimal getTrtyShrPct() {
		return trtyShrPct;
	}

	public void setTrtyShrPct(BigDecimal trtyShrPct) {
		this.trtyShrPct = trtyShrPct;
	}

	public BigDecimal getTrtyShrAmt() {
		return trtyShrAmt;
	}

	public void setTrtyShrAmt(BigDecimal trtyShrAmt) {
		this.trtyShrAmt = trtyShrAmt;
	}

	public BigDecimal getCcallLimit() {
		return ccallLimit;
	}

	public void setCcallLimit(BigDecimal ccallLimit) {
		this.ccallLimit = ccallLimit;
	}

	public BigDecimal getwhTaxRt() {
		return whTaxRt;
	}

	public void setwhTaxRt(BigDecimal whTaxRt) {
		this.whTaxRt = whTaxRt;
	}

	public BigDecimal getBrokerPct() {
		return brokerPct;
	}

	public void setBrokerPct(BigDecimal brokerPct) {
		this.brokerPct = brokerPct;
	}

	public Integer getBroker() {
		return broker;
	}

	public void setBroker(Integer broker) {
		this.broker = broker;
	}

	public BigDecimal getPremRes() {
		return premRes;
	}

	public void setPremRes(BigDecimal premRes) {
		this.premRes = premRes;
	}

	public BigDecimal getIntOnPremRes() {
		return intOnPremRes;
	}

	public void setIntOnPremRes(BigDecimal intOnPremRes) {
		this.intOnPremRes = intOnPremRes;
	}

	public BigDecimal getRiCommRt() {
		return riCommRt;
	}

	public void setRiCommRt(BigDecimal riCommRt) {
		this.riCommRt = riCommRt;
	}
	
	public String getStrRiCommRt() {
		return strRiCommRt;
	}

	public void setStrRiCommRt(String strRiCommRt) {
		this.strRiCommRt = strRiCommRt;
	}

	public BigDecimal getProfRt() {
		return profRt;
	}

	public void setProfRt(BigDecimal profRt) {
		this.profRt = profRt;
	}

	public BigDecimal getFundsHeldPct() {
		return fundsHeldPct;
	}

	public void setFundsHeldPct(BigDecimal fundsHeldPct) {
		this.fundsHeldPct = fundsHeldPct;
	}

	public String getStrFundsHeldPct() {
		return strFundsHeldPct;
	}

	public void setStrFundsHeldPct(String strFundsHeldPct) {
		this.strFundsHeldPct = strFundsHeldPct;
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

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	/* benjo 08.03.2016 SR-5512 */
	public BigDecimal getIntTaxRt() {
		return intTaxRt;
	}

	public void setIntTaxRt(BigDecimal intTaxRt) {
		this.intTaxRt = intTaxRt;
	}
	/* end */
}
