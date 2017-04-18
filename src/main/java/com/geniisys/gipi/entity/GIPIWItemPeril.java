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
 * The Class GIPIWItemPeril.
 */
public class GIPIWItemPeril extends BaseEntity /* changed from Entity to BaseEntity*/{
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;

	/** The par id. */
	private Integer parId;
	
	/** The item no. */
	private Integer itemNo;
	
	/** The line cd. */
	private String lineCd;
	
	/** The peril cd. */
	private Integer perilCd;
	
	/** The peril name. */
	private String perilName;
	
	/** The peril type. */
	private String perilType;
	
	/** The tarf cd. */
	private String tarfCd;
	
	/** The prem rt. */
	private BigDecimal premRt;
	
	/** The tsi amt. */
	private BigDecimal tsiAmt;
	
	/** The prem amt. */
	private BigDecimal premAmt;
	
	/** The ann tsi amt. */
	private BigDecimal annTsiAmt;
	
	/** The ann prem amt. */
	private BigDecimal annPremAmt;
	
	/** The rec flag. */
	private String recFlag;
	
	/** The comp rem. */
	private String compRem;
	
	/** The discount sw. */
	private String discountSw;
	
	/** The prt flag. */
	private String prtFlag;
	
	/** The ri comm rate. */
	private BigDecimal riCommRate;
	
	/** The ri comm amt. */
	private BigDecimal riCommAmt;
	
	/** The as charge sw. */
	private String asChargeSw;
	
	/** The surcharge sw. */
	private String surchargeSw;
	
	/** The no of days. */
	private Integer noOfDays;
	
	/** The base amt. */
	private BigDecimal baseAmt;
	
	/** The aggregate sw. */
	private String aggregateSw;
	
	/** The basc perl cd. */
	private Integer bascPerlCd;
	private String discExist;
	private BigDecimal discSum;
	
	//for getting post-text-tsi details
	private BigDecimal perilPremAmt;
	private BigDecimal perilAnnPremAmt;
	private BigDecimal perilAnnTsiAmt;
	private BigDecimal itemPremAmt;
	private BigDecimal itemAnnPremAmt;
	private BigDecimal itemTsiAmt;
	private BigDecimal itemAnnTsiAmt;
	private BigDecimal perilTsiAmt;

	public BigDecimal getPerilPremAmt() {
		return perilPremAmt;
	}
	
	public String getStrPerilPremAmt(){
		if(perilPremAmt != null){
			return perilPremAmt.toPlainString();
		} else {
			return null;
		}
	}

	public void setPerilPremAmt(BigDecimal perilPremAmt) {
		this.perilPremAmt = perilPremAmt;
	}

	public BigDecimal getPerilAnnPremAmt() {
		return perilAnnPremAmt;
	}
	
	public String getStrPerilAnnPremAmt(){
		if(perilAnnPremAmt != null){
			return perilAnnPremAmt.toPlainString();
		} else {
			return null;
		}
	}

	public void setPerilAnnPremAmt(BigDecimal perilAnnPremAmt) {
		this.perilAnnPremAmt = perilAnnPremAmt;
	}

	public BigDecimal getPerilAnnTsiAmt() {
		return perilAnnTsiAmt;
	}
	
	public String getStrPerilAnnTsiAmt() {
		if(perilAnnTsiAmt != null){
			return perilAnnTsiAmt.toPlainString();
		} else {
			return null;
		}
	}

	public void setPerilAnnTsiAmt(BigDecimal perilAnnTsiAmt) {
		this.perilAnnTsiAmt = perilAnnTsiAmt;
	}

	public BigDecimal getItemPremAmt() {
		return itemPremAmt;
	}

	public String getStrItemPremAmt() {
		if(itemPremAmt != null){
			return itemPremAmt.toPlainString();
		} else {
			return null;
		}
	}
	
	public void setItemPremAmt(BigDecimal itemPremAmt) {
		this.itemPremAmt = itemPremAmt;
	}

	public BigDecimal getItemAnnPremAmt() {
		return itemAnnPremAmt;
	}
	
	public String getStrItemAnnPremAmt() {
		if(itemAnnPremAmt != null){
			return itemAnnPremAmt.toPlainString();
		} else {
			return null;
		}
	}

	public void setItemAnnPremAmt(BigDecimal itemAnnPremAmt) {
		this.itemAnnPremAmt = itemAnnPremAmt;
	}

	public BigDecimal getItemTsiAmt() {
		return itemTsiAmt;
	}

	public String getStrItemTsiAmt() {
		if(itemTsiAmt != null){
			return itemTsiAmt.toPlainString();
		} else {
			return null;
		}
	}
	
	public void setItemTsiAmt(BigDecimal itemTsiAmt) {
		this.itemTsiAmt = itemTsiAmt;
	}

	public BigDecimal getItemAnnTsiAmt() {
		return itemAnnTsiAmt;
	}
	
	public String getStrItemAnnTsiAmt() {
		if(itemAnnTsiAmt != null){				
			return itemAnnTsiAmt.toPlainString();
		} else {
			return null;
		}
	}

	public void setItemAnnTsiAmt(BigDecimal itemAnnTsiAmt) {
		this.itemAnnTsiAmt = itemAnnTsiAmt;
	}

	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public Integer getParId() {
		return parId;
	}

	/**
	 * Sets the par id.
	 * 
	 * @param parId the new par id
	 */
	public void setParId(Integer parId) {
		this.parId = parId;
	}

	/**
	 * Gets the item no.
	 * 
	 * @return the item no
	 */
	public Integer getItemNo() {
		return itemNo;
	}

	/**
	 * Sets the item no.
	 * 
	 * @param itemNo the new item no
	 */
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	/**
	 * Gets the line cd.
	 * 
	 * @return the line cd
	 */
	public String getLineCd() {
		return lineCd;
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
	 * Gets the tarf cd.
	 * 
	 * @return the tarf cd
	 */
	public String getTarfCd() {
		return tarfCd;
	}

	/**
	 * Sets the tarf cd.
	 * 
	 * @param tarfCd the new tarf cd
	 */
	public void setTarfCd(String tarfCd) {
		this.tarfCd = tarfCd;
	}

	/**
	 * Gets the prem rt.
	 * 
	 * @return the prem rt
	 */
	//public String getPremRt() {
	//	return premRt.toPlainString();
	//}
	
	public BigDecimal getPremRt(){
		return premRt;
	}

	public String getStrPremRt(){
		if(premRt != null){
			return premRt.toPlainString();
		} else {
			return null;
		}
	}
	
	/**
	 * Sets the prem rt.
	 * 
	 * @param premRt the new prem rt
	 */
	public void setPremRt(BigDecimal premRt) {
		this.premRt = premRt;
	}

	/**
	 * Gets the tsi amt.
	 * 
	 * @return the tsi amt
	 */
	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}
	
	public String getStrTsiAmt() {
		if(tsiAmt != null){
			return tsiAmt.toPlainString();
		} else {
			return null;
		}
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

	public String getStrPremAmt() {
		if(premAmt != null){
			return premAmt.toPlainString();
		} else {
			return null;
		}
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
	 * Gets the ann tsi amt.
	 * 
	 * @return the ann tsi amt
	 */
	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}
	
	public String getStrAnnTsiAmt() {
		if(annTsiAmt != null){
			return annTsiAmt.toPlainString();
		} else {
			return null;
		}
	}

	/**
	 * Sets the ann tsi amt.
	 * 
	 * @param annTsiAmt the new ann tsi amt
	 */
	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}

	/**
	 * Gets the ann prem amt.
	 * 
	 * @return the ann prem amt
	 */
	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}
	
	public String getStrAnnPremAmt() {
		if(annPremAmt!=null){
			return annPremAmt.toPlainString();
		} else {
			return null;
		}
	}

	/**
	 * Sets the ann prem amt.
	 * 
	 * @param annPremAmt the new ann prem amt
	 */
	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}

	public BigDecimal getPerilTsiAmt() {
		return perilTsiAmt;
	}

	public void setPerilTsiAmt(BigDecimal perilTsiAmt) {
		this.perilTsiAmt = perilTsiAmt;
	}

	/**
	 * Gets the rec flag.
	 * 
	 * @return the rec flag
	 */
	public String getRecFlag() {
		return recFlag;
	}

	/**
	 * Sets the rec flag.
	 * 
	 * @param recFlag the new rec flag
	 */
	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}

	/**
	 * Gets the comp rem.
	 * 
	 * @return the comp rem
	 */
	public String getCompRem() {
		return compRem;
	}

	/**
	 * Sets the comp rem.
	 * 
	 * @param compRem the new comp rem
	 */
	public void setCompRem(String compRem) {
		this.compRem = compRem;
	}

	/**
	 * Gets the discount sw.
	 * 
	 * @return the discount sw
	 */
	public String getDiscountSw() {
		return discountSw;
	}

	/**
	 * Sets the discount sw.
	 * 
	 * @param discountSw the new discount sw
	 */
	public void setDiscountSw(String discountSw) {
		this.discountSw = discountSw;
	}

	/**
	 * Gets the prt flag.
	 * 
	 * @return the prt flag
	 */
	public String getPrtFlag() {
		return prtFlag;
	}

	/**
	 * Sets the prt flag.
	 * 
	 * @param prtFlag the new prt flag
	 */
	public void setPrtFlag(String prtFlag) {
		this.prtFlag = prtFlag;
	}

	/**
	 * Gets the ri comm rate.
	 * 
	 * @return the ri comm rate
	 */
	public BigDecimal getRiCommRate() {
		return riCommRate;
	}
	
	public String getStrRiCommRate() {
		if(riCommRate != null){
			return riCommRate.toPlainString();
		} else {
			return null;
		}
	}

	/**
	 * Sets the ri comm rate.
	 * 
	 * @param riCommRate the new ri comm rate
	 */
	public void setRiCommRate(BigDecimal riCommRate) {
		this.riCommRate = riCommRate;
	}

	/**
	 * Gets the ri comm amt.
	 * 
	 * @return the ri comm amt
	 */
	public BigDecimal getRiCommAmt() {
		return riCommAmt;
	}
	
	public String getStrRiCommAmt() {
		if(riCommAmt != null){
			return riCommAmt.toPlainString();
		} else {
			return null;
		}
	}

	/**
	 * Sets the ri comm amt.
	 * 
	 * @param riCommAmt the new ri comm amt
	 */
	public void setRiCommAmt(BigDecimal riCommAmt) {
		this.riCommAmt = riCommAmt;
	}

	/**
	 * Gets the as charge sw.
	 * 
	 * @return the as charge sw
	 */
	public String getAsChargeSw() {
		return asChargeSw;
	}

	/**
	 * Sets the as charge sw.
	 * 
	 * @param asChargeSw the new as charge sw
	 */
	public void setAsChargeSw(String asChargeSw) {
		this.asChargeSw = asChargeSw;
	}

	/**
	 * Gets the surcharge sw.
	 * 
	 * @return the surcharge sw
	 */
	public String getSurchargeSw() {
		return surchargeSw;
	}

	/**
	 * Sets the surcharge sw.
	 * 
	 * @param surchargeSw the new surcharge sw
	 */
	public void setSurchargeSw(String surchargeSw) {
		this.surchargeSw = surchargeSw;
	}

	/**
	 * Gets the no of days.
	 * 
	 * @return the no of days
	 */
	public Integer getNoOfDays() {
		return noOfDays;
	}

	/**
	 * Sets the no of days.
	 * 
	 * @param noOfDays the new no of days
	 */
	public void setNoOfDays(Integer noOfDays) {
		this.noOfDays = noOfDays;
	}

	/**
	 * Gets the base amt.
	 * 
	 * @return the base amt
	 */
	public BigDecimal getBaseAmt() {
		return baseAmt;
	}
	
	public String getStrBaseAmt() {
		if(baseAmt != null){
			return baseAmt.toPlainString();
		} else {
			return null;
		}
	}

	/**
	 * Sets the base amt.
	 * 
	 * @param baseAmt the new base amt
	 */
	public void setBaseAmt(BigDecimal baseAmt) {
		this.baseAmt = baseAmt;
	}

	/**
	 * Gets the aggregate sw.
	 * 
	 * @return the aggregate sw
	 */
	public String getAggregateSw() {
		return aggregateSw;
	}

	/**
	 * Sets the aggregate sw.
	 * 
	 * @param aggregateSw the new aggregate sw
	 */
	public void setAggregateSw(String aggregateSw) {
		this.aggregateSw = aggregateSw;
	}

	/**
	 * Gets the serialversionuid.
	 * 
	 * @return the serialversionuid
	 */
	public static long getSerialversionuid() {
		return serialVersionUID;
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
	 * Gets the peril name.
	 * 
	 * @return the peril name
	 */
	public String getPerilName() {
		return perilName;
	}

	/**
	 * Sets the peril type.
	 * 
	 * @param perilType the new peril type
	 */
	public void setPerilType(String perilType) {
		this.perilType = perilType;
	}

	/**
	 * Gets the peril type.
	 * 
	 * @return the peril type
	 */
	public String getPerilType() {
		return perilType;
	}	

	/**
	 * Sets the basc perl cd.
	 * 
	 * @param bascPerlCd the new basc perl cd
	 */
	public void setBascPerlCd(Integer bascPerlCd) {
		this.bascPerlCd = bascPerlCd;
	}

	/**
	 * Gets the basc perl cd.
	 * 
	 * @return the basc perl cd
	 */
	public Integer getBascPerlCd() {
		return bascPerlCd;
	}

	public void setDiscExist(String discExist) {
		this.discExist = discExist;
	}

	public String getDiscExist() {
		return discExist;
	}

	public void setDiscSum(BigDecimal discSum) {
		this.discSum = discSum;
	}

	public BigDecimal getDiscSum() {
		return discSum;
	}
	
	public String getStrDiscSum() {
		if(discSum != null){
			return discSum.toPlainString();
		} else {
			return null;
		}
	}

}
