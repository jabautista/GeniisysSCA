package com.geniisys.giri.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIRIBinderPeril extends BaseEntity{
	
	private Integer fnlBinderId;
	private Integer perilSeqNo;
	private BigDecimal riShrPct;
	private BigDecimal riTsiAmt;
	private BigDecimal riPremAmt;
	private BigDecimal annRiSAmt;
	private BigDecimal annRiPct;
	private BigDecimal riCommRt;
	private BigDecimal riCommAmt;
	private BigDecimal riPremVat;
	private BigDecimal riCommVat;
	private BigDecimal riWholdingVat;
	private BigDecimal premtax;
	
	public GIRIBinderPeril(){
		
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
	 * @return the perilSeqNo
	 */
	public Integer getPerilSeqNo() {
		return perilSeqNo;
	}

	/**
	 * @param perilSeqNo the perilSeqNo to set
	 */
	public void setPerilSeqNo(Integer perilSeqNo) {
		this.perilSeqNo = perilSeqNo;
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
	 * @return the riPremVat
	 */
	public BigDecimal getRiPremVat() {
		return riPremVat;
	}

	/**
	 * @param riPremVat the riPremVat to set
	 */
	public void setRiPremVat(BigDecimal riPremVat) {
		this.riPremVat = riPremVat;
	}

	/**
	 * @return the riCommVat
	 */
	public BigDecimal getRiCommVat() {
		return riCommVat;
	}

	/**
	 * @param riCommVat the riCommVat to set
	 */
	public void setRiCommVat(BigDecimal riCommVat) {
		this.riCommVat = riCommVat;
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
	 * @return the premtax
	 */
	public BigDecimal getPremtax() {
		return premtax;
	}

	/**
	 * @param premtax the premtax to set
	 */
	public void setPremtax(BigDecimal premtax) {
		this.premtax = premtax;
	}
	
	
}
