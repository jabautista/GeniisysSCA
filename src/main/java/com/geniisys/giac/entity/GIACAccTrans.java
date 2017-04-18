/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

/**
 * The Class GIACAcctrans.
 */
public class GIACAccTrans extends BaseEntity{

	
	/** The tran id. */
	private Integer tranId;
	
	/** The gfun Fund cd. */
	private String gfunFundCd;
	
	/** The branch cd. */
	private String branchCd;
	
	/** The tran date. */
	private Date tranDate;
	
	/** The tran flag. */
	private String tranFlag;
	
	/** The tran class. */
	private String tranClass;
	
	/** The tran class no. */
	private Integer tranClassNo;
	
	/** The particulars. */
	private String particulars;
	
	/** The tran year. */
	private Integer tranYear;
	
	/** The tran month. */
	private Integer tranMonth;
	
	/** The tran seqno. */
	private Integer tranSeqNo;
	
	/** Additional attributes */
	
	/** The fund desc */
	private String fundDesc;
	
	/** The branch name */
	private String branchName;
	
	/** The mean tran flag */
	private String meanTranFlag;
	
	/** The DCB flag */
	private String dcbFlag;
	
	/** The mean DCB flag */
	private String meanDCBFlag;
	
	private String dvFlag;
	
	private Date dcbDate; //Deo [09.01.2016]: SR-5631
	
	public GIACAccTrans(){
		
	}
	
	public GIACAccTrans(Integer tranId, String gfunFundCd, String branchCd, Date tranDate, String tranFlag, String tranClass, Integer tranClassNo, String particulars, Integer tranYear, Integer tranMonth, Integer tranSeqNo){
		this.tranId = tranId;
		this.gfunFundCd = gfunFundCd;
		this.branchCd = branchCd;
		this.tranDate = tranDate;
		this.tranFlag = tranFlag;
		this.tranClass = tranClass;
		this.tranClassNo = tranClassNo;
		this.particulars = particulars;
		this.tranYear = tranYear;
		this.tranMonth = tranMonth;
		this.tranSeqNo = tranSeqNo;
	}

	/**
	 * @return the tranId
	 */
	public Integer getTranId() {
		return tranId;
	}

	/**
	 * @param tranId the tranId to set
	 */
	public void setTranId(Integer tranId) {
		this.tranId = tranId;
	}

	/**
	 * @return the gfunFundCd
	 */
	public String getGfunFundCd() {
		return gfunFundCd;
	}

	/**
	 * @param gfunFundCd the gfunFundCd to set
	 */
	public void setGfunFundCd(String gfunFundCd) {
		this.gfunFundCd = gfunFundCd;
	}

	/**
	 * @return the branchCd
	 */
	public String getBranchCd() {
		return branchCd;
	}

	/**
	 * @param branchCd the branchCd to set
	 */
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}

	/**
	 * @return the tranDate
	 */
	public Date getTranDate() {
		return tranDate;
	}

	/**
	 * @param tranDate the tranDate to set
	 */
	public void setTranDate(Date tranDate) {
		this.tranDate = tranDate;
	}

	/**
	 * @return the tranFlag
	 */
	public String getTranFlag() {
		return tranFlag;
	}

	/**
	 * @param tranFlag the tranFlag to set
	 */
	public void setTranFlag(String tranFlag) {
		this.tranFlag = tranFlag;
	}

	/**
	 * @return the tranClass
	 */
	public String getTranClass() {
		return tranClass;
	}

	/**
	 * @param tranClass the tranClass to set
	 */
	public void setTranClass(String tranClass) {
		this.tranClass = tranClass;
	}

	/**
	 * @return the tranClassNo
	 */
	public Integer getTranClassNo() {
		return tranClassNo;
	}

	/**
	 * @param tranClassNo the tranClassNo to set
	 */
	public void setTranClassNo(Integer tranClassNo) {
		this.tranClassNo = tranClassNo;
	}

	/**
	 * @return the particulars
	 */
	public String getParticulars() {
		return particulars;
	}

	/**
	 * @param particulars the particulars to set
	 */
	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}

	/**
	 * @return the tranYear
	 */
	public Integer getTranYear() {
		return tranYear;
	}

	/**
	 * @param tranYear the tranYear to set
	 */
	public void setTranYear(Integer tranYear) {
		this.tranYear = tranYear;
	}

	/**
	 * @return the tranMonth
	 */
	public Integer getTranMonth() {
		return tranMonth;
	}

	/**
	 * @param tranMonth the tranMonth to set
	 */
	public void setTranMonth(Integer tranMonth) {
		this.tranMonth = tranMonth;
	}

	/**
	 * @return the tranSeqNo
	 */
	public Integer getTranSeqNo() {
		return tranSeqNo;
	}

	/**
	 * @param tranSeqNo the tranSeqNo to set
	 */
	public void setTranSeqNo(Integer tranSeqNo) {
		this.tranSeqNo = tranSeqNo;
	}
	
	public String getFundDesc() {
		return fundDesc;
	}

	public void setFundDesc(String fundDesc) {
		this.fundDesc = fundDesc;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}

	public String getMeanTranFlag() {
		return meanTranFlag;
	}

	public void setMeanTranFlag(String meanTranFlag) {
		this.meanTranFlag = meanTranFlag;
	}

	public String getDcbFlag() {
		return dcbFlag;
	}

	public void setDcbFlag(String dcbFlag) {
		this.dcbFlag = dcbFlag;
	}

	public String getMeanDCBFlag() {
		return meanDCBFlag;
	}

	public void setMeanDCBFlag(String meanDCBFlag) {
		this.meanDCBFlag = meanDCBFlag;
	}

	public String getDvFlag() {
		return dvFlag;
	}

	public void setDvFlag(String dvFlag) {
		this.dvFlag = dvFlag;
	}	
	
	//Deo [09.01.2016]: add start SR-5631
	public Date getDcbDate() {
		return dcbDate;
	}
	
	public void setDcbDate(Date dcbDate) {
		this.dcbDate = dcbDate;
	}
	//Deo [09.01.2016]: add ends SR-5631
}
