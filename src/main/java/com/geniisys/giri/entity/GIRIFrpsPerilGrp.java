package com.geniisys.giri.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIRIFrpsPerilGrp extends BaseEntity{
	
	private String  lineCd;
	private Integer frpsYy;
    private Integer frpsSeqNo;
    private Integer perilSeqNo;
    private Integer perilCd;
    private BigDecimal totFacSpct;
    private BigDecimal tsiAmt;
    private BigDecimal totFacTsi;
    private BigDecimal premAmt;
    private BigDecimal totFacPrem;
    private String perilTitle;
    private String remarks;
    
    
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
	 * @return the totFacSpct
	 */
	public BigDecimal getTotFacSpct() {
		return totFacSpct;
	}
	/**
	 * @param totFacSpct the totFacSpct to set
	 */
	public void setTotFacSpct(BigDecimal totFacSpct) {
		this.totFacSpct = totFacSpct;
	}
	/**
	 * @return the tsiAmt
	 */
	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}
	/**
	 * @param tsiAmt the tsiAmt to set
	 */
	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}
	/**
	 * @return the totFacTsi
	 */
	public BigDecimal getTotFacTsi() {
		return totFacTsi;
	}
	/**
	 * @param totFacTsi the totFacTsi to set
	 */
	public void setTotFacTsi(BigDecimal totFacTsi) {
		this.totFacTsi = totFacTsi;
	}
	/**
	 * @return the premAmt
	 */
	public BigDecimal getPremAmt() {
		return premAmt;
	}
	/**
	 * @param premAmt the premAmt to set
	 */
	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}
	/**
	 * @return the totFacPrem
	 */
	public BigDecimal getTotFacPrem() {
		return totFacPrem;
	}
	/**
	 * @param totFacPrem the totFacPrem to set
	 */
	public void setTotFacPrem(BigDecimal totFacPrem) {
		this.totFacPrem = totFacPrem;
	}
	/**
	 * @return the perilTitle
	 */
	public String getPerilTitle() {
		return perilTitle;
	}
	/**
	 * @param perilTitle the perilTitle to set
	 */
	public void setPerilTitle(String perilTitle) {
		this.perilTitle = perilTitle;
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
    
}
