package com.geniisys.giri.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIRIFrperil extends BaseEntity{
	
	private String lineCd;
	private Integer frpsYy;
	private Integer frpsSeqNo;
	private Integer riSeqNo;
	private Integer riCd;
	private Integer perilCd;
	private BigDecimal riShrPct;
	private BigDecimal riTsiAmt;
	private BigDecimal riPremAmt;
	private BigDecimal annRiSAmt;
	private BigDecimal annRiPct;
	private BigDecimal riCommRt;
	private BigDecimal riCommAmt;
	private BigDecimal premVat;
	private BigDecimal commVat;
	private BigDecimal riWholdingVat;
	private BigDecimal premtax;
	private BigDecimal riCommAmt2;
	
	public GIRIFrperil(){
		
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
	 * @return the perilCd
	 */
	public Integer getPerilCd() {
		return perilCd;
	}

	/**
	 * @param perilCd the perilCd to set
	 */
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
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
	 * @return the premVat
	 */
	public BigDecimal getPremVat() {
		return premVat;
	}

	/**
	 * @param premVat the premVat to set
	 */
	public void setPremVat(BigDecimal premVat) {
		this.premVat = premVat;
	}

	/**
	 * @return the commVat
	 */
	public BigDecimal getCommVat() {
		return commVat;
	}

	/**
	 * @param commVat the commVat to set
	 */
	public void setCommVat(BigDecimal commVat) {
		this.commVat = commVat;
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

	/**
	 * @return the riCommAmt2
	 */
	public BigDecimal getRiCommAmt2() {
		return riCommAmt2;
	}

	/**
	 * @param riCommAmt2 the riCommAmt2 to set
	 */
	public void setRiCommAmt2(BigDecimal riCommAmt2) {
		this.riCommAmt2 = riCommAmt2;
	}
	
	

}
