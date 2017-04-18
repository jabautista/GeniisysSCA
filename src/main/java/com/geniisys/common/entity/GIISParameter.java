/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.giis.entity.BaseEntity;

/**
 * The Class GIISParameter.
 */
public class GIISParameter extends BaseEntity {
	
	/** The param type. */
	private String paramType;
	
	private String paramTypeMean;
	
	/** The param name. */
	private String paramName;
	
	/** The param value n. */
	private BigDecimal paramValueN;
	
	/** The param value v. */
	private String paramValueV;
	
	/** The param value d. */
	private Date paramValueD;
	private String paramValueDStr;
	private String paramValueDStr1; //friendly-format MM-DD-YYYY
	private String formatMask;
	
	/** The param length. */
	private Integer paramLength;
	
	/** The remarks. */
	private String remarks;
	
	/**
	 * Gets the param type.
	 * 
	 * @return the param type
	 */
	public String getParamType() {
		return paramType;
	}
	
	/**
	 * Sets the param type.
	 * 
	 * @param paramType the new param type
	 */
	public void setParamType(String paramType) {
		this.paramType = paramType;
	}
	
	public String getParamTypeMean() {
		return paramTypeMean;
	}

	public void setParamTypeMean(String paramTypeMean) {
		this.paramTypeMean = paramTypeMean;
	}

	/**
	 * Gets the param name.
	 * 
	 * @return the param name
	 */
	public String getParamName() {
		return paramName;
	}
	
	/**
	 * Sets the param name.
	 * 
	 * @param paramName the new param name
	 */
	public void setParamName(String paramName) {
		this.paramName = paramName;
	}
	
	/**
	 * Gets the param value n.
	 * 
	 * @return the param value n
	 */
	public BigDecimal getParamValueN() {
		return paramValueN;
	}
	
	/**
	 * Sets the param value n.
	 * 
	 * @param paramValueN the new param value n
	 */
	public void setParamValueN(BigDecimal paramValueN) {
		this.paramValueN = paramValueN;
	}
	
	/**
	 * Gets the param value v.
	 * 
	 * @return the param value v
	 */
	public String getParamValueV() {
		return paramValueV;
	}
	
	/**
	 * Sets the param value v.
	 * 
	 * @param paramValueV the new param value v
	 */
	public void setParamValueV(String paramValueV) {
		this.paramValueV = paramValueV;
	}
	
	/**
	 * Gets the param value d.
	 * 
	 * @return the param value d
	 */
	public Date getParamValueD() {
		return paramValueD;
	}
	
	/**
	 * Sets the param value d.
	 * 
	 * @param paramValueD the new param value d
	 */
	public void setParamValueD(Date paramValueD) {
		this.paramValueD = paramValueD;
	}
	
	public String getParamValueDStr() {
		return paramValueDStr;
	}

	public void setParamValueDStr(String paramValueDStr) {
		this.paramValueDStr = paramValueDStr;
	}

	public String getParamValueDStr1() {
		return paramValueDStr1;
	}

	public void setParamValueDStr1(String paramValueDStr1) {
		this.paramValueDStr1 = paramValueDStr1;
	}

	public String getFormatMask() {
		return formatMask;
	}

	public void setFormatMask(String formatMask) {
		this.formatMask = formatMask;
	}

	/**
	 * Gets the param length.
	 * 
	 * @return the param length
	 */
	public Integer getParamLength() {
		return paramLength;
	}
	
	/**
	 * Sets the param length.
	 * 
	 * @param paramLength the new param length
	 */
	public void setParamLength(Integer paramLength) {
		this.paramLength = paramLength;
	}
	
	/**
	 * Gets the remarks.
	 * 
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}
	
	/**
	 * Sets the remarks.
	 * 
	 * @param remarks the new remarks
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	
}
