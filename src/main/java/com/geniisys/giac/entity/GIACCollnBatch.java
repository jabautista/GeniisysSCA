/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.entity;

import java.util.Date;

import com.geniisys.giis.entity.BaseEntity;

/**
 * The Class GIACCollnBatch.
 */
public class GIACCollnBatch extends BaseEntity {

	/** The dcb No. */
	private Integer dcbNo;
	
	/** The dcb Year. */
	private Integer dcbYear;
	
	/** The fund Cd. */
	private String fundCd;
	
	/** The branch cd. */
	private String branchCd;
	
	/** The tran date */
	private Date tranDate;
	
	/** The dcb flag */
	private String dcbFlag;
	
	/** The remarks */
	private String remarks;
	
	private String dcbStatus;
	
	public GIACCollnBatch() {
		
	}
	
	public GIACCollnBatch(Integer dcbNo, Integer dcbYear, String fundCd, String branchCd, Date tranDate, String dcbFlag, String remarks){
		this.dcbNo = dcbNo;
		this.dcbYear = dcbYear;
		this.fundCd = fundCd;
		this.branchCd = branchCd;
		this.tranDate = tranDate;
		this.dcbFlag = dcbFlag;
		this.remarks = remarks;
	}

	/**
	 * @return the dcbNo
	 */
	public Integer getDcbNo() {
		return dcbNo;
	}

	/**
	 * @param dcbNo the dcbNo to set
	 */
	public void setDcbNo(Integer dcbNo) {
		this.dcbNo = dcbNo;
	}

	/**
	 * @return the dcbYear
	 */
	public Integer getDcbYear() {
		return dcbYear;
	}

	/**
	 * @param dcbYear the dcbYear to set
	 */
	public void setDcbYear(Integer dcbYear) {
		this.dcbYear = dcbYear;
	}

	/**
	 * @return the fundCd
	 */
	public String getFundCd() {
		return fundCd;
	}

	/**
	 * @param fundCd the fundCd to set
	 */
	public void setFundCd(String fundCd) {
		this.fundCd = fundCd;
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
	 * @return the dcbFlag
	 */
	public String getDcbFlag() {
		return dcbFlag;
	}

	/**
	 * @param dcbFlag the dcbFlag to set
	 */
	public void setDcbFlag(String dcbFlag) {
		this.dcbFlag = dcbFlag;
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

	public String getDcbStatus() {
		return dcbStatus;
	}

	public void setDcbStatus(String dcbStatus) {
		this.dcbStatus = dcbStatus;
	}
}
