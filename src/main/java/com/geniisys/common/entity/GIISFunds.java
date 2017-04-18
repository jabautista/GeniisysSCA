/**
 * 
 */
package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

/**
 * @author steven
 *
 */
public class GIISFunds extends BaseEntity{
	private String fundCd;
	private String fundDesc;
	private String remarks;
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
	 * @return the fundDesc
	 */
	public String getFundDesc() {
		return fundDesc;
	}
	/**
	 * @param fundDesc the fundDesc to set
	 */
	public void setFundDesc(String fundDesc) {
		this.fundDesc = fundDesc;
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
