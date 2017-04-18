/**
 * 
 */
package com.geniisys.gipi.entity;

import com.geniisys.framework.util.BaseEntity;

/**
 * @author Anthony Santos april 18, 2011
 *
 */
public class GIPIQuotePrincipal extends BaseEntity{
	
	private Integer quoteId;
	private Integer principalCd;
	private Integer enggBasicInfonum;
	private String subconSw;
	private String principalName;
	private String principalType;
	
	public GIPIQuotePrincipal() {
		
	}

	/**
	 * @return the quoteId
	 */
	public Integer getQuoteId() {
		return quoteId;
	}

	/**
	 * @param quoteId the quoteId to set
	 */
	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}

	/**
	 * @return the principalCd
	 */
	public Integer getPrincipalCd() {
		return principalCd;
	}

	/**
	 * @param principalCd the principalCd to set
	 */
	public void setPrincipalCd(Integer principalCd) {
		this.principalCd = principalCd;
	}

	/**
	 * @return the engBasicInfoNum
	 */
	public Integer getEnggBasicInfonum() {
		return enggBasicInfonum;
	}

	/**
	 * @param engBasicInfoNum the engBasicInfoNum to set
	 */
	public void setEnggBasicInfonum(Integer enggBasicInfonum) {
		this.enggBasicInfonum = enggBasicInfonum;
	}

	/**
	 * @return the subconSw
	 */
	public String getSubconSw() {
		return subconSw;
	}

	/**
	 * @param subconSw the subconSw to set
	 */
	public void setSubconSw(String subconSw) {
		this.subconSw = subconSw;
	}

	/**
	 * @return the principalName
	 */
	public String getPrincipalName() {
		return principalName;
	}

	/**
	 * @param principalName the principalName to set
	 */
	public void setPrincipalName(String principalName) {
		this.principalName = principalName;
	}

	public void setPrincipalType(String principalType) {
		this.principalType = principalType;
	}

	public String getPrincipalType() {
		return principalType;
	}
	
	
	
}
