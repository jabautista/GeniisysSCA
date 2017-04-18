/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIWinvperl.
 */
public class GIPIWinvperl extends BaseEntity {
	
	/** The peril cd. */
	private Integer perilCd;
	
	/** The peril name. */
	private String perilName;
	
	/** The par id. */
	private int parId;
	
	/** The item grp. */
	private int itemGrp;
	
	/** The takeup seq no. */
	private Integer takeupSeqNo;	
	
	/** The tsi amt. */
	private BigDecimal tsiAmt;
	
	/** The prem amt. */
	private BigDecimal premAmt;
	
	/** The line cd. */
	private String lineCd;
	
	/**
	 * Gets the peril cd.
	 * 
	 * @return the peril cd
	 */
	public Integer getPerilCd() {
		return perilCd;
	}
	
	/**
	 * Sets the peril cd.
	 * 
	 * @param perilCd the new peril cd
	 */
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	
	/**
	 * Gets the peril name.
	 * 
	 * @return the peril name
	 */
	public String getPerilName() {
		return perilName;
	}
	
	/**
	 * Sets the peril name.
	 * 
	 * @param perilName the new peril name
	 */
	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}
	
	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public int getParId() {
		return parId;
	}
	
	/**
	 * Sets the par id.
	 * 
	 * @param parId the new par id
	 */
	public void setParId(int parId) {
		this.parId = parId;
	}
	
	/**
	 * Gets the item grp.
	 * 
	 * @return the item grp
	 */
	public int getItemGrp() {
		return itemGrp;
	}
	
	/**
	 * Sets the item grp.
	 * 
	 * @param itemGrp the new item grp
	 */
	public void setItemGrp(int itemGrp) {
		this.itemGrp = itemGrp;
	}
	
	/**
	 * Gets the takeup seq no.
	 * 
	 * @return the takeup seq no
	 */
	public Integer getTakeupSeqNo() {
		return takeupSeqNo;
	}
	
	/**
	 * Sets the takeup seq no.
	 * 
	 * @param takeupSeqNo the new takeup seq no
	 */
	public void setTakeupSeqNo(Integer takeupSeqNo) {
		this.takeupSeqNo = takeupSeqNo;
	}
	
	/**
	 * Gets the tsi amt.
	 * 
	 * @return the tsi amt
	 */
	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}
	
	/**
	 * Sets the tsi amt.
	 * 
	 * @param tsiAmt the new tsi amt
	 */
	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}
	
	/**
	 * Gets the prem amt.
	 * 
	 * @return the prem amt
	 */
	public BigDecimal getPremAmt() {
		return premAmt;
	}
	
	/**
	 * Sets the prem amt.
	 * 
	 * @param premAmt the new prem amt
	 */
	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}
	
	/**
	 * Sets the line cd.
	 * 
	 * @param lineCd the new line cd
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	
	/**
	 * Gets the line cd.
	 * 
	 * @return the line cd
	 */
	public String getLineCd() {
		return lineCd;
	}



}
